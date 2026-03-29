"""
Accounts serializers
"""
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth.hashers import make_password, check_password
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
        extra_kwargs = {
            'password': {'write_only': True}
        }


class UsersDetailSerializer(serializers.ModelSerializer):
    """
    Serializer for Users model - detailed view without password
    """
    class Meta:
        model = Users
        fields = ['id', 'username', 'email', 'designation', 'department', 'agentid',
                  'branchid', 'accountid', 'usertype', 'accountstatus', 'mobileno',
                  'phoneno', 'address', 'creditlimit', 'currentcreditlimit', 'created_at', 'updated_at']
        read_only_fields = fields


class RegisterSerializer(serializers.ModelSerializer):
    """
    Serializer for user registration
    Handles creation of new Users
    """
    password = serializers.CharField(write_only=True, required=True, style={'input_type': 'password'})
    password_confirm = serializers.CharField(write_only=True, required=True, style={'input_type': 'password'})

    class Meta:
        model = Users
        fields = ['username', 'email', 'password', 'password_confirm', 'mobileno', 'phoneno', 'address', 'agentid']
        extra_kwargs = {
            'username': {'required': True},
            'email': {'required': True},
        }

    def validate(self, attrs):
        """Validate that passwords match and email is unique"""
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError({"password": "Passwords do not match."})

        if Users.objects.filter(email=attrs['email']).exists():
            raise serializers.ValidationError({"email": "This email already exists."})

        return attrs

    def create(self, validated_data):
        """Create user with hashed password"""
        validated_data.pop('password_confirm')
        password = validated_data.pop('password')

        user = Users.objects.create(**validated_data)
        user.password = make_password(password)
        user.accountstatus = 'active'
        user.usertype = 'user'
        user.save()

        return user


class LoginSerializer(serializers.Serializer):
    """
    Serializer for user login
    Handles authentication with email/username and password
    """
    email = serializers.CharField(required=True)
    password = serializers.CharField(write_only=True, required=True, style={'input_type': 'password'})

    def validate(self, attrs):
        """Validate credentials"""
        email = attrs.get('email')
        password = attrs.get('password')

        try:
            user = Users.objects.get(email=email)
        except Users.DoesNotExist:
            raise serializers.ValidationError("Invalid email or password.")

        if not check_password(password, user.password):
            raise serializers.ValidationError("Invalid email or password.")

        if user.accountstatus != 'active':
            raise serializers.ValidationError("This account is not active.")

        attrs['user'] = user
        return attrs


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Custom JWT token serializer to include user details in token response
    """

    @classmethod
    def get_token(cls, user):
        """Add custom claims to token"""
        token = super().get_token(user)

        token['username'] = user.username
        token['email'] = user.email
        token['user_type'] = user.usertype
        token['user_id'] = user.id

        return token

    def validate(self, attrs):
        """Validate and return tokens with user data"""
        data = super().validate(attrs)

        user = self.user
        user_data = {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'designation': user.designation,
            'department': user.department,
            'user_type': user.usertype,
            'account_status': user.accountstatus,
            'mobile_no': user.mobileno,
            'phone_no': user.phoneno,
        }

        data['user'] = user_data
        return data


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


