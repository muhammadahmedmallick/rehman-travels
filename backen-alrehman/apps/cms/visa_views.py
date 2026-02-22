"""
Visa API Views
Public endpoints for visa data retrieval
"""
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.db.models import Prefetch
from apps.cms.models import ContentPages
from apps.umrah.models import CmsVisaPackages, CmsVisaDurations


class VisaViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Public API for Visa data

    Endpoints:
    - GET /api/visa/ - List all active visas
    - GET /api/visa/{id}/ - Get visa details by ID
    - GET /api/visa/by-url/?url=visa/singapore - Get visa by URL slug
    """
    permission_classes = [AllowAny]
    queryset = ContentPages.objects.none()  # Required for DRF
    ordering_fields = ['id', 'sequence', 'packagetitle']
    ordering = ['sequence']

    def get_queryset(self):
        """Get all active visa content pages"""
        return ContentPages.objects.filter(
            parentid=4,
            status=1
        ).order_by('sequence')

    def list(self, request):
        """
        Get all active visa listings

        Returns:
        [
            {
                "id": 1375,
                "packageTitle": "Singapore Visit Visa",
                "urlLink": "visa/singapore",
                "metaTitle": "...",
                "cardImage": "singapore-sec.webp",
                "countryName": "Singapore"
            },
            ...
        ]
        """
        queryset = self.get_queryset()

        visas = []
        for content_page in queryset:
            # Get related visa package
            try:
                visa_package = CmsVisaPackages.objects.get(cmscontentid=content_page.id)
            except CmsVisaPackages.DoesNotExist:
                visa_package = None

            visas.append({
                'id': content_page.id,
                'packageTitle': content_page.packagetitle,
                'urlLink': content_page.urllink,
                'metaTitle': content_page.metatitle,
                'metaDescription': content_page.metadescription,
                'cardImage': content_page.cardimage,
                'countryName': visa_package.countryname if visa_package else None,
                'packageUrl': visa_package.packageurl if visa_package else None,
            })

        return Response(visas)

    def retrieve(self, request, pk=None):
        """
        Get detailed visa information by ID

        Returns complete visa details including durations and pricing
        """
        try:
            content_page = self.get_queryset().get(pk=pk)
        except ContentPages.DoesNotExist:
            return Response(
                {'error': 'Visa not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        return self._build_visa_detail_response(content_page)

    @action(detail=False, methods=['get'], url_path='by-url')
    def get_by_url(self, request):
        """
        Get visa details by URL slug

        Query params:
        - url: The visa URL (e.g., "visa/singapore")

        Example: GET /api/visa/by-url/?url=visa/singapore
        """
        url_link = request.query_params.get('url')

        if not url_link:
            return Response(
                {'error': 'URL parameter is required'},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            content_page = self.get_queryset().get(urllink=url_link)
        except ContentPages.DoesNotExist:
            return Response(
                {'error': 'Visa not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        return self._build_visa_detail_response(content_page)

    def _build_visa_detail_response(self, content_page):
        """Build detailed visa response with all related data"""
        # Get related visa package
        try:
            visa_package = CmsVisaPackages.objects.get(cmscontentid=content_page.id)
        except CmsVisaPackages.DoesNotExist:
            visa_package = None

        # Get visa durations
        visa_durations = []
        if visa_package:
            durations = CmsVisaDurations.objects.filter(visaid=visa_package.id, durationstatus=1)
            for duration in durations:
                visa_durations.append({
                    'id': duration.id,
                    'visaTitle': duration.visatitle,
                    'visaPrice': duration.visaprice,
                    'currency': duration.currency,
                    'numEntries': duration.numentries,
                    'duration': duration.duration,
                    'validity': duration.validity,
                    'visaType': duration.visatype,
                    'visaIncludes': duration.visaincludes,
                })

        response_data = {
            'visaDetails': {
                'id': content_page.id,
                'parentId': content_page.parentid.id if content_page.parentid else None,
                'packageTitle': content_page.packagetitle,
                'urlLink': content_page.urllink,
                'metaTitle': content_page.metatitle,
                'metaDescription': content_page.metadescription,
                'description': content_page.description,
                'shortDescription': content_page.shortdescription,
                'cardImage': content_page.cardimage,
                'bannerImage': content_page.bannerimage,
                'includes': content_page.includes,
                'excludes': content_page.excludes,
                'documentsRequired': content_page.documentsrequired,
                'price': content_page.price,
                'status': content_page.status,
            },
            'visaPackage': {
                'countryName': visa_package.countryname if visa_package else None,
                'packageUrl': visa_package.packageurl if visa_package else None,
                'tourUrl': visa_package.toururl if visa_package else None,
            } if visa_package else None,
            'visaDurations': visa_durations
        }

        return Response(response_data)
