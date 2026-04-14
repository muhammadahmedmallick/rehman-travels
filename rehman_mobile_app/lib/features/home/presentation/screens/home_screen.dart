import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../flights/presentation/widgets/flight_search_form.dart';
import '../../../visa/presentation/providers/visa_provider.dart';
import '../../../pak_tour/presentation/providers/pak_tour_provider.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../app/main_shell.dart';
import '../../../umrah/presentation/providers/umrah_provider.dart';
import '../../../flights/data/models/recent_search_item.dart';
import '../../../flights/presentation/providers/recent_searches_provider.dart';
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
              // Hero
              _buildHeroSection(context, ref),

              // Search Card - overlapping hero
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

              // Pick up where you left off (right after search widget)
              _buildRecentSearches(context, ref),

              // Quick Services
              Padding(
                padding: AppPadding.screenH,
                child: _buildQuickServices(context),
              ),
              const SizedBox(height: 24),

              // Umrah Packages
              _buildSectionHeader('Umrah Packages', icon: Icons.mosque_outlined, onSeeAll: () {}),
              const SizedBox(height: 12),
              _buildUmrahList(context, ref),
              const SizedBox(height: 24),

              // Popular Destinations
              _buildSectionHeader('Popular Destinations', icon: Icons.explore_outlined, onSeeAll: () {}),
              const SizedBox(height: 12),
              _buildDestinationsList(context, ref),
              const SizedBox(height: 24),

              // Visa Services
              _buildSectionHeader('Visa Services', icon: Icons.article_outlined, onSeeAll: () => ref.read(selectedTabProvider.notifier).state = 1),
              const SizedBox(height: 12),
              _buildVisaList(context, ref),
              const SizedBox(height: 24),

              // Pakistan Tours
              _buildSectionHeader('Pakistan Tours', icon: Icons.landscape_outlined, onSeeAll: () => context.push('/pak-tour')),
              const SizedBox(height: 12),
              _buildPakTourList(context, ref),
              const SizedBox(height: 28),

              // Why Choose Us
              Padding(padding: AppPadding.screenHLg, child: _buildWhyChooseUs()),
              const SizedBox(height: 20),

              // Need Assistance
              Padding(padding: AppPadding.screenHLg, child: _buildNeedAssistance()),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  HERO SECTION
  // ═══════════════════════════════════════════
  Widget _buildHeroSection(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  // Logo + Brand
                  Container(
                    width: 44, height: 44,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome to', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w500)),
                      const Text('Rehman Travels', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                    ],
                  )),
                  const CurrencySelector(),
                ],
              ),

              const SizedBox(height: 20),

              // Tagline
              Text(
                'Where Would You\nLike To Go?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  QUICK SERVICES (replaces eSIM card)
  // ═══════════════════════════════════════════
  Widget _buildQuickServices(BuildContext context) {
    return SizedBox();
    return Row(
      children: [
        _quickServiceItem(context, Icons.sim_card_outlined, 'eSIM', const Color(0xFFE8403F), () => context.push(AppRoutes.esim)),
        const SizedBox(width: 10),
        _quickServiceItem(context, Icons.account_balance_outlined, 'Bank Info', AppColors.primary, () => context.push(AppRoutes.bankDetails)),
        const SizedBox(width: 10),
        _quickServiceItem(context, Icons.info_outline_rounded, 'About Us', const Color(0xFF059669), () => context.push(AppRoutes.aboutUs)),
        const SizedBox(width: 10),
        _quickServiceItem(context, Icons.calculate_outlined, 'Umrah Calc', AppColors.accent, () => context.push(AppRoutes.umrahCalculator)),
      ],
    );
  }

  Widget _quickServiceItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  PICK UP WHERE YOU LEFT OFF
  // ═══════════════════════════════════════════
  Widget _buildRecentSearches(BuildContext context, WidgetRef ref) {
    final all = ref.watch(recentSearchesProvider);
    if (all.isEmpty) return const SizedBox.shrink();
    final top = all.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.history, size: 15, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Text(
              'Pick up where you left off',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Here are your recent searches',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 10),
        ...top.map((item) => _buildRecentSearchTile(context, ref, item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRecentSearchTile(
      BuildContext context, WidgetRef ref, RecentSearchItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.push(AppRoutes.flightResults, extra: item.toSearchParams());
          },
          onLongPress: () => _confirmDeleteRecent(context, ref, item),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.departureName.isNotEmpty ? item.departureName : item.departureCode} → ${item.arrivalName.isNotEmpty ? item.arrivalName : item.arrivalCode}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatRecentDate(item.outboundDate)}${item.inboundDate != null ? ' – ${_formatRecentDate(item.inboundDate!)}' : ''} • ${item.tripTypeLabel}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
            ]),
          ),
        ),
      ),
    );
  }

  String _formatRecentDate(String ddMMyyyy) {
    // Input format: dd-MM-yyyy → "Apr 29"
    try {
      final parts = ddMMyyyy.split('-');
      if (parts.length != 3) return ddMMyyyy;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[(month - 1).clamp(0, 11)]} $day';
    } catch (_) {
      return ddMMyyyy;
    }
  }

  Future<void> _confirmDeleteRecent(
      BuildContext context, WidgetRef ref, RecentSearchItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove this search?'),
        content: Text(
          '${item.departureCode} → ${item.arrivalCode} will be removed from your recent searches.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(recentSearchesProvider.notifier).deleteByKey(item.dedupKey);
    }
  }

  // ═══════════════════════════════════════════
  //  SECTION HEADER
  // ═══════════════════════════════════════════
  Widget _buildSectionHeader(String title, {IconData? icon, required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        if (icon != null) ...[
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 15, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('See All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ),
      ]),
    );
  }

  // ═══════════════════════════════════════════
  //  DESTINATION CARDS
  // ═══════════════════════════════════════════
  Widget _buildDestinationsList(BuildContext context, WidgetRef ref) {
    final destState = ref.watch(destinationListProvider);
    if (destState.isLoading) return _shimmerList();
    if (destState.destinations.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenHLg,
        itemCount: destState.destinations.length,
        itemBuilder: (context, index) {
          final dest = destState.destinations[index];
          final isPakTour = dest.parentId == 12;
          return _DestinationCard(
            city: dest.displayName,
            tag: isPakTour ? 'Pak Tour' : 'Visa',
            price: dest.formattedPrice,
            imageUrl: dest.imageUrl,
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

  Widget _buildVisaList(BuildContext context, WidgetRef ref) {
    final visaState = ref.watch(visaListProvider);
    if (visaState.isLoading) return _shimmerList();
    if (visaState.visas.isEmpty) return const SizedBox.shrink();

    final displayVisas = visaState.visas.take(6).toList();
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenHLg,
        itemCount: displayVisas.length,
        itemBuilder: (context, index) {
          final visa = displayVisas[index];
          return _DestinationCard(
            city: visa.displayName,
            tag: 'Visa',
            price: '',
            imageUrl: visa.imageUrl,
            onTap: () => context.push('/visa/details', extra: visa.urlLink),
          );
        },
      ),
    );
  }

  Widget _buildUmrahList(BuildContext context, WidgetRef ref) {
    final umrahState = ref.watch(umrahListProvider);
    if (umrahState.isLoading) return _shimmerList();
    if (umrahState.error != null) {
      return Padding(
        padding: AppPadding.screenHLg,
        child: GestureDetector(
          onTap: () => ref.read(umrahListProvider.notifier).refresh(),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, color: AppColors.textHint, size: 24),
                  SizedBox(height: 4),
                  Text('Tap to retry', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (umrahState.packages.isEmpty) return const SizedBox.shrink();

    final displayPackages = umrahState.packages.take(6).toList();
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenHLg,
        itemCount: displayPackages.length,
        itemBuilder: (context, index) {
          final pkg = displayPackages[index];
          return _DestinationCard(
            city: pkg.packageTitle,
            tag: 'Umrah',
            price: pkg.formattedPrice,
            imageUrl: pkg.imageUrl,
            onTap: () => context.push('/umrah/details', extra: pkg.urlLink),
          );
        },
      ),
    );
  }

  Widget _buildPakTourList(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(pakTourListProvider);
    if (tourState.isLoading) return _shimmerList();
    if (tourState.tours.isEmpty) return const SizedBox.shrink();

    final displayTours = tourState.tours.take(6).toList();
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenHLg,
        itemCount: displayTours.length,
        itemBuilder: (context, index) {
          final tour = displayTours[index];
          return _DestinationCard(
            city: tour.packageTitle,
            tag: tour.durationText.isNotEmpty ? tour.durationText : 'Pak Tour',
            price: tour.formattedPrice,
            imageUrl: tour.imageUrl,
            onTap: () => context.push('/pak-tour/details', extra: tour.urlLink),
          );
        },
      ),
    );
  }

  Widget _shimmerList() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.screenHLg,
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          width: 160, margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  WHY CHOOSE US
  // ═══════════════════════════════════════════
  Widget _buildWhyChooseUs() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A1B4B), Color(0xFF2D31FA)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Text('Why Book With Us?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        ]),
        const SizedBox(height: 18),
        _featureRow(Icons.local_offer_outlined, 'Best Price Guarantee', 'We match any lower price', const Color(0xFFF5A623)),
        _featureRow(Icons.support_agent_outlined, '24/7 Support', 'Round the clock assistance', AppColors.accent),
        _featureRow(Icons.lock_outline_rounded, 'Secure Payments', '100% secure transactions', AppColors.success),
        _featureRow(Icons.star_outline_rounded, 'Trusted by Thousands', '10+ years of excellence', const Color(0xFFD4AF37), isLast: true),
      ]),
    );
  }

  Widget _featureRow(IconData icon, String title, String sub, Color color, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(sub, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
        Icon(Icons.check_circle_rounded, color: color, size: 18),
      ]),
    );
  }

  // ═══════════════════════════════════════════
  //  NEED ASSISTANCE
  // ═══════════════════════════════════════════
  Widget _buildNeedAssistance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        // Header
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A1B4B), Color(0xFF2D31FA)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Need Assistance?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
            const SizedBox(height: 2),
            Text('We\'re here to help you 24/7', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
        ]),
        const SizedBox(height: 16),

        // Contact buttons
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => _launchUrl('tel:+923111786785'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.phone_rounded, color: Colors.white, size: 17),
                SizedBox(width: 8),
                Text('Call Us', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          )),
          const SizedBox(width: 10),
          Expanded(child: GestureDetector(
            onTap: () => _launchUrl('https://wa.me/923111786785'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgPicture.asset('assets/icons/whatsapp.svg', width: 17, height: 17),
                const SizedBox(width: 8),
                const Text('WhatsApp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          )),
        ]),
        const SizedBox(height: 14),

        // Divider
        Container(height: 1, color: AppColors.divider),
        const SizedBox(height: 12),

        // Social
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Follow us', style: TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          _socialSvgIcon('assets/icons/facebook.svg', () => _launchUrl('https://facebook.com/rehmantravel')),
          const SizedBox(width: 8),
          _socialSvgIcon('assets/icons/instagram.svg', () => _launchUrl('https://instagram.com/rehmantravel')),
          const SizedBox(width: 8),
          _socialSvgIcon('assets/icons/x_twitter.svg', () => _launchUrl('https://twitter.com/rehmantravel')),
          const SizedBox(width: 8),
          _socialSvgIcon('assets/icons/youtube.svg', () => _launchUrl('https://youtube.com/@rehmantravel')),
        ]),
      ]),
    );
  }

  Widget _socialSvgIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle),
        child: SvgPicture.asset(assetPath),
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

// ═══════════════════════════════════════════
//  DESTINATION CARD - Elegant rounded design
// ═══════════════════════════════════════════
class _DestinationCard extends StatelessWidget {
  final String city;
  final String tag;
  final String price;
  final String? imageUrl;
  final VoidCallback? onTap;

  const _DestinationCard({
    required this.city,
    required this.tag,
    required this.price,
    this.imageUrl,
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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            if (imageUrl != null)
              Image.network(imageUrl!, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                ))
            else
              Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),

            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.0), Colors.black.withValues(alpha: 0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const Spacer(),
                // City name
                Text(city, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                if (price.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Text(price, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1A1B4B))),
                  ),
                ],
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
