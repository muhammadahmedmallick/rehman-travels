"""
Generate Django admin configurations for all models
"""
import os
import re

APPS = ['core', 'accounts', 'ticketing', 'umrah', 'payments', 'cms']

# Admin configurations for each app
ADMIN_CONFIGS = {
    'core': {
        'AdministrativeSettings': ['name', 'email', 'contactno', 'status'],
        'BankDetails': ['id', 'name'],
        'Branches': ['id'],
        'Currencies': ['id'],
        'Customers': ['id', 'name', 'email'],
        'RestApiCredentials': ['id'],
        'Sectors': ['id', 'from_city', 'to_city'],
    },
    'accounts': {
        'Agents': ['username', 'email', 'companyname', 'accountstatus'],
        'Users': ['username', 'email', 'designation', 'accountstatus'],
        'Permissions': ['title', 'moduletype'],
        'PermissionAssigns': ['agentid', 'userid', 'moduletype'],
        'PermissionTypes': ['title', 'moduletype'],
    },
    'ticketing': {
        'AirlineNameCodes': ['airlinename', 'carriercode', 'iatacode'],
        'FlightBookingReferences': ['id'],
        'FlightItineraryInfos': ['id'],
        'FlightItineraryLegInfos': ['id'],
        'FlightItineraryPersonInfos': ['id'],
        'FlightItineraryrefMarkupInfos': ['id'],
        'Inoutbounds': ['id'],
        'PremiumAirlines': ['id'],
    },
    'umrah': {
        'CmsVisaDurations': ['id', 'title'],
        'CmsVisaPackages': ['id', 'title'],
        'TourImages': ['id'],
        'TourPackages': ['id', 'title'],
        'UmrahBookingCustomers': ['id'],
        'UmrahBookingHotelRoom': ['id'],
        'UmrahBookings': ['id'],
        'UmrahHotelImages': ['id'],
        'UmrahHotelRoomPeriods': ['id'],
        'UmrahHotelRoomPrices': ['id'],
        'UmrahHotels': ['id', 'name'],
        'UmrahTransportSectors': ['id'],
        'UmrahVehiclePrices': ['id'],
        'UmrahVehicles': ['id'],
        'UmrahVisas': ['id'],
    },
    'payments': {
        'Payments': ['id'],
        'MarkupAndMarkdowns': ['id'],
    },
    'cms': {
        'CallRecordings': ['id'],
        'AssignCallRecordingFollowups': ['id'],
        'CmsCallbackQueries': ['id'],
        'CmsFaqs': ['id', 'question'],
        'ContentPages': ['id', 'title'],
        'ParentPages': ['id', 'title'],
        'FollowupUserLogs': ['id'],
        'Followups': ['id'],
    },
}

def extract_model_fields(file_path, model_name):
    """Extract all field names from a model"""
    with open(file_path, 'r') as f:
        content = f.read()

    # Find the model class
    pattern = rf'class {model_name}\(models\.Model\):.*?(?=\nclass |\Z)'
    match = re.search(pattern, content, re.DOTALL)

    if not match:
        return []

    model_code = match.group(0)
    fields = []

    # Extract field names
    for line in model_code.split('\n'):
        if ' = models.' in line and not line.strip().startswith('#'):
            field_match = re.match(r'\s+(\w+)\s*=\s*models\.', line)
            if field_match:
                field_name = field_match.group(1)
                # Skip some fields from admin
                if field_name not in ['password', 'remember_token', 'secretid', 'clientsecret']:
                    fields.append(field_name)

    return fields

def generate_admin_config(app_name, models_config):
    """Generate admin.py for an app"""
    app_path = f'apps/{app_name}'
    models_file = f'{app_path}/models.py'
    admin_file = f'{app_path}/admin.py'

    if not os.path.exists(models_file):
        print(f"  ✗ {models_file} not found")
        return

    # Start building admin.py content
    content = []
    content.append('"""\n')
    content.append(f'{app_name.capitalize()} admin configurations\n')
    content.append('"""\n')
    content.append('from django.contrib import admin\n')
    content.append(f'from apps.{app_name}.models import (\n')

    # Import all models
    model_names = list(models_config.keys())
    for i, model_name in enumerate(model_names):
        if i < len(model_names) - 1:
            content.append(f'    {model_name},\n')
        else:
            content.append(f'    {model_name}\n')
    content.append(')\n\n')

    # Generate admin classes
    for model_name, list_display in models_config.items():
        # Get all fields for this model
        all_fields = extract_model_fields(models_file, model_name)

        # Filter list_display to only include existing fields
        existing_display = [f for f in list_display if f in all_fields]

        if not existing_display:
            existing_display = ['id']

        # Generate search fields (text fields)
        search_fields = [f for f in existing_display if f not in ['id', 'created_at', 'updated_at']][:3]

        # Generate list_filter
        filter_fields = []
        if 'status' in all_fields:
            filter_fields.append('status')
        if 'accountstatus' in all_fields:
            filter_fields.append('accountstatus')
        if 'created_at' in all_fields:
            filter_fields.append('created_at')

        content.append('\n')
        content.append(f'@admin.register({model_name})\n')
        content.append(f'class {model_name}Admin(admin.ModelAdmin):\n')
        content.append(f'    list_display = {existing_display}\n')

        if search_fields:
            content.append(f'    search_fields = {search_fields}\n')

        if filter_fields:
            content.append(f'    list_filter = {filter_fields}\n')

        content.append(f'    list_per_page = 25\n')

        # Add date hierarchy if created_at exists
        if 'created_at' in all_fields:
            content.append(f'    date_hierarchy = \'created_at\'\n')

    # Write admin.py
    with open(admin_file, 'w') as f:
        f.writelines(content)

    print(f"  ✓ Generated {admin_file} with {len(models_config)} models")

def main():
    print("Generating admin configurations...\n")

    for app_name in APPS:
        if app_name in ADMIN_CONFIGS:
            print(f"Processing {app_name} app...")
            generate_admin_config(app_name, ADMIN_CONFIGS[app_name])

    print("\n✅ All admin configurations generated!")

if __name__ == '__main__':
    main()
