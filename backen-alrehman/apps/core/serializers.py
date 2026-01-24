"""
Core serializers
"""
from rest_framework import serializers
from apps.core.models import (
    AdministrativeSettings,
    BankDetails,
    Branches,
    Currencies,
    Customers,
    RestApiCredentials,
    Sectors
)


class AdministrativeSettingsSerializer(serializers.ModelSerializer):
    """
    Serializer for AdministrativeSettings model
    """
    class Meta:
        model = AdministrativeSettings
        fields = '__all__'


class BankDetailsSerializer(serializers.ModelSerializer):
    """
    Serializer for BankDetails model
    """
    class Meta:
        model = BankDetails
        fields = '__all__'


class BranchesSerializer(serializers.ModelSerializer):
    """
    Serializer for Branches model
    """
    class Meta:
        model = Branches
        fields = '__all__'


class CurrenciesSerializer(serializers.ModelSerializer):
    """
    Serializer for Currencies model
    """
    class Meta:
        model = Currencies
        fields = '__all__'


class CustomersSerializer(serializers.ModelSerializer):
    """
    Serializer for Customers model
    """
    class Meta:
        model = Customers
        fields = '__all__'


class RestApiCredentialsSerializer(serializers.ModelSerializer):
    """
    Serializer for RestApiCredentials model
    """
    class Meta:
        model = RestApiCredentials
        fields = '__all__'


class SectorsSerializer(serializers.ModelSerializer):
    """
    Serializer for Sectors model
    """
    class Meta:
        model = Sectors
        fields = '__all__'


