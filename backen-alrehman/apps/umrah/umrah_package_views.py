"""
Umrah Packages API Views
Public endpoints for Umrah package data retrieval with hotels, transport, and visa info
"""
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from apps.cms.models import ContentPages
from apps.umrah.models import (
    UmrahHotels,
    UmrahHotelImages,
    UmrahHotelRoomPeriods,
    UmrahHotelRoomPrices,
    UmrahTransportSectors,
    UmrahVehicles,
    UmrahVehiclePrices,
    UmrahVisas,
)


class UmrahPackageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Public API for Umrah Packages

    Endpoints:
    - GET /api/umrah/packages/              - List all active umrah packages
    - GET /api/umrah/packages/{id}/         - Get package details by ID
    - GET /api/umrah/packages/by-url/?url=umrah-packages/executive - Get by URL slug
    """
    permission_classes = [AllowAny]
    queryset = ContentPages.objects.none()
    ordering_fields = ['id', 'sequence', 'packagetitle']
    ordering = ['sequence']

    def get_queryset(self):
        """Get all active umrah content pages (parentId=2)"""
        return ContentPages.objects.filter(
            parentid=2,
            status=1
        ).order_by('sequence')

    def list(self, request):
        """
        List all active Umrah packages

        Returns:
        [
            {
                "id": 123,
                "packageTitle": "Executive Umrah Package",
                "urlLink": "umrah-packages/executive",
                "cardImage": "executive-card.webp",
                "bannerImage": "executive-banner.webp",
                "price": "150000",
                "currencyType": "PKR",
                "shortDescription": "...",
                "categories": "..."
            }
        ]
        """
        queryset = self.get_queryset()

        packages = []
        for page in queryset:
            packages.append({
                'id': page.id,
                'packageTitle': page.packagetitle,
                'urlLink': page.urllink,
                'metaTitle': page.metatitle,
                'cardImage': page.cardimage,
                'bannerImage': page.bannerimage,
                'price': page.price,
                'currencyType': page.currencytype,
                'shortDescription': page.shortdescription,
                'categories': page.categories,
                'sequence': page.sequence,
            })

        return Response(packages)

    def retrieve(self, request, pk=None):
        """Get detailed Umrah package by ID with hotels, transport, visa"""
        try:
            content_page = self.get_queryset().get(pk=pk)
        except ContentPages.DoesNotExist:
            return Response(
                {'error': 'Umrah package not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        return self._build_package_detail_response(content_page)

    @action(detail=False, methods=['get'], url_path='by-url')
    def get_by_url(self, request):
        """
        Get Umrah package details by URL slug

        Query params:
        - url: The package URL (e.g., "umrah-packages/executive")

        Example: GET /api/umrah/packages/by-url/?url=umrah-packages/executive
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
                {'error': 'Umrah package not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        return self._build_package_detail_response(content_page)

    def _build_package_detail_response(self, content_page):
        """Build detailed umrah package response with hotels, transport, visa"""

        # --- Hotels (Makkah & Madinah) ---
        makkah_hotels = self._get_hotels_by_location('Makkah')
        madinah_hotels = self._get_hotels_by_location('Madinah')

        # --- Transport sectors & vehicles ---
        transport_sectors = self._get_transport_sectors()
        vehicles = self._get_vehicles()

        # --- Visa options ---
        visas = self._get_active_visas()

        response_data = {
            'packageDetails': {
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
                'categories': content_page.categories,
                'status': content_page.status,
            },
            'makkahHotels': makkah_hotels,
            'madinahHotels': madinah_hotels,
            'transportSectors': transport_sectors,
            'vehicles': vehicles,
            'visas': visas,
        }

        return Response(response_data)

    def _get_hotels_by_location(self, location):
        """Get active hotels for a location with images and room periods/prices"""
        hotels = UmrahHotels.objects.filter(
            hotellocation=location,
            hotelstatus='1'
        )

        result = []
        for hotel in hotels:
            # Get hotel images
            images = UmrahHotelImages.objects.filter(
                hotelid=hotel.id,
                hotelroomimagestatus='1'
            )
            hotel_images = []
            for img in images:
                hotel_images.append({
                    'id': img.id,
                    'hotelImage': img.hotelimage,
                    'hotelRoomType': img.hotelroomtype,
                })

            # Get active room periods with prices
            periods = UmrahHotelRoomPeriods.objects.filter(
                hotelid=hotel.id,
                periodstatus='1'
            )
            room_periods = []
            for period in periods:
                prices = UmrahHotelRoomPrices.objects.filter(periodid=period.id)
                room_prices = []
                for price in prices:
                    room_prices.append({
                        'id': price.id,
                        'roomType': price.roomtype,
                        'onDayPrice': price.ondayprice,
                        'onDayMarkup': price.ondaymarkup,
                        'offDayPrice': price.offdayprice,
                        'offDayMarkup': price.offdaymarkup,
                    })

                room_periods.append({
                    'id': period.id,
                    'periodFrom': str(period.periodfrom),
                    'periodTo': str(period.periodto),
                    'ashraType': period.ashratype,
                    'roomPrices': room_prices,
                })

            result.append({
                'id': hotel.id,
                'hotelName': hotel.hotelname,
                'vendorName': hotel.vendorname,
                'hotelLocation': hotel.hotellocation,
                'hotelDistance': hotel.hoteldistance,
                'basisType': hotel.basistype,
                'hotelType': hotel.hoteltype,
                'hotelDesc': hotel.hoteldesc,
                'markup': hotel.markup,
                'images': hotel_images,
                'roomPeriods': room_periods,
            })

        return result

    def _get_transport_sectors(self):
        """Get all active transport sectors with vehicle prices"""
        sectors = UmrahTransportSectors.objects.filter(sectorstatus='1')

        result = []
        for sector in sectors:
            # Get vehicle prices for this sector
            vehicle_prices = UmrahVehiclePrices.objects.filter(
                sectorid=sector.id,
                vehiclepricestatus='1'
            )
            prices = []
            for vp in vehicle_prices:
                # Get vehicle name
                try:
                    vehicle = UmrahVehicles.objects.get(id=vp.vehicleid)
                    vehicle_name = vehicle.vehiclename
                except UmrahVehicles.DoesNotExist:
                    vehicle_name = None

                prices.append({
                    'id': vp.id,
                    'vehicleId': vp.vehicleid,
                    'vehicleName': vehicle_name,
                    'vehiclePrice': vp.vehicleprice,
                    'vehicleSectorMarkup': vp.vehiclesectormarkup,
                    'vehicleSectorMrkPrice': vp.vehiclesectormrkprice,
                })

            result.append({
                'id': sector.id,
                'sectorName': sector.sectorname,
                'sectorMarkup': sector.sectormarkup,
                'vehiclePrices': prices,
            })

        return result

    def _get_vehicles(self):
        """Get all active vehicles"""
        vehicles = UmrahVehicles.objects.filter(vehiclestatus='1')

        return [{
            'id': v.id,
            'vehicleName': v.vehiclename,
            'vehicleMarkup': v.vehiclemarkup,
        } for v in vehicles]

    def _get_active_visas(self):
        """Get all active umrah visas"""
        visas = UmrahVisas.objects.filter(umrahvisapricestatus='1')

        return [{
            'id': v.id,
            'umrahVisaName': v.umrahvisaname,
            'umrahVisaPeriodFrom': str(v.umrahvisaperiodfrom),
            'umrahVisaPeriodTo': str(v.umrahvisaperiodto),
            'umrahVisaPrice': v.umrahvisaprice,
            'umrahVisaNationality': v.umrahvisanationality,
        } for v in visas]
