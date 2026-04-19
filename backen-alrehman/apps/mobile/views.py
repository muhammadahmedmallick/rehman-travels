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
from django.shortcuts import get_object_or_404
from .models import MobileVisaType, MobileVisaVariant, VisaRule, MobilePackage
from .serializers import (
    UserRegistrationSerializer, UserSerializer,
    VisaRuleSerializer, VisaVariantListSerializer, VisaVariantSerializer,
    VisaTypeListSerializer, VisaTypeSerializer, PackageSerializer
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

class VisaTypeViewSet(viewsets.ModelViewSet):
    """
    ViewSet for visa types with full CRUD operations and custom filtering actions.

    Endpoints:
    - GET /api/mobile/visas/types/ - List all active types with variants
    - POST /api/mobile/visas/types/ - Create new visa type
    - GET /api/mobile/visas/types/{slug}/ - Retrieve type by slug with full variant details
    - PUT /api/mobile/visas/types/{slug}/ - Update visa type
    - PATCH /api/mobile/visas/types/{slug}/ - Partial update visa type
    - DELETE /api/mobile/visas/types/{slug}/ - Delete visa type
    - GET /api/mobile/visas/types/by_country/?country=ARE - Filter by country code
    - GET /api/mobile/visas/types/featured/ - Types with featured variants
    """
    permission_classes = [AllowAny]
    lookup_field = 'slug'
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['country_code', 'is_active']
    search_fields = ['title', 'subtitle', 'description']
    ordering_fields = ['display_order', 'title', 'created_at']
    ordering = ['display_order', 'title']

    def get_queryset(self):
        # For list/read, show only active; for admin operations, show all
        if self.action in ['list', 'by_country', 'featured']:
            queryset = MobileVisaType.objects.filter(is_active=True)
        else:
            queryset = MobileVisaType.objects.all()

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


class VisaVariantViewSet(viewsets.ModelViewSet):
    """
    ViewSet for visa variants with full CRUD operations, filtering and search.

    Endpoints:
    - GET /api/mobile/visas/variants/ - List all active variants
    - POST /api/mobile/visas/variants/ - Create new visa variant
    - GET /api/mobile/visas/variants/{slug}/ - Retrieve variant by slug with rules
    - PUT /api/mobile/visas/variants/{slug}/ - Update variant
    - PATCH /api/mobile/visas/variants/{slug}/ - Partial update variant
    - DELETE /api/mobile/visas/variants/{slug}/ - Delete variant
    - GET /api/mobile/visas/variants/featured/ - Featured variants
    - GET /api/mobile/visas/variants/by_category/?category=tourist - Filter by category
    """
    permission_classes = [AllowAny]
    lookup_field = 'slug'
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['visa_type', 'visa_category', 'is_active', 'is_featured', 'currency']
    search_fields = ['title', 'subtitle', 'description', 'requirements']
    ordering_fields = ['display_order', 'price', 'title', 'created_at']
    ordering = ['display_order', 'title']

    def get_queryset(self):
        # For list/read, show only active; for admin operations, show all
        if self.action in ['list', 'featured', 'by_category']:
            return MobileVisaVariant.objects.filter(
                is_active=True, visa_type__is_active=True
            ).select_related('visa_type').prefetch_related(
                Prefetch('rules', queryset=VisaRule.objects.order_by('display_order'))
            )
        else:
            return MobileVisaVariant.objects.all().select_related('visa_type').prefetch_related(
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


class VisaRuleViewSet(viewsets.ModelViewSet):
    """
    ViewSet for visa rules with full CRUD operations.

    Endpoints:
    - GET /api/mobile/visas/rules/ - List rules
    - POST /api/mobile/visas/rules/ - Create new rule
    - GET /api/mobile/visas/rules/{id}/ - Retrieve rule detail
    - PUT /api/mobile/visas/rules/{id}/ - Update rule
    - PATCH /api/mobile/visas/rules/{id}/ - Partial update rule
    - DELETE /api/mobile/visas/rules/{id}/ - Delete rule
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


# ==================== PACKAGE VIEWSETS ====================

class PackageViewSet(viewsets.ModelViewSet):
    """
    ViewSet for travel packages with full CRUD operations, slug-based lookup and suggestions.

    Endpoints:
    - GET /api/mobile/packages/ - List all active packages
    - POST /api/mobile/packages/ - Create new package
    - GET /api/mobile/packages/{slug}/ - Retrieve package by slug
    - GET /api/mobile/packages/{slug}/?suggestions=true - Get package with suggestions
    - PUT /api/mobile/packages/{slug}/ - Update package
    - PATCH /api/mobile/packages/{slug}/ - Partial update package
    - DELETE /api/mobile/packages/{slug}/ - Delete package
    - GET /api/mobile/packages/featured/ - Featured packages
    - GET /api/mobile/packages/by_type/?type=umrah - Filter by package type
    """
    serializer_class = PackageSerializer
    permission_classes = [AllowAny]
    lookup_field = 'slug'
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['package_type', 'is_active', 'is_featured', 'currency', 'location']
    search_fields = ['title', 'description', 'tags', 'location']
    ordering_fields = ['display_order', 'price', 'title', 'created_at']
    ordering = ['display_order', '-created_at']

    def get_queryset(self):
        # For list/read, show only active; for admin operations, show all
        if self.action in ['list', 'featured', 'by_type']:
            return MobilePackage.objects.filter(is_active=True)
        else:
            return MobilePackage.objects.all()

    def retrieve(self, request, slug=None):
        """
        Retrieve a package by slug with optional suggestions.

        Query parameters:
        - suggestions: if 'true', return the matched package first followed by other packages
        """
        suggestions = request.query_params.get('suggestions', '').lower() == 'true'

        # Get the requested package
        package = get_object_or_404(self.get_queryset(), slug=slug)

        if suggestions:
            # Get other packages excluding the current one
            other_packages = self.get_queryset().exclude(slug=slug).order_by('display_order', '-created_at')

            # Combine: requested package first, then others
            serializer = self.get_serializer(package)
            other_serializer = self.get_serializer(other_packages, many=True)

            return Response({
                'package': serializer.data,
                'suggestions': other_serializer.data
            })
        else:
            # Normal detail view
            serializer = self.get_serializer(package)
            return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get featured packages."""
        queryset = self.get_queryset().filter(is_featured=True)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='by-type')
    def by_type(self, request):
        """Filter packages by type."""
        package_type = request.query_params.get('type')
        if not package_type:
            return Response({'error': 'type parameter required'}, status=status.HTTP_400_BAD_REQUEST)
        queryset = self.get_queryset().filter(package_type=package_type)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)
