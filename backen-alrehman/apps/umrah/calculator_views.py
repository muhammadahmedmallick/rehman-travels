"""
Umrah Calculator API Views
Custom endpoints for calculator, menu, and booking
"""
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from apps.cms.models import (
    ContentPages,
    ParentPages,
)
from apps.umrah.models import (
    UmrahHotels,
    UmrahTransportSectors,
    UmrahVehicles,
    UmrahVehiclePrices,
    UmrahVisas,
)
from apps.umrah.services import UmrahPriceCalculator, UmrahBookingService
from apps.umrah.utils import (
    validate_calculator_request,
    validate_booking_request,
    create_quotation_text,
    generate_quotation_html,
    create_whatsapp_link,
)
import html2text


class UmrahCalculatorViewSet(viewsets.ViewSet):
    """
    Umrah Package Calculator API

    Endpoints:
    - GET /api/umrah/calculator/menu/ - Get Umrah dropdown menu
    - GET /api/umrah/calculator/init/ - Get calculator initialization data
    - POST /api/umrah/calculator/calculate/ - Calculate package price
    - POST /api/umrah/calculator/book/ - Create booking
    """
    permission_classes = [AllowAny]

    @action(detail=False, methods=['get'], url_path='menu')
    def get_menu(self, request):
        """
        GET /api/umrah/calculator/menu/
        Get Umrah dropdown menu structure with calculator and all packages
        """
        try:
            parent = ParentPages.objects.get(id=2)  # Umrah parent
            content_pages = ContentPages.objects.filter(
                parentid=2,
                status=1
            ).exclude(
                urllink__in=['Umrhbookingdyn']  # Exclude calculator page from list
            ).order_by('sequence')

            items = []

            # First item: Calculator
            items.append({
                'id': 0,
                'title': 'Umrah Package Calculator',
                'url': '/Umrhbookingdyn',
                'type': 'calculator',
            })

            # Content pages
            for page in content_pages:
                items.append({
                    'id': page.id,
                    'title': page.packagetitle,
                    'url': f'/{page.urllink}',
                    'type': 'content',
                })

            return Response({
                'parent': {
                    'id': parent.id,
                    'title': parent.title,
                    'url': parent.parenturl,
                },
                'items': items,
            })
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    @action(detail=False, methods=['get'], url_path='init')
    def calculator_init(self, request):
        """
        GET /api/umrah/calculator/init/
        Get all dropdown options for the calculator
        """
        try:
            # Hotels
            hotels_makkah = UmrahHotels.objects.filter(
                hotellocation='Makkah',
                hotelstatus='1'
            ).prefetch_related(
                'hotelroomperiods_set__hotelroomprice_set'
            ).order_by('hotelname')

            hotels_madinah = UmrahHotels.objects.filter(
                hotellocation='Madinah',
                hotelstatus='1'
            ).prefetch_related(
                'hotelroomperiods_set__hotelroomprice_set'
            ).order_by('hotelname')

            # Build hotel data with pricing
            makkah_data = self._serialize_hotels(hotels_makkah)
            madinah_data = self._serialize_hotels(hotels_madinah)

            # Transport
            sectors = UmrahTransportSectors.objects.filter(
                sectorstatus='1'
            ).order_by('sectorname')

            vehicles = UmrahVehicles.objects.filter(
                vehiclestatus='1'
            ).order_by('vehiclename')

            vehicle_prices = UmrahVehiclePrices.objects.filter(
                vehiclepricestatus='1'
            )

            # Visa
            visas = UmrahVisas.objects.filter(
                umrahvisapricestatus='1'
            ).order_by('umrahvisanationality')

            # Hardcoded currency data (common currencies for travel)
            currencies_data = [
                {
                    'code': 'PKR',
                    'name': 'Pakistani Rupee',
                    'symbol': '₨',
                    'rate': 277.50,  # PKR per 1 SAR
                    'flag': '🇵🇰',
                },
                {
                    'code': 'USD',
                    'name': 'US Dollar',
                    'symbol': '$',
                    'rate': 3.75,  # USD per 1 SAR
                    'flag': '🇺🇸',
                },
                {
                    'code': 'GBP',
                    'name': 'British Pound',
                    'symbol': '£',
                    'rate': 2.95,  # GBP per 1 SAR
                    'flag': '🇬🇧',
                },
                {
                    'code': 'EUR',
                    'name': 'Euro',
                    'symbol': '€',
                    'rate': 3.40,  # EUR per 1 SAR
                    'flag': '🇪🇺',
                },
                {
                    'code': 'AED',
                    'name': 'UAE Dirham',
                    'symbol': 'د.إ',
                    'rate': 1.38,  # AED per 1 SAR
                    'flag': '🇦🇪',
                },
                {
                    'code': 'SAR',
                    'name': 'Saudi Riyal',
                    'symbol': 'ر.س',
                    'rate': 1.0,  # SAR (base currency)
                    'flag': '🇸🇦',
                },
            ]

            return Response({
                'hotels': {
                    'makkah': makkah_data,
                    'madinah': madinah_data,
                },
                'transport': {
                    'sectors': [
                        {
                            'id': s.id,
                            'name': s.sectorname,
                            'markup': s.sectormarkup,
                        }
                        for s in sectors
                    ],
                    'vehicles': [
                        {
                            'id': v.id,
                            'name': v.vehiclename,
                            'markup': v.vehiclemarkup,
                        }
                        for v in vehicles
                    ],
                    'prices': [
                        {
                            'vehicle_id': vp.vehicleid,
                            'sector_id': vp.sectorid,
                            'price': float(vp.vehicleprice),
                            'markup_price': float(vp.vehiclesectormarkprice),
                        }
                        for vp in vehicle_prices
                    ],
                },
                'visas': [
                    {
                        'id': v.id,
                        'name': v.umrahvisaname,
                        'nationality': v.umrahvisanationality,
                        'price': float(v.umrahvisaprice),
                        'from': v.umrahvisaperiodfrom.isoformat(),
                        'to': v.umrahvisaperiodto.isoformat(),
                    }
                    for v in visas
                ],
                'currencies': currencies_data,
            })
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    @action(detail=False, methods=['post'], url_path='calculate')
    def calculate_price(self, request):
        """
        POST /api/umrah/calculator/calculate/
        Calculate package price without creating booking
        """
        try:
            # Validate request
            is_valid, errors = validate_calculator_request(request.data)
            if not is_valid:
                return Response(
                    {'errors': errors},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Calculate price
            calculator = UmrahPriceCalculator(request.data)
            result = calculator.calculate_total()

            return Response(result)
        except ValueError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    @action(detail=False, methods=['post'], url_path='book')
    def create_booking(self, request):
        """
        POST /api/umrah/calculator/book/
        Create booking with customer information
        """
        try:
            # Validate request
            is_valid, errors = validate_booking_request(request.data)
            if not is_valid:
                return Response(
                    {'errors': errors},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Create booking
            booking_service = UmrahBookingService()
            booking_result = booking_service.create_booking(request.data)

            # Calculate price for quotation
            calculator = UmrahPriceCalculator(request.data)
            price_breakdown = calculator.calculate_total()

            # Generate quotation
            quotation_text = create_quotation_text(request.data, price_breakdown)
            quotation_html = generate_quotation_html(request.data, price_breakdown)

            # Generate WhatsApp link
            customer = request.data.get('customer', {})
            phone = customer.get('mobile', '')
            whatsapp_link = create_whatsapp_link(phone, quotation_text) if phone else ''

            return Response(
                {
                    'success': True,
                    'booking_id': booking_result['booking_id'],
                    'customer_id': booking_result['customer_id'],
                    'totals': booking_result['totals'],
                    'quotation': {
                        'html': quotation_html,
                        'text': quotation_text,
                        'whatsapp_link': whatsapp_link,
                        'whatsapp_link_custom': create_whatsapp_link(
                            '', quotation_text
                        ).split('?phone=')[0] + '?text=' + create_whatsapp_link(
                            phone, quotation_text
                        ).split('&text=')[1],
                    },
                },
                status=status.HTTP_201_CREATED
            )
        except ValueError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def _serialize_hotels(self, hotels_queryset):
        """Serialize hotels with pricing information"""
        hotels_data = []

        for hotel in hotels_queryset:
            periods = []

            for period in hotel.hotelroomperiods_set.all():
                room_prices = {}

                for price in period.hotelroomprice_set.all():
                    room_type = price.roomtype
                    room_prices[room_type] = {
                        'weekday': float(price.ondaymarkup),
                        'weekend': float(price.offdaymarkup),
                        'markup': float(price.offdaymarkup) - float(price.ondaymarkup),
                    }

                periods.append({
                    'id': period.id,
                    'from': period.periodfrom.isoformat(),
                    'to': period.periodto.isoformat(),
                    'is_ramadan': period.ashratype == '1',
                    'room_prices': room_prices,
                })

            hotels_data.append({
                'id': hotel.id,
                'name': hotel.hotelname,
                'location': hotel.hotellocation,
                'distance': hotel.hoteldistance,
                'type': hotel.hoteltype,
                'basis_type': hotel.basistype,
                'description': hotel.hoteldesc,
                'available_periods': periods,
            })

        return hotels_data
