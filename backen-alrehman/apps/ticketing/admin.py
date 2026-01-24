"""
Ticketing admin configurations
"""
from django.contrib import admin
from apps.ticketing.models import (
    AirlineNameCodes,
    FlightBookingReferences,
    FlightItineraryInfos,
    FlightItineraryLegInfos,
    FlightItineraryPersonInfos,
    FlightItineraryrefMarkupInfos,
    Inoutbounds,
    PremiumAirlines
)


@admin.register(AirlineNameCodes)
class AirlineNameCodesAdmin(admin.ModelAdmin):
    list_display = ['airlinename', 'carriercode', 'iatacode']
    search_fields = ['airlinename', 'carriercode', 'iatacode']
    list_per_page = 25

@admin.register(FlightBookingReferences)
class FlightBookingReferencesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(FlightItineraryInfos)
class FlightItineraryInfosAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(FlightItineraryLegInfos)
class FlightItineraryLegInfosAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['status', 'created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(FlightItineraryPersonInfos)
class FlightItineraryPersonInfosAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(FlightItineraryrefMarkupInfos)
class FlightItineraryrefMarkupInfosAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Inoutbounds)
class InoutboundsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(PremiumAirlines)
class PremiumAirlinesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'
