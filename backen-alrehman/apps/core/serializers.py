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
    Sectors,
    FilterSortConfig
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


class FilterSortConfigSerializer(serializers.ModelSerializer):
    """
    Serializer for FilterSortConfig model
    Returns the complete config for frontend consumption
    """
    listing_display_name = serializers.CharField(source='get_listing_name_display', read_only=True)

    class Meta:
        model = FilterSortConfig
        fields = [
            'id',
            'listing_name',
            'listing_display_name',
            'config_data',
            'is_active',
            'version',
            'description',
            'created_at',
            'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class FilterSortConfigPublicSerializer(serializers.ModelSerializer):
    """
    Public-facing serializer that only returns essential config data
    Used by mobile/frontend apps
    """
    class Meta:
        model = FilterSortConfig
        fields = ['listing_name', 'config_data', 'version']


