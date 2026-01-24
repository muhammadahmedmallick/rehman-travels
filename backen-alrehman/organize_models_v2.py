"""
Script to organize inspected models into Django apps (v2 - improved extraction)
"""
import re

# Model categorization
MODEL_CATEGORIES = {
    'core': [
        'AdministrativeSettings', 'BankDetails', 'Branches', 'Currencies',
        'Customers', 'RestApiCredentials', 'Sectors'
    ],
    'accounts': [
        'Agents', 'Users', 'Permissions', 'PermissionAssigns', 'PermissionTypes'
    ],
    'ticketing': [
        'AirlineNameCodes', 'FlightBookingReferences', 'FlightItineraryInfos',
        'FlightItineraryLegInfos', 'FlightItineraryPersonInfos',
        'FlightItineraryrefMarkupInfos', 'Inoutbounds', 'PremiumAirlines'
    ],
    'umrah': [
        'CmsVisaDurations', 'CmsVisaPackages', 'TourImages', 'TourPackages',
        'UmrahBookingCustomers', 'UmrahBookingHotelRoom', 'UmrahBookings',
        'UmrahHotelImages', 'UmrahHotelRoomPeriods', 'UmrahHotelRoomPrices',
        'UmrahHotels', 'UmrahTransportSectors', 'UmrahVehiclePrices',
        'UmrahVehicles', 'UmrahVisas'
    ],
    'payments': [
        'Payments', 'MarkupAndMarkdowns'
    ],
    'cms': [
        'CallRecordings', 'AssignCallRecordingFollowups', 'CmsCallbackQueries',
        'CmsFaqs', 'ContentPages', 'ParentPages', 'FollowupUserLogs', 'Followups'
    ],
}

def clean_model_code(model_code):
    """Clean up model code by removing SQL debug statements"""
    lines = model_code.split('\n')
    clean_lines = []
    in_class_body = False
    skip_line = False

    for line in lines:
        # Skip DEBUG lines
        if 'DEBUG' in line or 'SELECT' in line or 'FROM' in line or 'WHERE' in line or '; args=' in line:
            continue

        # Check if we're in class definition
        if line.startswith('class '):
            in_class_body = True
            clean_lines.append(line)
            continue

        # If in class body, only keep valid Python code
        if in_class_body:
            stripped = line.strip()
            # Skip SQL-looking lines
            if any(sql in stripped for sql in ['SELECT', 'FROM', 'WHERE', 'ORDER BY', 'JOIN', 'GROUP BY']):
                continue
            clean_lines.append(line)

    return '\n'.join(clean_lines)

def extract_model_code(content, model_name):
    """Extract a single model class from the content"""
    # Find start of class
    class_pattern = rf'^class {model_name}\(models\.Model\):'
    class_match = re.search(class_pattern, content, re.MULTILINE)

    if not class_match:
        return None

    start_pos = class_match.start()

    # Find end of class (next class definition or end of file)
    next_class_pattern = r'\n(?=class \w+\(models\.Model\):)'
    remaining_content = content[start_pos:]
    next_class_match = re.search(next_class_pattern, remaining_content)

    if next_class_match:
        end_pos = start_pos + next_class_match.start()
    else:
        end_pos = len(content)

    model_code = content[start_pos:end_pos]

    # Clean up the code
    model_code = clean_model_code(model_code)

    # Remove managed = False
    model_code = model_code.replace('managed = False', 'managed = True')

    return model_code.strip()

def improve_str_method(model_code, model_name):
    """Improve __str__ method to return a meaningful representation"""
    # Find a better field to display (username, name, email, etc.)
    better_fields = ['username', 'name', 'email', 'title', 'companyname']
    field_to_use = None

    for field in better_fields:
        if f'{field} = models.' in model_code or f'{field.lower()} = models.' in model_code:
            field_to_use = field.lower()
            break

    if field_to_use:
        str_method = f'\n    def __str__(self):\n        return f"{{self.{field_to_use}}}"'
    else:
        str_method = f'\n    def __str__(self):\n        return f"{model_name} {{self.id}}"'

    # Find Meta class and insert __str__ before it
    if 'class Meta:' in model_code:
        model_code = model_code.replace('\n    class Meta:', str_method + '\n\n    class Meta:')
    else:
        # Add at the end if no Meta class
        model_code += '\n' + str_method

    return model_code

def process_models():
    """Process and organize models into apps"""
    # Read cleaned inspected models
    with open('inspected_models_clean.py', 'r') as f:
        content = f.read()

    # Process each category
    for app_name, models in MODEL_CATEGORIES.items():
        print(f"\nProcessing {app_name} app ({len(models)} models)...")

        app_models = []
        for model_name in models:
            model_code = extract_model_code(content, model_name)
            if model_code:
                # Improve __str__ method
                model_code = improve_str_method(model_code, model_name)
                app_models.append(model_code)
                print(f"  ✓ {model_name}")
            else:
                print(f"  ✗ {model_name} not found")

        # Write to app's models.py
        app_path = f'apps/{app_name}/models.py'
        with open(app_path, 'w') as f:
            f.write('"""\n')
            f.write(f'{app_name.capitalize()} models\n')
            f.write('"""\n')
            f.write('from django.db import models\n')
            if app_name == 'accounts':
                f.write('from django.contrib.auth.models import AbstractBaseUser, BaseUserManager\n')
            f.write('\n\n')

            for model in app_models:
                f.write(model + '\n\n\n')

        print(f"  → Wrote {len(app_models)} models to {app_path}")

if __name__ == '__main__':
    process_models()
    print("\n✅ Model organization complete!")
