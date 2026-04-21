"""
Management command to verify visa CSV before import
"""
import csv
from django.core.management.base import BaseCommand
from apps.mobile.models import MobileVisaType, MobileVisaVariant


class Command(BaseCommand):
    help = 'Verify visa CSV data before importing'

    def add_arguments(self, parser):
        parser.add_argument('csv_file', type=str, help='Path to CSV file')

    def handle(self, *args, **options):
        csv_file = options['csv_file']

        self.stdout.write(self.style.WARNING(f'\n📋 Verifying CSV: {csv_file}\n'))

        # Read CSV
        with open(csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter='\t')
            rows = list(reader)

        self.stdout.write(f"✅ Found {len(rows)} rows\n")

        # Check for unique visa types
        parent_slugs = set(row['parent_slug(child category)'] for row in rows)
        self.stdout.write(f"✅ Found {len(parent_slugs)} unique parent slugs (visa types):\n")
        for slug in sorted(parent_slugs):
            self.stdout.write(f"   - {slug}")

        # Check which visa types exist in database
        self.stdout.write(self.style.WARNING(f'\n🔍 Checking database for existing visa types...\n'))
        missing_types = []
        for slug in parent_slugs:
            # Extract country keyword
            slug_lower = slug.lower()
            found = False

            keywords = ['sri-lanka', 'srilanka', 'saudi-arabia', 'saudi', 'singapore',
                       'dubai', 'indonesia', 'kenya', 'tajikistan', 'malaysia',
                       'thailand', 'azerbaijan', 'uzbekistan', 'turkey', 'cambodia',
                       'vietnam', 'kazakhstan', 'umrah']

            for keyword in keywords:
                if keyword in slug_lower:
                    # Try to find visa type
                    country_map = {
                        'sri-lanka': 'Sri Lanka',
                        'srilanka': 'Sri Lanka',
                        'saudi-arabia': 'Saudi Arabia',
                        'saudi': 'Saudi Arabia',
                        'umrah': 'Saudi Arabia',
                        'singapore': 'Singapore',
                        'dubai': 'Dubai',
                        'indonesia': 'Indonesia',
                        'kenya': 'Kenya',
                        'tajikistan': 'Tajikistan',
                        'malaysia': 'Malaysia',
                        'thailand': 'Thailand',
                        'azerbaijan': 'Azerbaijan',
                        'uzbekistan': 'Uzbekistan',
                        'turkey': 'Turkey',
                        'cambodia': 'Cambodia',
                        'vietnam': 'Vietnam',
                        'kazakhstan': 'Kazakhstan',
                    }
                    country = country_map.get(keyword)
                    if country:
                        if MobileVisaType.objects.filter(title=country).exists():
                            self.stdout.write(self.style.SUCCESS(f"   ✅ {slug} → {country} (exists)"))
                            found = True
                            break
                        else:
                            self.stdout.write(self.style.WARNING(f"   ⚠️  {slug} → {country} (will be auto-created)"))
                            missing_types.append((slug, country))
                            found = True
                            break

            if not found:
                self.stdout.write(self.style.ERROR(f"   ❌ {slug} → No mapping found!"))
                missing_types.append((slug, None))

        # Check for duplicate slugs
        self.stdout.write(self.style.WARNING(f'\n🔍 Checking for duplicate slugs...\n'))
        slug_counts = {}
        for row in rows:
            slug = row.get('slug', '').strip()
            if slug:
                slug_counts[slug] = slug_counts.get(slug, 0) + 1

        duplicates = {slug: count for slug, count in slug_counts.items() if count > 1}
        if duplicates:
            self.stdout.write(self.style.ERROR(f"   ⚠️  Found {len(duplicates)} duplicate slugs:"))
            for slug, count in duplicates.items():
                self.stdout.write(f"      - {slug} appears {count} times")
                # Show which variants have this slug
                for row in rows:
                    if row.get('slug', '').strip() == slug:
                        self.stdout.write(f"         → {row.get('Sub title', 'N/A')}")
            self.stdout.write(self.style.SUCCESS("   ✅ Import will auto-fix duplicates by appending subtitles"))
        else:
            self.stdout.write(self.style.SUCCESS("   ✅ No duplicate slugs found"))

        # Summary
        self.stdout.write(self.style.SUCCESS(f'\n📊 Summary:'))
        self.stdout.write(f"   - Total variants to import: {len(rows)}")
        self.stdout.write(f"   - Visa types that will be auto-created: {len([t for t in missing_types if t[1]])}")
        self.stdout.write(f"   - Duplicate slugs to fix: {len(duplicates)}")

        # Current database stats
        current_types = MobileVisaType.objects.count()
        current_variants = MobileVisaVariant.objects.count()
        self.stdout.write(f"\n   Current database:")
        self.stdout.write(f"   - Visa Types: {current_types}")
        self.stdout.write(f"   - Visa Variants: {current_variants}")

        self.stdout.write(self.style.SUCCESS(f'\n✅ Verification complete! You can now import the CSV.\n'))
