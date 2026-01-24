"""
Ticketing API views
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
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
from apps.ticketing.serializers import (
    AirlineNameCodesSerializer,
    FlightBookingReferencesSerializer,
    FlightItineraryInfosSerializer,
    FlightItineraryLegInfosSerializer,
    FlightItineraryPersonInfosSerializer,
    FlightItineraryrefMarkupInfosSerializer,
    InoutboundsSerializer,
    PremiumAirlinesSerializer
)


class AirlineNameCodesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for AirlineNameCodes model
    Provides CRUD operations
    """
    queryset = AirlineNameCodes.objects.all()
    serializer_class = AirlineNameCodesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    search_fields = ['name', 'email']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FlightBookingReferencesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for FlightBookingReferences model
    Provides CRUD operations
    """
    queryset = FlightBookingReferences.objects.all()
    serializer_class = FlightBookingReferencesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FlightItineraryInfosViewSet(viewsets.ModelViewSet):
    """
    ViewSet for FlightItineraryInfos model
    Provides CRUD operations
    """
    queryset = FlightItineraryInfos.objects.all()
    serializer_class = FlightItineraryInfosSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FlightItineraryLegInfosViewSet(viewsets.ModelViewSet):
    """
    ViewSet for FlightItineraryLegInfos model
    Provides CRUD operations
    """
    queryset = FlightItineraryLegInfos.objects.all()
    serializer_class = FlightItineraryLegInfosSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FlightItineraryPersonInfosViewSet(viewsets.ModelViewSet):
    """
    ViewSet for FlightItineraryPersonInfos model
    Provides CRUD operations
    """
    queryset = FlightItineraryPersonInfos.objects.all()
    serializer_class = FlightItineraryPersonInfosSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FlightItineraryrefMarkupInfosViewSet(viewsets.ModelViewSet):
    """
    ViewSet for FlightItineraryrefMarkupInfos model
    Provides CRUD operations
    """
    queryset = FlightItineraryrefMarkupInfos.objects.all()
    serializer_class = FlightItineraryrefMarkupInfosSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class InoutboundsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Inoutbounds model
    Provides CRUD operations
    """
    queryset = Inoutbounds.objects.all()
    serializer_class = InoutboundsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PremiumAirlinesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for PremiumAirlines model
    Provides CRUD operations
    """
    queryset = PremiumAirlines.objects.all()
    serializer_class = PremiumAirlinesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


