# Generated migration file for mobile app
# This migration creates the MobileUserProfile model in PostgreSQL

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='MobileUserProfile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('phone_number', models.CharField(blank=True, max_length=20)),
                ('device_token', models.CharField(blank=True, help_text='For push notifications', max_length=255)),
                ('device_type', models.CharField(blank=True, choices=[('ios', 'iOS'), ('android', 'Android')], max_length=10)),
                ('is_mobile_verified', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='mobile_profile', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'Mobile User Profile',
                'verbose_name_plural': 'Mobile User Profiles',
                'db_table': 'mobile_user_profiles',
            },
        ),
    ]
