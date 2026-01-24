"""
Script to organize inspected models into Django apps (FINAL version - using AST)
"""
import ast
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

def extract_python_code(file_path):
    """Extract only valid Python code from file, skipping SQL debug statements"""
    with open(file_path, 'r') as f:
        content = f.read()

    # Remove all lines that are clearly SQL debug output
    lines = content.split('\n')
    python_lines = []
    skip_next = False

    for i, line in enumerate(lines):
        # Skip obvious SQL and debug lines
        if any(marker in line for marker in ['DEBUG ', 'SELECT ', '; args=', 'FROM information_schema',
                                               'WHERE table_', 'ORDER BY', 'SHOW INDEX']):
            continue

        python_lines.append(line)

    return '\n'.join(python_lines)

def get_better_str_field(fields):
    """Find the best field to use in __str__ method"""
    better_fields = ['username', 'name', 'email', 'title', 'companyname', 'airlinename']

    for field_name, field_type in fields:
        if field_name.lower() in better_fields:
            return field_name.lower()
    return None

def generate_str_method(model_name, fields):
    """Generate a meaningful __str__ method"""
    field = get_better_str_field(fields)
    if field:
        return f'    def __str__(self):\n        return f"{{self.{field}}}"\n'
    else:
        return f'    def __str__(self):\n        return f"{model_name} {{self.id}}"\n'

def extract_model(python_code, model_name):
    """Extract a specific model class definition"""
    # Find the class definition
    pattern = rf'(class {model_name}\(models\.Model\):.*?)(?=\nclass |\Z)'
    match = re.search(pattern, python_code, re.DOTALL)

    if not match:
        return None

    model_code = match.group(1)

    # Extract field information for __str__ method
    fields = []
    for line in model_code.split('\n'):
        if ' = models.' in line and not line.strip().startswith('#'):
            field_match = re.match(r'\s+(\w+)\s*=\s*models\.', line)
            if field_match:
                fields.append((field_match.group(1), 'field'))

    # Replace managed = False with managed = True
    model_code = model_code.replace('managed = False', 'managed = True')

    # Add __str__ method if not present
    if 'def __str__' not in model_code:
        str_method = generate_str_method(model_name, fields)
        # Insert before Meta class
        if 'class Meta:' in model_code:
            model_code = model_code.replace('\n    class Meta:', '\n' + str_method + '\n    class Meta:')
        else:
            model_code += '\n' + str_method

    return model_code.strip()

def process_models():
    """Process and organize models into apps"""
    # Read the super clean file
    print("Reading super clean Python code...")
    with open('inspected_models_super_clean.py', 'r') as f:
        python_code = f.read()

    # Process each category
    for app_name, models in MODEL_CATEGORIES.items():
        print(f"\nProcessing {app_name} app ({len(models)} models)...")

        app_models = []
        for model_name in models:
            model_code = extract_model(python_code, model_name)
            if model_code:
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

            for i, model in enumerate(app_models):
                f.write(model)
                if i < len(app_models) - 1:
                    f.write('\n\n\n')
                else:
                    f.write('\n')

        print(f"  → Wrote {len(app_models)} models to {app_path}")

if __name__ == '__main__':
    process_models()
    print("\n✅ Model organization complete!")
