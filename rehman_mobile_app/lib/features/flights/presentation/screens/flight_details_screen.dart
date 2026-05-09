import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/app_lifecycle_refresh_mixin.dart';
import '../../../../core/utils/time_format.dart';
import '../widgets/flight_gone_dialog.dart';
import '../widgets/flight_leg_card.dart';
import '../widgets/refresh_countdown_pill.dart';
import '../widgets/price_breakdown_card.dart';
import '../widgets/booking_journey_header.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../data/utils/fare_calculation.dart';
import '../providers/booking_session_provider.dart';
import '../providers/flight_search_provider.dart';

class FlightDetailsScreen extends ConsumerStatefulWidget {
  final String flightId;
  final Map<String, dynamic>? flightData;

  const FlightDetailsScreen({
    super.key,
    required this.flightId,
    this.flightData,
  });

  @override
  ConsumerState<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends ConsumerState<FlightDetailsScreen>
    with AppLifecycleRefreshMixin<FlightDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  late Map<String, dynamic> _liveFlight;

  @override
  void initState() {
    super.initState();
    _liveFlight = widget.flightData ?? {};
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Future<void> onLifecycleRefresh() async {
    final searchParams = ref.read(flightSearchProvider).searchParams;
    if (searchParams == null) return;
    await ref.read(flightSearchProvider.notifier).searchFlights(searchParams);
    if (!mounted) return;
    final newFlights = ref.read(flightSearchProvider).flights;
    // IDs regenerate on every search; fall back to a composite key
    // so we don't false-positive "flight gone" for flights that are
    // still in the results.
    final match = _findMatchingFlight(newFlights, _liveFlight, widget.flightId);
    if (match == null) {
      await showFlightGoneDialog(context);
      return;
    }
    setState(() => _liveFlight = match);
  }

  Map<String, dynamic>? _findMatchingFlight(
    List<dynamic> flights,
    Map<String, dynamic> target,
    String targetId,
  ) {
    for (final f in flights) {
      if (f is Map && f['id'] == targetId) return Map<String, dynamic>.from(f);
    }
    final airline = (target['airlineCode'] ?? '').toString();
    final flightNo = (target['flightNumber'] ?? '').toString();
    final depTime = (target['departureTime'] ?? '').toString();
    final arrTime = (target['arrivalTime'] ?? '').toString();
    if (airline.isEmpty || flightNo.isEmpty) return null;
    for (final f in flights) {
      if (f is! Map) continue;
      if ((f['airlineCode'] ?? '').toString() == airline &&
          (f['flightNumber'] ?? '').toString() == flightNo &&
          (f['departureTime'] ?? '').toString() == depTime &&
          (f['arrivalTime'] ?? '').toString() == arrTime) {
        return Map<String, dynamic>.from(f);
      }
    }
    return null;
  }

  /// Keep the fare fresh while the user is still browsing this flight —
  /// same cadence as the results screen since the booking hasn't been
  /// created yet.
  @override
  Duration? get periodicRefreshInterval => kFlightFareRefreshInterval;

  void _onScroll() {
    final isCollapsed = _scrollController.offset > 140;
    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  /// Shared fare breakdown — all price math lives in
  /// `fare_calculation.dart` so every screen reconciles against the
  /// same headline total. Pass explicit pax counts from the search
  /// params, otherwise extra adults/children end up inflating the tax
  /// line because the default falls back to 1 pax.
  Map<String, dynamic> _getPriceBreakdown(Map<String, dynamic> flight) {
    final params = ref.read(flightSearchProvider).searchParams ?? const {};
    int? asInt(dynamic v) =>
        v is int ? v : (v is String ? int.tryParse(v) : null);
    // Form writes `adultsCount` / `childrenCount` / `infantsCount`, not
    // the shorter keys — use both so either shape works.
    return computeFareBreakdown(
      flight: flight,
      adults: asInt(params['adultsCount']) ?? asInt(params['adults']),
      children: asInt(params['childrenCount']) ?? asInt(params['children']),
      infants: asInt(params['infantsCount']) ?? asInt(params['infants']),
    ).toMap();
  }

  @override
  Widget build(BuildContext context) {
    final flight = _liveFlight;
    final airlineName = flight['airlineName'] ?? '';
    final selectedCurrency = ref.watch(currencyProvider).selected;
    final priceBreakdown = _getPriceBreakdown(flight);
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final isRoundTrip = returnLeg != null;
    final allLegs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final searchParams = ref.read(flightSearchProvider).searchParams;
    final tripType = (searchParams?['tripType'] ?? '').toString();
    final headerTitle = tripType == 'round-trip'
        ? 'Round Trip'
        : tripType == 'multi'
            ? 'Multi-City'
            : 'One Way';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Same header used on the search results screen so both
          // surfaces share one visual identity — title (trip type),
          // route, meta. Stepper hidden until checkout starts.
          BookingJourneyHeader(
            title: headerTitle,
            params: searchParams,
            showStepper: false,
          ),

          // Content — leg cards + fare rules + price
          SliverToBoxAdapter(
            child: Column(children: [
              // Countdown pill — tells the user when rates will refresh
              // so they understand the booking window.
              RefreshCountdownPill(
                nextRefreshIn: nextRefreshIn,
                isPaused: () => isRefreshPaused,
                isRefreshing: () => isRefreshing,
              ),
              // Outbound leg — shared collapsible card
              FlightLegCard(
                leg: {
                  ...flight,
                  'segments': allLegs.isNotEmpty
                      ? (allLegs[0]['segments'] as List?) ?? const []
                      : const [],
                },
                label: isRoundTrip ? 'Outbound' : 'Flight',
                dateString: _prettyDate(
                    (ref.read(flightSearchProvider).searchParams?['outboundDate'] ?? '').toString()),
                defaultExpanded: !isRoundTrip,
              ),

              // Return leg
              if (isRoundTrip && returnLeg != null)
                FlightLegCard(
                  leg: {
                    ...returnLeg,
                    // Inherit cabin/baggage/refundable from the parent flight
                    // when the returnLeg payload doesn't carry them.
                    'cabin': returnLeg['cabin'] ?? flight['cabin'],
                    'baggage': returnLeg['baggage'] ?? flight['baggage'],
                    'isRefundable':
                        returnLeg['isRefundable'] ?? flight['isRefundable'],
                    'segments': allLegs.length > 1
                        ? (allLegs[1]['segments'] as List?) ?? const []
                        : const [],
                  },
                  label: 'Return',
                  dateString: _prettyDate(
                      (ref.read(flightSearchProvider).searchParams?['inboundDate'] ?? '').toString()),
                ),

              // Fare Rules - inline card with auto-load
              _FareRulesCard(flight: flight),

              // Reusable Price Breakdown card — same widget used on
              // booking + payment screens.
              PriceBreakdownCard(
                breakdown: priceBreakdown,
                currency: selectedCurrency,
                airlineName: airlineName,
              ),

              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: AppTextStyles.bodyMd.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatCurrencyPrice((priceBreakdown['total'] as num).toDouble(), selectedCurrency),
                      style: AppTextStyles.priceLg.copyWith(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              AppGap.hLg,
              Expanded(
                child: Builder(
                  builder: (context) {
                    final searchState = ref.watch(flightSearchProvider);
                    final isLegSelection = searchState.isMultiCityLegFlow;
                    return ElevatedButton(
                      onPressed: isRefreshing
                          ? null
                          : () async {
                              if (isLegSelection) {
                                final before =
                                    ref.read(flightSearchProvider);
                                final wasRePick = before.currentLegIndex <
                                    before.selectedLegFlights.length;
                                await ref
                                    .read(flightSearchProvider.notifier)
                                    .selectLegFlight(_liveFlight);
                                if (!context.mounted) return;
                                if (wasRePick) {
                                  context.pop();
                                  context.pop();
                                } else {
                                  context.pop();
                                }
                                return;
                              }
                              // Start (or refresh) the booking session
                              // so the downstream screens read fare /
                              // pax from the same source.
                              final notifier = ref.read(
                                  bookingSessionProvider.notifier);
                              if (ref.read(bookingSessionProvider) ==
                                  null) {
                                notifier.start(
                                  flight: _liveFlight,
                                  searchParams: ref
                                          .read(flightSearchProvider)
                                          .searchParams ??
                                      {},
                                );
                              } else {
                                notifier.refreshFlight(_liveFlight);
                              }
                              // Push the latest live flight data so
                              // booking screen gets any refreshed
                              // fare/segment info.
                              context.push(AppRoutes.booking,
                                  extra: _liveFlight);
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      child: Text(isRefreshing
                          ? 'Refreshing...'
                          : (isLegSelection ? 'Select Flight' : 'Book Now')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flightInfoCard({
    required String label, required String depCode, required String arrCode,
    required String depTime, required String arrTime, required String duration,
    required dynamic stops, required String baggage, required String cabin,
    required String provider, required bool isReturn,
  }) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        const SizedBox(height: 12),
        // Route visual
        Row(children: [
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(depTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ])),
          Expanded(flex: 3, child: Column(children: [
            Text(duration, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 4),
            Row(children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5))),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Transform.rotate(
                angle: isReturn ? -1.5708 : 1.5708,
                child: Icon(Icons.flight, size: 14, color: AppColors.primary),
              ),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
            ]),
            const SizedBox(height: 3),
            Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: stopsInt == 0 ? AppColors.success : AppColors.textSecondary)),
          ])),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(arrTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ])),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        _infoRow(Icons.airline_seat_recline_normal, 'Class', cabin),
        _infoRow(Icons.luggage_outlined, 'Baggage', baggage),
        _infoRow(Icons.business, 'Provider', provider),
      ]),
    );
  }

  Widget _buildSegmentsCard({required String label, required List<Map<String, dynamic>> allLegs, required int legIndex}) {
    if (legIndex >= allLegs.length) return const SizedBox.shrink();
    final leg = allLegs[legIndex];
    final segments = (leg['segments'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // Only show if there are 2+ segments (i.e. there's a stopover)
    if (segments.length < 2) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.route_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text('${segments.length - 1} Stop${segments.length > 2 ? 's' : ''}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.warning)),
          ),
        ]),
        const SizedBox(height: 14),
        for (int i = 0; i < segments.length; i++) ...[
          _buildSegmentRow(segments[i]),
          if (i < segments.length - 1)
            _buildLayoverIndicator(segments[i], segments[i + 1]),
        ],
      ]),
    );
  }

  Widget _buildSegmentRow(Map<String, dynamic> seg) {
    final depCode = seg['departureCode'] ?? '';
    final arrCode = seg['arrivalCode'] ?? '';
    final depCity = seg['departureCity'] ?? '';
    final arrCity = seg['arrivalCity'] ?? '';
    final depTime = seg['departureTime'] ?? '--:--';
    final arrTime = seg['arrivalTime'] ?? '--:--';
    final duration = seg['duration'] ?? '';
    final flightNum = seg['flightNumber'] ?? '';
    final airlineCode = seg['airlineCode'] ?? '';
    final aircraft = seg['aircraft'] ?? '';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        // Airline + flight number
        Row(children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border, width: 0.5)),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://www.rehmantravel.com/logos/${airlineCode.toUpperCase()}.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Center(child: Text(airlineCode, style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: AppColors.primary))),
            ),
          ),
          const SizedBox(width: 6),
          Text(flightNum, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          if (aircraft.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text('· $aircraft', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ]),
        const SizedBox(height: 8),
        // Route
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            if (depCity.isNotEmpty) Text(depCity, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(depTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ])),
          Expanded(child: Column(children: [
            if (duration.isNotEmpty) Text(duration, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 3),
            Row(children: [
              Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1))),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Icon(Icons.flight, size: 12, color: AppColors.primary),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
            ]),
          ])),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            if (arrCity.isNotEmpty) Text(arrCity, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(arrTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ])),
        ]),
      ]),
    );
  }

  Widget _buildLayoverIndicator(Map<String, dynamic> arrSeg, Map<String, dynamic> depSeg) {
    final layoverCity = arrSeg['arrivalCity'] ?? arrSeg['arrivalCode'] ?? '';
    final layoverCode = arrSeg['arrivalCode'] ?? '';

    // Calculate layover time from arrival → next departure
    String layoverTime = '';
    final arrTime = arrSeg['arrivalTime']?.toString() ?? '';
    final depTime = depSeg['departureTime']?.toString() ?? '';
    if (arrTime.contains(':') && depTime.contains(':')) {
      try {
        final arrParts = arrTime.split(':');
        final depParts = depTime.split(':');
        final arrMin = int.parse(arrParts[0]) * 60 + int.parse(arrParts[1]);
        var depMin = int.parse(depParts[0]) * 60 + int.parse(depParts[1]);
        if (depMin < arrMin) depMin += 24 * 60; // next day
        final diff = depMin - arrMin;
        if (diff > 0) {
          final h = diff ~/ 60;
          final m = diff % 60;
          layoverTime = h > 0 ? '${h}h ${m}m' : '${m}m';
        }
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.access_time, size: 14, color: AppColors.warning),
        ),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Layover in $layoverCity${layoverCode.isNotEmpty && layoverCode != layoverCity ? ' ($layoverCode)' : ''}',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning),
          ),
          if (layoverTime.isNotEmpty)
            Text('Waiting time: $layoverTime', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }

  Widget _headerRoute(String depCode, String arrCode, String depTime, String arrTime, String duration, dynamic stops, {bool isReturn = false, String depCity = '', String arrCity = ''}) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(depCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        if (depCity.isNotEmpty)
          SizedBox(width: 100, child: Text(depCity, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
        Text(depTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
      Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Text(duration, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Row(children: [
            Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5))),
            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.4))),
            Transform.rotate(angle: isReturn ? -1.5708 : 1.5708, child: const Icon(Icons.flight, size: 14, color: Colors.white)),
            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.4))),
            Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
          ]),
          const SizedBox(height: 3),
          Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
        ]),
      )),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(arrCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        if (arrCity.isNotEmpty)
          SizedBox(width: 100, child: Text(arrCity, textAlign: TextAlign.right, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
        Text(arrTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
    ]);
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.primary)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ]),
    );
  }

  // ── Price breakdown card (editorial style) ──────────────────────────────
  // Header: gradient-tinted icon + title + subtitle (matches home
  // "Why choose us" / "Need assistance" header pattern).
  // Per-pax rows, dashed divider, sub-total row, dashed divider, Total
  // in large golden weight. This reuses the home design vocabulary.
  Widget _buildPriceBreakdownCard(
      Map<String, dynamic> breakdown, Currency? currency) {
    final adults = breakdown['adults'] as int;
    final children = breakdown['children'] as int;
    final infants = breakdown['infants'] as int;
    final adultFare = (breakdown['adultFare'] as num).toDouble();
    final childFare = (breakdown['childFare'] as num).toDouble();
    final infantFare = (breakdown['infantFare'] as num).toDouble();
    final subtotal = (breakdown['subtotal'] as num?)?.toDouble() ??
        (adultFare * adults + childFare * children + infantFare * infants);
    final taxes = (breakdown['taxes'] as num).toDouble();
    final total = (breakdown['total'] as num).toDouble();
    final paxTotal = adults + children + infants;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header: icon + title + subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.16),
                      AppColors.secondary.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.receipt_long_rounded,
                    size: 18, color: AppColors.secondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Price Breakdown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Fare details for $paxTotal ${paxTotal == 1 ? 'passenger' : 'passengers'}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Per-passenger lines (Adult 1, Adult 2 …)
          ..._paxLines('Adult', adults, adultFare, currency),
          ..._paxLines('Child', children, childFare, currency),
          ..._paxLines('Infant', infants, infantFare, currency),

          // Dashed divider (airline-ticket vibe)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DashedLinePainter(color: AppColors.border),
            ),
          ),

          // Sub-total + Taxes
          _fareMetaRow('Sub-total',
              formatCurrencyPrice(subtotal, currency)),
          const SizedBox(height: 6),
          _fareMetaRow('Taxes & Fees',
              formatCurrencyPrice(taxes, currency)),

          // Solid hairline before total
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),

          // Total — large, golden, w900
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Text(
                formatCurrencyPrice(total, currency),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _paxLines(
      String type, int count, double fare, Currency? currency) {
    if (count <= 0) return const [];
    if (count == 1) {
      return [_paxLine(type, formatCurrencyPrice(fare, currency))];
    }
    return List.generate(count, (i) {
      return _paxLine('$type ${i + 1}', formatCurrencyPrice(fare, currency));
    });
  }

  Widget _paxLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fareMetaRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.primary)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ]),
    );
  }

  String _getCabinLabel(String cabin) {
    final lower = cabin.toLowerCase().trim();
    if (lower.isEmpty || lower == 'y' || lower == 'economy' || lower == 'm') return 'Economy';
    if (lower == 'c' || lower == 'business' || lower == 'j') return 'Business';
    if (lower == 'f' || lower == 'first') return 'First';
    if (lower == 's' || lower == 'w' || lower == 'premium economy' || lower == 'premium') return 'Premium Economy';
    return cabin;
  }

  String _getAirlineCode(String airline) {
    if (airline.toLowerCase().contains('pia') || airline.toLowerCase().contains('pakistan')) {
      return 'PK';
    } else if (airline.toLowerCase().contains('airsial')) {
      return 'PF';
    } else if (airline.toLowerCase().contains('airblue')) {
      return 'PA';
    } else if (airline.toLowerCase().contains('serene')) {
      return 'ER';
    } else if (airline.toLowerCase().contains('emirates')) {
      return 'EK';
    } else if (airline.toLowerCase().contains('qatar')) {
      return 'QR';
    } else if (airline.toLowerCase().contains('etihad')) {
      return 'EY';
    } else if (airline.toLowerCase().contains('turkish')) {
      return 'TK';
    } else if (airline.toLowerCase().contains('saudia') || airline.toLowerCase().contains('saudi')) {
      return 'SV';
    } else if (airline.toLowerCase().contains('flydubai')) {
      return 'FZ';
    } else if (airline.toLowerCase().contains('air arabia')) {
      return 'G9';
    } else if (airline.length >= 2) {
      return airline.substring(0, 2).toUpperCase();
    }
    return airline;
  }

  String _getAirlineLogo(String code) {
    return 'https://www.rehmantravel.com/logos/${code.toUpperCase()}.png';
  }

  // ═══════════════════════════════════════════
  //  SKYSCANNER-STYLE HELPERS
  // ═══════════════════════════════════════════

  /// Subtitle string for the shared header — "Economy · 1 Adult".
  String _composeSubtitle() {
    final params = ref.read(flightSearchProvider).searchParams;
    // Prefer the user's selected cabin (searchParams) because many
    // API responses return an empty cabin on the flight object — an
    // empty string bypasses the `??` fallback, so everything was
    // defaulting to Economy.
    final flightCabin = _liveFlight['cabin']?.toString().trim() ?? '';
    final paramCabin = params?['cabin']?.toString().trim() ?? '';
    final cabinCode = (paramCabin.isNotEmpty
            ? paramCabin
            : flightCabin.isNotEmpty
                ? flightCabin
                : 'Y')
        .toUpperCase();
    final cabin = switch (cabinCode) {
      'C' || 'BUSINESS' || 'J' => 'Business',
      'F' || 'FIRST' => 'First',
      'S' || 'W' || 'PREMIUM' || 'PREMIUM ECONOMY' => 'Premium Economy',
      _ => 'Economy',
    };
    final adults = (_liveFlight['adultsCount'] ??
            params?['adultsCount'] ??
            1) as int;
    final children = (_liveFlight['childrenCount'] ??
            params?['childrenCount'] ??
            0) as int;
    final infants = (_liveFlight['infantsCount'] ??
            params?['infantsCount'] ??
            0) as int;
    final total = adults + children + infants;
    final pax = '$total ${total == 1 ? 'Adult' : 'Pax'}';
    return '$cabin · $pax';
  }

  Widget _buildHero({
    required String departureCity,
    required String arrivalCity,
    required String departureCode,
    required String arrivalCode,
    required String outboundDate,
    required String inboundDate,
    required int adults,
    required int children,
    required int infants,
    required String cabin,
  }) {
    final totalTravelers = adults + children + infants;
    final travelerLabel =
        '$totalTravelers ${totalTravelers == 1 ? 'traveller' : 'travellers'}';
    final origin = departureCity.isNotEmpty ? departureCity : departureCode;
    final dest = arrivalCity.isNotEmpty ? arrivalCity : arrivalCode;
    final dateLabel = _heroDateRange(outboundDate, inboundDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      color: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$origin to $dest',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            [
              if (dateLabel.isNotEmpty) dateLabel,
              travelerLabel,
              cabin,
            ].join(' · '),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Format "dd-MM-yyyy" into a weekday + day + month string like
  /// "Saturday, 18 April". Returns an empty string on parse failure.
  String _prettyDate(String ddMMyyyy) {
    if (ddMMyyyy.isEmpty) return '';
    try {
      final parts = ddMMyyyy.split('-');
      if (parts.length != 3) return ddMMyyyy;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dt = DateTime(year, month, day);
      const weekdays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday', 'Sunday',
      ];
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      return '${weekdays[dt.weekday - 1]}, $day ${months[month - 1]}';
    } catch (_) {
      return ddMMyyyy;
    }
  }

  String _heroDateRange(String outbound, String inbound) {
    if (outbound.isEmpty) return '';
    try {
      final out = _parseDdMMyyyy(outbound);
      if (inbound.isEmpty) {
        return '${out.day} ${_shortMonth(out.month)}';
      }
      final inb = _parseDdMMyyyy(inbound);
      if (out.month == inb.month) {
        return '${out.day} - ${inb.day} ${_shortMonth(inb.month)}';
      }
      return '${out.day} ${_shortMonth(out.month)} - ${inb.day} ${_shortMonth(inb.month)}';
    } catch (_) {
      return outbound;
    }
  }

  DateTime _parseDdMMyyyy(String s) {
    final parts = s.split('-');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  String _shortMonth(int m) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[(m - 1).clamp(0, 11)];
  }
}

// ═══════════════════════════════════════════
//  LEG CARD (Skyscanner-style collapsible)
// ═══════════════════════════════════════════
class _LegCard extends StatefulWidget {
  final String label;
  final String dateString;
  final String originCity;
  final String originCode;
  final String destCity;
  final String destCode;
  final String depTime;
  final String arrTime;
  final String duration;
  final int stops;
  final String airlineCode;
  final String airlineName;
  final List<Map<String, dynamic>> segments;
  final bool isRefundable;
  final String cabin;
  final String baggage;
  final String airlineLogoUrl;
  final bool defaultExpanded;

  const _LegCard({
    required this.label,
    required this.dateString,
    required this.originCity,
    required this.originCode,
    required this.destCity,
    required this.destCode,
    required this.depTime,
    required this.arrTime,
    required this.duration,
    required this.stops,
    required this.airlineCode,
    required this.airlineName,
    required this.segments,
    required this.isRefundable,
    required this.cabin,
    required this.baggage,
    required this.airlineLogoUrl,
    this.defaultExpanded = false,
  });

  @override
  State<_LegCard> createState() => _LegCardState();
}

class _LegCardState extends State<_LegCard> {
  late bool _expanded = widget.defaultExpanded;

  @override
  Widget build(BuildContext context) {
    final hasSegments = widget.segments.length >= 2;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: hasSegments ? () => setState(() => _expanded = !_expanded) : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 12),
                _summary(),
                if (_expanded && hasSegments) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  _timeline(),
                  if (_arrivesNextDay()) ...[
                    const SizedBox(height: 12),
                    _dayChangeChip(),
                  ],
                  const SizedBox(height: 6),
                  _extraInfoRow(),
                ],
                if (hasSegments) ...[
                  const SizedBox(height: 10),
                  _expandToggle(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(children: [
      Text(
        widget.label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: 0.2,
        ),
      ),
      const SizedBox(width: 10),
      if (widget.dateString.isNotEmpty)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.dateString,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
    ]);
  }

  Widget _summary() {
    final stopsLabel = widget.stops == 0 ? 'Non-stop' : '${widget.stops} stop';
    final stopsColor =
        widget.stops == 0 ? AppColors.success : AppColors.error;
    final route = '${widget.originCode} - ${widget.destCode}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            widget.airlineLogoUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Center(
              child: Text(
                widget.airlineCode,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${formatFlightTime(widget.depTime)} - ${formatFlightTime(widget.arrTime)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.airlineName.isNotEmpty ? widget.airlineName : route,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              stopsLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: stopsColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.duration,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _timeline() {
    final widgets = <Widget>[];
    for (var i = 0; i < widget.segments.length; i++) {
      widgets.add(_segmentCard(widget.segments[i]));
      if (i < widget.segments.length - 1) {
        widgets.add(const SizedBox(height: 10));
        widgets.add(_connectionStrip(widget.segments[i], widget.segments[i + 1]));
        widgets.add(const SizedBox(height: 10));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets);
  }

  Widget _segmentCard(Map<String, dynamic> seg) {
    final depTime = formatFlightTime((seg['departureTime'] ?? '--:--').toString());
    final arrTime = formatFlightTime((seg['arrivalTime'] ?? '--:--').toString());
    final depCity = (seg['departureCity'] ?? seg['departureCode'] ?? '').toString();
    final arrCity = (seg['arrivalCity'] ?? seg['arrivalCode'] ?? '').toString();
    final duration = (seg['duration'] ?? '').toString();
    final flightNum = (seg['flightNumber'] ?? '').toString();
    final airlineName = (seg['airlineName'] ?? widget.airlineName).toString();
    final airlineCode = (seg['airlineCode'] ?? widget.airlineCode).toString();
    final aircraft = (seg['aircraft'] ?? seg['aircraftType'] ?? '').toString();
    final meal = (seg['meal'] ?? seg['mealService'] ?? seg['mealCode'] ?? '').toString();
    final logoUrl =
        'https://www.rehmantravel.com/logos/${airlineCode.toUpperCase()}.png';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Airline header
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airlineName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (flightNum.isNotEmpty)
                    Text(
                      flightNum,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    airlineCode,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Timeline rows
          _timelineRow(depTime, depCity, isStart: true),
          _timelineDurationLine(duration),
          _timelineRow(arrTime, arrCity, isStart: false),
          if (aircraft.isNotEmpty || meal.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                if (aircraft.isNotEmpty)
                  _segMeta(Icons.flight_outlined, aircraft),
                if (meal.isNotEmpty)
                  _segMeta(Icons.restaurant_outlined, _mealLabel(meal)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _segMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  String _mealLabel(String code) {
    // Common IATA meal codes; fall back to raw text otherwise.
    switch (code.toUpperCase().trim()) {
      case 'B':
        return 'Breakfast';
      case 'L':
        return 'Lunch';
      case 'D':
        return 'Dinner';
      case 'S':
      case 'K':
        return 'Snack';
      case 'M':
        return 'Meal';
      case 'R':
        return 'Refreshments';
      case 'C':
        return 'Continental breakfast';
      case 'H':
        return 'Hot meal';
      case 'N':
        return 'No meal';
      default:
        return code;
    }
  }

  Widget _timelineRow(String time, String place, {required bool isStart}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStart ? Colors.white : AppColors.primary,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  place,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timelineDurationLine(String duration) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 24,
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
          const SizedBox(width: 16),
          if (duration.isNotEmpty)
            Text(
              duration,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _connectionStrip(Map<String, dynamic> prev, Map<String, dynamic> next) {
    final airport = (prev['arrivalCity'] ?? prev['arrivalCode'] ?? '').toString();
    String waitTime = '';
    final arrMin = timeToMinutes((prev['arrivalTime'] ?? '').toString());
    final depMin = timeToMinutes((next['departureTime'] ?? '').toString());
    if (arrMin != null && depMin != null) {
      var diff = depMin - arrMin;
      if (diff < 0) diff += 1440;
      if (diff > 0) {
        final h = diff ~/ 60;
        final m = diff % 60;
        waitTime = h > 0 ? '${h}h ${m}m' : '${m}m';
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              waitTime.isNotEmpty
                  ? '$waitTime connection in $airport'
                  : 'Connection in $airport',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _arrivesNextDay() {
    final depMin = timeToMinutes(widget.depTime);
    final arrMin = timeToMinutes(widget.arrTime);
    if (depMin == null || arrMin == null) return false;
    return arrMin < depMin;
  }

  Widget _dayChangeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.nights_stay_outlined, size: 14, color: AppColors.error),
          const SizedBox(width: 8),
          Text(
            'You\'ll arrive the next day',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _extraInfoRow() {
    final items = <Widget>[
      _infoPill(Icons.airline_seat_recline_normal, widget.cabin),
      _infoPill(Icons.luggage_outlined, widget.baggage),
      _infoPill(
        widget.isRefundable ? Icons.check_circle_outline : Icons.cancel_outlined,
        widget.isRefundable ? 'Refundable' : 'Non-refundable',
        color: widget.isRefundable ? AppColors.success : AppColors.error,
      ),
    ];
    return Wrap(spacing: 8, runSpacing: 8, children: items);
  }

  Widget _infoPill(IconData icon, String text, {Color? color}) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: c,
            ),
          ),
        ],
      ),
    );
  }

  Widget _expandToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _expanded ? 'Hide details' : 'View details',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 18,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

// Fare Rules inline card with auto-load + skeleton
class _FareRulesCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> flight;
  const _FareRulesCard({required this.flight});

  @override
  ConsumerState<_FareRulesCard> createState() => _FareRulesCardState();
}

class _FareRulesCardState extends ConsumerState<_FareRulesCard> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _fareRules = [];

  @override
  void initState() {
    super.initState();
    _fetchFareRules();
  }

  Future<void> _fetchFareRules() async {
    final flight = widget.flight;
    final fareRuleKey = flight['fareRuleKey'];
    final jSessionId = flight['jSessionId'];
    final provider = flight['provider'];
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;

    if (fareRuleKey == null || jSessionId == null || provider == null) {
      setState(() { _isLoading = false; _fareRules = _defaults(); });
      return;
    }

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.postWithHeader(
        ApiEndpoints.fareRules,
        data: {
          'fareRuleKeys': [{'fareRuleRefKey': fareRuleKey}],
          'jSessionId': jSessionId,
          'airType': priceData?['airType'] ?? '',
          'vCarrier': priceData?['validatingCarrier'] ?? '',
        },
        extraHeaders: {'Action-Type': provider},
      );
      if (!mounted) return;

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('fareRules')) {
        final rules = data['fareRules'];
        if (rules is List && rules.isNotEmpty) {
          setState(() {
            _isLoading = false;
            _fareRules = rules.map((r) {
              if (r is Map<String, dynamic>) {
                return {'title': r['category'] ?? r['title'] ?? 'Rule', 'description': r['text'] ?? r['description'] ?? r['rules'] ?? ''};
              }
              return {'title': 'Rule', 'description': r.toString()};
            }).toList();
          });
          return;
        }
      }
      setState(() { _isLoading = false; _fareRules = _defaults(); });
    } catch (_) {
      if (!mounted) return;
      setState(() { _isLoading = false; _fareRules = _defaults(); });
    }
  }

  List<Map<String, dynamic>> _defaults() => [
    {'icon': Icons.cancel_outlined, 'title': 'Cancellation', 'description': 'Charges may apply as per airline policy.'},
    {'icon': Icons.edit_calendar_outlined, 'title': 'Date Changes', 'description': 'Date change allowed with a fee. Subject to availability.'},
    {'icon': Icons.luggage_outlined, 'title': 'Baggage', 'description': '${widget.flight['baggage'] ?? '20kg'} checked baggage included.'},
    {'icon': Icons.event_busy_outlined, 'title': 'No Show', 'description': 'No show penalty applies. Tickets may become non-refundable.'},
  ];

  IconData _icon(String title) {
    final l = title.toLowerCase();
    if (l.contains('cancel')) return Icons.cancel_outlined;
    if (l.contains('change') || l.contains('date')) return Icons.edit_calendar_outlined;
    if (l.contains('baggage')) return Icons.luggage_outlined;
    if (l.contains('no show')) return Icons.event_busy_outlined;
    if (l.contains('refund')) return Icons.money_off_outlined;
    return Icons.article_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fare Rules', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        const SizedBox(height: 10),
        if (_isLoading) ...[
          // Skeleton loading
          for (int i = 0; i < 3; i++) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 80, height: 10, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(width: double.infinity, height: 8, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4))),
                ])),
              ]),
            ),
          ],
        ] else ...[
          for (final rule in _fareRules) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                  child: Icon(rule['icon'] as IconData? ?? _icon(rule['title'] ?? ''), size: 14, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(rule['title'] ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text(rule['description'] ?? '', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
                ])),
              ]),
            ),
          ],
        ],
      ]),
    );
  }
}

// === UNUSED LEGACY WIDGETS BELOW ===
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppIconSize.lg, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.titleSm.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppGap.md,
          ...children,
        ],
      ),
    );
  }
}

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final IconData? icon;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppIconSize.lg - 2, color: AppColors.textSecondary),
                AppGap.hSm,
              ],
              Text(
                label,
                style: AppTextStyles.bodyLg.copyWith(
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.titleSm.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.textPrimary,
                  )
                : AppTextStyles.bodyLg.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
          ),
        ],
      ),
    );
  }
}

// Flight Route Visualization Widget (used inside section cards)
class _FlightRouteWidget extends StatelessWidget {
  final String departureCode;
  final String arrivalCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int stops;

  const _FlightRouteWidget({
    required this.departureCode,
    required this.arrivalCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Departure
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(departureTime, style: AppTextStyles.titleLg),
              AppGap.xs,
              Text(departureCode, style: AppTextStyles.caption),
            ],
          ),
        ),

        // Flight Path
        Expanded(
          child: Column(
            children: [
              Text(duration, style: AppTextStyles.hint),
              AppGap.xs,
              Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: AppColors.border)),
                  Icon(Icons.flight, size: AppIconSize.sm, color: AppColors.primary),
                  Expanded(child: Container(height: 1, color: AppColors.border)),
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              AppGap.xs,
              Text(
                stops == 0 ? 'Direct' : '$stops Stop${stops > 1 ? 's' : ''}',
                style: AppTextStyles.hint.copyWith(
                  fontSize: 9,
                  color: stops == 0 ? AppColors.success : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),

        // Arrival
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(arrivalTime, style: AppTextStyles.titleLg),
              AppGap.xs,
              Text(arrivalCode, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

// Fare Rule Item Widget
class _FareRuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FareRuleItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: AppIconSize.lg, color: AppColors.primary),
          ),
          AppGap.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMd,
                ),
                AppGap.xs,
                Text(
                  description,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
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

/// Airline-ticket style dashed divider used in Price Breakdown card.
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double gapWidth;
  final double strokeWidth;

  _DashedLinePainter({
    required this.color,
    this.dashWidth = 4.0,
    this.gapWidth = 4.0,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) =>
      color != old.color ||
      dashWidth != old.dashWidth ||
      gapWidth != old.gapWidth ||
      strokeWidth != old.strokeWidth;
}
