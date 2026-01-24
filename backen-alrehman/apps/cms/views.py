"""
Cms API views
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from apps.cms.models import (
    CallRecordings,
    AssignCallRecordingFollowups,
    CmsCallbackQueries,
    CmsFaqs,
    ContentPages,
    ParentPages,
    FollowupUserLogs,
    Followups
)
from apps.cms.serializers import (
    CallRecordingsSerializer,
    AssignCallRecordingFollowupsSerializer,
    CmsCallbackQueriesSerializer,
    CmsFaqsSerializer,
    ContentPagesSerializer,
    ParentPagesSerializer,
    FollowupUserLogsSerializer,
    FollowupsSerializer
)


class CallRecordingsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for CallRecordings model
    Provides CRUD operations
    """
    queryset = CallRecordings.objects.all()
    serializer_class = CallRecordingsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class AssignCallRecordingFollowupsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for AssignCallRecordingFollowups model
    Provides CRUD operations
    """
    queryset = AssignCallRecordingFollowups.objects.all()
    serializer_class = AssignCallRecordingFollowupsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class CmsCallbackQueriesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for CmsCallbackQueries model
    Provides CRUD operations
    """
    queryset = CmsCallbackQueries.objects.all()
    serializer_class = CmsCallbackQueriesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class CmsFaqsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for CmsFaqs model
    Provides CRUD operations
    """
    queryset = CmsFaqs.objects.all()
    serializer_class = CmsFaqsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class ContentPagesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for ContentPages model
    Provides CRUD operations
    """
    queryset = ContentPages.objects.all()
    serializer_class = ContentPagesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class ParentPagesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for ParentPages model
    Provides CRUD operations
    """
    queryset = ParentPages.objects.all()
    serializer_class = ParentPagesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FollowupUserLogsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for FollowupUserLogs model
    Provides CRUD operations
    """
    queryset = FollowupUserLogs.objects.all()
    serializer_class = FollowupUserLogsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class FollowupsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Followups model
    Provides CRUD operations
    """
    queryset = Followups.objects.all()
    serializer_class = FollowupsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


