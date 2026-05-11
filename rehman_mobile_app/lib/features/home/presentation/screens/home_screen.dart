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
import '../../../visa/presentation/widgets/select_visa_sheet.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../flights/data/models/recent_search_item.dart';
import '../../../flights/presentation/providers/recent_searches_provider.dart';
import '../providers/home_service_provider.dart';

/// Home-screen service switcher — `HomeService` enum and the
/// `homeServiceProvider` live in `home_service_provider.dart` so the
/// selected tab survives app restarts (persisted via SharedPreferences).

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final selectedService = ref.watch(homeServiceProvider);
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

              // Search card overlaps the hero by 36px so the form
              // feels anchored to the gradient rather than floating
              // below it. Subsequent sections use plain SizedBox
              // gaps (no more Transform.translate chains) so the
              // vertical rhythm is predictable whether or not the
              // recent-searches carousel is visible.
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
                    child: _buildServiceCard(context, ref),
                  ),
                ),
              ),

              // The -36 overlap above eats half the natural gap, so
              // we only need a small top-up before the first section.
              const SizedBox(height: 4),

              // Continue where you left off — flights-only.
              if (selectedService == HomeService.flights) ...[
                _buildRecentSearches(context, ref),
                const SizedBox(height: 8),
              ],

              // eSIM promo — cross-service, always shown.
              Padding(
                padding: AppPadding.screenH,
                child: _buildEsimBanner(context),
              ),
              const SizedBox(height: 32),

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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: 100,
                      child: Image.asset('assets/icons/logo_text.png', fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const CurrencySelector(),
                ],
              ),

              const SizedBox(height: 4),
              _buildServiceTabs(),
            ],
          ),
        ),
      ),
    );
  }

  /// Service tiles above the search card. Buses and Packages are
  /// hidden for now (backend/content isn't live), so the strip shows
  /// only Flights and Visas. Re-add those enum values to
  /// [_visibleServices] when those flows ship.
  static const List<HomeService> _visibleServices = [
    HomeService.flights,
    HomeService.visas,
    HomeService.esim,
  ];

  Widget _buildServiceTabs() {
    final selectedService = ref.watch(homeServiceProvider);
    return Row(
      children: [
        for (final service in _visibleServices) ...[
          if (service != _visibleServices.first) const SizedBox(width: 10),
          Expanded(
            child: _ServiceTile(
              icon: _iconFor(service),
              label: _labelFor(service),
              selected: selectedService == service,
              onTap: () {
                // eSIM is a navigational tile — it doesn't swap the
                // search card, it just pushes the eSIM screen and
                // leaves the previous selection (usually Flights)
                // intact so the tile strip keeps its active state.
                if (service == HomeService.esim) {
                  context.push(AppRoutes.esim);
                  return;
                }
                if (selectedService == service) return;
                ref.read(homeServiceProvider.notifier).select(service);
                if (service == HomeService.visas) {
                  _openVisaPicker();
                }
              },
            ),
          ),
        ],
      ],
    );
  }

  IconData _iconFor(HomeService s) {
    switch (s) {
      case HomeService.flights:
        return Icons.flight_takeoff_rounded;
      case HomeService.buses:
        return Icons.directions_bus_rounded;
      case HomeService.packages:
        return Icons.card_travel_rounded;
      case HomeService.visas:
        return Icons.badge_outlined;
      case HomeService.esim:
        return Icons.sim_card_rounded;
    }
  }

  String _labelFor(HomeService s) {
    switch (s) {
      case HomeService.flights:
        return 'Flights';
      case HomeService.buses:
        return 'Buses';
      case HomeService.packages:
        return 'Packages';
      case HomeService.visas:
        return 'Visas';
      case HomeService.esim:
        return 'eSIM';
    }
  }

  /// Renders the card body based on the selected service tile.
  /// Flights → flight search form (unchanged); Visas → a "Where are
  /// you going?" picker that opens the same sheet the Visas tab uses;
  /// Buses / Packages → a friendly "coming soon" placeholder.
  Widget _buildServiceCard(BuildContext context, WidgetRef ref) {
    switch (ref.watch(homeServiceProvider)) {
      case HomeService.flights:
        return const FlightSearchForm();
      case HomeService.visas:
        return _VisaPickerCard(onTap: _openVisaPicker);
      case HomeService.buses:
        return const _ComingSoonCard(
          icon: Icons.directions_bus_rounded,
          title: 'Bus bookings coming soon',
          subtitle:
              'We\'re adding intercity bus routes. Stay tuned — this will land shortly.',
        );
      case HomeService.esim:
        // eSIM tile opens the dedicated screen directly rather than
        // swapping the card body, so this branch is never actually
        // rendered — kept only to keep the switch exhaustive.
        return const SizedBox.shrink();
      case HomeService.packages:
        return const _ComingSoonCard(
          icon: Icons.card_travel_rounded,
          title: 'Holiday packages coming soon',
          subtitle:
              'Curated tour packages are on the way. Meanwhile, explore our Umrah and Pakistan tours below.',
        );
    }
  }

  Future<void> _openVisaPicker() async {
    // Warm the visa cache so the sheet opens populated.
    final visaState = ref.read(visaTypesProvider);
    if (visaState.types.isEmpty && !visaState.isLoading) {
      ref.read(visaTypesProvider.notifier).refresh();
    }
    final picked = await SelectVisaSheet.show(context);
    if (picked == null || !mounted) return;
    context.push(AppRoutes.visaDetails, extra: picked);
  }

  /// eSIM promo — editorial travel-magazine card. A warm cream-to-
  /// ivory base frames a large editorial "10%" numeral, a delicate
  /// airplane-on-dashed-path motif, and a gold "Claim offer" pill.
  /// Kept visually quiet so it breaks up the darker surfaces above
  /// (hero, recent-trip carousel) without competing for attention.
  Widget _buildEsimBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(AppRoutes.esim),
        child: Container(
          height: 132,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFFBF2), // cream
                Color(0xFFF7F5FF), // faint lavender
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Gold corner glow — evokes a stamp / collectible feel.
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Airplane + dashed arc motif on the right half.
              Positioned.fill(
                child: CustomPaint(
                  painter: _FlightPathPainter(
                    dashColor:
                        AppColors.primary.withValues(alpha: 0.22),
                    planeColor: AppColors.primary,
                  ),
                ),
              ),
              // Content.
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 16, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hairline eyebrow label.
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 1.2,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'LIMITED OFFER',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondary,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ],
                          ),
                          // Editorial headline — big numeric anchor.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '10%',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  height: 0.95,
                                  letterSpacing: -1.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      height: 1.2,
                                      letterSpacing: -0.1,
                                    ),
                                    children: [
                                      TextSpan(text: 'off your\n'),
                                      TextSpan(
                                        text: 'first eSIM',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Footer row — small meta + gold CTA pill.
                          Row(
                            children: [
                              Icon(
                                Icons.public_rounded,
                                size: 11,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '200+ countries',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE0C896),
                                      Color(0xFFC9A96E),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Claim offer',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1E293B),
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Right-hand spacer so the dashed flight path +
                    // plane icon on the painter have room to breathe.
                    const SizedBox(width: 88),
                  ],
                ),
              ),
            ],
          ),
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
    final top = all.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — kept slim so the real estate goes to the
        // trip cards below.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Continue where you left off',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Horizontal card strip — each card is an at-a-glance trip
        // with a colored countdown badge, prominent route, dates,
        // pax chip, and a clear "Resume" CTA. The carousel pattern
        // gives each tile breathing room (vs. a dense stacked list)
        // and makes 3+ entries feel browsable, not overwhelming.
        SizedBox(
          height: 158,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: top.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) =>
                _buildRecentSearchTile(context, ref, top[i]),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }

  Widget _buildRecentSearchTile(
      BuildContext context, WidgetRef ref, RecentSearchItem item) {
    final isMulti =
        item.tripType == 'multi' && (item.legs?.isNotEmpty ?? false);
    final paxTotal = item.adults + item.children + item.infants;

    final title = isMulti
        ? _multiCityHeadline(item)
        : '${item.departureName.isNotEmpty ? item.departureName : item.departureCode} → ${item.arrivalName.isNotEmpty ? item.arrivalName : item.arrivalCode}';

    // Days until departure — drives the colored countdown badge
    // (urgent / soon / relaxed) so active trips pop visually.
    final departureDate = isMulti
        ? _tryParseRecentDate(item.legs!.first.date)
        : _tryParseRecentDate(item.outboundDate);
    final daysUntil = departureDate?.difference(DateTime.now()).inDays;

    final dateText = isMulti
        ? '${item.legs!.length} flights · ${_formatRecentDate(item.legs!.first.date)}'
        : '${_formatRecentDate(item.outboundDate)}${item.inboundDate != null ? ' – ${_formatRecentDate(item.inboundDate!)}' : ''}';

    // Countdown palette — warm red for imminent (<=3 days), golden for
    // within two weeks, cool navy for future trips.
    final (badgeColor, badgeText) = _countdownBadge(daysUntil);

    // Split the title into origin / destination for the two-line big
    // route display — falls back to a single-line title for multi-city.
    String? originLine;
    String? destLine;
    if (!isMulti) {
      originLine = item.departureName.isNotEmpty
          ? item.departureName
          : item.departureCode;
      destLine = item.arrivalName.isNotEmpty
          ? item.arrivalName
          : item.arrivalCode;
    }

    return SizedBox(
      width: 286,
      child: Stack(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                context.push(
                    AppRoutes.flightResults, extra: item.toSearchParams());
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      AppColors.surfaceLight.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row — countdown badge. Delete button is
                    // layered as a Positioned in the Stack below so
                    // it sits precisely in the corner without
                    // distorting the badge row spacing.
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: badgeColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                badgeText,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: badgeColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Reserve space on the right for the
                        // Positioned delete button.
                        const SizedBox(width: 36),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Route — two-line for one-way/return, single
                    // line for multi-city.
                    if (isMulti)
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              originLine ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: AppColors.accent
                                    .withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                item.inboundDate != null
                                    ? Icons.sync_alt_rounded
                                    : Icons.flight_takeoff_rounded,
                                size: 14,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              destLine ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    // Thin dashed separator — airline-ticket style.
                    _DashedLine(
                      color: AppColors.border,
                    ),
                    const SizedBox(height: 10),
                    // Date + pax row.
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            dateText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.border
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_rounded,
                                  size: 11,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 3),
                              Text(
                                '$paxTotal',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Delete affordance — tiny circular icon button pinned to
          // the top-right corner. Kept visually quiet so it doesn't
          // compete with the primary tap target (the card itself).
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _confirmDeleteRecent(context, ref, item),
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.7),
                    ),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns (color, label) for the countdown badge. The zone
  /// boundaries (3d / 14d) intentionally mirror the user's mental
  /// model — "this week" urgent, "this fortnight" soon, "later" chill.
  (Color, String) _countdownBadge(int? days) {
    if (days == null) return (AppColors.textSecondary, 'Saved');
    if (days < 0) return (AppColors.textHint, 'Past');
    if (days == 0) return (AppColors.error, 'Today');
    if (days == 1) return (AppColors.error, 'Tomorrow');
    if (days <= 3) return (AppColors.error, 'In ${days}d');
    if (days <= 14) return (AppColors.secondary, 'In ${days}d');
    return (AppColors.primary, 'In ${days}d');
  }

  /// Parses a stored dd-MM-yyyy date without throwing. Returns null
  /// on any parse failure so the calling countdown logic falls back
  /// to the "Saved" badge instead of crashing.
  DateTime? _tryParseRecentDate(String ddMMyyyy) {
    try {
      final parts = ddMMyyyy.split('-');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  /// Builds a "City A → City B → City C" headline from a multi-city
  /// item's legs, collapsing consecutive duplicates so back-to-back
  /// legs don't repeat the same city twice.
  String _multiCityHeadline(RecentSearchItem item) {
    final legs = item.legs ?? const [];
    if (legs.isEmpty) return '';
    String pickName(String name, String code) =>
        name.isNotEmpty ? name : code;
    final chain = <String>[pickName(legs.first.fromName, legs.first.fromCode)];
    for (final leg in legs) {
      final to = pickName(leg.toName, leg.toCode);
      if (chain.last != to) chain.add(to);
    }
    return chain.join(' → ');
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
  //  WHY CHOOSE US
  // ═══════════════════════════════════════════
  /// "Why Book With Us" — the section header lives outside the card
  /// so it reads as a proper home surface row (mirroring how top
  /// travel apps frame their trust pillars). The four USPs render as
  /// a 2×2 grid of small feature cards instead of a vertical list, so
  /// the block feels airy and scannable instead of text-heavy.
  Widget _buildWhyChooseUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFFD4A574)],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.verified_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              'Why Book With Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            'Four reasons travellers trust us',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 2×2 grid — each cell tiles an icon + title + one-liner.
        Row(
          children: [
            Expanded(
              child: _featureCell(
                Icons.local_offer_rounded,
                'Best Price',
                'We match any lower fare',
                const Color(0xFFC9A96E),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _featureCell(
                Icons.support_agent_rounded,
                '24/7 Support',
                'Real humans, any hour',
                AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _featureCell(
                Icons.shield_rounded,
                'Secure Payments',
                '100% safe transactions',
                AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _featureCell(
                Icons.auto_awesome_rounded,
                '10+ Years',
                'Thousands of happy trips',
                const Color(0xFFD4AF37),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _featureCell(
      IconData icon, String title, String sub, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.16),
                  accent.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  NEED ASSISTANCE
  // ═══════════════════════════════════════════
  /// "Need Assistance" — styled as a twin of the eSIM offer card so
  /// the bottom of home feels like a set of matched editorial tiles
  /// rather than two disjointed widgets. Same gradient base + border
  /// + shadow + corner glow recipe; an editorial "24/7" numeric
  /// replaces the "10%"; Call + WhatsApp pills sit where eSIM's
  /// "Claim offer" lives.
  Widget _buildNeedAssistance() {
    return Column(
      children: [
        Container(
          height: 132,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF2F9F4), // mint cream — nods to WhatsApp green
                Color(0xFFF4F5FF), // faint lavender — matches eSIM tile
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Green corner glow — reads as "online / available".
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF25D366).withValues(alpha: 0.20),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Chat-bubble + signal-rings motif on the right.
              Positioned.fill(
                child: CustomPaint(
                  painter: _SupportMotifPainter(
                    primaryColor: AppColors.primary,
                    accentColor: const Color(0xFF25D366),
                  ),
                ),
              ),
              // Content.
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 16, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hairline eyebrow label — green mirrors the
                          // gold used on the eSIM card.
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 1.2,
                                color: const Color(0xFF25D366),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'WE\'RE HERE, ALWAYS',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF25D366),
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ],
                          ),
                          // Editorial headline — big numeric anchor.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '24/7',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  height: 0.95,
                                  letterSpacing: -1.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      height: 1.2,
                                      letterSpacing: -0.1,
                                    ),
                                    children: [
                                      TextSpan(text: 'travel\n'),
                                      TextSpan(
                                        text: 'experts online',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Footer row — Call + WhatsApp pills replace
                          // the eSIM's single "Claim offer" pill.
                          Row(
                            children: [
                              _supportPill(
                                icon: Icons.phone_rounded,
                                label: 'Call',
                                bg: Colors.white,
                                borderColor: AppColors.border,
                                fg: AppColors.primary,
                                onTap: () =>
                                    _launchUrl('tel:+923111786785'),
                              ),
                              const SizedBox(width: 8),
                              _supportPill(
                                svgAsset: 'assets/icons/whatsapp.svg',
                                label: 'WhatsApp',
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF25D366),
                                    Color(0xFF128C7E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                fg: Colors.white,
                                onTap: () => _launchUrl(
                                    'https://wa.me/923111786785'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Right-hand spacer so the motif painter has room.
                    const SizedBox(width: 88),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Social strip — editorial "hairline rule + eyebrow label"
        // treatment so it reads as a deliberate footer, not an
        // afterthought. Icons sit on a row of their own below the
        // label, giving each enough breathing room.
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.border.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'FOLLOW THE JOURNEY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.textSecondary,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.border.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialSvgIcon('assets/icons/facebook.svg', 'Facebook',
                () => _launchUrl('https://www.facebook.com/rehmantravelofficial')),
            const SizedBox(width: 14),
            _socialSvgIcon('assets/icons/instagram.svg', 'Instagram',
                () => _launchUrl('https://instagram.com/rehmantravel')),
            const SizedBox(width: 14),
            _socialSvgIcon('assets/icons/x_twitter.svg', 'X',
                () => _launchUrl('https://twitter.com/rehmantravel')),
            const SizedBox(width: 14),
            _socialSvgIcon('assets/icons/youtube.svg', 'YouTube',
                () => _launchUrl('https://youtube.com/@rehmantravel')),
          ],
        ),
      ],
    );
  }

  /// Compact pill-shaped CTA used on the Need Assistance card. Mirrors
  /// the "Claim offer" pill on the eSIM tile so both cards feel like
  /// the same editorial template. Pass either a solid [bg] + optional
  /// [borderColor] (outline style — used for the Call pill), or a
  /// [gradient] (used for the primary WhatsApp pill).
  Widget _supportPill({
    required String label,
    required Color fg,
    required VoidCallback onTap,
    IconData? icon,
    String? svgAsset,
    Color? bg,
    Color? borderColor,
    Gradient? gradient,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: gradient == null ? (bg ?? Colors.white) : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 0.8)
                : null,
            boxShadow: gradient != null
                ? [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, color: fg, size: 12)
              else if (svgAsset != null)
                SvgPicture.asset(svgAsset, width: 12, height: 12),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: fg,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialSvgIcon(
      String assetPath, String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Tooltip(
          message: label,
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SvgPicture.asset(assetPath),
          ),
        ),
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



/// Single service tile in the hero tab strip. Selected state uses a
/// filled white tile with primary icon; unselected uses a translucent
/// dark tile with a white icon for contrast against the hero gradient.
class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon tile — kept square (58×58) and centered so the row
          // reads as four uniform chips instead of wide pills when
          // the hero column stretches on larger screens.
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [Colors.white, Color(0xFFF3F5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.18),
                width: selected ? 0 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.20),
                        blurRadius: 20,
                        spreadRadius: -2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Icon(
                icon,
                key: ValueKey('${label}_$selected'),
                size: selected ? 26 : 22,
                color: selected ? AppColors.primary : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              letterSpacing: selected ? 0.2 : 0,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.72),
            ),
            child: Text(label),
          ),
          const SizedBox(height: 5),
          // Short golden underline signals the active tile — subtle
          // enough to not compete with the filled icon above.
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            height: 3,
            width: selected ? 20 : 0,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card body shown when "Visas" is the selected service on home.
/// Mirrors the destination picker on the Visas tab — single tap
/// opens the same `SelectVisaSheet` so the flow is consistent.
class _VisaPickerCard extends StatelessWidget {
  final VoidCallback onTap;

  const _VisaPickerCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Speed up your visa process',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Trusted by 1M+ happy visa customers',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Where are you going?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'From Pakistan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textHint, size: 22),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Friendly placeholder used for service tiles that don't have a
/// full flow yet (Buses, Packages). Keeps the card height roughly
/// parallel to the flight-search form so tapping between tiles
/// doesn't jank the scroll position.
class _ComingSoonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ComingSoonCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Airline-ticket style dashed divider. Scales to whatever width is
/// given and auto-computes the dash count so the gaps stay even.
class _DashedLine extends StatelessWidget {
  final Color color;

  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        const double dashW = 4;
        const double gapW = 4;
        final int count = (c.maxWidth / (dashW + gapW)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count.clamp(2, 200),
            (_) => Container(width: dashW, height: 1, color: color),
          ),
        );
      },
    );
  }
}

/// Decorative flight path for the eSIM card — paints a small plane
/// icon on the right-hand side of the card followed by a dashed
/// curved arc that trails off to the bottom-left, plus a few ambient
/// dots around it (suggesting network nodes / destinations).
class _FlightPathPainter extends CustomPainter {
  final Color dashColor;
  final Color planeColor;

  _FlightPathPainter({required this.dashColor, required this.planeColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Anchor the motif to the right half of the card.
    final planeCenter = Offset(size.width - 44, size.height * 0.38);

    // Dashed arc from the plane trailing down-left — painted as a
    // series of small line segments along a quadratic bezier.
    final path = Path()
      ..moveTo(planeCenter.dx - 2, planeCenter.dy + 4)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.85,
        size.width * 0.42,
        size.height - 14,
      );

    final dashPaint = Paint()
      ..color = dashColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double dashLen = 3.5;
    const double gapLen = 3.5;
    final metrics = path.computeMetrics().toList();
    for (final m in metrics) {
      double distance = 0;
      while (distance < m.length) {
        final end = (distance + dashLen).clamp(0, m.length).toDouble();
        final seg = m.extractPath(distance, end);
        canvas.drawPath(seg, dashPaint);
        distance += dashLen + gapLen;
      }
    }

    // Origin / destination dots on either end of the arc.
    final dotPaint = Paint()..color = dashColor;
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height - 14),
      2.2,
      dotPaint,
    );

    // Ambient pinpoints — scattered along the trail for a map feel.
    final ambientPaint = Paint()
      ..color = planeColor.withValues(alpha: 0.18);
    canvas.drawCircle(
      Offset(size.width - 22, size.height * 0.78),
      1.6,
      ambientPaint,
    );
    canvas.drawCircle(
      Offset(size.width - 60, size.height * 0.22),
      1.4,
      ambientPaint,
    );

    // Plane glyph — drawn as a simple triangular chevron so we don't
    // depend on a font glyph or image. Angled slightly to feel like
    // it's departing along the arc.
    canvas.save();
    canvas.translate(planeCenter.dx, planeCenter.dy);
    canvas.rotate(-0.35);
    final planePaint = Paint()
      ..color = planeColor
      ..style = PaintingStyle.fill;
    final plane = Path()
      ..moveTo(-10, 0)
      ..lineTo(10, -2.5)
      ..lineTo(6, 0)
      ..lineTo(10, 2.5)
      ..close();
    canvas.drawPath(plane, planePaint);
    // Thin fuselage line for polish.
    canvas.drawLine(
      const Offset(-10, 0),
      const Offset(6, 0),
      Paint()
        ..color = planeColor
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FlightPathPainter old) =>
      old.dashColor != dashColor || old.planeColor != planeColor;
}

/// Decorative motif for the Need Assistance card — mirrors the eSIM
/// card's `_FlightPathPainter` as a visual twin. Anchored to the
/// right half: three concentric signal rings emanate from a small
/// chat bubble (with three typing dots inside), plus a couple of
/// ambient pinpoints so the composition doesn't feel sparse.
class _SupportMotifPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  _SupportMotifPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 46, size.height * 0.42);

    // Concentric signal rings — suggests "reaching out / broadcast".
    final ringPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.32)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        (10.0 * i).toDouble(),
        ringPaint..color = accentColor.withValues(alpha: 0.34 - i * 0.08),
      );
    }

    // Chat bubble — rounded rect with a small tail.
    final bubblePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 26, height: 18),
      const Radius.circular(7),
    );
    canvas.drawRRect(bubbleRect, bubblePaint);
    // Tail
    final tail = Path()
      ..moveTo(center.dx - 6, center.dy + 9)
      ..lineTo(center.dx - 10, center.dy + 13)
      ..lineTo(center.dx - 3, center.dy + 9)
      ..close();
    canvas.drawPath(tail, bubblePaint);

    // Three typing dots inside the bubble.
    final dotPaint = Paint()..color = Colors.white;
    for (int i = -1; i <= 1; i++) {
      canvas.drawCircle(
        Offset(center.dx + i * 6, center.dy),
        1.6,
        dotPaint,
      );
    }

    // Ambient pinpoints — same visual vocabulary as the eSIM card.
    final ambientPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.22);
    canvas.drawCircle(
      Offset(size.width - 22, size.height * 0.78),
      1.6,
      ambientPaint,
    );
    canvas.drawCircle(
      Offset(size.width - 70, size.height * 0.22),
      1.4,
      ambientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SupportMotifPainter old) =>
      old.primaryColor != primaryColor || old.accentColor != accentColor;
}
