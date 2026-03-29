"""
API views for mobile app
"""
from rest_framework import status, generics
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from .serializers import UserRegistrationSerializer, UserSerializer


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Custom serializer to support login with both username and email
    """
    username = None
    email = None

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Make both fields optional
        self.fields['username'].required = False
        self.fields['email'] = self.fields['username'].__class__(required=False)

    def validate(self, attrs):
        """
        Support login with username or email
        """
        username = attrs.get('username', '')
        email = attrs.get('email', '')
        password = attrs.get('password')

        # Try to find user by username or email
        user = None

        if username:
            try:
                user = User.objects.get(username=username)
            except User.DoesNotExist:
                pass

        if not user and email:
            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                pass

        if not user:
            raise ValueError('User with given username or email does not exist')

        # Authenticate using the found user
        user = authenticate(username=user.username, password=password)

        if user is None:
            raise ValueError('Invalid password')

        refresh = self.get_token(user)
        data = {'refresh': str(refresh), 'access': str(refresh.access_token)}

        return data


class CustomTokenObtainPairView(TokenObtainPairView):
    """
    Custom login view supporting both username and email
    POST /api/mobile/auth/login/

    Request body (choose one):
    {
        "username": "john",
        "password": "password123"
    }
    or
    {
        "email": "john@example.com",
        "password": "password123"
    }
    """
    serializer_class = CustomTokenObtainPairSerializer


class RegisterView(generics.CreateAPIView):
    """
    Register new mobile user.
    POST /api/mobile/auth/register/
    """
    queryset = User.objects.all()
    permission_classes = [AllowAny]
    serializer_class = UserRegistrationSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


class UserProfileView(generics.RetrieveUpdateAPIView):
    """
    Get or update user profile.
    GET /api/mobile/auth/profile/
    PUT /api/mobile/auth/profile/
    """
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user
