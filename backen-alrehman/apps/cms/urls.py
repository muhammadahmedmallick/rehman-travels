"""
Cms URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.cms.views import (
    CallRecordingsViewSet,
    AssignCallRecordingFollowupsViewSet,
    CmsCallbackQueriesViewSet,
    CmsFaqsViewSet,
    ContentPagesViewSet,
    ParentPagesViewSet,
    FollowupUserLogsViewSet,
    FollowupsViewSet
)

router = DefaultRouter()
router.register(r'call-recordings', CallRecordingsViewSet, basename='call-recordings')
router.register(r'assign-call-recording-followups', AssignCallRecordingFollowupsViewSet, basename='assign-call-recording-followups')
router.register(r'cms-callback-queries', CmsCallbackQueriesViewSet, basename='cms-callback-queries')
router.register(r'cms-faqs', CmsFaqsViewSet, basename='cms-faqs')
router.register(r'content-pages', ContentPagesViewSet, basename='content-pages')
router.register(r'parent-pages', ParentPagesViewSet, basename='parent-pages')
router.register(r'followup-user-logs', FollowupUserLogsViewSet, basename='followup-user-logs')
router.register(r'followups', FollowupsViewSet, basename='followups')

urlpatterns = [
    path('', include(router.urls)),
]
