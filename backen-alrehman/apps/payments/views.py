"""
Payments API views
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from apps.payments.models import (
    Payments,
    MarkupAndMarkdowns
)
from apps.payments.serializers import (
    PaymentsSerializer,
    MarkupAndMarkdownsSerializer
)


class PaymentsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Payments model
    Provides CRUD operations
    """
    queryset = Payments.objects.all()
    serializer_class = PaymentsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class MarkupAndMarkdownsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for MarkupAndMarkdowns model
    Provides CRUD operations
    """
    queryset = MarkupAndMarkdowns.objects.all()
    serializer_class = MarkupAndMarkdownsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


