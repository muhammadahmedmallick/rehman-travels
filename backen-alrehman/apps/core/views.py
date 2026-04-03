"""
Core API views
"""
from rest_framework import viewsets, filters
from rest_framework.decorators import api_view
from rest_framework.response import Response
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


@api_view(['GET'])
def app_config(request):
    """
    Returns app configuration: contact info from DB + social links.
    Single source of truth for all contact/social values in the mobile app.
    Reads from administrative_settings table (id=1 for general).
    """
    # Get contact info from legacy DB
    try:
        admin = AdministrativeSettings.objects.get(id=1)
        phone = admin.contactno or '+9251111786785'
        email = admin.email or 'info@rehmantravel.com'
        name = admin.name or 'Rehman Travel'
    except AdministrativeSettings.DoesNotExist:
        phone = '+9251111786785'
        email = 'info@rehmantravel.com'
        name = 'Rehman Travel'

    # Clean whatsapp number (remove + and spaces)
    whatsapp = phone.replace('+', '').replace(' ', '').replace('-', '')

    return Response({
        'phone': phone,
        'whatsapp': whatsapp,
        'email': email,
        'name': name,
        'website': 'https://www.rehmantravel.com',
        'social': {
            'facebook': 'https://facebook.com/rehmantravel',
            'instagram': 'https://instagram.com/rehmantravel',
            'twitter': 'https://twitter.com/rehmantravel',
            'youtube': 'https://youtube.com/@rehmantravel',
        },
        'office': {
            'name': 'Rehman Group of Travels',
            'address': 'Blue Area, Islamabad, Pakistan',
            'hours': 'Mon - Sat: 9:00 AM - 8:00 PM',
        },
    })


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


