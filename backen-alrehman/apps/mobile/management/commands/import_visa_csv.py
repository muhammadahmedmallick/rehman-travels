"""
Django management command to import visa data from CSV files.

Usage:
    python manage.py import_visa_csv <visa_types_csv> <variants_csv> [--clear]

Example:
    python manage.py import_visa_csv \
        "/Users/muhammadahmed/Downloads/navigation_minimal - Visa.csv" \
        "/Users/muhammadahmed/Downloads/navigation_minimal - Child Variant.csv" \
        --clear
"""
import csv
from decimal import Decimal
from django.core.management.base import BaseCommand, CommandError
from apps.mobile.models import MobileVisaType, MobileVisaVariant, VisaRule


class Command(BaseCommand):
    help = 'Import visa data from CSV files'

    def add_arguments(self, parser):
        parser.add_argument(
            'visa_types_csv',
            type=str,
            help='Path to visa types CSV file'
        )
        parser.add_argument(
            'variants_csv',
            type=str,
            help='Path to visa variants CSV file'
        )
        parser.add_argument(
            '--clear',
            action='store_true',
            help='Clear existing visa data before import'
        )

    def handle(self, *args, **options):
        visa_types_path = options['visa_types_csv']
        variants_path = options['variants_csv']
        clear_data = options['clear']

        # Clear existing data if requested
        if clear_data:
            if self.confirm_clear():
                self.stdout.write(self.style.WARNING('Clearing existing visa data...'))
                VisaRule.objects.all().delete()
                MobileVisaVariant.objects.all().delete()
                MobileVisaType.objects.all().delete()
                self.stdout.write(self.style.SUCCESS('✓ Data cleared'))
            else:
                self.stdout.write(self.style.ERROR('Import cancelled'))
                return

        # Import visa types
        self.stdout.write(self.style.HTTP_INFO('\n=== IMPORTING VISA TYPES ==='))
        types_imported = self.import_visa_types(visa_types_path)
        self.stdout.write(self.style.SUCCESS(f'✓ Imported {types_imported} visa types'))

        # Import variants
        self.stdout.write(self.style.HTTP_INFO('\n=== IMPORTING VISA VARIANTS ==='))
        variants_imported, rules_imported = self.import_visa_variants(variants_path)
        self.stdout.write(self.style.SUCCESS(f'✓ Imported {variants_imported} visa variants'))
        self.stdout.write(self.style.SUCCESS(f'✓ Created {rules_imported} visa rules'))

        # Summary
        self.stdout.write(self.style.SUCCESS(
            f'\n✅ IMPORT COMPLETE!\n'
            f'   Visa Types: {types_imported}\n'
            f'   Variants: {variants_imported}\n'
            f'   Rules: {rules_imported}'
        ))

    def confirm_clear(self):
        """Ask for confirmation before clearing data."""
        response = input('This will DELETE all existing visa data. Continue? (yes/no): ')
        return response.lower() == 'yes'

    def import_visa_types(self, csv_path):
        """
        Import visa types from CSV.

        CSV Format: parent_slug, title, slug, order, is_active, image_url
        """
        count = 0
        slug_to_title = {}  # For variant mapping later

        try:
            with open(csv_path, 'r', encoding='utf-8') as file:
                reader = csv.DictReader(file)

                for row in reader:
                    # Skip empty rows
                    if not row.get('title') or not row.get('title').strip():
                        continue

                    title = row['title'].strip()
                    slug = row['slug'].strip()

                    # Store slug to title mapping for variant import
                    slug_to_title[slug] = title

                    # Extract country code from title if possible
                    country_code = self.extract_country_code(title)

                    # Create or update visa type
                    visa_type, created = MobileVisaType.objects.update_or_create(
                        title=title,
                        defaults={
                            'subtitle': f'{title} - Quick and Easy Processing',
                            'description': f'Get your {title} with hassle-free processing',
                            'country_code': country_code,
                            'is_active': True,
                            'display_order': count,
                        }
                    )

                    action = 'Created' if created else 'Updated'
                    self.stdout.write(f'  {action}: {visa_type.title}')
                    count += 1

            # Store the mapping for later use
            self.slug_to_title = slug_to_title
            return count

        except FileNotFoundError:
            raise CommandError(f'Visa types CSV file not found: {csv_path}')
        except Exception as e:
            raise CommandError(f'Error importing visa types: {str(e)}')

    def import_visa_variants(self, csv_path):
        """
        Import visa variants from CSV.

        CSV Format: parent_slug, title, slug, order, is_active, Requirements, Price, Currency, Sub title
        """
        variants_count = 0
        rules_count = 0

        try:
            with open(csv_path, 'r', encoding='utf-8') as file:
                reader = csv.DictReader(file)

                for row in reader:
                    # Skip empty rows
                    if not row.get('title') or not row.get('title').strip():
                        continue

                    parent_slug = row['parent_slug(child category)'].strip()
                    title = row['title'].strip()
                    requirements = row.get('Requirements', '').strip()
                    price_str = row.get('Price', '').strip()
                    currency = row.get('Currency', 'PKR').strip()
                    subtitle = row.get('Sub title', '').strip()

                    # Find parent visa type
                    visa_type = self.find_visa_type_by_slug(parent_slug)

                    if not visa_type:
                        self.stdout.write(
                            self.style.WARNING(
                                f'  ⚠ Parent not found for "{parent_slug}", skipping variant: {title}'
                            )
                        )
                        continue

                    # Parse price
                    price = self.parse_price(price_str)

                    # Determine visa category
                    category = self.determine_category(title, requirements)

                    # Extract duration and validity from requirements
                    duration, validity, processing_time = self.extract_details(requirements)

                    # Create or update variant
                    variant, created = MobileVisaVariant.objects.update_or_create(
                        visa_type=visa_type,
                        title=title,
                        defaults={
                            'subtitle': subtitle,
                            'description': requirements,
                            'price': price,
                            'currency': currency,
                            'duration': duration or title,  # Use title as fallback
                            'validity': validity,
                            'processing_time': processing_time,
                            'num_entries': self.extract_entries(title, requirements),
                            'visa_category': category,
                            'includes': requirements,
                            'is_active': True,
                            'display_order': variants_count,
                        }
                    )

                    action = 'Created' if created else 'Updated'
                    self.stdout.write(
                        f'  {action}: {visa_type.title} - {title} '
                        f'({currency} {price if price else "N/A"})'
                    )
                    variants_count += 1

                    # Create rules from requirements
                    if requirements and created:
                        rules = self.parse_requirements_to_rules(requirements)
                        for idx, rule_text in enumerate(rules):
                            VisaRule.objects.create(
                                visa_variant=variant,
                                title=rule_text,
                                description=rule_text,
                                rule_type='general',
                                display_order=idx,
                                is_mandatory=True
                            )
                            rules_count += 1

            return variants_count, rules_count

        except FileNotFoundError:
            raise CommandError(f'Variants CSV file not found: {csv_path}')
        except Exception as e:
            raise CommandError(f'Error importing variants: {str(e)}')

    def find_visa_type_by_slug(self, slug):
        """Find visa type by matching slug patterns."""
        # Try direct slug match first
        if hasattr(self, 'slug_to_title'):
            title = self.slug_to_title.get(slug)
            if title:
                return MobileVisaType.objects.filter(title=title).first()

        # Try partial matching
        for keyword in ['singapore', 'dubai', 'indonesia', 'kenya', 'srilanka',
                       'tajikistan', 'malaysia']:
            if keyword in slug.lower():
                return MobileVisaType.objects.filter(
                    title__icontains=keyword
                ).first()

        return None

    def extract_country_code(self, title):
        """Extract country code from title."""
        country_map = {
            'Singapore': 'SGP',
            'Dubai': 'ARE',
            'Indonesia': 'IDN',
            'Kenya': 'KEN',
            'Srilanka': 'LKA',
            'Tajikistan': 'TJK',
            'Malaysia': 'MYS',
        }

        for country, code in country_map.items():
            if country.lower() in title.lower():
                return code

        return ''

    def parse_price(self, price_str):
        """Parse price string to Decimal."""
        if not price_str:
            return None

        try:
            # Remove any non-numeric characters except decimal point
            cleaned = ''.join(c for c in price_str if c.isdigit() or c == '.')
            return Decimal(cleaned) if cleaned else None
        except:
            return None

    def determine_category(self, title, requirements):
        """Determine visa category from title and requirements."""
        text = (title + ' ' + requirements).lower()

        if 'tourist' in text:
            return 'tourist'
        elif 'business' in text:
            return 'business'
        elif 'transit' in text:
            return 'transit'
        elif 'work' in text:
            return 'work'
        elif 'student' in text:
            return 'student'
        elif 'umrah' in text or 'hajj' in text:
            return 'religious'
        else:
            return 'tourist'  # Default

    def extract_details(self, requirements):
        """Extract duration, validity, and processing time from requirements."""
        duration = ''
        validity = ''
        processing_time = ''

        if not requirements:
            return duration, validity, processing_time

        text = requirements.lower()

        # Extract duration
        if 'duration of stay' in text:
            parts = text.split('duration of stay')
            if len(parts) > 1:
                duration_part = parts[1].split(',')[0].strip()
                duration = duration_part.replace('in', '').strip()

        # Extract validity
        if 'validity' in text:
            parts = text.split('validity')
            if len(parts) > 1:
                validity_part = parts[1].split(',')[0].strip()
                validity = validity_part.replace('(travel time)', '').strip()

        # Extract processing time
        if 'processing' in text or 'working days' in text:
            parts = text.split('processing')
            if len(parts) > 1:
                processing_part = parts[1].split(',')[0].strip()
                processing_time = processing_part.replace('time', '').replace('is', '').strip()
            elif 'working days' in text:
                # Find the pattern "X working days"
                import re
                match = re.search(r'(\d+\s+(?:to\s+)?\d*\s*working\s+days)', text)
                if match:
                    processing_time = match.group(1)

        return duration, validity, processing_time

    def extract_entries(self, title, requirements):
        """Extract number of entries from title or requirements."""
        text = (title + ' ' + requirements).lower()

        if 'single' in text:
            return 'Single Entry'
        elif 'double' in text:
            return 'Double Entry'
        elif 'multiple' in text:
            return 'Multiple Entry'

        return 'Single Entry'  # Default

    def parse_requirements_to_rules(self, requirements):
        """
        Parse comma-separated requirements into individual rules.

        Returns a list of rule texts.
        """
        if not requirements:
            return []

        # Split by comma
        rules = [r.strip() for r in requirements.split(',') if r.strip()]

        # Clean up and return
        return [r for r in rules if len(r) > 3]  # Filter out very short items
