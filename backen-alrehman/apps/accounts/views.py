"""
Accounts API views
"""
from rest_framework import viewsets, filters, status
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
from django_filters.rest_framework import DjangoFilterBackend
from django.contrib.auth.hashers import make_password
from apps.accounts.models import (
    Agents,
    Users,
    Permissions,
    PermissionAssigns,
    PermissionTypes
)
from apps.accounts.serializers import (
    AgentsSerializer,
    UsersSerializer,
    UsersDetailSerializer,
    PermissionsSerializer,
    PermissionAssignsSerializer,
    PermissionTypesSerializer,
    RegisterSerializer,
    LoginSerializer,
    CustomTokenObtainPairSerializer
)


class AgentsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Agents model
    Provides CRUD operations
    """
    queryset = Agents.objects.all()
    serializer_class = AgentsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    search_fields = ['email', 'username']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class UsersViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Users model
    Provides CRUD operations
    """
    queryset = Users.objects.all()
    serializer_class = UsersSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    search_fields = ['email', 'username']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PermissionsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Permissions model
    Provides CRUD operations
    """
    queryset = Permissions.objects.all()
    serializer_class = PermissionsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PermissionAssignsViewSet(viewsets.ModelViewSet):
    """
    ViewSet for PermissionAssigns model
    Provides CRUD operations
    """
    queryset = PermissionAssigns.objects.all()
    serializer_class = PermissionAssignsSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class PermissionTypesViewSet(viewsets.ModelViewSet):
    """
    ViewSet for PermissionTypes model
    Provides CRUD operations
    """
    queryset = PermissionTypes.objects.all()
    serializer_class = PermissionTypesSerializer
    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id']
    ordering_fields = ['id', 'created_at']
    ordering = ['-id']


class LoginView(TokenObtainPairView):
    """
    Login endpoint for Users
    Returns JWT tokens and user information

    POST /api/auth/login/
    {
        "email": "user@example.com",
        "password": "password123"
    }
    """
    serializer_class = CustomTokenObtainPairSerializer
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        login_serializer = LoginSerializer(data=request.data)
        if login_serializer.is_valid():
            user = login_serializer.validated_data['user']
            refresh = RefreshToken.for_user(user)

            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'designation': user.designation,
                    'department': user.department,
                    'user_type': user.usertype,
                    'account_status': user.accountstatus,
                    'mobile_no': user.mobileno,
                    'phone_no': user.phoneno,
                    'address': user.address,
                    'created_at': user.created_at,
                }
            }, status=status.HTTP_200_OK)

        return Response(login_serializer.errors, status=status.HTTP_401_UNAUTHORIZED)


class RegisterView(viewsets.ViewSet):
    """
    Registration endpoint for new Users
    Creates new user account

    POST /api/auth/register/
    {
        "username": "john_doe",
        "email": "john@example.com",
        "password": "securepassword123",
        "password_confirm": "securepassword123",
        "mobileno": "+923001234567",
        "phoneno": "+923001234567",
        "address": "123 Main St, City, Country"
    }
    """
    permission_classes = [AllowAny]

    @action(detail=False, methods=['post'])
    def create(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            refresh = RefreshToken.for_user(user)

            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'mobile_no': user.mobileno,
                    'phone_no': user.phoneno,
                    'address': user.address,
                    'created_at': user.created_at,
                }
            }, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def list(self, request):
        """Not implemented for register endpoint"""
        return Response({"detail": "Use POST to register."}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


class UserProfileView(viewsets.ViewSet):
    """
    User profile endpoints
    Get current authenticated user's profile or update it

    GET /api/auth/profile/
    PUT /api/auth/profile/
    """
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['get'])
    def get_profile(self, request):
        """Get current user profile"""
        user = request.user if hasattr(request, 'user') else None

        if not user:
            try:
                user_id = request.auth.get('user_id')
                user = Users.objects.get(id=user_id)
            except (Users.DoesNotExist, TypeError, AttributeError):
                return Response(
                    {"detail": "User not found."},
                    status=status.HTTP_404_NOT_FOUND
                )

        serializer = UsersDetailSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['put'])
    def update_profile(self, request):
        """Update current user profile"""
        try:
            user_id = request.auth.get('user_id') if hasattr(request, 'auth') else request.user.id
            user = Users.objects.get(id=user_id)
        except (Users.DoesNotExist, TypeError, AttributeError):
            return Response(
                {"detail": "User not found."},
                status=status.HTTP_404_NOT_FOUND
            )

        allowed_fields = ['designation', 'department', 'mobileno', 'phoneno', 'address']
        data = {key: value for key, value in request.data.items() if key in allowed_fields}

        serializer = UsersDetailSerializer(user, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def list(self, request):
        """Not implemented for profile endpoint"""
        return Response({"detail": "Use GET /api/auth/profile/ for your profile."}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


class LogoutView(viewsets.ViewSet):
    """
    Logout endpoint to blacklist refresh tokens

    POST /api/auth/logout/
    {
        "refresh": "refresh_token_here"
    }
    """
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['post'])
    def logout(self, request):
        """Blacklist refresh token"""
        try:
            refresh_token = request.data.get('refresh')
            if not refresh_token:
                return Response(
                    {"detail": "Refresh token is required."},
                    status=status.HTTP_400_BAD_REQUEST
                )

            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response(
                {"detail": "Successfully logged out."},
                status=status.HTTP_200_OK
            )
        except Exception as e:
            return Response(
                {"detail": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )

    def list(self, request):
        """Not implemented for logout endpoint"""
        return Response({"detail": "Use POST to logout."}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


class ChangePasswordView(viewsets.ViewSet):
    """
    Change password endpoint for authenticated users

    POST /api/auth/change-password/
    {
        "old_password": "current_password",
        "new_password": "new_password123",
        "new_password_confirm": "new_password123"
    }
    """
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['post'])
    def change_password(self, request):
        """Change user password"""
        try:
            user_id = request.auth.get('user_id') if hasattr(request, 'auth') else request.user.id
            user = Users.objects.get(id=user_id)
        except (Users.DoesNotExist, TypeError, AttributeError):
            return Response(
                {"detail": "User not found."},
                status=status.HTTP_404_NOT_FOUND
            )

        old_password = request.data.get('old_password')
        new_password = request.data.get('new_password')
        new_password_confirm = request.data.get('new_password_confirm')

        from django.contrib.auth.hashers import check_password

        if not check_password(old_password, user.password):
            return Response(
                {"old_password": "Incorrect old password."},
                status=status.HTTP_400_BAD_REQUEST
            )

        if new_password != new_password_confirm:
            return Response(
                {"new_password": "Passwords do not match."},
                status=status.HTTP_400_BAD_REQUEST
            )

        if len(new_password) < 8:
            return Response(
                {"new_password": "Password must be at least 8 characters long."},
                status=status.HTTP_400_BAD_REQUEST
            )

        user.password = make_password(new_password)
        user.save()

        return Response(
            {"detail": "Password changed successfully."},
            status=status.HTTP_200_OK
        )

    def list(self, request):
        """Not implemented for change-password endpoint"""
        return Response({"detail": "Use POST to change password."}, status=status.HTTP_405_METHOD_NOT_ALLOWED)




class GoogleOAuth2LoginView(viewsets.ViewSet):
    """
    Google OAuth2 login endpoint for Flutter apps

    POST /api/accounts/auth/google-login/
    {
        "token": "google_id_token_from_flutter"
    }
    """
    permission_classes = [AllowAny]

    @action(detail=False, methods=['post'])
    def google_login(self, request):
        """Authenticate user with Google OAuth2 token"""
        from apps.accounts.auth_backends import GoogleOAuth2Backend, GoogleOAuth2Serializer

        serializer = GoogleOAuth2Serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data['user']
            google_data = serializer.validated_data['google_data']

            refresh = RefreshToken.for_user(user)

            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'designation': user.designation or '',
                    'department': user.department or '',
                    'user_type': user.usertype,
                    'account_status': user.accountstatus,
                    'mobile_no': user.mobileno,
                    'phone_no': user.phoneno,
                    'address': user.address or '',
                    'created_at': user.created_at,
                    'google_picture': google_data.get('picture'),
                }
            }, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_401_UNAUTHORIZED)

    def list(self, request):
        """Not implemented"""
        return Response({"detail": "Use POST to login with Google."}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
