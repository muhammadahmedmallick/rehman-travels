"""
Core admin configurations
"""
from django.contrib import admin
from apps.core.models import (
    AdministrativeSettings,
    BankDetails,
    Branches,
    Currencies,
    Customers,
    RestApiCredentials,
    Sectors
)


@admin.register(AdministrativeSettings)
class AdministrativeSettingsAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'contactno', 'status']
    search_fields = ['name', 'email', 'contactno']
    list_filter = ['status']
    list_per_page = 25

@admin.register(BankDetails)
class BankDetailsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
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
