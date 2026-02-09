"""
Core URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.core.views import (
    AdministrativeSettingsViewSet,
    BankDetailsViewSet,
    BranchesViewSet,
    CurrenciesViewSet,
    CustomersViewSet,
    RestApiCredentialsViewSet,
    SectorsViewSet
)

router = DefaultRouter()
router.register(r'administrative-settings', AdministrativeSettingsViewSet, basename='administrative-settings')
router.register(r'bank-details', BankDetailsViewSet, basename='bank-details')
router.register(r'branches', BranchesViewSet, basename='branches')
router.register(r'currencies', CurrenciesViewSet, basename='currencies')
router.register(r'customers', CustomersViewSet, basename='customers')
router.register(r'rest-api-credentials', RestApiCredentialsViewSet, basename='rest-api-credentials')
router.register(r'sectors', SectorsViewSet, basename='sectors')

urlpatterns = [
    path('', include(router.urls)),
]
