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

urlpatterns = [
    path('', include(router.urls)),
    path('auth/login/', LoginView.as_view(), name='login'),
    path('auth/register/', RegisterView.as_view({'post': 'create'}), name='register'),
    path('auth/logout/', LogoutView.as_view({'post': 'logout'}), name='logout'),
    path('auth/change-password/', ChangePasswordView.as_view({'post': 'change_password'}), name='change-password'),
    path('auth/google-login/', GoogleOAuth2LoginView.as_view({'post': 'google_login'}), name='google-login'),
    path('auth/profile/', UserProfileView.as_view({'get': 'get_profile', 'put': 'update_profile'}), name='profile'),
]
