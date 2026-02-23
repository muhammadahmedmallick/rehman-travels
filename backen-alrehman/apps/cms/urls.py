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
from apps.cms.visa_views import VisaViewSet
from apps.cms.pak_tour_views import PakTourViewSet
from apps.cms.destination_views import HomeDestinationViewSet

router = DefaultRouter()
router.register(r'call-recordings', CallRecordingsViewSet, basename='call-recordings')
router.register(r'assign-call-recording-followups', AssignCallRecordingFollowupsViewSet, basename='assign-call-recording-followups')
router.register(r'cms-callback-queries', CmsCallbackQueriesViewSet, basename='cms-callback-queries')
router.register(r'cms-faqs', CmsFaqsViewSet, basename='cms-faqs')
router.register(r'content-pages', ContentPagesViewSet, basename='content-pages')
router.register(r'parent-pages', ParentPagesViewSet, basename='parent-pages')
router.register(r'followup-user-logs', FollowupUserLogsViewSet, basename='followup-user-logs')
router.register(r'followups', FollowupsViewSet, basename='followups')
router.register(r'visa', VisaViewSet, basename='visa')
router.register(r'pak-tour', PakTourViewSet, basename='pak-tour')
router.register(r'home-destinations', HomeDestinationViewSet, basename='home-destinations')

urlpatterns = [
    path('', include(router.urls)),
]
