"""
Validation URL Configuration
"""
from django.urls import path
from apps.validation.views import SchemaInfoView, ValidateView

urlpatterns = [
    # POST — validate a fields dict against a named schema
    path('validate/', ValidateView.as_view(), name='validate'),

    # GET  — inspect the rules defined for a schema (dev/docs helper)
    path('schema/<str:schema_type>/', SchemaInfoView.as_view(), name='schema-info'),
]
