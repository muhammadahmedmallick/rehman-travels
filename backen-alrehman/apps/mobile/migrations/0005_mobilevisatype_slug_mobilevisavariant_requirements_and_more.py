# Generated manually on 2026-04-19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mobile', '0004_mobilepackage'),
    ]

    operations = [
        migrations.AddField(
            model_name='mobilevisatype',
            name='slug',
            field=models.SlugField(blank=True, help_text='URL-friendly unique identifier (e.g., singapore-visa, dubai-visa)', max_length=255, null=True, unique=True),
        ),
        migrations.AddField(
            model_name='mobilevisavariant',
            name='requirements',
            field=models.TextField(blank=True, help_text='Comma-separated list of requirements (e.g., "Passport, Photo, Visa Form")'),
        ),
        migrations.AddField(
            model_name='mobilevisavariant',
            name='slug',
            field=models.SlugField(blank=True, help_text='URL-friendly unique identifier (e.g., singapore-30-days)', max_length=255, null=True, unique=True),
        ),
        migrations.AddIndex(
            model_name='mobilevisatype',
            index=models.Index(fields=['slug'], name='mobile_visa_slug_c5be94_idx'),
        ),
    ]
