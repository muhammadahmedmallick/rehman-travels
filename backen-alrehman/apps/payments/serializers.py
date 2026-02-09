"""
Payments serializers
"""
from rest_framework import serializers
from apps.payments.models import (
    Payments,
    MarkupAndMarkdowns
)


class PaymentsSerializer(serializers.ModelSerializer):
    """
    Serializer for Payments model
    """
    class Meta:
        model = Payments
        fields = '__all__'


class MarkupAndMarkdownsSerializer(serializers.ModelSerializer):
    """
    Serializer for MarkupAndMarkdowns model
    """
    class Meta:
        model = MarkupAndMarkdowns
        fields = '__all__'


