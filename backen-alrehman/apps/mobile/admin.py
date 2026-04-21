"""
Admin configuration for mobile app models
"""
from django.contrib import admin
from django.shortcuts import render, redirect
from django.urls import path
from django.contrib import messages
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from django.core.management import call_command
from import_export import resources, fields
from import_export.admin import ImportExportActionModelAdmin
from import_export.widgets import ForeignKeyWidget
from .models import MobileUserProfile, MobileVisaType, MobileVisaVariant, VisaRule, MobilePackage
from .forms import CSVImportForm
import os
import tempfile


@admin.register(MobileUserProfile)
class MobileUserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'phone_number', 'device_type',
                   'is_mobile_verified', 'created_at']
    search_fields = ['user__username', 'user__email', 'phone_number']
    list_filter = ['device_type', 'is_mobile_verified', 'created_at']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('User Information', {
            'fields': ('user',)
        }),
        ('Mobile Details', {
            'fields': ('phone_number', 'device_token', 'device_type',
                      'is_mobile_verified')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


# ==================== VISA MANAGEMENT ====================

# Import/Export Resources
class VisaRuleResource(resources.ModelResource):
    """Resource for VisaRule import/export"""
    visa_variant = fields.Field(
        column_name='visa_variant',
        attribute='visa_variant',
        widget=ForeignKeyWidget(MobileVisaVariant, 'title')
    )

    class Meta:
        model = VisaRule
        import_id_fields = ['id']
        fields = ('id', 'visa_variant', 'title', 'description',
                  'rule_type', 'icon', 'is_mandatory', 'display_order')
        export_order = fields


class CustomVisaTypeWidget(ForeignKeyWidget):
    """Custom widget to match visa types by slug"""

    def clean(self, value, row=None, **kwargs):
        """Match parent_slug from CSV to visa type by slug"""
        if not value:
            return None

        # The value is the parent_slug from CSV (e.g., "visa-singapore")
        parent_slug = str(value).strip()

        # Try to find visa type by exact slug match
        try:
            return MobileVisaType.objects.get(slug=parent_slug)
        except MobileVisaType.DoesNotExist:
            # Auto-create missing visa type from slug
            from django.utils.text import slugify

            # Extract country name from slug (e.g., "visa-singapore" -> "Singapore")
            # Remove common prefixes
            title = parent_slug.replace('visa-', '').replace('-visa', '')
            title = ' '.join(word.capitalize() for word in title.split('-'))

            # Create new visa type
            visa_type = MobileVisaType.objects.create(
                title=title,
                slug=parent_slug,
                subtitle=f'{title} Visa - Quick and Easy Processing',
                description=f'Get your {title} visa with hassle-free processing',
                is_active=True,
                display_order=0
            )
            print(f"✅ Auto-created visa type: {title} (slug: {parent_slug})")
            return visa_type


class VisaVariantResource(resources.ModelResource):
    """Resource for VisaVariant import/export"""
    visa_type = fields.Field(
        column_name='parent_slug',
        attribute='visa_type',
        widget=CustomVisaTypeWidget(MobileVisaType, 'slug')
    )
    requirements_field = fields.Field(
        column_name='Requirements',
        attribute='requirements'
    )
    price = fields.Field(
        column_name='Price',
        attribute='price'
    )
    currency = fields.Field(
        column_name='Currency',
        attribute='currency'
    )
    subtitle_csv = fields.Field(
        column_name='Sub title',
        attribute='subtitle'
    )
    slug_csv = fields.Field(
        column_name='slug',
        attribute='slug'
    )

    class Meta:
        model = MobileVisaVariant
        import_id_fields = []  # Allow creating new records
        fields = ('id', 'visa_type', 'title', 'slug', 'slug_csv', 'subtitle', 'subtitle_csv',
                  'requirements', 'requirements_field', 'price', 'currency', 'is_active', 'display_order')
        skip_unchanged = True
        report_skipped = False

    def before_import_row(self, row, **kwargs):
        """Process row data before importing"""
        from django.utils.text import slugify

        # Convert is_active (Yes/No to boolean)
        is_active_val = str(row.get('is_active', '')).strip().lower()
        row['is_active'] = is_active_val in ['yes', 'true', '1', 'y']

        # Set default display_order
        if not row.get('order') or row.get('order') == 'NULL':
            row['display_order'] = 0
        else:
            row['display_order'] = int(row.get('order', 0))

        # Get the slug from CSV
        base_slug = row.get('slug', '').strip()

        # If slug already exists, make it unique by checking database
        if base_slug:
            # Check if this exact slug already exists
            from apps.mobile.models import MobileVisaVariant
            if MobileVisaVariant.objects.filter(slug=base_slug).exists():
                # Append subtitle to make unique
                subtitle = slugify(row.get('Sub title', ''))
                if subtitle:
                    unique_slug = f"{base_slug}-{subtitle}"
                    # If still exists, append a counter
                    counter = 1
                    while MobileVisaVariant.objects.filter(slug=unique_slug).exists():
                        unique_slug = f"{base_slug}-{subtitle}-{counter}"
                        counter += 1
                    row['slug'] = unique_slug
                    print(f"⚠️  Duplicate slug detected. Changed '{base_slug}' to '{unique_slug}'")
                else:
                    # No subtitle, just append counter
                    counter = 1
                    unique_slug = f"{base_slug}-{counter}"
                    while MobileVisaVariant.objects.filter(slug=unique_slug).exists():
                        counter += 1
                        unique_slug = f"{base_slug}-{counter}"
                    row['slug'] = unique_slug
                    print(f"⚠️  Duplicate slug detected. Changed '{base_slug}' to '{unique_slug}'")
            else:
                row['slug'] = base_slug
        elif row.get('title'):
            # Auto-generate from title if slug not provided
            row['slug'] = slugify(row['title'])

        # Copy Requirements to description and includes for backwards compatibility
        if row.get('Requirements'):
            row['description'] = row.get('Requirements')
            row['includes'] = row.get('Requirements')
            row['requirements'] = row.get('Requirements')

        return row

    def after_save_instance(self, instance, using_transactions, dry_run):
        """Create visa rules from requirements after saving variant"""
        if dry_run:
            return

        # Get requirements from the instance
        requirements_text = instance.includes

        if requirements_text:
            # Delete existing rules for this variant to avoid duplicates on re-import
            VisaRule.objects.filter(visa_variant=instance).delete()

            # Split requirements by comma and create rules
            requirements_list = [r.strip() for r in requirements_text.split(',') if r.strip()]

            for idx, requirement in enumerate(requirements_list):
                # Skip very short items (likely noise)
                if len(requirement) > 3:
                    VisaRule.objects.create(
                        visa_variant=instance,
                        title=requirement,
                        description=requirement,
                        rule_type='general',
                        is_mandatory=True,
                        display_order=idx
                    )


class VisaTypeResource(resources.ModelResource):
    """Resource for VisaType import/export"""
    order = fields.Field(
        column_name='order',
        attribute='display_order'
    )
    slug_csv = fields.Field(
        column_name='slug',
        attribute='slug'
    )

    class Meta:
        model = MobileVisaType
        import_id_fields = []  # Allow creating new records
        fields = ('id', 'title', 'slug', 'slug_csv', 'order', 'is_active')
        skip_unchanged = True
        report_skipped = False

    def before_import_row(self, row, **kwargs):
        """Process row data before importing"""
        # Extract country code from title
        country_map = {
            'Singapore': 'SGP',
            'Dubai': 'ARE',
            'Indonesia': 'IDN',
            'kenya': 'KEN',
            'Kenya': 'KEN',
            'Srilanka': 'LKA',
            'Tajikistan': 'TJK',
            'Malaysia': 'MYS',
        }

        title = row.get('title', '')
        if title in country_map:
            row['country_code'] = country_map[title]

        # Auto-generate slug if not provided
        if not row.get('slug') and row.get('slug'):
            from django.utils.text import slugify
            row['slug'] = slugify(row['slug'])
        elif not row.get('slug') and title:
            from django.utils.text import slugify
            row['slug'] = slugify(title)

        # Set default subtitle and description
        if title:
            row['subtitle'] = f'{title} Visa - Quick and Easy Processing'
            row['description'] = f'Get your {title} visa with hassle-free processing'

        # Set defaults
        if not row.get('is_active'):
            row['is_active'] = True
        if not row.get('order'):
            row['display_order'] = 0

        return row


# Inline Admins
class VisaRuleInline(admin.TabularInline):
    """Inline editor for visa rules"""
    model = VisaRule
    extra = 3
    fields = ['title', 'description', 'rule_type', 'icon', 'is_mandatory', 'display_order']
    ordering = ['display_order']
    classes = ['collapse']  # Collapsed by default but expandable
    verbose_name = 'Visa Rule'
    verbose_name_plural = 'Visa Rules (Requirements)'


class VisaVariantInline(admin.StackedInline):
    """Inline editor for visa variants"""
    model = MobileVisaVariant
    extra = 0
    fields = ['title', 'slug', 'subtitle', 'price', 'currency', 'validity',
              'duration', 'num_entries', 'visa_category', 'is_active', 'is_featured', 'display_order']
    prepopulated_fields = {'slug': ('title',)}
    ordering = ['display_order']
    show_change_link = True


# Admin Classes
@admin.register(VisaRule)
class VisaRuleAdmin(ImportExportActionModelAdmin):
    """Admin interface for visa rules"""
    resource_class = VisaRuleResource
    list_display = ['id', 'title_short', 'visa_variant_display', 'rule_type', 'icon', 'is_mandatory', 'display_order']
    list_filter = ['rule_type', 'is_mandatory', 'visa_variant__visa_type', 'created_at']
    search_fields = ['title', 'description', 'visa_variant__title', 'visa_variant__visa_type__title']
    list_per_page = 100
    date_hierarchy = 'created_at'
    list_select_related = ['visa_variant', 'visa_variant__visa_type']
    list_editable = ['is_mandatory', 'display_order']

    fieldsets = (
        ('Visa Variant', {'fields': ('visa_variant',)}),
        ('Rule Information', {'fields': ('title', 'description', 'rule_type', 'icon')}),
        ('Display Settings', {'fields': ('is_mandatory', 'display_order')}),
        ('Timestamps', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )
    readonly_fields = ['created_at', 'updated_at']

    def title_short(self, obj):
        """Display shortened title"""
        if len(obj.title) > 60:
            return obj.title[:60] + '...'
        return obj.title

    title_short.short_description = 'Rule Title'
    title_short.admin_order_field = 'title'

    def visa_variant_display(self, obj):
        """Display visa variant with type"""
        return f"{obj.visa_variant.visa_type.title} - {obj.visa_variant.title}"

    visa_variant_display.short_description = 'Visa Variant'
    visa_variant_display.admin_order_field = 'visa_variant__visa_type__title'

    actions = ['mark_mandatory', 'mark_optional', 'set_transit_type', 'set_general_type']

    def mark_mandatory(self, request, queryset):
        """Mark selected rules as mandatory"""
        count = queryset.update(is_mandatory=True)
        self.message_user(request, f"✅ Marked {count} rules as mandatory.")

    mark_mandatory.short_description = "✓ Mark as mandatory"

    def mark_optional(self, request, queryset):
        """Mark selected rules as optional"""
        count = queryset.update(is_mandatory=False)
        self.message_user(request, f"✅ Marked {count} rules as optional.")

    mark_optional.short_description = "○ Mark as optional"

    def set_transit_type(self, request, queryset):
        """Set rule type to transit"""
        count = queryset.update(rule_type='transit')
        self.message_user(request, f"✅ Set {count} rules to transit type.")

    set_transit_type.short_description = "🚶 Set as transit rules"

    def set_general_type(self, request, queryset):
        """Set rule type to general"""
        count = queryset.update(rule_type='general')
        self.message_user(request, f"✅ Set {count} rules to general type.")

    set_general_type.short_description = "📋 Set as general rules"


@admin.register(MobileVisaVariant)
class MobileVisaVariantAdmin(ImportExportActionModelAdmin):
    """Admin interface for visa variants"""
    resource_class = VisaVariantResource
    list_display = ['id', 'title', 'visa_type', 'formatted_price', 'validity',
                    'visa_category', 'rules_count_display', 'is_active', 'is_featured', 'display_order']
    list_filter = ['is_active', 'is_featured', 'visa_category', 'visa_type', 'currency', 'created_at']
    search_fields = ['title', 'subtitle', 'description', 'visa_type__title']
    list_per_page = 50
    date_hierarchy = 'created_at'
    list_select_related = ['visa_type']
    inlines = [VisaRuleInline]
    prepopulated_fields = {'slug': ('title',)}

    fieldsets = (
        ('Visa Type', {'fields': ('visa_type',)}),
        ('Basic Information', {'fields': ('title', 'slug', 'subtitle', 'description', 'requirements')}),
        ('Images', {'fields': ('thumbnail', 'banner'), 'classes': ('collapse',)}),
        ('Pricing & Validity', {'fields': ('price', 'currency', 'validity', 'duration',
                                           'num_entries', 'processing_time')}),
        ('Classification', {'fields': ('visa_category',)}),
        ('Additional Details', {'fields': ('includes', 'excludes'), 'classes': ('collapse',)}),
        ('Display Settings', {'fields': ('is_active', 'is_featured', 'display_order')}),
        ('Timestamps', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )
    readonly_fields = ['created_at', 'updated_at']

    def rules_count_display(self, obj):
        """Display count of rules with link to manage them"""
        count = obj.rules.count()
        if count > 0:
            return f'📋 {count} rules'
        return '⚠️ No rules'

    rules_count_display.short_description = 'Rules'
    rules_count_display.admin_order_field = 'rules__count'

    actions = ['make_active', 'make_inactive', 'mark_as_featured', 'regenerate_rules']

    def regenerate_rules(self, request, queryset):
        """Regenerate rules from includes field for selected variants"""
        total_rules_created = 0
        variants_updated = 0

        for variant in queryset:
            if variant.includes:
                # Delete existing rules
                VisaRule.objects.filter(visa_variant=variant).delete()

                # Create new rules from includes
                requirements_list = [r.strip() for r in variant.includes.split(',') if r.strip()]

                for idx, requirement in enumerate(requirements_list):
                    if len(requirement) > 3:
                        VisaRule.objects.create(
                            visa_variant=variant,
                            title=requirement,
                            description=requirement,
                            rule_type='general',
                            is_mandatory=True,
                            display_order=idx
                        )
                        total_rules_created += 1

                variants_updated += 1

        self.message_user(
            request,
            f"✅ Regenerated rules for {variants_updated} variants. Created {total_rules_created} rules."
        )

    regenerate_rules.short_description = "🔄 Regenerate rules from requirements"

    def make_active(self, request, queryset):
        """Bulk action to mark variants as active"""
        count = queryset.update(is_active=True)
        self.message_user(request, f"{count} variants marked as active.")

    make_active.short_description = "Mark selected variants as active"

    def make_inactive(self, request, queryset):
        """Bulk action to mark variants as inactive"""
        count = queryset.update(is_active=False)
        self.message_user(request, f"{count} variants marked as inactive.")

    make_inactive.short_description = "Mark selected variants as inactive"

    def mark_as_featured(self, request, queryset):
        """Bulk action to mark variants as featured"""
        count = queryset.update(is_featured=True)
        self.message_user(request, f"{count} variants marked as featured.")

    mark_as_featured.short_description = "Mark selected variants as featured"


@admin.register(MobileVisaType)
class MobileVisaTypeAdmin(ImportExportActionModelAdmin):
    """Admin interface for visa types"""
    resource_class = VisaTypeResource
    list_display = ['id', 'title', 'country_code', 'active_variants_count',
                    'processing_time', 'is_active', 'display_order']
    list_filter = ['is_active', 'country_code', 'created_at']
    search_fields = ['title', 'subtitle', 'description', 'country_code']
    list_per_page = 25
    date_hierarchy = 'created_at'
    inlines = [VisaVariantInline]

    prepopulated_fields = {'slug': ('title',)}

    fieldsets = (
        ('Basic Information', {'fields': ('title', 'slug', 'subtitle', 'description')}),
        ('Images', {'fields': ('thumbnail', 'banner'), 'classes': ('collapse',)}),
        ('Metadata', {'fields': ('country_code', 'processing_time')}),
        ('Display Settings', {'fields': ('is_active', 'display_order')}),
        ('Timestamps', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )
    readonly_fields = ['created_at', 'updated_at']

    actions = ['make_active', 'make_inactive']

    def get_urls(self):
        """Add custom URL for CSV import"""
        urls = super().get_urls()
        custom_urls = [
            path('import-csv/', self.admin_site.admin_view(self.import_csv_view), name='mobile_visa_import_csv'),
        ]
        return custom_urls + urls

    def import_csv_view(self, request):
        """Custom view to handle CSV upload and import"""
        if request.method == 'POST':
            form = CSVImportForm(request.POST, request.FILES)
            if form.is_valid():
                visa_types_file = request.FILES['visa_types_csv']
                variants_file = request.FILES['variants_csv']
                clear_existing = form.cleaned_data.get('clear_existing', False)

                try:
                    # Create temporary files to store uploaded CSVs
                    with tempfile.NamedTemporaryFile(mode='wb', suffix='.csv', delete=False) as types_tmp:
                        for chunk in visa_types_file.chunks():
                            types_tmp.write(chunk)
                        types_path = types_tmp.name

                    with tempfile.NamedTemporaryFile(mode='wb', suffix='.csv', delete=False) as variants_tmp:
                        for chunk in variants_file.chunks():
                            variants_tmp.write(chunk)
                        variants_path = variants_tmp.name

                    # Build command arguments
                    cmd_args = [types_path, variants_path]
                    cmd_options = {}
                    if clear_existing:
                        cmd_options['clear'] = True

                    # Call the management command
                    call_command('import_visa_csv', *cmd_args, **cmd_options)

                    # Clean up temporary files
                    os.unlink(types_path)
                    os.unlink(variants_path)

                    # Show success message
                    messages.success(
                        request,
                        '✅ CSV import completed successfully! Check the statistics below for details.'
                    )

                    # Get statistics
                    types_count = MobileVisaType.objects.count()
                    variants_count = MobileVisaVariant.objects.count()
                    rules_count = VisaRule.objects.count()

                    messages.info(
                        request,
                        f'📊 Current Statistics: {types_count} visa types, '
                        f'{variants_count} variants, {rules_count} rules'
                    )

                    return redirect('..')  # Redirect to visa types list

                except Exception as e:
                    messages.error(
                        request,
                        f'❌ Import failed: {str(e)}'
                    )
                    # Clean up temporary files on error
                    try:
                        if 'types_path' in locals():
                            os.unlink(types_path)
                        if 'variants_path' in locals():
                            os.unlink(variants_path)
                    except:
                        pass
        else:
            form = CSVImportForm()

        # Get current statistics
        types_count = MobileVisaType.objects.count()
        variants_count = MobileVisaVariant.objects.count()
        rules_count = VisaRule.objects.count()

        context = {
            'form': form,
            'title': 'Import Visa Data from CSV',
            'opts': self.model._meta,
            'has_view_permission': self.has_view_permission(request),
            'site_title': 'Mobile Admin',
            'site_header': 'Mobile Administration',
            'types_count': types_count,
            'variants_count': variants_count,
            'rules_count': rules_count,
        }

        return render(request, 'admin/mobile/visa_csv_import.html', context)

    def make_active(self, request, queryset):
        """Bulk action to mark visa types as active"""
        count = queryset.update(is_active=True)
        self.message_user(request, f"{count} visa types marked as active.")

    make_active.short_description = "Mark selected visa types as active"

    def make_inactive(self, request, queryset):
        """Bulk action to mark visa types as inactive"""
        count = queryset.update(is_active=False)
        self.message_user(request, f"{count} visa types marked as inactive.")

    make_inactive.short_description = "Mark selected visa types as inactive"


# ==================== PACKAGE MANAGEMENT ====================

class PackageResource(resources.ModelResource):
    """Resource for Package import/export"""

    class Meta:
        model = MobilePackage
        import_id_fields = ['slug']
        fields = ('id', 'thumbnail', 'banner', 'video_url', 'package_type',
                  'title', 'slug', 'description', 'tags', 'contact_no',
                  'whatsapp_no', 'informational_message', 'starting_from',
                  'price', 'currency', 'location', 'is_active', 'is_featured',
                  'display_order')
        export_order = fields

    def before_import_row(self, row, **kwargs):
        """Preprocess row before import"""
        # Auto-generate slug from title if not provided
        if not row.get('slug') and row.get('title'):
            from django.utils.text import slugify
            row['slug'] = slugify(row['title'])


@admin.register(MobilePackage)
class MobilePackageAdmin(ImportExportActionModelAdmin):
    """Admin interface for travel packages"""
    resource_class = PackageResource
    list_display = ['id', 'title', 'package_type', 'formatted_price',
                    'location', 'is_featured', 'is_active', 'display_order', 'created_at']
    list_filter = ['package_type', 'is_active', 'is_featured', 'currency', 'created_at']
    search_fields = ['title', 'description', 'tags', 'location', 'slug']
    list_per_page = 50
    date_hierarchy = 'created_at'
    prepopulated_fields = {'slug': ('title',)}

    fieldsets = (
        ('Media', {
            'fields': ('thumbnail', 'banner', 'video_url'),
            'classes': ('collapse',)
        }),
        ('Basic Information', {
            'fields': ('package_type', 'title', 'slug', 'description', 'tags')
        }),
        ('Contact Information', {
            'fields': ('contact_no', 'whatsapp_no', 'informational_message'),
            'classes': ('collapse',)
        }),
        ('Pricing & Location', {
            'fields': ('starting_from', 'price', 'currency', 'location')
        }),
        ('Display Settings', {
            'fields': ('is_active', 'is_featured', 'display_order')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
    readonly_fields = ['created_at', 'updated_at']

    actions = ['make_active', 'make_inactive', 'mark_as_featured', 'unmark_as_featured']

    def make_active(self, request, queryset):
        """Bulk action to mark packages as active"""
        count = queryset.update(is_active=True)
        self.message_user(request, f"✅ {count} packages marked as active.")

    make_active.short_description = "✓ Mark as active"

    def make_inactive(self, request, queryset):
        """Bulk action to mark packages as inactive"""
        count = queryset.update(is_active=False)
        self.message_user(request, f"✅ {count} packages marked as inactive.")

    make_inactive.short_description = "✗ Mark as inactive"

    def mark_as_featured(self, request, queryset):
        """Bulk action to mark packages as featured"""
        count = queryset.update(is_featured=True)
        self.message_user(request, f"✅ {count} packages marked as featured.")

    mark_as_featured.short_description = "⭐ Mark as featured"

    def unmark_as_featured(self, request, queryset):
        """Bulk action to unmark packages as featured"""
        count = queryset.update(is_featured=False)
        self.message_user(request, f"✅ {count} packages unmarked as featured.")

    unmark_as_featured.short_description = "○ Unmark as featured"
