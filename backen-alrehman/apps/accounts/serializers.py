"""
Accounts serializers
"""
from rest_framework import serializers
from apps.accounts.models import (
    Agents,
    Users,
    Permissions,
    PermissionAssigns,
    PermissionTypes
)


class AgentsSerializer(serializers.ModelSerializer):
    """
    Serializer for Agents model
    """
    class Meta:
        model = Agents
        fields = '__all__'


class UsersSerializer(serializers.ModelSerializer):
    """
    Serializer for Users model
    """
    class Meta:
        model = Users
        fields = '__all__'


class PermissionsSerializer(serializers.ModelSerializer):
    """
    Serializer for Permissions model
    """
    class Meta:
        model = Permissions
        fields = '__all__'


class PermissionAssignsSerializer(serializers.ModelSerializer):
    """
    Serializer for PermissionAssigns model
    """
    class Meta:
        model = PermissionAssigns
        fields = '__all__'


class PermissionTypesSerializer(serializers.ModelSerializer):
    """
    Serializer for PermissionTypes model
    """
    class Meta:
        model = PermissionTypes
        fields = '__all__'


