"""
Umrah admin configurations
"""
from django.contrib import admin
from apps.umrah.models import (
    CmsVisaDurations,
    CmsVisaPackages,
    TourImages,
    TourPackages,
    UmrahBookingCustomers,
    UmrahBookingHotelRoom,
    UmrahBookings,
    UmrahHotelImages,
    UmrahHotelRoomPeriods,
    UmrahHotelRoomPrices,
    UmrahHotels,
    UmrahTransportSectors,
    UmrahVehiclePrices,
    UmrahVehicles,
    UmrahVisas
)


@admin.register(CmsVisaDurations)
class CmsVisaDurationsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(CmsVisaPackages)
class CmsVisaPackagesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(TourImages)
class TourImagesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(TourPackages)
class TourPackagesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahBookingCustomers)
class UmrahBookingCustomersAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahBookingHotelRoom)
class UmrahBookingHotelRoomAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahBookings)
class UmrahBookingsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahHotelImages)
class UmrahHotelImagesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahHotelRoomPeriods)
class UmrahHotelRoomPeriodsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahHotelRoomPrices)
class UmrahHotelRoomPricesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahHotels)
class UmrahHotelsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahTransportSectors)
class UmrahTransportSectorsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahVehiclePrices)
class UmrahVehiclePricesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahVehicles)
class UmrahVehiclesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(UmrahVisas)
class UmrahVisasAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'
