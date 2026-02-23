import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../flights/presentation/widgets/flight_search_form.dart';
import '../../../visa/presentation/widgets/visa_card.dart';
import '../../../visa/presentation/providers/visa_provider.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../providers/destination_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(context, ref),

              // Search Card - Overlapping Hero
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.elevated,
                    ),
                    child: const FlightSearchForm(),
                  ),
                ),
              ),

              // Popular Destinations
              _buildSectionHeader('Popular Destinations', onSeeAll: () {}),
              const SizedBox(height: 12),
              _buildDestinationsList(context, ref),

              const SizedBox(height: 28),

              // Special Offers Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPromoBanner(),
              ),

              const SizedBox(height: 28),

              // Visa Services
              _buildSectionHeader(
                'Visa Services',
                icon: Icons.article_outlined,
                iconColor: AppColors.accent,
                onSeeAll: () {},
              ),
              const SizedBox(height: 12),
              _buildVisaList(context, ref),

              const SizedBox(height: 28),

              // Why Choose Us
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildWhyChooseUs(),
              ),

              const SizedBox(height: 28),

              // Need Assistance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildNeedAssistance(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/app_icon.png',
                        width: 48,
                        height: 68,
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rehman Travels',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Your journey starts here',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildCurrencyButton(context, ref),
                ],
              ),

              const SizedBox(height: 32),

              // Welcome Text
              const Text(
                'Hello, Traveler!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Where would you\nlike to go?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyButton(BuildContext context, WidgetRef ref) {
    final currencyState = ref.watch(currencyProvider);
    final selected = currencyState.selected;
    final code = selected?.currencyCode ?? 'PKR';
    final flag = selected?.flagEmoji ?? '🇵🇰';

    return GestureDetector(
      onTap: () => _showCurrencyPicker(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              code,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    final currencyState = ref.read(currencyProvider);

    if (currencyState.isLoading) return;
    if (currencyState.currencies.isEmpty) {
      ref.read(currencyProvider.notifier).refresh();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _CurrencyBottomSheet(
        currencies: currencyState.currencies,
        selected: currencyState.selected,
        onSelect: (currency) {
          ref.read(currencyProvider.notifier).selectCurrency(currency);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon, Color? iconColor, required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor ?? AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Row(
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsList(BuildContext context, WidgetRef ref) {
    final destState = ref.watch(destinationListProvider);

    if (destState.isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (destState.destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: destState.destinations.length,
        itemBuilder: (context, index) {
          final dest = destState.destinations[index];
          final gradientColors = _getGradientForIndex(index);
          return _DestinationCard(
            city: dest.displayName,
            country: dest.parentId == 4 ? 'Visa' : 'Umrah',
            price: dest.formattedPrice,
            imageUrl: dest.imageUrl,
            gradient: gradientColors,
            onTap: () {
              if (dest.parentId == 4) {
                context.push('/visa/details', extra: dest.urlLink);
              }
            },
          );
        },
      ),
    );
  }

  List<Color> _getGradientForIndex(int index) {
    const gradients = [
      [Color(0xFF1E3A5F), Color(0xFF3D6B8C)],
      [Color(0xFF006C35), Color(0xFF00A854)],
      [Color(0xFFE30A17), Color(0xFFFF4757)],
      [Color(0xFF00247D), Color(0xFF4169E1)],
      [Color(0xFF010066), Color(0xFF3333AA)],
      [Color(0xFF6B21A8), Color(0xFF9333EA)],
      [Color(0xFFB45309), Color(0xFFD97706)],
      [Color(0xFF0F766E), Color(0xFF14B8A6)],
    ];
    return gradients[index % gradients.length];
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'UMRAH SPECIAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Get 20% Off\non Umrah Packages',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '🕋',
              style: TextStyle(fontSize: 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaList(BuildContext context, WidgetRef ref) {
    final visaState = ref.watch(visaListProvider);

    if (visaState.isLoading) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (visaState.visas.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show first 6 visas on home screen
    final displayVisas = visaState.visas.take(6).toList();

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: displayVisas.length,
        itemBuilder: (context, index) {
          final visa = displayVisas[index];
          return VisaCard(
            visa: visa,
            onTap: () => context.push('/visa/details', extra: visa.urlLink),
          );
        },
      ),
    );
  }

  Widget _buildWhyChooseUs() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.accent.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Why Book With Us?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _FeatureItem(
            icon: Icons.local_offer_outlined,
            title: 'Best Price Guarantee',
            subtitle: 'We match any lower price you find',
            color: AppColors.secondary,
          ),
          const SizedBox(height: 14),
          const _FeatureItem(
            icon: Icons.support_agent_outlined,
            title: '24/7 Customer Support',
            subtitle: 'Round the clock assistance',
            color: AppColors.accent,
          ),
          const SizedBox(height: 14),
          const _FeatureItem(
            icon: Icons.lock_outline_rounded,
            title: 'Secure Payments',
            subtitle: '100% secure transactions',
            color: AppColors.success,
          ),
          const SizedBox(height: 14),
          const _FeatureItem(
            icon: Icons.star_outline_rounded,
            title: 'Trusted by Thousands',
            subtitle: '10+ years of excellence',
            color: Color(0xFFD4AF37),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedAssistance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.headset_mic_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Assistance?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'We\'re here to help 24/7',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact Buttons Row
          Row(
            children: [
              Expanded(
                child: _ContactButton(
                  icon: Icons.phone_outlined,
                  label: 'Call Us',
                  color: AppColors.primary,
                  onTap: () => _launchUrl('tel:+923001234567'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ContactButton(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchUrl('https://wa.me/923001234567'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
          ),

          const SizedBox(height: 16),

          // Social Media Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Follow us',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(width: 16),
              _SocialIcon(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => _launchUrl('https://facebook.com/rehmantravel'),
              ),
              const SizedBox(width: 12),
              _SocialIcon(
                icon: Icons.camera_alt_outlined,
                color: const Color(0xFFE4405F),
                onTap: () => _launchUrl('https://instagram.com/rehmantravel'),
              ),
              const SizedBox(width: 12),
              _SocialIconText(
                text: 'X',
                color: Colors.black,
                onTap: () => _launchUrl('https://twitter.com/rehmantravel'),
              ),
              const SizedBox(width: 12),
              _SocialIcon(
                icon: Icons.play_circle_outline,
                color: const Color(0xFFFF0000),
                onTap: () => _launchUrl('https://youtube.com/@rehmantravel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Destination Card
class _DestinationCard extends StatelessWidget {
  final String city;
  final String country;
  final String price;
  final String? imageUrl;
  final List<Color> gradient;
  final VoidCallback? onTap;

  const _DestinationCard({
    required this.city,
    required this.country,
    required this.price,
    this.imageUrl,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background - image or gradient
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            // Dark overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      country,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'from $price',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: gradient[0],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Feature Item
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: color,
          size: 20,
        ),
      ],
    );
  }
}

// Contact Button
class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Social Icon
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// Social Icon with Text (for X/Twitter)
class _SocialIconText extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _SocialIconText({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

// Currency Bottom Sheet
class _CurrencyBottomSheet extends StatelessWidget {
  final List<Currency> currencies;
  final Currency? selected;
  final ValueChanged<Currency> onSelect;

  const _CurrencyBottomSheet({
    required this.currencies,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.currency_exchange, color: AppColors.primary, size: 22),
                SizedBox(width: 10),
                Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Currency List
          ...currencies.map((currency) {
            final isSelected = selected?.currencyCode == currency.currencyCode;
            return InkWell(
              onTap: () => onSelect(currency),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.06)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Text(
                      currency.flagEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currency.currencyName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${currency.currencyCode} (${currency.currencySymbol})',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (currency.currencyRate > 0)
                      Text(
                        '${currency.currencyRate.toStringAsFixed(2)} PKR',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 22,
                      )
                    else
                      Icon(
                        Icons.circle_outlined,
                        color: AppColors.textHint,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
