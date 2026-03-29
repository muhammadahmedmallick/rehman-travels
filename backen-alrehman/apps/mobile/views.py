"""
API views for mobile app
"""
from rest_framework import status, generics
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth.models import User
from .serializers import UserRegistrationSerializer, UserSerializer


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
