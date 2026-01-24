"""
Payments URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.payments.views import (
    PaymentsViewSet,
    MarkupAndMarkdownsViewSet
)

router = DefaultRouter()
router.register(r'payments', PaymentsViewSet, basename='payments')
router.register(r'markup-and-markdowns', MarkupAndMarkdownsViewSet, basename='markup-and-markdowns')

urlpatterns = [
    path('', include(router.urls)),
]
