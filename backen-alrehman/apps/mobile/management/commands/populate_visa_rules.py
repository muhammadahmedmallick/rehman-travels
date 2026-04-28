"""
Management command to populate visa rules from existing requirements
"""
from django.core.management.base import BaseCommand
from apps.mobile.models import MobileVisaVariant, VisaRule


class Command(BaseCommand):
    help = 'Populate visa rules from existing requirements in variants'

    def add_arguments(self, parser):
        parser.add_argument(
            '--dry-run',
            action='store_true',
            help='Show what would be created without actually creating',
        )

    def handle(self, *args, **options):
        dry_run = options.get('dry_run', False)

        if dry_run:
            self.stdout.write(self.style.WARNING('\n🔍 DRY RUN MODE - No changes will be made\n'))

        variants = MobileVisaVariant.objects.all()
        total_variants = variants.count()
        processed = 0
        created_rules = 0
        skipped = 0

        self.stdout.write(f'Processing {total_variants} variants...\n')

        for variant in variants:
            # Get requirements from the variant
            requirements_text = variant.requirements or variant.includes

            if not requirements_text:
                skipped += 1
                continue

            # Split requirements by comma and create rules
            requirements_list = [r.strip() for r in requirements_text.split(',') if r.strip()]

            if not requirements_list:
                skipped += 1
                continue

            if not dry_run:
                # Delete existing rules to avoid duplicates
                deleted_count = VisaRule.objects.filter(visa_variant=variant).delete()[0]
                if deleted_count > 0:
                    self.stdout.write(f'  🗑️  Deleted {deleted_count} existing rules for: {variant.title}')

            variant_rules_count = 0
            for idx, requirement in enumerate(requirements_list):
                # Skip very short items (likely noise)
                if len(requirement) > 3:
                    if dry_run:
                        self.stdout.write(f'  Would create rule: {requirement[:60]}...')
                    else:
                        VisaRule.objects.create(
                            visa_variant=variant,
                            title=requirement,
                            description=requirement,
                            rule_type='general',
                            is_mandatory=True,
                            display_order=idx
                        )
                    variant_rules_count += 1
                    created_rules += 1

            if variant_rules_count > 0:
                processed += 1
                self.stdout.write(
                    self.style.SUCCESS(
                        f'✅ {variant.title} ({variant.visa_type.title}): '
                        f'{variant_rules_count} rules {"would be created" if dry_run else "created"}'
                    )
                )

        # Summary
        self.stdout.write(self.style.SUCCESS(f'\n📊 Summary:'))
        self.stdout.write(f'  - Total variants: {total_variants}')
        self.stdout.write(f'  - Variants processed: {processed}')
        self.stdout.write(f'  - Variants skipped (no requirements): {skipped}')
        self.stdout.write(f'  - Total rules {"would be created" if dry_run else "created"}: {created_rules}')

        if dry_run:
            self.stdout.write(self.style.WARNING(f'\n⚠️  This was a DRY RUN. Run without --dry-run to apply changes.\n'))
        else:
            self.stdout.write(self.style.SUCCESS(f'\n✅ Rules populated successfully!\n'))
