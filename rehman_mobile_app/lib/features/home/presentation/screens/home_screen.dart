import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../flights/presentation/widgets/flight_search_form.dart';
import '../../../visa/presentation/widgets/visa_card.dart';

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
              _buildHeroSection(context),

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

              // Quick Services
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: _buildQuickServices(context),
              ),

              // Popular Destinations
              _buildSectionHeader('Popular Destinations', onSeeAll: () {}),
              const SizedBox(height: 12),
              _buildDestinationsList(),

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
              _buildVisaList(context),

              const SizedBox(height: 28),

              // Why Choose Us
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildWhyChooseUs(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
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
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.search, () {}),
                      const SizedBox(width: 8),
                      _buildHeaderIcon(Icons.notifications_none_rounded, () {}),
                    ],
                  ),
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

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildQuickServices(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickServiceCard(
            icon: Icons.flight_rounded,
            label: 'Flights',
            color: AppColors.primary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickServiceCard(
            icon: Icons.article_outlined,
            label: 'Visa',
            color: AppColors.accent,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickServiceCard(
            icon: Icons.mosque_outlined,
            label: 'Umrah',
            color: const Color(0xFF10B981),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickServiceCard(
            icon: Icons.support_agent_rounded,
            label: 'Support',
            color: AppColors.secondary,
            onTap: () {},
          ),
        ),
      ],
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

  Widget _buildDestinationsList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          _DestinationCard(
            city: 'Dubai',
            country: 'UAE',
            code: 'DXB',
            price: 'PKR 45,000',
            emoji: '🇦🇪',
            gradient: [Color(0xFF1E3A5F), Color(0xFF3D6B8C)],
          ),
          _DestinationCard(
            city: 'Jeddah',
            country: 'Saudi Arabia',
            code: 'JED',
            price: 'PKR 85,000',
            emoji: '🇸🇦',
            gradient: [Color(0xFF006C35), Color(0xFF00A854)],
          ),
          _DestinationCard(
            city: 'Istanbul',
            country: 'Turkey',
            code: 'IST',
            price: 'PKR 95,000',
            emoji: '🇹🇷',
            gradient: [Color(0xFFE30A17), Color(0xFFFF4757)],
          ),
          _DestinationCard(
            city: 'London',
            country: 'United Kingdom',
            code: 'LHR',
            price: 'PKR 150,000',
            emoji: '🇬🇧',
            gradient: [Color(0xFF00247D), Color(0xFF4169E1)],
          ),
          _DestinationCard(
            city: 'Kuala Lumpur',
            country: 'Malaysia',
            code: 'KUL',
            price: 'PKR 75,000',
            emoji: '🇲🇾',
            gradient: [Color(0xFF010066), Color(0xFF3333AA)],
          ),
        ],
      ),
    );
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

  Widget _buildVisaList(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          VisaCard(
            country: 'United Arab Emirates',
            countryCode: 'UAE',
            visaType: 'Tourist',
            duration: '30 Days',
            processing: '3-5 Days',
            price: 15000,
            onTap: () => _navigateToVisaDetails(context, {
              'country': 'United Arab Emirates',
              'countryCode': 'UAE',
              'visaType': 'Tourist Visa',
              'duration': '30 Days',
              'processing': '3-5 Working Days',
              'price': 15000,
              'entry': 'Single',
            }),
          ),
          VisaCard(
            country: 'Saudi Arabia',
            countryCode: 'SAU',
            visaType: 'Umrah',
            duration: '14 Days',
            processing: '5-7 Days',
            price: 25000,
            onTap: () => _navigateToVisaDetails(context, {
              'country': 'Saudi Arabia',
              'countryCode': 'SAU',
              'visaType': 'Umrah Visa',
              'duration': '14 Days',
              'processing': '5-7 Working Days',
              'price': 25000,
              'entry': 'Single',
            }),
          ),
          VisaCard(
            country: 'Turkey',
            countryCode: 'TUR',
            visaType: 'E-Visa',
            duration: '30 Days',
            processing: '24-48 Hours',
            price: 8000,
            onTap: () => _navigateToVisaDetails(context, {
              'country': 'Turkey',
              'countryCode': 'TUR',
              'visaType': 'E-Visa',
              'duration': '30 Days',
              'processing': '24-48 Hours',
              'price': 8000,
              'entry': 'Multiple',
            }),
          ),
          VisaCard(
            country: 'Malaysia',
            countryCode: 'MYS',
            visaType: 'E-Visa',
            duration: '30 Days',
            processing: '3-5 Days',
            price: 12000,
            onTap: () => _navigateToVisaDetails(context, {
              'country': 'Malaysia',
              'countryCode': 'MYS',
              'visaType': 'E-Visa',
              'duration': '30 Days',
              'processing': '3-5 Working Days',
              'price': 12000,
              'entry': 'Single',
            }),
          ),
          VisaCard(
            country: 'Thailand',
            countryCode: 'THA',
            visaType: 'Tourist',
            duration: '60 Days',
            processing: '5-7 Days',
            price: 10000,
            onTap: () => _navigateToVisaDetails(context, {
              'country': 'Thailand',
              'countryCode': 'THA',
              'visaType': 'Tourist Visa',
              'duration': '60 Days',
              'processing': '5-7 Working Days',
              'price': 10000,
              'entry': 'Single',
            }),
          ),
        ],
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

  void _navigateToVisaDetails(BuildContext context, Map<String, dynamic> visaData) {
    context.push('/visa/details', extra: visaData);
  }
}

// Quick Service Card
class _QuickServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickServiceCard({
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Destination Card
class _DestinationCard extends StatelessWidget {
  final String city;
  final String country;
  final String code;
  final String price;
  final String emoji;
  final List<Color> gradient;

  const _DestinationCard({
    required this.city,
    required this.country,
    required this.code,
    required this.price,
    required this.emoji,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
        children: [
          // Background Pattern
          Positioned(
            right: -30,
            bottom: -30,
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 100,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        code,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  country,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),
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
            ),
          ),
        ],
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
