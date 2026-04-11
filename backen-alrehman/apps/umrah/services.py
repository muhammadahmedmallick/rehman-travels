"""
Umrah Calculator Services
Price calculation logic for booking calculator
"""
from datetime import datetime, timedelta
from decimal import Decimal
from django.db import transaction
from apps.cms.models import (
    Currency,
    ContentPages,
    Customers,
    UmrahBookingCustomers,
    UmrahBookings,
    UmrahTicketDetails,
    UmrahHotels,
    UmrahHotelRoomPeriods,
    UmrahHotelRoomPrices,
    UmrahVisas,
    UmrahVehiclePrices,
)


class UmrahPriceCalculator:
    """
    Calculate Umrah package prices with support for:
    - Multiple hotels with period-based pricing
    - Weekday/weekend pricing differentiation
    - Transport costs (special handling for per-person vehicles)
    - Visa fees (per traveler)
    - Flight fares with currency conversion
    """

    def __init__(self, request_data):
        self.data = request_data
        self.currency_cache = {}
        self.sar_rate = None
        self._load_sar_rate()

    def _load_sar_rate(self):
        """Cache SAR currency rate"""
        try:
            sar_currency = Currency.objects.get(currencycode='SAR')
            self.sar_rate = float(sar_currency.currencyrate)
        except Currency.DoesNotExist:
            self.sar_rate = 75.0  # Fallback

    def calculate_total(self) -> dict:
        """Calculate complete price breakdown"""
        try:
            hotels_breakdown = self._calculate_hotels()
            transport_breakdown = self._calculate_transport()
            visa_breakdown = self._calculate_visa()
            flight_breakdown = self._calculate_flight()

            # Calculate totals
            hotel_total = hotels_breakdown['total']
            transport_total = transport_breakdown['total']
            visa_total = visa_breakdown['total']
            flight_total = flight_breakdown['total']

            # Without flight
            total_without_flight = hotel_total + transport_total + visa_total
            total_with_flight = total_without_flight + flight_total

            # Convert to other currencies
            usd_with_flight = self._convert_from_sar(total_with_flight, 'USD')
            gbp_with_flight = self._convert_from_sar(total_with_flight, 'GBP')

            usd_without_flight = self._convert_from_sar(total_without_flight, 'USD')
            gbp_without_flight = self._convert_from_sar(total_without_flight, 'GBP')

            return {
                'breakdown': {
                    'hotels': hotels_breakdown,
                    'transport': transport_breakdown,
                    'visa': visa_breakdown,
                    'flight': flight_breakdown,
                },
                'totals': {
                    'sar': round(total_with_flight, 2),
                    'usd': round(usd_with_flight, 2),
                    'gbp': round(gbp_with_flight, 2),
                    'without_flight': {
                        'sar': round(total_without_flight, 2),
                        'usd': round(usd_without_flight, 2),
                        'gbp': round(gbp_without_flight, 2),
                    }
                },
                'summary': {
                    'total_nights': sum(h['nights'] for h in hotels_breakdown['details']),
                    'total_rooms': sum(
                        h['rooms'].get('Double', 0) +
                        h['rooms'].get('Triple', 0) +
                        h['rooms'].get('Quad', 0) +
                        h['rooms'].get('Quint', 0)
                        for h in hotels_breakdown['details']
                    ),
                    'travelers': {
                        'adults': self.data['travelers']['adults'],
                        'children': self.data['travelers']['children'],
                        'infants': self.data['travelers']['infants'],
                        'total': (
                            self.data['travelers']['adults'] +
                            self.data['travelers']['children'] +
                            self.data['travelers']['infants']
                        ),
                    }
                }
            }
        except Exception as e:
            raise ValueError(f"Price calculation error: {str(e)}")

    def _calculate_hotels(self) -> dict:
        """Calculate hotel prices with period overlap logic"""
        details = []
        total = 0.0

        for hotel_booking in self.data['hotels']:
            hotel_id = hotel_booking['hotel_id']
            check_in = datetime.strptime(hotel_booking['check_in'], '%Y-%m-%d').date()
            check_out = datetime.strptime(hotel_booking['check_out'], '%Y-%m-%d').date()

            # Get hotel with periods
            try:
                hotel = UmrahHotels.objects.get(id=hotel_id)
            except UmrahHotels.DoesNotExist:
                continue

            # Calculate nights
            nights = (check_out - check_in).days
            weekday_nights, weekend_nights = self._count_weekday_weekend(check_in, check_out)

            hotel_total = 0.0
            room_counts = hotel_booking['rooms']

            # Get pricing periods
            periods = UmrahHotelRoomPeriods.objects.filter(
                hotelid=hotel_id,
                periodstatus='1'
            ).order_by('periodfrom')

            for room_type in ['Double', 'Triple', 'Quad', 'Quint']:
                room_count = room_counts.get(room_type, 0)
                if room_count == 0:
                    continue

                # Find applicable prices for this room type
                for period in periods:
                    # Check if dates overlap
                    period_from = period.periodfrom
                    period_to = period.periodto

                    if not (check_in <= period_to and check_out >= period_from):
                        continue

                    # Get room prices
                    room_prices = UmrahHotelRoomPrices.objects.filter(
                        periodid=period.id,
                        roomtype=room_type
                    ).first()

                    if not room_prices:
                        continue

                    # Handle Ramadan special pricing
                    if period.ashratype == '1':
                        # Flat rate for entire stay
                        price = room_prices.ondaymarkup * nights * room_count
                    else:
                        # Weekday/weekend pricing
                        on_day_price = float(room_prices.ondaymarkup)
                        off_day_price = float(room_prices.offdaymarkup)

                        price = (
                            (on_day_price * weekday_nights) +
                            (off_day_price * weekend_nights)
                        ) * room_count

                    hotel_total += price

            details.append({
                'hotel': hotel.hotelname,
                'location': hotel_booking['location'],
                'check_in': hotel_booking['check_in'],
                'check_out': hotel_booking['check_out'],
                'nights': nights,
                'weekday_nights': weekday_nights,
                'weekend_nights': weekend_nights,
                'rooms': room_counts,
                'price': round(hotel_total, 2),
            })

            total += hotel_total

        return {
            'total': round(total, 2),
            'details': details,
        }

    def _count_weekday_weekend(self, check_in: 'date', check_out: 'date') -> tuple:
        """
        Count weekday and weekend nights
        Weekdays: Sat-Wed (0-4)
        Weekends: Thu-Fri (4-5)
        """
        weekday_count = 0
        weekend_count = 0

        current = check_in
        while current < check_out:
            # Thursday = 3, Friday = 4 (in Python's weekday)
            if current.weekday() in [3, 4]:
                weekend_count += 1
            else:
                weekday_count += 1
            current += timedelta(days=1)

        return weekday_count, weekend_count

    def _calculate_transport(self) -> dict:
        """Calculate transport costs"""
        if not self.data['transport']['enabled']:
            return {'total': 0.0, 'details': None}

        sector_id = self.data['transport']['sector_id']
        vehicle_id = self.data['transport']['vehicle_id']

        try:
            # Special case: vehicle_id = 5 is 50 SAR per person
            if vehicle_id == 5:
                adults = self.data['travelers']['adults']
                children = self.data['travelers']['children']
                price_per_person = 50.0
                total = (adults + children) * price_per_person

                return {
                    'total': round(total, 2),
                    'vehicle_id': vehicle_id,
                    'sector_id': sector_id,
                    'price_per_person': price_per_person,
                    'travelers': adults + children,
                }

            # Regular vehicle pricing
            vehicle_price = UmrahVehiclePrices.objects.get(
                vehicleid=vehicle_id,
                sectorid=sector_id,
                vehiclepricestatus='1'
            )

            return {
                'total': round(float(vehicle_price.vehiclesectormarkprice), 2),
                'vehicle_id': vehicle_id,
                'sector_id': sector_id,
                'base_price': round(float(vehicle_price.vehicleprice), 2),
                'markup': round(
                    float(vehicle_price.vehiclesectormarkprice) -
                    float(vehicle_price.vehicleprice),
                    2
                ),
            }
        except (UmrahVehiclePrices.DoesNotExist, Exception):
            return {'total': 0.0, 'details': None}

    def _calculate_visa(self) -> dict:
        """Calculate visa costs (per person)"""
        if not self.data['visa']['enabled']:
            return {'total': 0.0, 'details': None}

        nationality = self.data['visa']['nationality']
        nationality_map = {'Pakistan': 'Pakistan', '0': 'Pakistan', 1: 'Others', '1': 'Others'}
        nationality_str = nationality_map.get(nationality, 'Pakistan')

        try:
            visa = UmrahVisas.objects.filter(
                umrahvisanationality=nationality_str,
                umrahvisapricestatus='1'
            ).first()

            if not visa:
                return {'total': 0.0, 'details': None}

            travelers = (
                self.data['travelers']['adults'] +
                self.data['travelers']['children'] +
                self.data['travelers']['infants']
            )

            price_per_person = float(visa.umrahvisaprice)
            total = price_per_person * travelers

            return {
                'total': round(total, 2),
                'nationality': nationality_str,
                'price_per_person': round(price_per_person, 2),
                'travelers': travelers,
            }
        except Exception:
            return {'total': 0.0, 'details': None}

    def _calculate_flight(self) -> dict:
        """Calculate flight fares with currency conversion"""
        flight_data = self.data.get('flight')
        if not flight_data or not flight_data.get('enabled'):
            return {'total': 0.0, 'details': None}

        try:
            adults = self.data['travelers']['adults']
            children = self.data['travelers']['children']
            infants = self.data['travelers']['infants']

            currency = flight_data.get('currency', 'USD')
            adult_price = float(flight_data.get('adult_price', 0))
            child_price = float(flight_data.get('child_price', 0))
            infant_price = float(flight_data.get('infant_price', 0))

            # Convert to SAR
            adult_price_sar = self._convert_to_sar(adult_price, currency)
            child_price_sar = self._convert_to_sar(child_price, currency)
            infant_price_sar = self._convert_to_sar(infant_price, currency)

            total = (
                (adult_price_sar * adults) +
                (child_price_sar * children) +
                (infant_price_sar * infants)
            )

            return {
                'total': round(total, 2),
                'currency': currency,
                'adults': {
                    'count': adults,
                    'price_original': round(adult_price, 2),
                    'price_sar': round(adult_price_sar, 2),
                    'total': round(adult_price_sar * adults, 2),
                },
                'children': {
                    'count': children,
                    'price_original': round(child_price, 2),
                    'price_sar': round(child_price_sar, 2),
                    'total': round(child_price_sar * children, 2),
                },
                'infants': {
                    'count': infants,
                    'price_original': round(infant_price, 2),
                    'price_sar': round(infant_price_sar, 2),
                    'total': round(infant_price_sar * infants, 2),
                },
            }
        except Exception as e:
            return {'total': 0.0, 'error': str(e)}

    def _convert_to_sar(self, amount: float, from_currency: str) -> float:
        """Convert amount from given currency to SAR via PKR"""
        if from_currency == 'SAR':
            return amount

        try:
            from_curr = Currency.objects.get(currencycode=from_currency)
            from_rate = float(from_curr.currencyrate)

            # Convert to PKR
            pkr_amount = amount * from_rate

            # Convert PKR to SAR
            sar_amount = pkr_amount / self.sar_rate

            return sar_amount
        except Currency.DoesNotExist:
            return amount

    def _convert_from_sar(self, amount: float, to_currency: str) -> float:
        """Convert amount from SAR to given currency via PKR"""
        if to_currency == 'SAR':
            return amount

        try:
            to_curr = Currency.objects.get(currencycode=to_currency)
            to_rate = float(to_curr.currencyrate)

            # Convert SAR to PKR
            pkr_amount = amount * self.sar_rate

            # Convert PKR to target currency
            target_amount = pkr_amount / to_rate

            return target_amount
        except Currency.DoesNotExist:
            return amount


class UmrahBookingService:
    """Handle booking creation and persistence"""

    @transaction.atomic
    def create_booking(self, request_data: dict) -> dict:
        """Create complete booking with customer, hotel, and ticket details"""
        try:
            # Get or create customer
            customer_data = request_data.get('customer', {})
            customer = self._get_or_create_customer(customer_data)

            # Calculate prices
            calculator = UmrahPriceCalculator(request_data)
            price_breakdown = calculator.calculate_total()

            # Create booking customer record
            booking_customer = self._create_booking_customer(
                customer, request_data, price_breakdown
            )

            # Create hotel bookings
            for hotel_booking in request_data['hotels']:
                self._create_hotel_booking(booking_customer, hotel_booking)

            # Create ticket details if flight included
            if request_data.get('flight', {}).get('enabled'):
                self._create_ticket_details(booking_customer, request_data['flight'])

            return {
                'success': True,
                'booking_id': booking_customer.id,
                'customer_id': customer.id,
                'totals': price_breakdown['totals'],
            }
        except Exception as e:
            raise ValueError(f"Booking creation failed: {str(e)}")

    def _get_or_create_customer(self, customer_data: dict):
        """Get existing customer or create new one"""
        phone = customer_data.get('mobile', '').strip()
        email = customer_data.get('email', '').strip()

        # Try to find by email or phone
        if email:
            customer = Customers.objects.filter(email=email).first()
            if customer:
                return customer

        if phone:
            customer = Customers.objects.filter(phoneno=phone).first()
            if customer:
                return customer

        # Create new customer
        customer = Customers.objects.create(
            fname=customer_data.get('first_name', 'Guest'),
            lname=customer_data.get('last_name', ''),
            email=email,
            phoneno=phone,
            countryid=self._get_default_country(),
        )
        return customer

    def _get_default_country(self):
        """Get default country ID (Pakistan)"""
        return 1  # Assuming Pakistan is ID 1

    def _create_booking_customer(self, customer, request_data, price_breakdown):
        """Create UmrahBookingCustomers record"""
        transport_data = request_data.get('transport', {})
        visa_data = request_data.get('visa', {})

        # Get visa and transport prices from breakdown
        visa_total = price_breakdown['breakdown']['visa']['total']
        transport_total = price_breakdown['breakdown']['transport']['total']

        booking_customer = UmrahBookingCustomers.objects.create(
            customerid=customer.id,
            nationality='0' if request_data.get('visa', {}).get('nationality') == 'Pakistan' else '1',
            city=request_data.get('city_id', 0),
            transport='1' if transport_data.get('enabled') else '0',
            umrahvisaprice=visa_total,
            umrahsectorid=transport_data.get('sector_id', 5),
            umrahvehicleid=transport_data.get('vehicle_id', 5),
            umrahvehicleprice=transport_total,
            adultscount=request_data['travelers']['adults'],
            childrencount=request_data['travelers']['children'],
            infantscount=request_data['travelers']['infants'],
            totalroom=price_breakdown['summary']['total_rooms'],
            totalnight=price_breakdown['summary']['total_nights'],
            totalprice=price_breakdown['totals']['sar'],
        )
        return booking_customer

    def _create_hotel_booking(self, booking_customer, hotel_booking):
        """Create UmrahBookings record for each hotel"""
        check_in = datetime.strptime(hotel_booking['check_in'], '%Y-%m-%d').date()
        check_out = datetime.strptime(hotel_booking['check_out'], '%Y-%m-%d').date()
        rooms = hotel_booking['rooms']

        UmrahBookings.objects.create(
            location=hotel_booking['location'],
            bookingcustomerid=booking_customer.id,
            hotelid=hotel_booking['hotel_id'],
            checkin=check_in,
            checkout=check_out,
            doubleroom=rooms.get('Double', 0),
            tripleroom=rooms.get('Triple', 0),
            quadroom=rooms.get('Quad', 0),
            quintroom=rooms.get('Quint', 0),
            hoteltotalprice=0,  # Calculated separately if needed
        )

    def _create_ticket_details(self, booking_customer, flight_data):
        """Create UmrahTicketDetails record"""
        UmrahTicketDetails.objects.create(
            adultprice=flight_data.get('adult_price', 0),
            childprice=flight_data.get('child_price', 0),
            infantprice=flight_data.get('infant_price', 0),
            bookinngcustomerid=booking_customer.id,
            selectedcurrency=flight_data.get('currency', 'USD'),
            sector=flight_data.get('sector', ''),
            departure=flight_data.get('departure', ''),
            arrival=flight_data.get('arrival', ''),
        )
