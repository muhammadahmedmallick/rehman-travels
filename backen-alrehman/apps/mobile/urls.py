"""
URL routing for mobile app API
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenRefreshView
from . import views

app_name = 'mobile'

# Create router for ViewSets
router = DefaultRouter()
router.register(r'visas/types', views.VisaTypeViewSet, basename='visa-types')
router.register(r'visas/variants', views.VisaVariantViewSet, basename='visa-variants')
router.register(r'visas/rules', views.VisaRuleViewSet, basename='visa-rules')

urlpatterns = [
    # Authentication endpoints
    path('auth/register/', views.RegisterView.as_view(), name='register'),
    path('auth/login/', views.CustomTokenObtainPairView.as_view(), name='login'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/profile/', views.UserProfileView.as_view(), name='profile'),

    # Visa API endpoints (via router)
    path('', include(router.urls)),
]
