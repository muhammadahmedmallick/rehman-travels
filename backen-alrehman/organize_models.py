"""
Script to organize inspected models into Django apps
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
    # Models to skip (Django's own or Laravel-specific)
    'skip': [
        'AuthGroup', 'AuthGroupPermissions', 'AuthPermission', 'AuthUser',
        'AuthUserGroups', 'AuthUserUserPermissions', 'DjangoAdminLog',
        'DjangoContentType', 'DjangoMigrations', 'DjangoSession',
        'FailedJobs', 'Jobs', 'Migrations', 'PasswordResets', 'PersonalAccessTokens'
    ]
}

def extract_model_code(content, model_name):
    """Extract a single model class from the content"""
    # Find the model class definition
    pattern = rf'class {model_name}\(models\.Model\):.*?(?=\nclass |\Z)'
    match = re.search(pattern, content, re.DOTALL)

    if match:
        model_code = match.group(0)
        # Remove managed = False and clean up
        model_code = model_code.replace('managed = False', 'managed = True')
        return model_code
    return None

def add_str_method(model_code, model_name):
    """Add __str__ method to model if not present"""
    if '__str__' in model_code:
        return model_code

    # Find the Meta class and add __str__ before it
    lines = model_code.split('\n')
    result_lines = []
    meta_found = False

    for i, line in enumerate(lines):
        if '    class Meta:' in line and not meta_found:
            # Add __str__ method before Meta
            result_lines.append('')
            result_lines.append('    def __str__(self):')
            result_lines.append(f'        return f"{model_name} {{self.id}}"')
            meta_found = True
        result_lines.append(line)

    return '\n'.join(result_lines)

def process_models():
    """Process and organize models into apps"""
    # Read cleaned inspected models
    with open('inspected_models_clean.py', 'r') as f:
        content = f.read()

    # Process each category
    for app_name, models in MODEL_CATEGORIES.items():
        if app_name == 'skip':
            continue

        print(f"\nProcessing {app_name} app ({len(models)} models)...")

        app_models = []
        for model_name in models:
            model_code = extract_model_code(content, model_name)
            if model_code:
                # Add __str__ method
                model_code = add_str_method(model_code, model_name)
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
            f.write('from django.contrib.auth.models import AbstractBaseUser, BaseUserManager\n\n')

            for model in app_models:
                f.write('\n' + model + '\n')

        print(f"  → Wrote {len(app_models)} models to {app_path}")

if __name__ == '__main__':
    process_models()
    print("\n✅ Model organization complete!")
