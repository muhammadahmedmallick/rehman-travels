"""
Accounts app URL configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.accounts.views import (
    AgentsViewSet,
    UsersViewSet,
    PermissionsViewSet,
    PermissionAssignsViewSet,
    PermissionTypesViewSet,
    LoginView,
    RegisterView,
    UserProfileView,
    LogoutView,
    ChangePasswordView,
    GoogleOAuth2LoginView
)

router = DefaultRouter()
router.register(r'agents', AgentsViewSet, basename='agents')
router.register(r'users', UsersViewSet, basename='users')
router.register(r'permissions', PermissionsViewSet, basename='permissions')
router.register(r'permission-assigns', PermissionAssignsViewSet, basename='permission-assigns')
router.register(r'permission-types', PermissionTypesViewSet, basename='permission-types')
router.register(r'auth/register', RegisterView, basename='register')
router.register(r'auth/logout', LogoutView, basename='logout')
router.register(r'auth/change-password', ChangePasswordView, basename='change-password')
router.register(r'auth/google-login', GoogleOAuth2LoginView, basename='google-login')
router.register(r'auth/profile', UserProfileView, basename='profile')

urlpatterns = [
    path('', include(router.urls)),
    path('auth/login/', LoginView.as_view(), name='login'),
]
