"""
Umrah admin configurations
"""
from django.contrib import admin
from import_export import resources
from import_export.admin import ImportExportModelAdmin, ImportExportActionModelAdmin
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


class CmsVisaDurationsResource(resources.ModelResource):
    """Resource for CmsVisaDurations import/export"""
    class Meta:
        model = CmsVisaDurations
        import_id_fields = ['id']
        fields = (
            'id', 'visaid', 'visatitle', 'visaprice', 'currency', 'numentries',
            'duration', 'validity', 'validforcityid', 'visatype', 'visaincludes',
            'durationstatus', 'created_at', 'updated_at'
        )
        export_order = fields

@admin.register(CmsVisaDurations)
class CmsVisaDurationsAdmin(ImportExportActionModelAdmin):
    resource_class = CmsVisaDurationsResource
    list_display = ['id', 'visatitle', 'visaprice', 'currency', 'duration', 'durationstatus']
    list_filter = ['durationstatus', 'currency', 'created_at']
    search_fields = ['visatitle', 'visatype']
    list_per_page = 25
    date_hierarchy = 'created_at'

    # Export formats available in actions dropdown
    formats = ['csv', 'xlsx', 'json']

class CmsVisaPackagesResource(resources.ModelResource):
    """Resource for CmsVisaPackages import/export"""
    class Meta:
        model = CmsVisaPackages
        import_id_fields = ['id']
        fields = (
            'id', 'cmscontentid', 'countryname', 'packageurl', 'toururl',
            'created_at', 'updated_at'
        )
        export_order = fields

@admin.register(CmsVisaPackages)
class CmsVisaPackagesAdmin(ImportExportActionModelAdmin):
    resource_class = CmsVisaPackagesResource
    list_display = ['id', 'countryname', 'cmscontentid', 'packageurl']
    list_filter = ['countryname', 'created_at']
    search_fields = ['countryname', 'packageurl']
    list_per_page = 25
    date_hierarchy = 'created_at'

    # Export formats available in actions dropdown
    formats = ['csv', 'xlsx', 'json']

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
