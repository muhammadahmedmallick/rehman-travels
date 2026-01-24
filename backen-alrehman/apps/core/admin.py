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
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'
