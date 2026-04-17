import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../data/utils/fare_calculation.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/collapsible_itinerary_card.dart';
import '../widgets/flight_route_header.dart';

/// Review step at the end of the multi-city leg-by-leg flow.
///
/// Renders each selected leg with the same `CollapsibleItineraryCard`
/// the booking / payment screens use so the look is consistent across
/// the flow. A "Change" button on each card drops the user back to the
/// results screen re-searching that specific leg (later legs are
/// cleared because they depend on this one).
class MultiCityReviewScreen extends ConsumerWidget {
  const MultiCityReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(flightSearchProvider);
    final currency = ref.watch(currencyProvider).selected;
    final selected = searchState.selectedLegFlights;
    final searchParams = searchState.searchParams;

    final adults = (searchParams?['adultsCount'] as num?)?.toInt() ?? 1;
    final children = (searchParams?['childrenCount'] as num?)?.toInt() ?? 0;
    final infants = (searchParams?['infantsCount'] as num?)?.toInt() ?? 0;

    final breakdowns = <FareBreakdown>[
      for (final f in selected)
        computeFareBreakdown(
          flight: f,
          adults: adults,
          children: children,
          infants: infants,
        ),
    ];

    double total = 0;
    double baseTotal = 0;
    double taxTotal = 0;
    for (final b in breakdowns) {
      total += b.total;
      baseTotal += b.baseFare;
      taxTotal += b.taxes;
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          FlightRouteHeader(
            title: 'Review Trip',
            subtitle:
                '${selected.length} ${selected.length == 1 ? 'Flight' : 'Flights'}',
            params: null,
          ),
          if (selected.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No legs selected')),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.only(top: 6),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _LegReviewCard(
                    index: index,
                    totalLegs: selected.length,
                    flight: selected[index],
                    breakdown: breakdowns[index],
                    searchParams: searchParams,
                    currency: currency,
                    onChange: () => _changeLeg(context, ref, index),
                  ),
                  childCount: selected.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _PriceDetailsCard(
                breakdowns: breakdowns,
                baseTotal: baseTotal,
                taxTotal: taxTotal,
                grandTotal: total,
                currency: currency,
                searchParams: searchParams,
                selected: selected,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ],
      ),
      bottomNavigationBar: selected.isEmpty
          ? null
          : Container(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: AppShadows.soft,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                  ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total (${selected.length} ${selected.length == 1 ? 'flight' : 'flights'})',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            formatCurrencyPrice(total, currency),
                            style: AppTextStyles.h3.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final merged = ref
                              .read(flightSearchProvider.notifier)
                              .buildMergedMultiCityFlight();
                          context.push('/booking', extra: {
                            ...merged,
                            'adultsCount': searchParams?['adultsCount'] ?? 1,
                            'childrenCount':
                                searchParams?['childrenCount'] ?? 0,
                            'infantsCount': searchParams?['infantsCount'] ?? 0,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),
    );
  }

  /// Re-opens leg `index` for editing by pushing a fresh results
  /// screen on top of the review. Non-destructive — every other leg
  /// keeps its existing selection. The pushed results screen handles
  /// the actual `jumpToLeg` call in its own `initState`, and pops
  /// itself when a replacement flight is chosen, dropping the user
  /// straight back on review with the new selection reflected.
  void _changeLeg(BuildContext context, WidgetRef ref, int index) {
    final baseParams = ref.read(flightSearchProvider).searchParams;
    if (baseParams == null) return;
    context.push('/flights/results', extra: {
      ...baseParams,
      'isRePick': true,
      'rePickLegIndex': index,
    });
  }
}

/// Wraps a single leg's `CollapsibleItineraryCard` with a small header
/// (Leg N badge, airline name, price, "Change" link) so the review
/// screen reads as a stacked list of editable legs without hiding the
/// shared itinerary chrome used elsewhere.
class _LegReviewCard extends StatelessWidget {
  final int index;
  final int totalLegs;
  final Map<String, dynamic> flight;
  final FareBreakdown breakdown;
  final Map<String, dynamic>? searchParams;
  final Currency? currency;
  final VoidCallback onChange;

  const _LegReviewCard({
    required this.index,
    required this.totalLegs,
    required this.flight,
    required this.breakdown,
    required this.searchParams,
    required this.currency,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final airlineName = (flight['airlineName'] ?? '').toString();
    final dep = (flight['departureCode'] ?? '').toString();
    final arr = (flight['arrivalCode'] ?? '').toString();
    final depName = _legCityName('departureName', dep);
    final arrName = _legCityName('arrivalName', arr);
    final price = (flight['price'] as num?)?.toDouble() ?? 0;

    // Build a per-leg searchParams shim so `ItineraryView` picks the
    // right date pill and cabin label for this specific leg instead of
    // pulling the whole trip's first leg.
    final legSearchParams = <String, dynamic>{
      if (searchParams != null) ...searchParams!,
      'legs': [
        {
          'departureCode': dep,
          'arrivalCode': arr,
          'outboundDate': _outboundDateForLeg(),
        },
      ],
    };

    final routeSubtitle = [
      if (dep.isNotEmpty && arr.isNotEmpty) '$dep → $arr',
      if (airlineName.isNotEmpty) airlineName,
    ].join('  ·  ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Flight header strip — sits above the collapsible card so the
          // flight number, route, airline, and price stay visible even
          // when the itinerary card is collapsed.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'Flight ${index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        depName.isNotEmpty && arrName.isNotEmpty
                            ? '$depName → $arrName'
                            : '$dep → $arr',
                        style: AppTextStyles.bodyMd.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (routeSubtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          routeSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Fare',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatCurrencyPrice(price, currency),
                      style: AppTextStyles.bodyMd.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Shared itinerary card — exactly the same widget used on the
          // booking / payment screens, so the review step is visually
          // consistent with the rest of the flow.
          CollapsibleItineraryCard(
            flight: flight,
            searchParams: legSearchParams,
          ),
          // Change-leg link (right-aligned, below the card).
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: onChange,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 14, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        'Edit flight',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Resolves a human-readable city name for this leg, falling back to
  /// the trip-level `searchParams.legs[index]` entry (which carries the
  /// name the user picked on the search form) and finally to the IATA
  /// code so the header never ends up blank.
  String _legCityName(String key, String code) {
    final direct = (flight[key] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;
    final legs = (searchParams?[key == 'departureName' ? 'legs' : 'legs']
        as List?) ?? const [];
    if (index < legs.length) {
      final entry = legs[index];
      if (entry is Map) {
        final name = (entry[key] ?? '').toString().trim();
        if (name.isNotEmpty) return name;
      }
    }
    return code;
  }

  /// Picks this leg's outbound date from the trip-level searchParams
  /// (`legs[index].outboundDate`) so the date pill in ItineraryView
  /// shows the right day for this leg, not the first leg's.
  String _outboundDateForLeg() {
    final legs = (searchParams?['legs'] as List?) ?? const [];
    if (index < legs.length) {
      final entry = legs[index];
      if (entry is Map) return (entry['outboundDate'] ?? '').toString();
    }
    return '';
  }
}

/// Full fare breakdown card rendered at the end of the review list.
/// Shows each flight's base + taxes on their own row and the summed
/// base / taxes / grand total footer so the user can reconcile the
/// total they're about to pay against each leg's contribution.
class _PriceDetailsCard extends StatelessWidget {
  final List<FareBreakdown> breakdowns;
  final double baseTotal;
  final double taxTotal;
  final double grandTotal;
  final Currency? currency;
  final Map<String, dynamic>? searchParams;
  final List<Map<String, dynamic>> selected;

  const _PriceDetailsCard({
    required this.breakdowns,
    required this.baseTotal,
    required this.taxTotal,
    required this.grandTotal,
    required this.currency,
    required this.searchParams,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final paxLine = _paxSummary();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Price details',
                style: AppTextStyles.bodyMd.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (paxLine.isNotEmpty)
                Text(
                  paxLine,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < breakdowns.length; i++) ...[
            _flightRow(i),
            if (i != breakdowns.length - 1)
              Divider(
                height: 14,
                color: AppColors.border.withValues(alpha: 0.4),
              ),
          ],
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 10),
          _summaryRow('Base fare (all flights)',
              formatCurrencyPrice(baseTotal, currency)),
          const SizedBox(height: 6),
          _summaryRow('Taxes & fees (all flights)',
              formatCurrencyPrice(taxTotal, currency)),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grand total',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                formatCurrencyPrice(grandTotal, currency),
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _flightRow(int i) {
    final f = selected[i];
    final dep = (f['departureCode'] ?? '').toString();
    final arr = (f['arrivalCode'] ?? '').toString();
    final b = breakdowns[i];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Flight ${i + 1} · $dep → $arr',
                style: AppTextStyles.bodySm.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              formatCurrencyPrice(b.total, currency),
              style: AppTextStyles.bodySm.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _subRow('Base fare', formatCurrencyPrice(b.baseFare, currency)),
        const SizedBox(height: 2),
        _subRow('Taxes & fees', formatCurrencyPrice(b.taxes, currency)),
      ],
    );
  }

  Widget _subRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  String _paxSummary() {
    final a = (searchParams?['adultsCount'] as num?)?.toInt() ?? 1;
    final c = (searchParams?['childrenCount'] as num?)?.toInt() ?? 0;
    final i = (searchParams?['infantsCount'] as num?)?.toInt() ?? 0;
    final parts = <String>[
      if (a > 0) '$a ${a == 1 ? 'Adult' : 'Adults'}',
      if (c > 0) '$c ${c == 1 ? 'Child' : 'Children'}',
      if (i > 0) '$i ${i == 1 ? 'Infant' : 'Infants'}',
    ];
    return parts.join(' · ');
  }
}
