"""
Accounts API views
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from apps.accounts.models import (
    Agents,
    Users,
    Permissions,
    PermissionAssigns,
    PermissionTypes
)
from apps.accounts.serializers import (
    AgentsSerializer,
    UsersSerializer,
    PermissionsSerializer,
    PermissionAssignsSerializer,
    PermissionTypesSerializer
)


class AgentsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Agents model
    Provides CRUD operations
    """
    queryset = Agents.objects.all()
    serializer_class = AgentsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    search_fields = ['email', 'username']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UsersViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Users model
    Provides CRUD operations
    """
    queryset = Users.objects.all()
    serializer_class = UsersSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    search_fields = ['email', 'username']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PermissionsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Permissions model
    Provides CRUD operations
    """
    queryset = Permissions.objects.all()
    serializer_class = PermissionsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PermissionAssignsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for PermissionAssigns model
    Provides CRUD operations
    """
    queryset = PermissionAssigns.objects.all()
    serializer_class = PermissionAssignsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PermissionTypesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for PermissionTypes model
    Provides CRUD operations
    """
    queryset = PermissionTypes.objects.all()
    serializer_class = PermissionTypesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


