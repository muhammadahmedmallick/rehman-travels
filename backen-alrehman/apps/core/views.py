"""
Core API views
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from apps.core.models import (
    AdministrativeSettings,
    BankDetails,
    Branches,
    Currencies,
    Customers,
    RestApiCredentials,
    Sectors
)
from apps.core.serializers import (
    AdministrativeSettingsSerializer,
    BankDetailsSerializer,
    BranchesSerializer,
    CurrenciesSerializer,
    CustomersSerializer,
    RestApiCredentialsSerializer,
    SectorsSerializer
)


class AdministrativeSettingsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for AdministrativeSettings model
    Provides CRUD operations
    """
    queryset = AdministrativeSettings.objects.all()
    serializer_class = AdministrativeSettingsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class BankDetailsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for BankDetails model
    Provides CRUD operations
    """
    queryset = BankDetails.objects.all()
    serializer_class = BankDetailsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class BranchesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Branches model
    Provides CRUD operations
    """
    queryset = Branches.objects.all()
    serializer_class = BranchesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class CurrenciesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Currencies model
    Provides CRUD operations
    """
    queryset = Currencies.objects.all()
    serializer_class = CurrenciesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class CustomersViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Customers model
    Provides CRUD operations
    """
    queryset = Customers.objects.all()
    serializer_class = CustomersSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    search_fields = ['name', 'email']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class RestApiCredentialsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for RestApiCredentials model
    Provides CRUD operations
    """
    queryset = RestApiCredentials.objects.all()
    serializer_class = RestApiCredentialsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class SectorsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Sectors model
    Provides CRUD operations
    """
    queryset = Sectors.objects.all()
    serializer_class = SectorsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


