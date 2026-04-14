import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/utils/app_lifecycle_refresh_mixin.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../providers/fare_refresh_clock.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/fare_rules_view.dart';
import '../widgets/flight_gone_dialog.dart';
import '../widgets/flight_route_header.dart';
import '../widgets/itinerary_view.dart';
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

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }

  /// Pulls per-passenger-type fares out of `flight['rawData']['price']`
  /// and derives the tax portion from the flight's total so the
  /// displayed Total always matches the card price.
  ///
  /// Why it's done this way: the upstream provider sometimes quotes
  /// `baseFarePerAdult` but omits child/infant rows, or returns
  /// `grossFarePerAdult` without a separate taxes line. Instead of
  /// guessing, we anchor on `flight['price']` (the single number
  /// shown on the results card) and back out `taxes = total - subtotal`.
  /// That keeps the breakdown additions equal to the headline price
  /// no matter which subset of fare fields the provider returns.
  Map<String, dynamic> _getPriceBreakdown(Map<String, dynamic> flight) {
    final totalPrice = (flight['price'] as num?)?.toDouble() ?? 0;
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;

    final adults = _parseInt(flight['adultsCount']) ?? 1;
    final children = _parseInt(flight['childrenCount']) ?? 0;
    final infants = _parseInt(flight['infantsCount']) ?? 0;

    double adultFare = 0;
    double childFare = 0;
    double infantFare = 0;
    if (priceData != null) {
      adultFare = _parseDouble(
          priceData['baseFarePerAdult'] ?? priceData['grossFarePerAdult']);
      childFare = _parseDouble(
          priceData['baseFarePerChild'] ?? priceData['grossFarePerChild']);
      infantFare = _parseDouble(
          priceData['baseFarePerInfant'] ?? priceData['grossFarePerInfant']);
    }
    // Fallback: if nothing came back, split the total evenly across
    // adults so the row isn't empty.
    if (adultFare == 0 && adults > 0) {
      adultFare = totalPrice / (adults + children + infants).clamp(1, 99);
    }

    final subtotal =
        (adultFare * adults) + (childFare * children) + (infantFare * infants);
    // Taxes are whatever the total can't account for. Clamped to
    // zero so a provider quote that's already tax-inclusive doesn't
    // show a negative tax line.
    final derivedTaxes = (totalPrice - subtotal).clamp(0.0, double.infinity);

    return {
      'adults': adults,
      'children': children,
      'infants': infants,
      'adultFare': adultFare,
      'childFare': childFare,
      'infantFare': infantFare,
      'subtotal': subtotal,
      'taxes': derivedTaxes,
      'total': totalPrice,
    };
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    final searchParams = ref.read(flightSearchProvider).searchParams;
    final selectedCurrency = ref.watch(currencyProvider).selected;
    final priceBreakdown = _getPriceBreakdown(_liveFlight);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          FlightRouteHeader(title: 'Itinerary', params: searchParams),
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
                ItineraryView(flight: _liveFlight, searchParams: searchParams),
                const SizedBox(height: 14),
                _priceBreakdownCard(priceBreakdown, selectedCurrency),
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

  /// Inline price breakdown card rendered between the itinerary and
  /// the fare rules. Single white card with per-pax rows, sub-total,
  /// taxes, and total — matches the fare rules card's chrome so both
  /// sit together visually.
  Widget _priceBreakdownCard(
    Map<String, dynamic> breakdown,
    Currency? currency,
  ) {
    final adults = breakdown['adults'] as int;
    final children = breakdown['children'] as int;
    final infants = breakdown['infants'] as int;
    final adultFare = (breakdown['adultFare'] as num).toDouble();
    final childFare = (breakdown['childFare'] as num).toDouble();
    final infantFare = (breakdown['infantFare'] as num).toDouble();
    final subtotal = (breakdown['subtotal'] as num).toDouble();
    final taxes = (breakdown['taxes'] as num).toDouble();
    final total = (breakdown['total'] as num).toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Price Breakdown',
                  style: AppTextStyles.titleSm.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (adults > 0)
              _paxRow('Adult', adults, adultFare, currency),
            if (children > 0) ...[
              const SizedBox(height: 12),
              _paxRow('Child', children, childFare, currency),
            ],
            if (infants > 0) ...[
              const SizedBox(height: 12),
              _paxRow('Infant', infants, infantFare, currency),
            ],
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),
            _summaryRow(
              'Sub-total',
              formatCurrencyPrice(subtotal, currency),
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'Taxes & Fees',
              formatCurrencyPrice(taxes, currency),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  formatCurrencyPrice(total, currency),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One row per passenger type: headline on the left, count × fare
  /// subtitle below, total on the right.
  Widget _paxRow(String type, int count, double perPax, Currency? currency) {
    final perPaxLabel = formatCurrencyPrice(perPax, currency);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$type × $count',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$count × $perPaxLabel',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          formatCurrencyPrice(perPax * count, currency),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Neutral "label right-aligned value" row used for Sub-total and
  /// Taxes & Fees.
  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
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
              child: ElevatedButton(
                onPressed: isRefreshing
                    ? null
                    : () => context.push(
                          AppRoutes.booking,
                          extra: _liveFlight,
                        ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isRefreshing ? 'Refreshing...' : 'Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
