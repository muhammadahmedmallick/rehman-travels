"""
Admin configuration for mobile app models
"""
from django.contrib import admin
from .models import MobileUserProfile


@admin.register(MobileUserProfile)
class MobileUserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'phone_number', 'device_type',
                   'is_mobile_verified', 'created_at']
    search_fields = ['user__username', 'user__email', 'phone_number']
    list_filter = ['device_type', 'is_mobile_verified', 'created_at']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('User Information', {
            'fields': ('user',)
        }),
        ('Mobile Details', {
            'fields': ('phone_number', 'device_token', 'device_type',
                      'is_mobile_verified')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
