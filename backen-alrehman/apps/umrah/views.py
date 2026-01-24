"""
Umrah API views
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
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
from apps.umrah.serializers import (
    CmsVisaDurationsSerializer,
    CmsVisaPackagesSerializer,
    TourImagesSerializer,
    TourPackagesSerializer,
    UmrahBookingCustomersSerializer,
    UmrahBookingHotelRoomSerializer,
    UmrahBookingsSerializer,
    UmrahHotelImagesSerializer,
    UmrahHotelRoomPeriodsSerializer,
    UmrahHotelRoomPricesSerializer,
    UmrahHotelsSerializer,
    UmrahTransportSectorsSerializer,
    UmrahVehiclePricesSerializer,
    UmrahVehiclesSerializer,
    UmrahVisasSerializer
)


class CmsVisaDurationsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for CmsVisaDurations model
    Provides CRUD operations
    """
    queryset = CmsVisaDurations.objects.all()
    serializer_class = CmsVisaDurationsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class CmsVisaPackagesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for CmsVisaPackages model
    Provides CRUD operations
    """
    queryset = CmsVisaPackages.objects.all()
    serializer_class = CmsVisaPackagesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class TourImagesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for TourImages model
    Provides CRUD operations
    """
    queryset = TourImages.objects.all()
    serializer_class = TourImagesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class TourPackagesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for TourPackages model
    Provides CRUD operations
    """
    queryset = TourPackages.objects.all()
    serializer_class = TourPackagesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahBookingCustomersViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahBookingCustomers model
    Provides CRUD operations
    """
    queryset = UmrahBookingCustomers.objects.all()
    serializer_class = UmrahBookingCustomersSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahBookingHotelRoomViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahBookingHotelRoom model
    Provides CRUD operations
    """
    queryset = UmrahBookingHotelRoom.objects.all()
    serializer_class = UmrahBookingHotelRoomSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahBookingsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahBookings model
    Provides CRUD operations
    """
    queryset = UmrahBookings.objects.all()
    serializer_class = UmrahBookingsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahHotelImagesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahHotelImages model
    Provides CRUD operations
    """
    queryset = UmrahHotelImages.objects.all()
    serializer_class = UmrahHotelImagesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahHotelRoomPeriodsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahHotelRoomPeriods model
    Provides CRUD operations
    """
    queryset = UmrahHotelRoomPeriods.objects.all()
    serializer_class = UmrahHotelRoomPeriodsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahHotelRoomPricesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahHotelRoomPrices model
    Provides CRUD operations
    """
    queryset = UmrahHotelRoomPrices.objects.all()
    serializer_class = UmrahHotelRoomPricesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahHotelsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahHotels model
    Provides CRUD operations
    """
    queryset = UmrahHotels.objects.all()
    serializer_class = UmrahHotelsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahTransportSectorsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahTransportSectors model
    Provides CRUD operations
    """
    queryset = UmrahTransportSectors.objects.all()
    serializer_class = UmrahTransportSectorsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahVehiclePricesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahVehiclePrices model
    Provides CRUD operations
    """
    queryset = UmrahVehiclePrices.objects.all()
    serializer_class = UmrahVehiclePricesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahVehiclesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahVehicles model
    Provides CRUD operations
    """
    queryset = UmrahVehicles.objects.all()
    serializer_class = UmrahVehiclesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UmrahVisasViewSet(viewsets.ModelViewSet):
    """
    ViewSet for UmrahVisas model
    Provides CRUD operations
    """
    queryset = UmrahVisas.objects.all()
    serializer_class = UmrahVisasSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


