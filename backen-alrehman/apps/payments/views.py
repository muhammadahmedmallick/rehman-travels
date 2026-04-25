"""
Payments API views
"""
import logging

import requests as http_requests
from django.conf import settings
from django.db.models import Q
from django.http import HttpResponse, JsonResponse
from django.utils.decorators import method_decorator
from django.views import View
from django.views.decorators.csrf import csrf_exempt
from rest_framework import filters, status, viewsets
from rest_framework.response import Response
from rest_framework.views import APIView
from django_filters.rest_framework import DjangoFilterBackend

from apps.payments.models import APGTransaction, MarkupAndMarkdowns, Payments
from apps.payments.serializers import (
    APGTransactionSerializer,
    MarkupAndMarkdownsSerializer,
    PaymentsSerializer,
)

logger = logging.getLogger(__name__)


# ─────────────────────────────────────────────────────────────────────────────
# Model ViewSets
# ─────────────────────────────────────────────────────────────────────────────

class APGTransactionViewSet(viewsets.ModelViewSet):
    """ViewSet for APGTransaction model. Provides CRUD and monitoring."""
    queryset = APGTransaction.objects.all()
    serializer_class = APGTransactionSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['transaction_ref', 'booking_pnr', 'order_id']
    filterset_fields = ['transaction_status', 'currency']
    ordering_fields = ['created_at', 'updated_at', 'amount']
    ordering = ['-created_at']


class PaymentsViewSet(viewsets.ModelViewSet):
    """ViewSet for the legacy Payments model. Provides CRUD operations."""
    queryset = Payments.objects.all()
    serializer_class = PaymentsSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class MarkupAndMarkdownsViewSet(viewsets.ModelViewSet):
    """ViewSet for MarkupAndMarkdowns model. Provides CRUD operations."""
    queryset = MarkupAndMarkdowns.objects.all()
    serializer_class = MarkupAndMarkdownsSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


# ─────────────────────────────────────────────────────────────────────────────
# APG helpers
# ─────────────────────────────────────────────────────────────────────────────

def _get_apg_config():
    """Return APG merchant credentials from Django settings."""
    return {
        'merchant_id': getattr(settings, 'APG_MERCHANT_ID', ''),
        'store_id':    getattr(settings, 'APG_STORE_ID', ''),
        'sandbox':     getattr(settings, 'APG_SANDBOX', False),
    }


def _inquire_apg_status(order_id: str) -> dict | None:
    """
    Call the APG IPN inquiry endpoint and return the parsed JSON response,
    or None if the request fails.

    Sandbox:    https://sandbox.bankalfalah.com/HS/api/IPN/OrderStatus/{mid}/{sid}/{oid}
    Production: https://payments.bankalfalah.com/HS/api/IPN/OrderStatus/{mid}/{sid}/{oid}
    """
    cfg = _get_apg_config()
    base = (
        'https://sandbox.bankalfalah.com/HS/api/IPN/OrderStatus'
        if cfg['sandbox'] else
        'https://payments.bankalfalah.com/HS/api/IPN/OrderStatus'
    )
    url = f"{base}/{cfg['merchant_id']}/{cfg['store_id']}/{order_id}"
    try:
        resp = http_requests.get(url, timeout=10)
        resp.raise_for_status()
        return resp.json()
    except Exception as exc:
        logger.error("APG inquiry failed for order %s: %s", order_id, exc)
        return None


def _payment_result_html(success: bool, transaction_ref: str) -> str:
    """
    Simple HTML page shown in the browser after APG redirects the user back.
    Tells the user to return to the app; we also attempt a deep-link redirect.
    """
    icon    = "✅" if success else "❌"
    heading = "Payment Successful!" if success else "Payment Failed"
    message = (
        "Your payment has been confirmed. Please return to the app to see your ticket."
        if success else
        "Your payment could not be processed. Please return to the app and try again."
    )
    color = "#2e7d32" if success else "#c62828"

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{heading}</title>
  <style>
    body {{
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      display: flex; flex-direction: column; align-items: center;
      justify-content: center; min-height: 100vh; margin: 0;
      background: #f5f5f5; text-align: center; padding: 24px;
    }}
    .card {{
      background: white; border-radius: 16px; padding: 40px 32px;
      box-shadow: 0 4px 24px rgba(0,0,0,.1); max-width: 360px; width: 100%;
    }}
    .icon {{ font-size: 64px; margin-bottom: 16px; }}
    h1 {{ color: {color}; margin: 0 0 12px; font-size: 22px; }}
    p  {{ color: #555; line-height: 1.6; margin: 0 0 24px; }}
    a  {{
      display: inline-block; background: {color}; color: white;
      text-decoration: none; padding: 14px 28px; border-radius: 8px;
      font-weight: 600; font-size: 15px;
    }}
    small {{ display: block; color: #999; margin-top: 16px; font-size: 12px; }}
  </style>
</head>
<body>
  <div class="card">
    <div class="icon">{icon}</div>
    <h1>{heading}</h1>
    <p>{message}</p>
    <a href="rehmantravel://payment-result?status={'paid' if success else 'failed'}&ref={transaction_ref}">
      Return to App
    </a>
    <small>Reference: {transaction_ref}</small>
  </div>
  <script>
    // Attempt deep-link immediately; fall back to the button above.
    setTimeout(function() {{
      window.location.href =
        "rehmantravel://payment-result?status={'paid' if success else 'failed'}&ref={transaction_ref}";
    }}, 800);
  </script>
</body>
</html>"""


# ─────────────────────────────────────────────────────────────────────────────
# APG Views
# ─────────────────────────────────────────────────────────────────────────────

class APGInitiateView(APIView):
    """
    POST /api/payments/apg/initiate/

    Called by Flutter **before** launching the APG payment URL.
    Creates a pending APGTransaction keyed by the booking PNR so we can
    track status once APG notifies us via IPN.

    Request body:
        {
          "transaction_ref":   "KHI-DXB-ABC123",   // booking PNR / reference
          "booking_pnr":       "ABC123",
          "booking_reference": "ABC123",
          "air_type":          "IATA",
          "amount":            15000.00,
          "currency":          "PKR"                // optional, default PKR
        }

    Response:
        {
          "transaction_ref": "KHI-DXB-ABC123",
          "status":          "pending"
        }
    """

    def post(self, request):
        data = request.data
        transaction_ref = data.get('transaction_ref', '').strip()

        if not transaction_ref:
            return Response(
                {'error': 'transaction_ref is required'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Upsert: if a pending record already exists for this ref (e.g. retry),
        # reset it rather than failing with a duplicate-key error.
        txn, created = APGTransaction.objects.update_or_create(
            transaction_ref=transaction_ref,
            defaults={
                'booking_pnr':       data.get('booking_pnr', transaction_ref),
                'booking_reference': data.get('booking_reference', ''),
                'air_type':          data.get('air_type', ''),
                'amount':            data.get('amount', 0),
                'currency':          data.get('currency', 'PKR'),
                'transaction_status': APGTransaction.STATUS_PENDING,
                'order_id':          None,
                'apg_response':      None,
            },
        )

        logger.info(
            "APGTransaction %s for ref=%s (created=%s)",
            'created' if created else 'reset', transaction_ref, created,
        )

        return Response({
            'transaction_ref': txn.transaction_ref,
            'status':          txn.transaction_status,
        }, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)


class APGStatusView(APIView):
    """
    GET /api/payments/apg/status/<transaction_ref>/

    Flutter polls this endpoint after returning from the external browser to
    learn whether the payment succeeded or failed.

    Response:
        {
          "transaction_ref":    "ABC123",
          "order_id":           "A10",
          "status":             "paid",          // pending | paid | failed | cancelled
          "response_code":      "00",
          "apg_transaction_id": "1263781929",
          "amount":             "15000.00",
          "currency":           "PKR",
          "booking_pnr":        "ABC123",
          "created_at":         "2024-01-01T12:00:00Z",
          "updated_at":         "2024-01-01T12:01:00Z"
        }
    """

    def get(self, request, transaction_ref):
        try:
            txn = APGTransaction.objects.get(transaction_ref=transaction_ref)
        except APGTransaction.DoesNotExist:
            return Response(
                {'error': 'Transaction not found'},
                status=status.HTTP_404_NOT_FOUND,
            )

        # If still pending, try to proactively fetch from APG using the
        # order_id (populated by IPN or Return URL handler).
        if txn.transaction_status == APGTransaction.STATUS_PENDING and txn.order_id:
            apg_data = _inquire_apg_status(txn.order_id)
            if apg_data:
                txn.update_from_apg_response(apg_data)

        return Response({
            'transaction_ref':    txn.transaction_ref,
            'order_id':           txn.order_id,
            'status':             txn.transaction_status,
            'response_code':      txn.response_code,
            'apg_transaction_id': txn.apg_transaction_id,
            'amount':             str(txn.amount),
            'currency':           txn.currency,
            'booking_pnr':        txn.booking_pnr,
            'created_at':         txn.created_at.isoformat(),
            'updated_at':         txn.updated_at.isoformat(),
        })


class APGReturnView(View):
    """
    GET /api/payments/apg/return/

    APG redirects the customer here after they complete (or abandon) payment.
    APG appends query params:  TS=P  RC=00  RD=  O=<OrderId>

    We also expect our own  ?ref=<transaction_ref>  appended to the Return URL
    when we build it (so we can match the APGTransaction record).

    Steps:
      1. Extract Order ID (?O=) and our ref (?ref=)
      2. Call APG IPN inquiry to get definitive status
      3. Update APGTransaction in DB
      4. Render a browser page telling the user to return to the app
         (with a deep-link attempt)
    """

    def get(self, request):
        order_id        = request.GET.get('O', '').strip()
        transaction_ref = request.GET.get('ref', '').strip()
        success         = False
        apg_data        = None

        if order_id:
            apg_data = _inquire_apg_status(order_id)

            if apg_data:
                apg_status = apg_data.get('TransactionStatus', '').lower()
                success    = apg_status == 'paid'

                # The TransactionReferenceNumber in the IPN response is the
                # merchant's own ref (= the booking PNR we sent to APG).
                ipn_ref = apg_data.get('TransactionReferenceNumber', '')

                # Find the matching record: prefer our ?ref= param, fall back
                # to the ref embedded in the IPN response.
                txn = None
                for lookup_ref in filter(None, [transaction_ref, ipn_ref, order_id]):
                    txn = APGTransaction.objects.filter(
                        Q(transaction_ref=lookup_ref) | Q(order_id=lookup_ref)
                    ).first()
                    if txn:
                        break

                if txn:
                    # Store order_id in case the IPN listener hasn't fired yet.
                    txn.order_id = order_id
                    txn.save(update_fields=['order_id'])
                    txn.update_from_apg_response(apg_data)
                    transaction_ref = txn.transaction_ref
                else:
                    logger.warning(
                        "APGReturnView: no APGTransaction found for ref=%s / order=%s",
                        transaction_ref, order_id,
                    )
            else:
                logger.error("APGReturnView: IPN inquiry returned nothing for order=%s", order_id)
        else:
            logger.warning("APGReturnView called without ?O= param")

        return HttpResponse(
            _payment_result_html(success, transaction_ref),
            content_type='text/html',
        )


@method_decorator(csrf_exempt, name='dispatch')
class APGIPNView(View):
    """
    POST /api/payments/apg/ipn/

    APG's Instant Payment Notification webhook.  APG sends a POST with a
    'url' query/body parameter containing the IPN inquiry URL, e.g.:

        POST /api/payments/apg/ipn/?url=https://payments.bankalfalah.com/HS/api/IPN/OrderStatus/123/456/A10

    We fetch that URL (GET), parse the JSON response and update the DB.

    This URL must be:
      • Registered in the APG merchant portal as the "Listener URL"
      • Whitelisted on Bank Alfalah's network
    """

    def post(self, request):
        # APG sends the inquiry URL as a query-string OR body parameter.
        ipn_url = (
            request.GET.get('url') or
            request.POST.get('url', '')
        ).strip()

        if not ipn_url:
            logger.error("APGIPNView: received POST with no 'url' parameter")
            return JsonResponse({'error': "Missing 'url' parameter"}, status=400)

        # Validate the URL is from Bank Alfalah (basic security check)
        allowed_hosts = ['payments.bankalfalah.com', 'sandbox.bankalfalah.com']
        from urllib.parse import urlparse
        parsed = urlparse(ipn_url)
        if parsed.netloc not in allowed_hosts:
            logger.error("APGIPNView: untrusted IPN URL host: %s", parsed.netloc)
            return JsonResponse({'error': 'Untrusted IPN URL'}, status=400)

        try:
            resp = http_requests.get(ipn_url, timeout=10)
            resp.raise_for_status()
            apg_data = resp.json()
        except Exception as exc:
            logger.error("APGIPNView: failed to fetch IPN URL %s: %s", ipn_url, exc)
            return JsonResponse({'error': str(exc)}, status=500)

        # TransactionReferenceNumber = the merchant ref we sent to APG (= booking PNR)
        ipn_ref    = apg_data.get('TransactionReferenceNumber', '').strip()
        apg_status = apg_data.get('TransactionStatus', '').lower()

        logger.info(
            "APGIPNView: ref=%s status=%s response_code=%s",
            ipn_ref, apg_status, apg_data.get('ResponseCode'),
        )

        txn = APGTransaction.objects.filter(
            Q(transaction_ref=ipn_ref) | Q(order_id=ipn_ref)
        ).first()

        if txn:
            txn.update_from_apg_response(apg_data)
            logger.info("APGIPNView: updated APGTransaction pk=%s → %s", txn.pk, txn.transaction_status)
        else:
            # Create a record so we have an audit trail even if the initiate
            # call never happened (e.g. dev/test scenario).
            APGTransaction.objects.create(
                transaction_ref     = ipn_ref or f"IPN-{apg_data.get('TransactionId', 'unknown')}",
                order_id            = ipn_ref,
                transaction_status  = APGTransaction.STATUS_PAID if apg_status == 'paid' else APGTransaction.STATUS_FAILED,
                response_code       = apg_data.get('ResponseCode', ''),
                apg_transaction_id  = apg_data.get('TransactionId', ''),
                account_number      = apg_data.get('AccountNumber', ''),
                mobile_number       = apg_data.get('MobileNumber', ''),
                order_datetime      = apg_data.get('OrderDateTime', ''),
                transaction_datetime = apg_data.get('TransactionDateTime', ''),
                apg_response        = apg_data,
            )
            logger.warning(
                "APGIPNView: no existing APGTransaction for ref=%s; created new record", ipn_ref
            )

        # APG expects a 200 OK to consider the IPN delivered.
        return JsonResponse({'received': True})
