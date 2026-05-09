"""
Migration: create apg_transactions table (managed PostgreSQL table).
"""
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payments', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='APGTransaction',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('transaction_ref', models.CharField(
                    db_index=True, max_length=150, unique=True,
                    help_text='Merchant-generated unique ref (= booking PNR sent to APG)',
                )),
                ('order_id', models.CharField(
                    blank=True, db_index=True, max_length=150, null=True,
                    help_text='APG Order ID returned in return-URL query param ?O=',
                )),
                ('apg_transaction_id', models.CharField(
                    blank=True, max_length=150, null=True,
                    help_text="APG's internal TransactionId from IPN response",
                )),
                ('booking_pnr',       models.CharField(blank=True, max_length=150, null=True)),
                ('booking_reference', models.CharField(blank=True, max_length=150, null=True)),
                ('air_type',          models.CharField(blank=True, max_length=50,  null=True)),
                ('amount',   models.DecimalField(decimal_places=2, default=0, max_digits=14)),
                ('currency', models.CharField(default='PKR', max_length=10)),
                ('transaction_status', models.CharField(
                    choices=[
                        ('pending',   'Pending'),
                        ('paid',      'Paid'),
                        ('failed',    'Failed'),
                        ('cancelled', 'Cancelled'),
                    ],
                    db_index=True, default='pending', max_length=20,
                )),
                ('response_code',        models.CharField(blank=True, max_length=10, null=True)),
                ('account_number',       models.CharField(blank=True, max_length=50, null=True)),
                ('mobile_number',        models.CharField(blank=True, max_length=20, null=True)),
                ('order_datetime',       models.CharField(blank=True, max_length=50, null=True)),
                ('transaction_datetime', models.CharField(blank=True, max_length=50, null=True)),
                ('apg_response', models.JSONField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={
                'verbose_name': 'APG Transaction',
                'verbose_name_plural': 'APG Transactions',
                'db_table': 'apg_transactions',
                'ordering': ['-created_at'],
            },
        ),
    ]
