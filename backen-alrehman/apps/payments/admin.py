"""
Payments admin configurations
"""
from django.contrib import admin
from apps.payments.models import APGTransaction, MarkupAndMarkdowns, Payments


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


@admin.register(APGTransaction)
class APGTransactionAdmin(admin.ModelAdmin):
    list_display = [
        'transaction_ref', 'booking_pnr', 'amount', 'currency',
        'transaction_status', 'response_code', 'order_id',
        'apg_transaction_id', 'created_at', 'updated_at',
    ]
    list_filter = ['transaction_status', 'currency', 'created_at']
    search_fields = ['transaction_ref', 'booking_pnr', 'order_id', 'apg_transaction_id']
    readonly_fields = [
        'transaction_ref', 'order_id', 'apg_transaction_id',
        'response_code', 'account_number', 'mobile_number',
        'order_datetime', 'transaction_datetime', 'apg_response',
        'created_at', 'updated_at',
    ]
    ordering = ['-created_at']
    list_per_page = 50
    date_hierarchy = 'created_at'

    fieldsets = (
        ('Booking', {
            'fields': ('transaction_ref', 'booking_pnr', 'booking_reference', 'air_type'),
        }),
        ('Financial', {
            'fields': ('amount', 'currency', 'transaction_status'),
        }),
        ('APG Response', {
            'fields': (
                'order_id', 'apg_transaction_id', 'response_code',
                'account_number', 'mobile_number',
                'order_datetime', 'transaction_datetime',
                'apg_response',
            ),
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
        }),
    )
