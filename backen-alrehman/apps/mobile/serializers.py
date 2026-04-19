"""
Serializers for mobile app API
"""
from rest_framework import serializers
from django.contrib.auth.models import User
from .models import MobileUserProfile, MobileVisaType, MobileVisaVariant, VisaRule, MobilePackage


class UserRegistrationSerializer(serializers.ModelSerializer):
    """Serializer for user registration"""
    password = serializers.CharField(write_only=True, min_length=8)
    phone_number = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'first_name',
                 'last_name', 'phone_number']

    def create(self, validated_data):
        phone_number = validated_data.pop('phone_number', '')
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )

        # Create mobile profile
        MobileUserProfile.objects.create(
            user=user,
            phone_number=phone_number
        )

        return user


class UserSerializer(serializers.ModelSerializer):
    """Serializer for user data"""
    mobile_profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name',
                 'last_name', 'mobile_profile']

    def get_mobile_profile(self, obj):
        try:
            profile = obj.mobile_profile
            return {
                'phone_number': profile.phone_number,
                'device_type': profile.device_type,
                'is_verified': profile.is_mobile_verified,
            }
        except MobileUserProfile.DoesNotExist:
            return None


# ==================== VISA SERIALIZERS ====================

class VisaRuleSerializer(serializers.ModelSerializer):
    """Serializer for visa rules"""
    icon_class = serializers.ReadOnlyField()

    class Meta:
        model = VisaRule
        fields = [
            'id', 'title', 'description', 'rule_type',
            'icon', 'icon_class', 'is_mandatory', 'display_order'
        ]


class VisaVariantListSerializer(serializers.ModelSerializer):
    """Serializer for visa variants in list view"""
    formatted_price = serializers.ReadOnlyField()
    rules_count = serializers.ReadOnlyField()
    rules = VisaRuleSerializer(many=True, read_only=True)

    class Meta:
        model = MobileVisaVariant
        fields = [
            'id', 'title', 'subtitle', 'thumbnail',
            'price', 'currency', 'formatted_price',
            'validity', 'num_entries', 'visa_category',
            'is_featured', 'rules', 'rules_count'
        ]


class VisaVariantSerializer(serializers.ModelSerializer):
    """Serializer for visa variant detail view"""
    rules = VisaRuleSerializer(many=True, read_only=True)
    formatted_price = serializers.ReadOnlyField()
    rules_count = serializers.ReadOnlyField()
    visa_type_name = serializers.CharField(source='visa_type.title', read_only=True)

    class Meta:
        model = MobileVisaVariant
        fields = [
            'id', 'visa_type', 'visa_type_name', 'title', 'subtitle',
            'description', 'thumbnail', 'banner', 'price', 'currency',
            'formatted_price', 'validity', 'duration', 'num_entries',
            'processing_time', 'visa_category', 'includes', 'excludes',
            'is_active', 'is_featured', 'display_order', 'rules',
            'rules_count', 'created_at', 'updated_at'
        ]


class VisaTypeListSerializer(serializers.ModelSerializer):
    """Serializer for visa types in list view"""
    active_variants_count = serializers.ReadOnlyField()
    variant_price_range = serializers.ReadOnlyField()
    variants = VisaVariantListSerializer(many=True, read_only=True)

    class Meta:
        model = MobileVisaType
        fields = [
            'id', 'title', 'subtitle', 'thumbnail',
            'country_code', 'processing_time',
            'active_variants_count', 'variant_price_range', 'variants'
        ]


class VisaTypeSerializer(serializers.ModelSerializer):
    """Serializer for visa type detail view"""
    variants = VisaVariantSerializer(many=True, read_only=True)
    active_variants_count = serializers.ReadOnlyField()
    variant_price_range = serializers.ReadOnlyField()

    class Meta:
        model = MobileVisaType
        fields = [
            'id', 'title', 'subtitle', 'description',
            'thumbnail', 'banner', 'country_code', 'processing_time',
            'is_active', 'display_order', 'variants',
            'active_variants_count', 'variant_price_range',
            'created_at', 'updated_at'
        ]


# ==================== PACKAGE SERIALIZERS ====================

class PackageSerializer(serializers.ModelSerializer):
    """Serializer for travel packages"""
    formatted_price = serializers.ReadOnlyField()
    formatted_starting_from = serializers.ReadOnlyField()
    tags_list = serializers.ReadOnlyField()
    banner_url = serializers.ReadOnlyField()
    thumbnail_url = serializers.ReadOnlyField()

    class Meta:
        model = MobilePackage
        fields = [
            'id', 'thumbnail', 'thumbnail_url', 'banner', 'banner_url',
            'video_url', 'package_type', 'title', 'slug', 'description',
            'tags', 'tags_list', 'contact_no', 'whatsapp_no',
            'informational_message', 'starting_from', 'formatted_starting_from',
            'price', 'currency', 'formatted_price', 'location',
            'is_active', 'is_featured', 'display_order',
            'created_at', 'updated_at'
        ]
