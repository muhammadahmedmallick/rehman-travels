import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/utils/app_lifecycle_refresh_mixin.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../data/utils/fare_calculation.dart';
import '../providers/booking_session_provider.dart';
import '../providers/fare_refresh_clock.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/booking_journey_header.dart';
import '../widgets/fare_rules_view.dart';
import '../widgets/flight_gone_dialog.dart';
import '../widgets/itinerary_view.dart';
import '../widgets/price_breakdown_card.dart';
import '../widgets/refresh_countdown_pill.dart';

/// Full-screen itinerary view shown from the "View details" link
/// on a flight card.
///
/// Wires up the same fare-refresh cadence, countdown pill, price
/// breakdown, and "Book Now" bottom bar as the legacy details screen
/// so the user can review and book from one place. Uses
/// [AppLifecycleRefreshMixin] so the periodic re-search pauses when
/// the screen is backgrounded and fires again on return.
class FlightItineraryScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> flight;

  const FlightItineraryScreen({super.key, required this.flight});

  @override
  ConsumerState<FlightItineraryScreen> createState() =>
      _FlightItineraryScreenState();
}

class _FlightItineraryScreenState extends ConsumerState<FlightItineraryScreen>
    with AppLifecycleRefreshMixin<FlightItineraryScreen> {
  late Map<String, dynamic> _liveFlight;

  @override
  void initState() {
    super.initState();
    _liveFlight = widget.flight;
    // Entry point into the booking flow — start (or resume) the
    // shared clock so the booking screen sees the same countdown.
    FareRefreshClock.startIfIdle();
  }

  @override
  void dispose() {
    // Itinerary is the root of the booking flow — when it pops
    // (back to results) the next session should start fresh.
    FareRefreshClock.clear();
    super.dispose();
  }

  /// Keep fares fresh while the user is reading the itinerary so the
  /// Book Now button always reflects the latest price.
  @override
  Duration? get periodicRefreshInterval => kFlightFareRefreshInterval;

  /// Same trip-type title used by the search results header so both
  /// screens read identically.
  String _tripTypeLabel(Map<String, dynamic>? params) {
    final tripType = (params?['tripType'] ?? '').toString();
    if (tripType == 'round-trip') return 'Round Trip';
    if (tripType == 'multi') return 'Multi-City';
    return 'One Way';
  }

  // Share the fare-refresh countdown with the booking screen so
  // navigating forward doesn't reset the 3-minute timer.
  @override
  DateTime? readSharedLastTickAt() => FareRefreshClock.lastTickAt;

  @override
  void writeSharedLastTickAt(DateTime at) =>
      FareRefreshClock.lastTickAt = at;

  @override
  Future<void> onLifecycleRefresh() async {
    final searchParams = ref.read(flightSearchProvider).searchParams;
    if (searchParams == null) return;
    await ref.read(flightSearchProvider.notifier).searchFlights(searchParams);
    if (!mounted) return;
    final newFlights = ref.read(flightSearchProvider).flights;
    final match = _findMatchingFlight(newFlights, _liveFlight);
    if (match == null) {
      await showFlightGoneDialog(context);
      return;
    }
    setState(() => _liveFlight = match);
  }

  /// Flight IDs regenerate on every search. Fall back to a composite
  /// key (airline + flight number + dep/arr times) so a refreshed
  /// result still matches the card the user tapped into.
  Map<String, dynamic>? _findMatchingFlight(
    List<dynamic> flights,
    Map<String, dynamic> target,
  ) {
    final targetId = (target['id'] ?? '').toString();
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

  // ---------- Price breakdown ----------

  /// Shared fare breakdown — pulled straight from the booking
  /// session so every screen renders the same numbers. Falls back
  /// to recomputing locally only when there's no session yet
  /// (e.g. deep-link, screen opened directly).
  Map<String, dynamic> _getPriceBreakdown(Map<String, dynamic> flight) {
    final session = ref.read(bookingSessionProvider);
    if (session != null) return session.fare.toMap();

    // Fallback path — no session, derive from search params.
    final provider = ref.read(flightSearchProvider).searchParams;
    int asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    final adults = asInt(flight['adultsCount'] ?? provider?['adultsCount']);
    final children =
        asInt(flight['childrenCount'] ?? provider?['childrenCount']);
    final infants =
        asInt(flight['infantsCount'] ?? provider?['infantsCount']);

    return computeFareBreakdown(
      flight: flight,
      adults: adults > 0 ? adults : 1,
      children: children,
      infants: infants,
    ).toMap();
  }

  /// Builds the header/itinerary params from the flight object
  /// itself rather than the global `searchParams`.
  ///
  /// Why: this screen is bound to a specific flight the user tapped
  /// into from the results card. The global `searchParams` can drift
  /// away from this flight (e.g. when the user navigated forward,
  /// changed the search, and then came back to this screen still in
  /// the stack). Deriving everything from `_liveFlight` guarantees
  /// the header / date pills / leg dates stay consistent with the
  /// itinerary the user is actually looking at.
  Map<String, dynamic> _flightDerivedParams() {
    final flight = _liveFlight;
    final allLegs = (flight['allLegs'] as List?)
            ?.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        const <Map<String, dynamic>>[];
    final first = allLegs.isNotEmpty ? allLegs.first : flight;
    final last = allLegs.isNotEmpty ? allLegs.last : flight;

    // Prefer the segment-level departureDate for accuracy, fall
    // back to the stored searchParams entry for this route.
    String outboundDate = '';
    final firstSegments = (first['segments'] as List?)?.whereType<Map>();
    if (firstSegments != null && firstSegments.isNotEmpty) {
      outboundDate =
          (firstSegments.first['departureDate'] ?? '').toString();
    }

    // Build a per-leg list so the ItineraryView date helper can
    // resolve each leg's date correctly on multi-city flights.
    final legsForParams = <Map<String, dynamic>>[];
    for (final l in allLegs) {
      final segs = (l['segments'] as List?)?.whereType<Map>();
      String date = '';
      if (segs != null && segs.isNotEmpty) {
        date = (segs.first['departureDate'] ?? '').toString();
      }
      legsForParams.add({
        'departureCode': (l['departureCode'] ?? '').toString(),
        'arrivalCode': (l['arrivalCode'] ?? '').toString(),
        'outboundDate': date,
      });
    }

    // Pax counts — may have been passed through on the flight map
    // (via `extra:` on navigation from results). Fall back to the
    // current provider state only as a last resort, then 1/0/0.
    final provider = ref.read(flightSearchProvider).searchParams;
    int toInt(dynamic v, int fallback) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? fallback;
    }

    return <String, dynamic>{
      'tripType': legsForParams.length > 2
          ? 'multi'
          : (legsForParams.length == 2 ? 'round-trip' : 'one-way'),
      'departureCode': (first['departureCode'] ?? '').toString(),
      'arrivalCode': (last['arrivalCode'] ?? '').toString(),
      'outboundDate': outboundDate,
      if (legsForParams.isNotEmpty) 'legs': legsForParams,
      'cabin': (flight['cabin'] ?? provider?['cabin'] ?? 'Y').toString(),
      'adultsCount':
          toInt(flight['adultsCount'] ?? provider?['adultsCount'], 1),
      'childrenCount':
          toInt(flight['childrenCount'] ?? provider?['childrenCount'], 0),
      'infantsCount':
          toInt(flight['infantsCount'] ?? provider?['infantsCount'], 0),
    };
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    final flightParams = _flightDerivedParams();
    final selectedCurrency = ref.watch(currencyProvider).selected;
    final priceBreakdown = _getPriceBreakdown(_liveFlight);
    // Reuse the exact same params the search-results header uses so
    // both screens show identical title / route / meta. Flight-derived
    // params still drive the itinerary body below (where per-leg dates
    // matter), but the header reads from the original search.
    final searchParams = ref.watch(flightSearchProvider).searchParams;
    final headerParams = searchParams ?? flightParams;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          BookingJourneyHeader(
            title: _tripTypeLabel(headerParams),
            params: headerParams,
            showStepper: false,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: PinnedRefreshCountdownHeader(
              nextRefreshIn: nextRefreshIn,
              isPaused: () => isRefreshPaused,
              isRefreshing: () => isRefreshing,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ItineraryView(flight: _liveFlight, searchParams: flightParams),
                const SizedBox(height: 14),
                PriceBreakdownCard(
                  breakdown: priceBreakdown,
                  currency: selectedCurrency,
                  airlineName: (_liveFlight['airlineName'] ?? '').toString(),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppShadows.soft,
                    ),
                    // `flat: true` — outer container already provides
                    // the card chrome, so the inner view shouldn't draw
                    // a second card.
                    child: FareRulesView(flight: _liveFlight, flat: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(priceBreakdown, selectedCurrency),
    );
  }

  Widget _bottomBar(Map<String, dynamic> breakdown, Currency? currency) {
    return Container(
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
                    formatCurrencyPrice(
                      (breakdown['total'] as num).toDouble(),
                      currency,
                    ),
                    style: AppTextStyles.priceLg.copyWith(fontSize: 22),
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
                              // Multi-city leg-by-leg flow — pick this
                              // flight as the current leg and hand
                              // control back to the screen below
                              // (review on re-pick, results for the
                              // next leg on forward flow).
                              final before =
                                  ref.read(flightSearchProvider);
                              final wasRePick = before.currentLegIndex <
                                  before.selectedLegFlights.length;
                              await ref
                                  .read(flightSearchProvider.notifier)
                                  .selectLegFlight(_liveFlight);
                              if (!context.mounted) return;
                              if (wasRePick) {
                                // Pop itinerary and the re-pick
                                // results screen so review is visible.
                                context.pop();
                                context.pop();
                              } else {
                                context.pop();
                              }
                              return;
                            }
                            // Make sure the session is started (if
                            // the user landed here via deep-link
                            // without going through the card tap, we
                            // start it now). Idempotent — if a
                            // session already exists for this flight,
                            // refresh it with the latest quote.
                            final sessionNotifier =
                                ref.read(bookingSessionProvider.notifier);
                            final existing =
                                ref.read(bookingSessionProvider);
                            if (existing == null) {
                              sessionNotifier.start(
                                flight: _liveFlight,
                                searchParams: ref
                                        .read(flightSearchProvider)
                                        .searchParams ??
                                    {},
                              );
                            } else {
                              sessionNotifier.refreshFlight(_liveFlight);
                            }
                            context.push(
                              AppRoutes.booking,
                              extra: _liveFlight,
                            );
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
    );
  }
}
