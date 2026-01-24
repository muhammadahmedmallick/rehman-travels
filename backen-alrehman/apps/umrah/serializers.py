"""
Umrah serializers
"""
from rest_framework import serializers
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


class CmsVisaDurationsSerializer(serializers.ModelSerializer):
    """
    Serializer for CmsVisaDurations model
    """
    class Meta:
        model = CmsVisaDurations
        fields = '__all__'


class CmsVisaPackagesSerializer(serializers.ModelSerializer):
    """
    Serializer for CmsVisaPackages model
    """
    class Meta:
        model = CmsVisaPackages
        fields = '__all__'


class TourImagesSerializer(serializers.ModelSerializer):
    """
    Serializer for TourImages model
    """
    class Meta:
        model = TourImages
        fields = '__all__'


class TourPackagesSerializer(serializers.ModelSerializer):
    """
    Serializer for TourPackages model
    """
    class Meta:
        model = TourPackages
        fields = '__all__'


class UmrahBookingCustomersSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahBookingCustomers model
    """
    class Meta:
        model = UmrahBookingCustomers
        fields = '__all__'


class UmrahBookingHotelRoomSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahBookingHotelRoom model
    """
    class Meta:
        model = UmrahBookingHotelRoom
        fields = '__all__'


class UmrahBookingsSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahBookings model
    """
    class Meta:
        model = UmrahBookings
        fields = '__all__'


class UmrahHotelImagesSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahHotelImages model
    """
    class Meta:
        model = UmrahHotelImages
        fields = '__all__'


class UmrahHotelRoomPeriodsSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahHotelRoomPeriods model
    """
    class Meta:
        model = UmrahHotelRoomPeriods
        fields = '__all__'


class UmrahHotelRoomPricesSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahHotelRoomPrices model
    """
    class Meta:
        model = UmrahHotelRoomPrices
        fields = '__all__'


class UmrahHotelsSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahHotels model
    """
    class Meta:
        model = UmrahHotels
        fields = '__all__'


class UmrahTransportSectorsSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahTransportSectors model
    """
    class Meta:
        model = UmrahTransportSectors
        fields = '__all__'


class UmrahVehiclePricesSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahVehiclePrices model
    """
    class Meta:
        model = UmrahVehiclePrices
        fields = '__all__'


class UmrahVehiclesSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahVehicles model
    """
    class Meta:
        model = UmrahVehicles
        fields = '__all__'


class UmrahVisasSerializer(serializers.ModelSerializer):
    """
    Serializer for UmrahVisas model
    """
    class Meta:
        model = UmrahVisas
        fields = '__all__'


