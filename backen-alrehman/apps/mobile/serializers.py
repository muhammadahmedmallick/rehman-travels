"""
Serializers for mobile app API
"""
from rest_framework import serializers
from django.contrib.auth.models import User
from .models import MobileUserProfile


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
