"""
Mobile app models for new Django features
"""
from django.db import models
from django.contrib.auth.models import User
from apps.core.base_models import NewModel


class MobileUserProfile(NewModel):
    """
    Extended profile for mobile app users.

    Stored in new PostgreSQL database.
    References Django's built-in User model.
    """
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='mobile_profile'
    )
    phone_number = models.CharField(max_length=20, blank=True)
    device_token = models.CharField(
        max_length=255,
        blank=True,
        help_text='For push notifications'
    )
    device_type = models.CharField(
        max_length=10,
        choices=[('ios', 'iOS'), ('android', 'Android')],
        blank=True
    )
    is_mobile_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mobile_user_profiles'
        verbose_name = 'Mobile User Profile'
        verbose_name_plural = 'Mobile User Profiles'

    def __str__(self):
        return f"{self.user.username} - Mobile Profile"
