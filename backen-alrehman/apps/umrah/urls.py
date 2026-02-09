"""
Umrah URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.umrah.views import (
    CmsVisaDurationsViewSet,
    CmsVisaPackagesViewSet,
    TourImagesViewSet,
    TourPackagesViewSet,
    UmrahBookingCustomersViewSet,
    UmrahBookingHotelRoomViewSet,
    UmrahBookingsViewSet,
    UmrahHotelImagesViewSet,
    UmrahHotelRoomPeriodsViewSet,
    UmrahHotelRoomPricesViewSet,
    UmrahHotelsViewSet,
    UmrahTransportSectorsViewSet,
    UmrahVehiclePricesViewSet,
    UmrahVehiclesViewSet,
    UmrahVisasViewSet
)

router = DefaultRouter()
router.register(r'cms-visa-durations', CmsVisaDurationsViewSet, basename='cms-visa-durations')
router.register(r'cms-visa-packages', CmsVisaPackagesViewSet, basename='cms-visa-packages')
router.register(r'tour-images', TourImagesViewSet, basename='tour-images')
router.register(r'tour-packages', TourPackagesViewSet, basename='tour-packages')
router.register(r'umrah-booking-customers', UmrahBookingCustomersViewSet, basename='umrah-booking-customers')
router.register(r'umrah-booking-hotel-room', UmrahBookingHotelRoomViewSet, basename='umrah-booking-hotel-room')
router.register(r'umrah-bookings', UmrahBookingsViewSet, basename='umrah-bookings')
router.register(r'umrah-hotel-images', UmrahHotelImagesViewSet, basename='umrah-hotel-images')
router.register(r'umrah-hotel-room-periods', UmrahHotelRoomPeriodsViewSet, basename='umrah-hotel-room-periods')
router.register(r'umrah-hotel-room-prices', UmrahHotelRoomPricesViewSet, basename='umrah-hotel-room-prices')
router.register(r'umrah-hotels', UmrahHotelsViewSet, basename='umrah-hotels')
router.register(r'umrah-transport-sectors', UmrahTransportSectorsViewSet, basename='umrah-transport-sectors')
router.register(r'umrah-vehicle-prices', UmrahVehiclePricesViewSet, basename='umrah-vehicle-prices')
router.register(r'umrah-vehicles', UmrahVehiclesViewSet, basename='umrah-vehicles')
router.register(r'umrah-visas', UmrahVisasViewSet, basename='umrah-visas')

urlpatterns = [
    path('', include(router.urls)),
]
