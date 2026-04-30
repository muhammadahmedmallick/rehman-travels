"""
Core admin configurations
"""
from django.contrib import admin
from django.utils.html import format_html
from import_export import resources
from import_export.admin import ImportExportModelAdmin, ImportExportActionModelAdmin
from apps.core.models import (
    AdministrativeSettings,
    BankDetails,
    Branches,
    Currencies,
    Customers,
    RestApiCredentials,
    Sectors,
    FilterSortConfig
)


@admin.register(AdministrativeSettings)
class AdministrativeSettingsAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'contactno', 'status']
    search_fields = ['name', 'email', 'contactno']
    list_filter = ['status']
    list_per_page = 25

class BankDetailsResource(resources.ModelResource):
    """Resource for BankDetails import/export"""
    class Meta:
        model = BankDetails
        import_id_fields = ['id']
        fields = (
            'id', 'postbyid', 'postbytype', 'bankname', 'accounttitle',
            'branchcode', 'accountno', 'ibanno', 'swiftcode', 'contactno',
            'bankstatus', 'banklogoname', 'created_at', 'updated_at'
        )
        export_order = fields

@admin.register(BankDetails)
class BankDetailsAdmin(ImportExportActionModelAdmin):
    resource_class = BankDetailsResource
    list_display = ['id', 'bankname', 'accounttitle', 'accountno', 'bankstatus']
    list_filter = ['bankstatus', 'created_at']
    search_fields = ['bankname', 'accounttitle', 'accountno', 'ibanno']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Branches)
class BranchesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Currencies)
class CurrenciesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['status', 'created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Customers)
class CustomersAdmin(admin.ModelAdmin):
    list_display = ['id', 'email']
    search_fields = ['email']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(RestApiCredentials)
class RestApiCredentialsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Sectors)
class SectorsAdmin(admin.ModelAdmin):
    """
    Admin interface for Airport/Sector management
    Matches the search functionality from AirportSearchViewSet
    """
    list_display = ['code', 'city', 'country', 'sectortype', 'allowtype', 'id']
    search_fields = ['code', 'city', 'country']  # Same fields as API search
    list_filter = ['sectortype', 'country', 'created_at']
    list_per_page = 50
    date_hierarchy = 'created_at'
    ordering = ['code']

    fieldsets = (
        ('Airport Information', {
            'fields': ('code', 'city', 'country')
        }),
        ('Configuration', {
            'fields': ('sectortype', 'allowtype')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    readonly_fields = ['created_at', 'updated_at']

    def get_readonly_fields(self, request, obj=None):
        """Make timestamps readonly"""
        if obj:  # Editing an existing object
            return self.readonly_fields
        return []


@admin.register(FilterSortConfig)
class FilterSortConfigAdmin(admin.ModelAdmin):
    """
    Admin interface for FilterSortConfig
    Manages filter/sort configurations for different listing types
    """
    list_display = [
        'listing_name',
        'version',
        'is_active_badge',
        'updated_at',
        'created_at'
    ]
    list_filter = ['listing_name', 'is_active', 'created_at', 'updated_at']
    search_fields = ['listing_name', 'description', 'version']
    list_per_page = 25
    date_hierarchy = 'updated_at'
    ordering = ['-updated_at']

    fieldsets = (
        ('Basic Information', {
            'fields': ('listing_name', 'version', 'is_active')
        }),
        ('Configuration', {
            'fields': ('config_data', 'description'),
            'description': 'JSON configuration for filters, sorts, and scoring. See documentation for schema.'
        }),
        ('Metadata', {
            'fields': ('created_by', 'created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    readonly_fields = ['created_at', 'updated_at']

    def is_active_badge(self, obj):
        """Display active status with color badge"""
        if obj.is_active:
            return format_html(
                '<span style="color: #28a745; font-weight: bold;">● Active</span>'
            )
        return format_html(
            '<span style="color: #dc3545; font-weight: bold;">○ Inactive</span>'
        )
    is_active_badge.short_description = 'Status'

    def save_model(self, request, obj, form, change):
        """Auto-populate created_by field"""
        if not change:
            obj.created_by = request.user.username if request.user.is_authenticated else 'system'
        super().save_model(request, obj, form, change)
