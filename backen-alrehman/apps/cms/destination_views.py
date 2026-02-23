"""
Homepage Destinations API Views
Public endpoints for home page destination data
"""
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from apps.cms.models import ContentPages
from apps.umrah.models import CmsVisaPackages


class HomeDestinationViewSet(viewsets.ViewSet):
    """
    Public API for Homepage Destinations

    Returns content pages marked as showOnHome=1 with parentId=4
    (Visa destinations only) that have a price > 0.

    Endpoints:
    - GET /api/cms/home-destinations/ - List all homepage destinations
    """
    permission_classes = [AllowAny]

    def list(self, request):
        destinations = ContentPages.objects.filter(
            parentid__in=[4, 12],
            showonhome=1,
            status=1,
        ).order_by('sequence')

        result = []
        for page in destinations:
            price_str = page.price or '0'
            try:
                price_val = float(price_str.replace(',', ''))
            except (ValueError, TypeError):
                price_val = 0

            if price_val <= 0:
                continue

            # Get country name from visa package if available (only for visa pages)
            country_name = None
            if page.parentid_id == 4:
                try:
                    visa_pkg = CmsVisaPackages.objects.get(cmscontentid=page.id)
                    country_name = visa_pkg.countryname
                except CmsVisaPackages.DoesNotExist:
                    pass

            result.append({
                'id': page.id,
                'parentId': page.parentid_id,
                'packageTitle': page.packagetitle,
                'urlLink': page.urllink,
                'cardImage': page.cardimage,
                'price': page.price,
                'currencyType': page.currencytype,
                'type': page.type,
                'countryName': country_name,
            })

        return Response(result)
