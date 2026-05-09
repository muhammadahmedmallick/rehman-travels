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
    SectorsViewSet,
    FilterSortConfigViewSet,
    app_config,
    get_filter_config,
)
from apps.core.airport_views import AirportSearchViewSet

router = DefaultRouter()
router.register(r'administrative-settings', AdministrativeSettingsViewSet, basename='administrative-settings')
router.register(r'bank-details', BankDetailsViewSet, basename='bank-details')
router.register(r'branches', BranchesViewSet, basename='branches')
router.register(r'currencies', CurrenciesViewSet, basename='currencies')
router.register(r'customers', CustomersViewSet, basename='customers')
router.register(r'rest-api-credentials', RestApiCredentialsViewSet, basename='rest-api-credentials')
router.register(r'sectors', SectorsViewSet, basename='sectors')
router.register(r'airports/search', AirportSearchViewSet, basename='airports-search')
router.register(r'filter-sort-configs', FilterSortConfigViewSet, basename='filter-sort-configs')

urlpatterns = [
    path('app-config/', app_config, name='app-config'),
    path('filter-config/<str:listing_name>/', get_filter_config, name='filter-config'),
    path('', include(router.urls)),
]
