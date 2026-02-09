"""
Payments admin configurations
"""
from django.contrib import admin
from apps.payments.models import (
    Payments,
    MarkupAndMarkdowns
)


@admin.register(Payments)
class PaymentsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(MarkupAndMarkdowns)
class MarkupAndMarkdownsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'
