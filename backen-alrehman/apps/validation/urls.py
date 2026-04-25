"""
Validation URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.validation.views import (
    SchemaInfoView,
    ValidateView,
    ValidationSchemaViewSet,
    FieldRuleViewSet,
)

router = DefaultRouter()
router.register(r'schemas', ValidationSchemaViewSet, basename='validation-schemas')
router.register(r'field-rules', FieldRuleViewSet, basename='field-rules')

urlpatterns = [
    # Management endpoints (via router)
    path('', include(router.urls)),

    # POST — validate a fields dict against a named schema
    path('validate/', ValidateView.as_view(), name='validate'),

    # GET  — inspect the rules defined for a schema (dev/docs helper)
    path('schema/<str:schema_type>/', SchemaInfoView.as_view(), name='schema-info'),
]
