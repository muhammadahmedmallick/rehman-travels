import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../flights/presentation/widgets/flight_search_form.dart';
import '../../../visa/data/models/visa_models.dart';
import '../../../visa/presentation/providers/visa_provider.dart';
import '../../../visa/presentation/widgets/select_visa_sheet.dart';
import '../../../../app/widgets/app_bottom_sheet.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../flights/data/models/recent_search_item.dart';
import '../../../flights/presentation/providers/recent_searches_provider.dart';

/// Home-screen service switcher — the four icon buttons above the
/// search card let the user swap the card's content between flight
/// search, the visa picker, and (for now) "coming soon" placeholders
/// for Buses / Packages without leaving the home surface.
enum _HomeService { flights, buses, packages, visas, esim }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  _HomeService _selectedService = _HomeService.flights;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
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
              if (_selectedService == _HomeService.flights) ...[
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

              const SizedBox(height: 24),
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
  static const List<_HomeService> _visibleServices = [
    _HomeService.flights,
    _HomeService.visas,
    _HomeService.esim,
  ];

  Widget _buildServiceTabs() {
    return Row(
      children: [
        for (final service in _visibleServices) ...[
          if (service != _visibleServices.first) const SizedBox(width: 10),
          Expanded(
            child: _ServiceTile(
              icon: _iconFor(service),
              label: _labelFor(service),
              selected: _selectedService == service,
              onTap: () {
                // eSIM is a navigational tile — it doesn't swap the
                // search card, it just pushes the eSIM screen and
                // leaves the previous selection (usually Flights)
                // intact so the tile strip keeps its active state.
                if (service == _HomeService.esim) {
                  context.push(AppRoutes.esim);
                  return;
                }
                if (_selectedService == service) return;
                setState(() => _selectedService = service);
                if (service == _HomeService.visas) {
                  _openVisaPicker();
                }
              },
            ),
          ),
        ],
      ],
    );
  }

  IconData _iconFor(_HomeService s) {
    switch (s) {
      case _HomeService.flights:
        return Icons.flight_takeoff_rounded;
      case _HomeService.buses:
        return Icons.directions_bus_rounded;
      case _HomeService.packages:
        return Icons.card_travel_rounded;
      case _HomeService.visas:
        return Icons.badge_outlined;
      case _HomeService.esim:
        return Icons.sim_card_rounded;
    }
  }

  String _labelFor(_HomeService s) {
    switch (s) {
      case _HomeService.flights:
        return 'Flights';
      case _HomeService.buses:
        return 'Buses';
      case _HomeService.packages:
        return 'Packages';
      case _HomeService.visas:
        return 'Visas';
      case _HomeService.esim:
        return 'eSIM';
    }
  }

  /// Renders the card body based on the selected service tile.
  /// Flights → flight search form (unchanged); Visas → a "Where are
  /// you going?" picker that opens the same sheet the Visas tab uses;
  /// Buses / Packages → a friendly "coming soon" placeholder.
  Widget _buildServiceCard(BuildContext context, WidgetRef ref) {
    switch (_selectedService) {
      case _HomeService.flights:
        return const FlightSearchForm();
      case _HomeService.visas:
        return _VisaPickerCard(onTap: _openVisaPicker);
      case _HomeService.buses:
        return const _ComingSoonCard(
          icon: Icons.directions_bus_rounded,
          title: 'Bus bookings coming soon',
          subtitle:
              'We\'re adding intercity bus routes. Stay tuned — this will land shortly.',
        );
      case _HomeService.esim:
        // eSIM tile opens the dedicated screen directly rather than
        // swapping the card body, so this branch is never actually
        // rendered — kept only to keep the switch exhaustive.
        return const SizedBox.shrink();
      case _HomeService.packages:
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
    final picked = await showAppBottomSheet<VisaType>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SelectVisaSheet(),
    );
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
                                      Color(0xFFFFD976),
                                      Color(0xFFF5A623),
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
                                        color: Color(0xFF1A1B4B),
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12,
                                      color: Color(0xFF1A1B4B),
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
              if (all.length > 5)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${all.length} saved',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.3,
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
                  colors: [Color(0xFF1A1B4B), Color(0xFF2D31FA)],
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
                const Color(0xFFF5A623),
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
  /// "Need Assistance" — a warm dark-gradient card that feels like
  /// a concierge greeting. Side illustration (a circular mosaic of
  /// support icons) gives it travel warmth; CTAs are oversized and
  /// color-coded so Call / WhatsApp are one-tap obvious. Socials
  /// move below the card as a muted footer row so they don't
  /// compete with the primary support action.
  Widget _buildNeedAssistance() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0F1035),
                Color(0xFF1A1B4B),
                Color(0xFF252670),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          Icons.headset_mic_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      // Tiny online pulse dot — suggests live support.
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1A1B4B),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'We\'re here, around the clock',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Speak to a real travel expert',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _assistanceCta(
                      label: 'Call',
                      icon: Icons.phone_rounded,
                      bg: Colors.white,
                      fg: AppColors.primary,
                      onTap: () => _launchUrl('tel:+923111786785'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _assistanceCta(
                      label: 'WhatsApp',
                      svgAsset: 'assets/icons/whatsapp.svg',
                      bg: const Color(0xFF25D366),
                      fg: Colors.white,
                      onTap: () =>
                          _launchUrl('https://wa.me/923111786785'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Social strip — quiet, below the card, doesn't compete
        // with the support CTAs above.
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Follow the journey',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 14),
            _socialSvgIcon('assets/icons/facebook.svg',
                () => _launchUrl('https://facebook.com/rehmantravel')),
            const SizedBox(width: 8),
            _socialSvgIcon('assets/icons/instagram.svg',
                () => _launchUrl('https://instagram.com/rehmantravel')),
            const SizedBox(width: 8),
            _socialSvgIcon('assets/icons/x_twitter.svg',
                () => _launchUrl('https://twitter.com/rehmantravel')),
            const SizedBox(width: 8),
            _socialSvgIcon('assets/icons/youtube.svg',
                () => _launchUrl('https://youtube.com/@rehmantravel')),
          ],
        ),
      ],
    );
  }

  Widget _assistanceCta({
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
    IconData? icon,
    String? svgAsset,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, color: fg, size: 17)
              else if (svgAsset != null)
                SvgPicture.asset(svgAsset, width: 17, height: 17),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
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

  Widget _socialSvgIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.8),
          ),
        ),
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
