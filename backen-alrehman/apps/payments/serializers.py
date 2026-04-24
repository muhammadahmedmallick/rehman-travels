"""
Payments serializers
"""
from rest_framework import serializers
from apps.payments.models import APGTransaction, MarkupAndMarkdowns, Payments


class PaymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = '__all__'


class MarkupAndMarkdownsSerializer(serializers.ModelSerializer):
    class Meta:
        model = MarkupAndMarkdowns
        fields = '__all__'


class APGTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = APGTransaction
        fields = [
            'id',
            'transaction_ref',
            'order_id',
            'apg_transaction_id',
            'booking_pnr',
            'booking_reference',
            'air_type',
            'amount',
            'currency',
            'transaction_status',
            'response_code',
            'account_number',
            'mobile_number',
            'order_datetime',
            'transaction_datetime',
            'apg_response',
            'created_at',
            'updated_at',
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
