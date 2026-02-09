"""
Main URL Configuration
"""
from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

# Swagger/OpenAPI Schema Configuration
schema_view = get_schema_view(
    openapi.Info(
        title="Rehman Travels API",
        default_version='v1',
        description="""
# Rehman Travels Django REST API

Complete API documentation for the Rehman Travels platform.

## Features
- **Authentication**: JWT token-based authentication
- **Pagination**: 25 items per page
- **Filtering**: Filter results by various fields
- **Search**: Full-text search on relevant fields
- **Ordering**: Sort results by multiple fields

## Modules
- **Accounts**: Agents, Users, Permissions
- **Core**: Customers, Branches, Bank Details
- **Ticketing**: Flight Bookings, Itineraries, Airlines
- **Umrah**: Hotels, Packages, Visas, Vehicles
- **Payments**: Payments, Markup & Markdowns
- **CMS**: FAQs, Content Pages, Followups

## Authentication
To access protected endpoints, you need to:
1. Obtain a JWT token from `/api/token/`
2. Include the token in the Authorization header: `Bearer YOUR_TOKEN`
        """,
        terms_of_service="https://www.rehman-travels.com/terms/",
        contact=openapi.Contact(email="api@rehman-travels.com"),
        license=openapi.License(name="Proprietary"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
    authentication_classes=[],
)

urlpatterns = [
    # Admin
    path('admin/', admin.site.urls),

    # Swagger/OpenAPI Documentation
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    path('', schema_view.with_ui('swagger', cache_timeout=0), name='api-root'),  # Root redirects to Swagger

    # JWT Authentication
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # API Endpoints
    path('api/accounts/', include('apps.accounts.urls')),
    path('api/core/', include('apps.core.urls')),
    path('api/ticketing/', include('apps.ticketing.urls')),
    path('api/umrah/', include('apps.umrah.urls')),
    path('api/payments/', include('apps.payments.urls')),
    path('api/cms/', include('apps.cms.urls')),
]
