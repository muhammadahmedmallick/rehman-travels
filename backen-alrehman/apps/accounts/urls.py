"""
Accounts URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.accounts.views import (
    AgentsViewSet,
    UsersViewSet,
    PermissionsViewSet,
    PermissionAssignsViewSet,
    PermissionTypesViewSet
)

router = DefaultRouter()
router.register(r'agents', AgentsViewSet, basename='agents')
router.register(r'users', UsersViewSet, basename='users')
router.register(r'permissions', PermissionsViewSet, basename='permissions')
router.register(r'permission-assigns', PermissionAssignsViewSet, basename='permission-assigns')
router.register(r'permission-types', PermissionTypesViewSet, basename='permission-types')

urlpatterns = [
    path('', include(router.urls)),
]
