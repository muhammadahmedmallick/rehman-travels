"""
Mobile app models for new Django features
"""
from django.db import models
from django.contrib.auth.models import User
from apps.core.base_models import NewModel


class MobileUserProfile(NewModel):
    """
    Extended profile for mobile app users.

    Stored in new PostgreSQL database.
    References Django's built-in User model.
    """
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='mobile_profile'
    )
    phone_number = models.CharField(max_length=20, blank=True)
    device_token = models.CharField(
        max_length=255,
        blank=True,
        help_text='For push notifications'
    )
    device_type = models.CharField(
        max_length=10,
        choices=[('ios', 'iOS'), ('android', 'Android')],
        blank=True
    )
    is_mobile_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mobile_user_profiles'
        verbose_name = 'Mobile User Profile'
        verbose_name_plural = 'Mobile User Profiles'

    def __str__(self):
        return f"{self.user.username} - Mobile Profile"


class MobileVisaType(NewModel):
    """
    Top-level visa category (e.g., UAE Visa, Umrah Visa).

    Represents a destination/country-based visa type with associated variants.
    Stored in PostgreSQL.
    """
    # Basic Information
    title = models.CharField(
        max_length=255,
        help_text='Visa type name (e.g., UAE Visa, Umrah Visa)'
    )
    subtitle = models.CharField(
        max_length=500,
        blank=True,
        help_text='Short tagline for the visa type'
    )
    description = models.TextField(
        blank=True,
        help_text='Detailed description of visa type'
    )

    # Images
    thumbnail = models.ImageField(
        upload_to='visas/types/thumbnails/',
        blank=True,
        null=True,
        help_text='Card image (400x300px recommended)'
    )
    banner = models.ImageField(
        upload_to='visas/types/banners/',
        blank=True,
        null=True,
        help_text='Banner image (1920x400px recommended)'
    )

    # Metadata
    country_code = models.CharField(
        max_length=3,
        blank=True,
        help_text='ISO 3166-1 alpha-3 country code (e.g., ARE, SAU)'
    )
    processing_time = models.CharField(
        max_length=100,
        blank=True,
        help_text='e.g., "3-5 working days"'
    )

    # Display Control
    is_active = models.BooleanField(
        default=True,
        help_text='Enable/disable this visa type'
    )
    display_order = models.IntegerField(
        default=0,
        help_text='Order of display in lists'
    )

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mobile_visa_types'
        verbose_name = 'Mobile Visa Type'
        verbose_name_plural = 'Mobile Visa Types'
        ordering = ['display_order', 'title']
        indexes = [
            models.Index(fields=['is_active', 'display_order']),
            models.Index(fields=['country_code']),
        ]

    def __str__(self):
        return self.title

    @property
    def active_variants_count(self):
        """Count of active variants for this visa type."""
        return self.variants.filter(is_active=True).count()

    @property
    def variant_price_range(self):
        """Get min/max pricing from active variants."""
        variants = self.variants.filter(is_active=True)
        if not variants.exists():
            return None
        prices = [v.price for v in variants if v.price]
        if not prices:
            return None
        return {
            'min': min(prices),
            'max': max(prices),
            'currency': variants.first().currency
        }


class MobileVisaVariant(NewModel):
    """
    Specific visa package under a type (e.g., "30 Days Single Entry").

    Represents a specific variant or option of a visa type with detailed
    information, pricing, and associated rules.
    """
    # Foreign Key
    visa_type = models.ForeignKey(
        'MobileVisaType',
        on_delete=models.CASCADE,
        related_name='variants',
        help_text='Parent visa type'
    )

    # Basic Information
    title = models.CharField(
        max_length=255,
        help_text='Visa variant name (e.g., 30 Days Single Entry)'
    )
    subtitle = models.CharField(
        max_length=500,
        blank=True,
        help_text='Descriptive subtitle'
    )
    description = models.TextField(
        blank=True,
        help_text='Detailed description of this variant'
    )

    # Images
    thumbnail = models.ImageField(
        upload_to='visas/variants/thumbnails/',
        blank=True,
        null=True,
        help_text='Variant thumbnail image'
    )
    banner = models.ImageField(
        upload_to='visas/variants/banners/',
        blank=True,
        null=True,
        help_text='Variant banner image'
    )

    # Pricing & Validity
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        blank=True,
        null=True,
        help_text='Visa price'
    )
    currency = models.CharField(
        max_length=3,
        default='PKR',
        help_text='Currency code (e.g., PKR, USD)'
    )
    validity = models.CharField(
        max_length=100,
        blank=True,
        help_text='Validity period (e.g., 60 days from issue)'
    )
    duration = models.CharField(
        max_length=100,
        blank=True,
        help_text='Stay duration (e.g., 30 days)'
    )
    num_entries = models.CharField(
        max_length=50,
        blank=True,
        help_text='Number of entries (e.g., Single, Double, Multiple)'
    )
    processing_time = models.CharField(
        max_length=100,
        blank=True,
        help_text='Processing time (overrides type-level if set)'
    )

    # Classification
    visa_category = models.CharField(
        max_length=50,
        blank=True,
        choices=[
            ('tourist', 'Tourist'),
            ('business', 'Business'),
            ('transit', 'Transit'),
            ('work', 'Work'),
            ('student', 'Student'),
            ('family', 'Family/Visit'),
            ('religious', 'Religious (Umrah/Hajj)'),
            ('other', 'Other'),
        ],
        help_text='Category of this visa'
    )

    # Additional Details
    includes = models.TextField(
        blank=True,
        help_text='What is included in this package'
    )
    excludes = models.TextField(
        blank=True,
        help_text='What is excluded from this package'
    )

    # Display Control
    is_active = models.BooleanField(
        default=True,
        help_text='Enable/disable this variant'
    )
    is_featured = models.BooleanField(
        default=False,
        help_text='Mark as featured on homepage'
    )
    display_order = models.IntegerField(
        default=0,
        help_text='Order of display'
    )

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mobile_visa_variants'
        verbose_name = 'Mobile Visa Variant'
        verbose_name_plural = 'Mobile Visa Variants'
        ordering = ['visa_type', 'display_order', 'title']
        indexes = [
            models.Index(fields=['visa_type', 'is_active', 'display_order']),
            models.Index(fields=['visa_category']),
            models.Index(fields=['is_featured']),
        ]
        # unique_together removed to allow multiple variants with same title per visa type
        # Example: Malaysia can have multiple "30 days" variants (e-visa, sticker, urgent)

    def __str__(self):
        return f"{self.visa_type.title} - {self.title}"

    @property
    def formatted_price(self):
        """Return formatted price string."""
        if self.price:
            return f"{self.currency} {self.price:,.0f}"
        return "Contact for pricing"

    @property
    def rules_count(self):
        """Count of associated rules."""
        return self.rules.count()


class VisaRule(NewModel):
    """
    Individual requirement/document for a visa variant.

    Represents a specific rule, requirement, or document needed for a visa variant.
    Can be classified as transit or general rule.
    """
    # Foreign Key
    visa_variant = models.ForeignKey(
        'MobileVisaVariant',
        on_delete=models.CASCADE,
        related_name='rules',
        help_text='Parent visa variant'
    )

    # Rule Information
    title = models.CharField(
        max_length=255,
        help_text='Rule/requirement name (e.g., Valid Passport Required)'
    )
    description = models.TextField(
        blank=True,
        help_text='Detailed description of the requirement'
    )

    # Classification
    rule_type = models.CharField(
        max_length=20,
        choices=[
            ('transit', 'Transit Rule'),
            ('general', 'General Requirement'),
        ],
        default='general',
        help_text='Type of rule (transit vs general visa)'
    )

    # Visual Icon
    icon = models.CharField(
        max_length=50,
        blank=True,
        help_text='FontAwesome icon class (e.g., fa-passport)'
    )

    # Display Control
    is_mandatory = models.BooleanField(
        default=True,
        help_text='Mark as mandatory requirement'
    )
    display_order = models.IntegerField(
        default=0,
        help_text='Order of display'
    )

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mobile_visa_rules'
        verbose_name = 'Visa Rule'
        verbose_name_plural = 'Visa Rules'
        ordering = ['visa_variant', 'display_order', 'title']
        indexes = [
            models.Index(fields=['visa_variant', 'display_order']),
            models.Index(fields=['rule_type']),
        ]

    def __str__(self):
        return f"{self.visa_variant} - {self.title}"

    @property
    def icon_class(self):
        """Return full FontAwesome icon class."""
        if self.icon:
            return f"fas {self.icon}" if self.icon.startswith('fa-') else f"fas fa-{self.icon}"
        return "fas fa-check-circle"
