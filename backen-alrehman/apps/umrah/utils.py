"""
Umrah Utils
Helper functions for booking calculator
"""
import re
from datetime import datetime


def normalize_phone(phone: str) -> str:
    """
    Normalize phone number to +92XXXXXXXXX format
    Handles various input formats:
    - 03001234567
    - +923001234567
    - 923001234567
    """
    if not phone:
        return ''

    # Remove all non-digit characters except +
    phone = re.sub(r'[^\d+]', '', phone)

    # Remove leading +
    if phone.startswith('+'):
        phone = phone[1:]

    # Remove leading 92 if present (convert to 03xx format)
    if phone.startswith('92'):
        phone = '0' + phone[2:]

    # If starts with 0, convert to +92
    if phone.startswith('0'):
        phone = '+92' + phone[1:]
    else:
        # Add +92 prefix if not present
        phone = '+92' + phone

    return phone


def validate_date_range(check_in: str, check_out: str) -> tuple:
    """
    Validate date range
    Returns: (is_valid: bool, error_message: str)
    """
    try:
        check_in_date = datetime.strptime(check_in, '%Y-%m-%d').date()
        check_out_date = datetime.strptime(check_out, '%Y-%m-%d').date()

        if check_in_date >= check_out_date:
            return False, "Check-in date must be before check-out date"

        today = datetime.now().date()
        if check_in_date < today:
            return False, "Check-in date must be in the future"

        return True, None
    except ValueError:
        return False, "Invalid date format. Use YYYY-MM-DD"


def validate_booking_request(request_data: dict) -> tuple:
    """
    Validate booking request data
    Returns: (is_valid: bool, errors: dict)
    """
    errors = {}

    # Validate travelers
    travelers = request_data.get('travelers', {})
    if not travelers:
        errors['travelers'] = "Travelers information is required"
    else:
        total_travelers = (
            travelers.get('adults', 0) +
            travelers.get('children', 0) +
            travelers.get('infants', 0)
        )
        if total_travelers == 0:
            errors['travelers'] = "At least one traveler is required"

    # Validate hotels
    hotels = request_data.get('hotels', [])
    if not hotels:
        errors['hotels'] = "At least one hotel must be selected"
    else:
        for i, hotel in enumerate(hotels):
            is_valid, error = validate_date_range(
                hotel.get('check_in'),
                hotel.get('check_out')
            )
            if not is_valid:
                errors[f'hotel_{i}'] = error

            rooms = hotel.get('rooms', {})
            total_rooms = sum(rooms.values())
            if total_rooms == 0:
                errors[f'hotel_{i}_rooms'] = "At least one room must be selected"

    # Validate transport if enabled
    if request_data.get('transport', {}).get('enabled'):
        transport = request_data.get('transport', {})
        if not transport.get('sector_id') or not transport.get('vehicle_id'):
            errors['transport'] = "Sector and vehicle must be selected"

    # Validate customer if provided
    customer = request_data.get('customer', {})
    if customer:
        if not customer.get('email') and not customer.get('mobile'):
            errors['customer'] = "Email or mobile number is required"

        if customer.get('mobile'):
            phone = normalize_phone(customer['mobile'])
            if len(phone) < 13:  # +92 + 10 digits = 13 chars
                errors['customer_phone'] = "Invalid phone number"

    return len(errors) == 0, errors


def validate_calculator_request(request_data: dict) -> tuple:
    """
    Validate calculator request (same as booking but without customer)
    Returns: (is_valid: bool, errors: dict)
    """
    # Remove customer requirement for calculation
    request_copy = request_data.copy()
    request_copy['customer'] = {'email': 'temp@temp.com'}  # Add dummy customer

    return validate_booking_request(request_copy)


def format_currency(amount: float, currency: str = 'SAR') -> str:
    """Format amount as currency string"""
    symbols = {
        'SAR': '﷼',
        'USD': '$',
        'GBP': '£',
        'PKR': 'Rs.',
        'AED': 'د.إ',
    }

    symbol = symbols.get(currency, currency)
    return f"{symbol} {amount:,.2f}"


def create_whatsapp_link(phone: str, message: str) -> str:
    """Generate WhatsApp share link"""
    phone = normalize_phone(phone)
    # Remove + and spaces for WhatsApp API
    phone_clean = phone.replace('+', '').replace(' ', '')

    # URL encode message
    import urllib.parse
    message_encoded = urllib.parse.quote(message)

    return f"https://api.whatsapp.com/send?phone={phone_clean}&text={message_encoded}"


def create_quotation_text(booking_data: dict, price_breakdown: dict) -> str:
    """Generate plain text quotation"""
    lines = []
    lines.append("=" * 50)
    lines.append("UMRAH PACKAGE QUOTATION")
    lines.append("=" * 50)
    lines.append("")

    # Customer info
    customer = booking_data.get('customer', {})
    if customer:
        lines.append(f"Customer: {customer.get('first_name', 'Guest')}")
        lines.append(f"Email: {customer.get('email', 'N/A')}")
        lines.append(f"Phone: {customer.get('mobile', 'N/A')}")
        lines.append("")

    # Hotels
    lines.append("HOTELS:")
    for hotel in price_breakdown['breakdown']['hotels']['details']:
        lines.append(f"  {hotel['hotel']} ({hotel['location']})")
        lines.append(f"    Check-in: {hotel['check_in']}")
        lines.append(f"    Check-out: {hotel['check_out']}")
        lines.append(f"    Nights: {hotel['nights']} (Weekday: {hotel['weekday_nights']}, Weekend: {hotel['weekend_nights']})")
        lines.append(f"    Rooms: {hotel['rooms']}")
        lines.append(f"    Price: SAR {hotel['price']:,.2f}")
        lines.append("")

    # Transport
    if price_breakdown['breakdown']['transport']['total'] > 0:
        transport = price_breakdown['breakdown']['transport']
        lines.append("TRANSPORT:")
        lines.append(f"  Price: SAR {transport['total']:,.2f}")
        lines.append("")

    # Visa
    if price_breakdown['breakdown']['visa']['total'] > 0:
        visa = price_breakdown['breakdown']['visa']
        lines.append("VISA:")
        lines.append(f"  Nationality: {visa['nationality']}")
        lines.append(f"  Per Person: SAR {visa['price_per_person']:,.2f}")
        lines.append(f"  Total: SAR {visa['total']:,.2f}")
        lines.append("")

    # Flight
    if price_breakdown['breakdown']['flight']['total'] > 0:
        flight = price_breakdown['breakdown']['flight']
        lines.append("FLIGHT:")
        lines.append(f"  Adults: {flight['adults']['count']} × {flight['currency']} {flight['adults']['price_original']} = SAR {flight['adults']['total']}")
        lines.append(f"  Children: {flight['children']['count']} × {flight['currency']} {flight['children']['price_original']} = SAR {flight['children']['total']}")
        if flight['infants']['count'] > 0:
            lines.append(f"  Infants: {flight['infants']['count']} × {flight['currency']} {flight['infants']['price_original']} = SAR {flight['infants']['total']}")
        lines.append(f"  Total: SAR {flight['total']:,.2f}")
        lines.append("")

    # Totals
    lines.append("-" * 50)
    lines.append("TOTALS:")
    totals = price_breakdown['totals']
    lines.append(f"  SAR: ﷼ {totals['sar']:,.2f}")
    lines.append(f"  USD: $ {totals['usd']:,.2f}")
    lines.append(f"  GBP: £ {totals['gbp']:,.2f}")
    lines.append("")
    lines.append("Without Flight:")
    lines.append(f"  SAR: ﷼ {totals['without_flight']['sar']:,.2f}")
    lines.append(f"  USD: $ {totals['without_flight']['usd']:,.2f}")
    lines.append(f"  GBP: £ {totals['without_flight']['gbp']:,.2f}")
    lines.append("=" * 50)

    return "\n".join(lines)


def generate_quotation_html(booking_data: dict, price_breakdown: dict) -> str:
    """Generate HTML quotation for printing/display"""
    customer = booking_data.get('customer', {})
    hotel_details = price_breakdown['breakdown']['hotels']['details']
    transport = price_breakdown['breakdown']['transport']
    visa = price_breakdown['breakdown']['visa']
    flight = price_breakdown['breakdown']['flight']
    totals = price_breakdown['totals']

    html = f"""
    <html>
    <head>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; }}
            h1 {{ color: #1a73e8; border-bottom: 2px solid #1a73e8; padding-bottom: 10px; }}
            h2 {{ color: #1a73e8; margin-top: 20px; }}
            .section {{ margin: 20px 0; }}
            .hotel-card {{ border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 5px; }}
            .price {{ font-weight: bold; color: #0d7377; font-size: 16px; }}
            table {{ width: 100%; border-collapse: collapse; margin: 10px 0; }}
            th, td {{ border: 1px solid #ddd; padding: 10px; text-align: left; }}
            th {{ background-color: #f0f0f0; }}
            .total {{ background-color: #f0f0f0; font-weight: bold; }}
            .currency-row {{ display: flex; justify-content: space-between; padding: 8px 0; }}
        </style>
    </head>
    <body>
        <h1>Umrah Package Quotation</h1>

        <div class="section">
            <h3>Customer Information</h3>
            <p><strong>Name:</strong> {customer.get('first_name', 'Guest')}</p>
            <p><strong>Email:</strong> {customer.get('email', 'N/A')}</p>
            <p><strong>Phone:</strong> {customer.get('mobile', 'N/A')}</p>
        </div>

        <div class="section">
            <h2>Hotels</h2>
    """

    for hotel in hotel_details:
        html += f"""
            <div class="hotel-card">
                <h3>{hotel['hotel']} ({hotel['location']})</h3>
                <p><strong>Check-in:</strong> {hotel['check_in']}</p>
                <p><strong>Check-out:</strong> {hotel['check_out']}</p>
                <p><strong>Nights:</strong> {hotel['nights']} (Weekday: {hotel['weekday_nights']}, Weekend: {hotel['weekend_nights']})</p>
                <p><strong>Rooms:</strong> {', '.join(f"{k}: {v}" for k, v in hotel['rooms'].items() if v > 0)}</p>
                <p class="price">SAR {hotel['price']:,.2f}</p>
            </div>
        """

    if transport['total'] > 0:
        html += f"""
            <div class="section">
                <h2>Transport</h2>
                <p class="price">SAR {transport['total']:,.2f}</p>
            </div>
        """

    if visa['total'] > 0:
        html += f"""
            <div class="section">
                <h2>Visa ({visa['nationality']})</h2>
                <p><strong>Per Person:</strong> SAR {visa['price_per_person']:,.2f}</p>
                <p><strong>Travelers:</strong> {visa['travelers']}</p>
                <p class="price">SAR {visa['total']:,.2f}</p>
            </div>
        """

    if flight['total'] > 0:
        html += f"""
            <div class="section">
                <h2>Flight ({flight['currency']})</h2>
                <table>
                    <tr>
                        <th>Type</th>
                        <th>Count</th>
                        <th>Price</th>
                        <th>Total SAR</th>
                    </tr>
                    <tr>
                        <td>Adults</td>
                        <td>{flight['adults']['count']}</td>
                        <td>{flight['currency']} {flight['adults']['price_original']}</td>
                        <td>SAR {flight['adults']['total']:,.2f}</td>
                    </tr>
                    <tr>
                        <td>Children</td>
                        <td>{flight['children']['count']}</td>
                        <td>{flight['currency']} {flight['children']['price_original']}</td>
                        <td>SAR {flight['children']['total']:,.2f}</td>
                    </tr>
        """
        if flight['infants']['count'] > 0:
            html += f"""
                    <tr>
                        <td>Infants</td>
                        <td>{flight['infants']['count']}</td>
                        <td>{flight['currency']} {flight['infants']['price_original']}</td>
                        <td>SAR {flight['infants']['total']:,.2f}</td>
                    </tr>
            """
        html += """
                </table>
            </div>
        """

    html += f"""
        <div class="section">
            <h2>TOTALS</h2>
            <div style="font-size: 18px; margin: 20px 0;">
                <div class="currency-row">
                    <span>SAR:</span>
                    <strong>﷼ {totals['sar']:,.2f}</strong>
                </div>
                <div class="currency-row">
                    <span>USD:</span>
                    <strong>$ {totals['usd']:,.2f}</strong>
                </div>
                <div class="currency-row">
                    <span>GBP:</span>
                    <strong>£ {totals['gbp']:,.2f}</strong>
                </div>
            </div>

            <hr>
            <h3>Without Flight</h3>
            <div style="font-size: 16px;">
                <div class="currency-row">
                    <span>SAR:</span>
                    <strong>﷼ {totals['without_flight']['sar']:,.2f}</strong>
                </div>
                <div class="currency-row">
                    <span>USD:</span>
                    <strong>$ {totals['without_flight']['usd']:,.2f}</strong>
                </div>
                <div class="currency-row">
                    <span>GBP:</span>
                    <strong>£ {totals['without_flight']['gbp']:,.2f}</strong>
                </div>
            </div>
        </div>
    </body>
    </html>
    """

    return html
