import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../flights/presentation/widgets/flight_search_form.dart';
import '../../../visa/presentation/providers/visa_provider.dart';
import '../../../pak_tour/presentation/providers/pak_tour_provider.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../app/main_shell.dart';
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
                offset: const Offset(0, -36),
                child: Padding(
                  padding: AppPadding.screenH,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: AppShadows.elevated,
                    ),
                    child: const FlightSearchForm(),
                  ),
                ),
              ),

              // eSIM Card
              Padding(
                padding: AppPadding.screenH,
                child: _buildEsimCard(context),
              ),
              const SizedBox(height: 20),

              // Popular Destinations
              _buildSectionHeader('Popular Destinations', onSeeAll: () {}),
              const SizedBox(height: 8),
              _buildDestinationsList(context, ref),

              const SizedBox(height: 20),

              // Visa Services
              _buildSectionHeader(
                'Visa Services',
                icon: Icons.article_outlined,
                iconColor: AppColors.accent,
                onSeeAll: () => ref.read(selectedTabProvider.notifier).state = 1,
              ),
              const SizedBox(height: 8),
              _buildVisaList(context, ref),

              const SizedBox(height: 20),

              // Pakistan Tours
              _buildSectionHeader(
                'Pakistan Tours',
                icon: Icons.landscape_outlined,
                iconColor: const Color(0xFF059669),
                onSeeAll: () => context.push('/pak-tour'),
              ),
              const SizedBox(height: 8),
              _buildPakTourList(context, ref),

              const SizedBox(height: 20),

              // Why Choose Us
              Padding(
                padding: AppPadding.screenH,
                child: _buildWhyChooseUs(),
              ),

              const SizedBox(height: 28),

              // Need Assistance
              Padding(
                padding: AppPadding.screenH,
                child: _buildNeedAssistance(),
              ),

              AppGap.xl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Location + Currency/Notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location
                  Row(children: [
                     Image.asset('assets/icons/logo.png', width: 64, height: 64,),
                    const SizedBox(width: 4),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome to', style: AppTextStyles.titleMd.copyWith(color: Colors.white54,)),
                      Text('Rehman Travel', style: AppTextStyles.titleLg.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                  Row(children: [
                    _buildCurrencyButton(context, ref),
                   
                  ]),
                ],
              ),

              const SizedBox(height: 12),

              // Search heading
              Text(
                'Search For\nFlights To your\nDestination',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 26,
                  color: Colors.white,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyButton(BuildContext context, WidgetRef ref) {
    return const CurrencySelector();
  }

  Widget _buildEsimCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.esim),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8403F), Color(0xFFFF6B35)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.sim_card_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text('TRAVEL eSIM', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              ]),
              const SizedBox(height: 6),
              Text('Stay connected worldwide', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
            child: Text('Get eSIM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFE8403F))),
          ),
        ]),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon, Color? iconColor, required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: Text('See All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
        ),
      ]),
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
        padding: AppPadding.screenH,
        itemCount: destState.destinations.length,
        itemBuilder: (context, index) {
          final dest = destState.destinations[index];
          final gradientColors = _getGradientForIndex(index);
          final isPakTour = dest.parentId == 12;
          return _DestinationCard(
            city: dest.displayName,
            country: isPakTour ? 'Pak Tour' : 'Visa',
            price: dest.formattedPrice,
            imageUrl: dest.imageUrl,
            gradient: gradientColors,
            onTap: () {
              if (isPakTour) {
                context.push('/pak-tour/details', extra: dest.urlLink);
              } else {
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

  Widget _buildVisaList(BuildContext context, WidgetRef ref) {
    final visaState = ref.watch(visaListProvider);

    if (visaState.isLoading) {
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

    if (visaState.visas.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayVisas = visaState.visas.take(6).toList();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenH,
        itemCount: displayVisas.length,
        itemBuilder: (context, index) {
          final visa = displayVisas[index];
          final gradientColors = _getGradientForIndex(index + 2);
          return _DestinationCard(
            city: visa.displayName,
            country: 'Visa',
            price: '',
            imageUrl: visa.imageUrl,
            gradient: gradientColors,
            onTap: () => context.push('/visa/details', extra: visa.urlLink),
          );
        },
      ),
    );
  }

  Widget _buildPakTourList(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(pakTourListProvider);

    if (tourState.isLoading) {
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

    if (tourState.tours.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayTours = tourState.tours.take(6).toList();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenH,
        itemCount: displayTours.length,
        itemBuilder: (context, index) {
          final tour = displayTours[index];
          final gradientColors = _getGradientForIndex(index + 4);
          return _DestinationCard(
            city: tour.packageTitle,
            country: tour.durationText.isNotEmpty ? tour.durationText : 'Pak Tour',
            price: tour.formattedPrice,
            imageUrl: tour.imageUrl,
            gradient: gradientColors,
            onTap: () => context.push('/pak-tour/details', extra: tour.urlLink),
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
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: AppIconSize.lg,
                ),
              ),
              AppGap.hMd,
              Text(
                'Why Book With Us?',
                style: AppTextStyles.titleLg,
              ),
            ],
          ),
          AppGap.lg,
          const _FeatureItem(
            icon: Icons.local_offer_outlined,
            title: 'Best Price Guarantee',
            subtitle: 'We match any lower price you find',
            color: AppColors.secondary,
          ),
          AppGap.md,
          const _FeatureItem(
            icon: Icons.support_agent_outlined,
            title: '24/7 Customer Support',
            subtitle: 'Round the clock assistance',
            color: AppColors.accent,
          ),
          AppGap.md,
          const _FeatureItem(
            icon: Icons.lock_outline_rounded,
            title: 'Secure Payments',
            subtitle: '100% secure transactions',
            color: AppColors.success,
          ),
          AppGap.md,
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                ),
                child: const Icon(
                  Icons.headset_mic_outlined,
                  color: AppColors.primary,
                  size: AppIconSize.xl,
                ),
              ),
              AppGap.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Assistance?',
                      style: AppTextStyles.titleLg.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'We\'re here to help 24/7',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppGap.md,

          // Contact Buttons Row
          Row(
            children: [
              Expanded(
                child: _ContactButton(
                  icon: Icons.phone_outlined,
                  label: 'Call Us',
                  color: AppColors.primary,
                  onTap: () => _launchUrl('tel:+‪+923111786785‬'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ContactButton(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchUrl('https://wa.me/‪+923111786785‬'),
                ),
              ),
            ],
          ),

          AppGap.md,

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
          ),

          AppGap.md,

          // Social Media Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Follow us',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                ),
              ),
              AppGap.hLg,
              _SocialIcon(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => _launchUrl('https://facebook.com/rehmantravel'),
              ),
              AppGap.hMd,
              _SocialIcon(
                icon: Icons.camera_alt_outlined,
                color: const Color(0xFFE4405F),
                onTap: () => _launchUrl('https://instagram.com/rehmantravel'),
              ),
              AppGap.hMd,
              _SocialIconText(
                text: 'X',
                color: Colors.black,
                onTap: () => _launchUrl('https://twitter.com/rehmantravel'),
              ),
              AppGap.hMd,
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
          borderRadius: BorderRadius.circular(AppRadius.xl),
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
              padding: AppPadding.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.xs + 2),
                    ),
                    child: Text(
                      country,
                      style: AppTextStyles.bodySm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    city,
                    style: AppTextStyles.labelLg.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price.isNotEmpty) ...[
                    AppGap.xs,
                    Container(
                      padding: AppPadding.badge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xs + 2),
                      ),
                      child: Text(
                        price,
                        style: AppTextStyles.labelSm.copyWith(
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
            borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppIconSize.lg,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSm,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: color,
          size: AppIconSize.lg,
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
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppIconSize.lg),
            AppGap.hSm,
            Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                fontSize: 13,
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
        child: Icon(icon, color: color, size: AppIconSize.lg),
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
            style: AppTextStyles.titleSm.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

