"""
Payments URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter

from apps.payments.views import (
    APGInitiateView,
    APGIPNView,
    APGReturnView,
    APGStatusView,
    APGTransactionViewSet,
    MarkupAndMarkdownsViewSet,
    PaymentsViewSet,
)

router = DefaultRouter()
router.register(r'apg-transactions',      APGTransactionViewSet,    basename='apg-transactions')
router.register(r'payments',              PaymentsViewSet,          basename='payments')
router.register(r'markup-and-markdowns',  MarkupAndMarkdownsViewSet, basename='markup-and-markdowns')

urlpatterns = [
    # ── Legacy model endpoints (via router) ──────────────────────────────────
    path('', include(router.urls)),

    # ── APG (Alfa Payment Gateway) endpoints ─────────────────────────────────
    #
    #  1. POST  /api/payments/apg/initiate/
    #     Flutter calls this BEFORE launching the APG URL.
    #     Creates a pending APGTransaction record in the DB.
    #
    path('apg/initiate/', APGInitiateView.as_view(), name='apg-initiate'),

    #  2. GET   /api/payments/apg/status/<transaction_ref>/
    #     Flutter polls this after the user returns from the browser.
    #     Returns { status: "paid" | "failed" | "pending", ... }
    #
    path('apg/status/<str:transaction_ref>/', APGStatusView.as_view(), name='apg-status'),

    #  3. GET   /api/payments/apg/return/
    #     APG redirects the customer here after payment.
    #     Extracts ?O=<OrderId>, calls APG IPN inquiry, updates DB,
    #     then renders a "return to app" page.
    #
    #     Register this URL in APG merchant portal as the "Return URL":
    #       https://<your-domain>/api/payments/apg/return/?ref=<transaction_ref>
    #     (append ?ref= dynamically when building the HS_ReturnURL)
    #
    path('apg/return/', APGReturnView.as_view(), name='apg-return'),

    #  4. POST  /api/payments/apg/ipn/
    #     APG's Instant Payment Notification webhook.
    #     Register in APG merchant portal as the "Listener URL":
    #       https://<your-domain>/api/payments/apg/ipn/
    #     Must be whitelisted on Bank Alfalah's network.
    #
    path('apg/ipn/', APGIPNView.as_view(), name='apg-ipn'),
]
