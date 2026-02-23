"""
Pak Tour API Views
Public endpoints for Pakistan domestic tour data retrieval
"""
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from apps.cms.models import ContentPages
from apps.umrah.models import TourPackages, TourImages


class PakTourViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Public API for Pakistan Tours data

    Endpoints:
    - GET /api/cms/pak-tour/ - List all active tours
    - GET /api/cms/pak-tour/{id}/ - Get tour details by ID
    - GET /api/cms/pak-tour/by-url/?url=pak-tour/naran - Get tour by URL slug
    """
    permission_classes = [AllowAny]
    queryset = ContentPages.objects.none()
    ordering_fields = ['id', 'sequence', 'packagetitle']
    ordering = ['sequence']

    def get_queryset(self):
        """Get all active pak tour content pages"""
        return ContentPages.objects.filter(
            parentid=12,
            status=1
        ).order_by('sequence')

    def list(self, request):
        """
        Get all active Pakistan tour listings with tour package data
        """
        queryset = self.get_queryset()

        tours = []
        for content_page in queryset:
            try:
                tour_package = TourPackages.objects.get(cms_cp=content_page.id)
            except TourPackages.DoesNotExist:
                tour_package = None

            tour_days = tour_package.tour_days if tour_package and tour_package.tour_days else 0
            price_label_val = tour_package.price_label if tour_package else None
            if price_label_val == '0':
                price_label = 'Couple'
            elif price_label_val == '1':
                price_label = 'Per Person'
            else:
                price_label = None

            tours.append({
                'id': content_page.id,
                'packageTitle': content_page.packagetitle,
                'urlLink': content_page.urllink,
                'cardImage': content_page.cardimage,
                'price': content_page.price,
                'currencyType': content_page.currencytype,
                'tourDays': tour_days + 1 if tour_days else None,
                'tourNights': tour_days if tour_days else None,
                'tourAvailability': str(tour_package.tour_availability) if tour_package and tour_package.tour_availability else None,
                'priceLabel': price_label,
                'departureLocation': tour_package.departure_location if tour_package else None,
                'destinationLocation': tour_package.destination_location if tour_package else None,
            })

        return Response(tours)

    def retrieve(self, request, pk=None):
        """Get detailed tour information by ID"""
        try:
            content_page = self.get_queryset().get(pk=pk)
        except ContentPages.DoesNotExist:
            return Response(
                {'error': 'Tour not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        return self._build_tour_detail_response(content_page)

    @action(detail=False, methods=['get'], url_path='by-url')
    def get_by_url(self, request):
        """
        Get tour details by URL slug

        Query params:
        - url: The tour URL (e.g., "pak-tour/naran")

        Example: GET /api/cms/pak-tour/by-url/?url=pak-tour/naran
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
                {'error': 'Tour not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        return self._build_tour_detail_response(content_page)

    def _build_tour_detail_response(self, content_page):
        """Build detailed tour response with all related data"""
        try:
            tour_package = TourPackages.objects.get(cms_cp=content_page.id)
        except TourPackages.DoesNotExist:
            tour_package = None

        tour_images = []
        if tour_package:
            images = TourImages.objects.filter(tour_package=tour_package.id)
            for img in images:
                tour_images.append({
                    'id': img.id,
                    'images': img.images,
                    'bannerImage': img.banner_image,
                })

        tour_days = tour_package.tour_days if tour_package and tour_package.tour_days else 0
        price_label_val = tour_package.price_label if tour_package else None
        if price_label_val == '0':
            price_label = 'Couple'
        elif price_label_val == '1':
            price_label = 'Per Person'
        else:
            price_label = None

        response_data = {
            'tourDetails': {
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
                'price': content_page.price,
                'currencyType': content_page.currencytype,
                'status': content_page.status,
            },
            'tourPackage': {
                'tourDays': tour_days + 1 if tour_days else None,
                'tourNights': tour_days if tour_days else None,
                'tourAvailability': str(tour_package.tour_availability) if tour_package.tour_availability else None,
                'priceLabel': price_label,
                'discountPrice': str(tour_package.discount_price) if tour_package.discount_price else None,
                'departureLocation': tour_package.departure_location,
                'destinationLocation': tour_package.destination_location,
                'tourServices': tour_package.tour_services,
                'map': tour_package.map,
                'daysDetails': tour_package.days_details,
            } if tour_package else None,
            'tourImages': tour_images,
        }

        return Response(response_data)
