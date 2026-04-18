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
from .models import MobileUserProfile, MobileVisaType, MobileVisaVariant, VisaRule
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


class VisaVariantResource(resources.ModelResource):
    """Resource for VisaVariant import/export"""
    visa_type = fields.Field(
        column_name='visa_type',
        attribute='visa_type',
        widget=ForeignKeyWidget(MobileVisaType, 'title')
    )

    class Meta:
        model = MobileVisaVariant
        import_id_fields = ['id']
        fields = ('id', 'visa_type', 'title', 'subtitle', 'description',
                  'price', 'currency', 'validity', 'duration', 'num_entries',
                  'processing_time', 'visa_category', 'includes', 'excludes',
                  'is_active', 'display_order', 'is_featured')
        export_order = fields


class VisaTypeResource(resources.ModelResource):
    """Resource for VisaType import/export"""
    class Meta:
        model = MobileVisaType
        import_id_fields = ['id']
        fields = ('id', 'title', 'subtitle', 'description',
                  'country_code', 'processing_time', 'is_active', 'display_order')
        export_order = fields


# Inline Admins
class VisaRuleInline(admin.TabularInline):
    """Inline editor for visa rules"""
    model = VisaRule
    extra = 1
    fields = ['title', 'description', 'rule_type', 'icon', 'is_mandatory', 'display_order']
    ordering = ['display_order']


class VisaVariantInline(admin.StackedInline):
    """Inline editor for visa variants"""
    model = MobileVisaVariant
    extra = 0
    fields = ['title', 'subtitle', 'price', 'currency', 'validity',
              'num_entries', 'visa_category', 'is_active', 'is_featured', 'display_order']
    ordering = ['display_order']
    show_change_link = True


# Admin Classes
@admin.register(VisaRule)
class VisaRuleAdmin(ImportExportActionModelAdmin):
    """Admin interface for visa rules"""
    resource_class = VisaRuleResource
    list_display = ['id', 'title', 'visa_variant', 'rule_type', 'icon', 'is_mandatory', 'display_order']
    list_filter = ['rule_type', 'is_mandatory', 'visa_variant__visa_type', 'created_at']
    search_fields = ['title', 'description', 'visa_variant__title']
    list_per_page = 50
    date_hierarchy = 'created_at'
    list_select_related = ['visa_variant', 'visa_variant__visa_type']

    fieldsets = (
        ('Visa Variant', {'fields': ('visa_variant',)}),
        ('Rule Information', {'fields': ('title', 'description', 'rule_type', 'icon')}),
        ('Display Settings', {'fields': ('is_mandatory', 'display_order')}),
        ('Timestamps', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )
    readonly_fields = ['created_at', 'updated_at']


@admin.register(MobileVisaVariant)
class MobileVisaVariantAdmin(ImportExportActionModelAdmin):
    """Admin interface for visa variants"""
    resource_class = VisaVariantResource
    list_display = ['id', 'title', 'visa_type', 'formatted_price', 'validity',
                    'visa_category', 'is_active', 'is_featured', 'display_order']
    list_filter = ['is_active', 'is_featured', 'visa_category', 'visa_type', 'currency', 'created_at']
    search_fields = ['title', 'subtitle', 'description', 'visa_type__title']
    list_per_page = 50
    date_hierarchy = 'created_at'
    list_select_related = ['visa_type']
    inlines = [VisaRuleInline]

    fieldsets = (
        ('Visa Type', {'fields': ('visa_type',)}),
        ('Basic Information', {'fields': ('title', 'subtitle', 'description')}),
        ('Images', {'fields': ('thumbnail', 'banner'), 'classes': ('collapse',)}),
        ('Pricing & Validity', {'fields': ('price', 'currency', 'validity', 'duration',
                                           'num_entries', 'processing_time')}),
        ('Classification', {'fields': ('visa_category',)}),
        ('Additional Details', {'fields': ('includes', 'excludes'), 'classes': ('collapse',)}),
        ('Display Settings', {'fields': ('is_active', 'is_featured', 'display_order')}),
        ('Timestamps', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )
    readonly_fields = ['created_at', 'updated_at']

    actions = ['make_active', 'make_inactive', 'mark_as_featured']

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

    fieldsets = (
        ('Basic Information', {'fields': ('title', 'subtitle', 'description')}),
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
