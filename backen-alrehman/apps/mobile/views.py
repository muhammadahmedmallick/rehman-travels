"""
API views for mobile app
"""
from rest_framework import status, generics, serializers, viewsets, filters
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.decorators import action
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Prefetch
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from .models import MobileVisaType, MobileVisaVariant, VisaRule
from .serializers import (
    UserRegistrationSerializer, UserSerializer,
    VisaRuleSerializer, VisaVariantListSerializer, VisaVariantSerializer,
    VisaTypeListSerializer, VisaTypeSerializer
)


class CustomTokenObtainPairSerializer(serializers.Serializer):
    """
    Custom serializer to support login with both username and email
    Accepts either username OR email with password
    """
    username = serializers.CharField(required=False, allow_blank=True)
    email = serializers.EmailField(required=False, allow_blank=True)
    password = serializers.CharField(write_only=True, required=True)

    def validate(self, attrs):
        """
        Support login with username or email
        """
        username = attrs.get('username', '').strip()
        email = attrs.get('email', '').strip()
        password = attrs.get('password')

        # Validate that at least one of username or email is provided
        if not username and not email:
            raise serializers.ValidationError({
                'non_field_errors': 'Either username or email must be provided'
            })

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
            raise serializers.ValidationError({
                'non_field_errors': 'Invalid username or email'
            })

        # Authenticate using the found user
        authenticated_user = authenticate(username=user.username, password=password)

        if authenticated_user is None:
            raise serializers.ValidationError({
                'password': 'Invalid password'
            })

        # Generate tokens
        from rest_framework_simplejwt.tokens import RefreshToken
        refresh = RefreshToken.for_user(authenticated_user)

        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': {
                'id': authenticated_user.id,
                'username': authenticated_user.username,
                'email': authenticated_user.email,
                'first_name': authenticated_user.first_name,
                'last_name': authenticated_user.last_name,
            }
        }


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


# ==================== VISA VIEWSETS ====================

class VisaTypeViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for visa types with custom filtering actions.

    Endpoints:
    - GET /api/mobile/visas/types/ - List all active types with variants
    - GET /api/mobile/visas/types/{id}/ - Retrieve type with full variant details
    - GET /api/mobile/visas/types/by_country/?country=ARE - Filter by country code
    - GET /api/mobile/visas/types/featured/ - Types with featured variants
    """
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['country_code', 'is_active']
    search_fields = ['title', 'subtitle', 'description']
    ordering_fields = ['display_order', 'title', 'created_at']
    ordering = ['display_order', 'title']

    def get_queryset(self):
        queryset = MobileVisaType.objects.filter(is_active=True)
        active_variants = Prefetch(
            'variants',
            queryset=MobileVisaVariant.objects.filter(is_active=True).prefetch_related(
                Prefetch('rules', queryset=VisaRule.objects.order_by('display_order'))
            ).order_by('display_order')
        )
        return queryset.prefetch_related(active_variants)

    def get_serializer_class(self):
        if self.action == 'list':
            return VisaTypeListSerializer
        return VisaTypeSerializer

    @action(detail=False, methods=['get'], url_path='by-country')
    def by_country(self, request):
        """Filter visa types by country code."""
        country_code = request.query_params.get('country')
        if not country_code:
            return Response({'error': 'country parameter required'}, status=status.HTTP_400_BAD_REQUEST)
        queryset = self.get_queryset().filter(country_code__iexact=country_code)
        serializer = VisaTypeListSerializer(queryset, many=True, context={'request': request})
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get visa types with featured variants."""
        queryset = self.get_queryset().filter(
            variants__is_featured=True, variants__is_active=True
        ).distinct()
        serializer = VisaTypeListSerializer(queryset, many=True, context={'request': request})
        return Response(serializer.data)


class VisaVariantViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for visa variants with filtering and search.

    Endpoints:
    - GET /api/mobile/visas/variants/ - List all active variants
    - GET /api/mobile/visas/variants/{id}/ - Retrieve variant with rules
    - GET /api/mobile/visas/variants/featured/ - Featured variants
    - GET /api/mobile/visas/variants/by_category/?category=tourist - Filter by category
    """
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['visa_type', 'visa_category', 'is_active', 'is_featured', 'currency']
    search_fields = ['title', 'subtitle', 'description']
    ordering_fields = ['display_order', 'price', 'title', 'created_at']
    ordering = ['display_order', 'title']

    def get_queryset(self):
        return MobileVisaVariant.objects.filter(
            is_active=True, visa_type__is_active=True
        ).select_related('visa_type').prefetch_related(
            Prefetch('rules', queryset=VisaRule.objects.order_by('display_order'))
        )

    def get_serializer_class(self):
        if self.action == 'list':
            return VisaVariantListSerializer
        return VisaVariantSerializer

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get featured visa variants."""
        queryset = self.get_queryset().filter(is_featured=True)
        serializer = VisaVariantListSerializer(queryset, many=True, context={'request': request})
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='by-category')
    def by_category(self, request):
        """Filter variants by visa category."""
        category = request.query_params.get('category')
        if not category:
            return Response({'error': 'category parameter required'}, status=status.HTTP_400_BAD_REQUEST)
        queryset = self.get_queryset().filter(visa_category=category)
        serializer = VisaVariantListSerializer(queryset, many=True, context={'request': request})
        return Response(serializer.data)


class VisaRuleViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for visa rules (read-only).

    Endpoints:
    - GET /api/mobile/visas/rules/ - List rules
    - GET /api/mobile/visas/rules/{id}/ - Retrieve rule detail
    """
    queryset = VisaRule.objects.select_related(
        'visa_variant', 'visa_variant__visa_type'
    ).order_by('display_order', 'title')
    serializer_class = VisaRuleSerializer
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['visa_variant', 'rule_type', 'is_mandatory']
    search_fields = ['title', 'description']
    ordering_fields = ['display_order', 'title']
    ordering = ['display_order']
