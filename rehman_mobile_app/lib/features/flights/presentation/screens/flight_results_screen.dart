import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rehman_mobile_app/app/theme.dart';
import 'package:rehman_mobile_app/app/widgets/app_bottom_sheet.dart';
import 'package:rehman_mobile_app/app/widgets/currency_selector.dart';
import 'package:rehman_mobile_app/core/constants/feature_flags.dart';
import 'package:rehman_mobile_app/core/utils/app_lifecycle_refresh_mixin.dart';
import 'package:rehman_mobile_app/features/currency/presentation/providers/currency_provider.dart';
import 'package:rehman_mobile_app/features/flights/presentation/providers/booking_session_provider.dart';
import 'package:rehman_mobile_app/features/flights/presentation/providers/flight_search_provider.dart';
import 'package:rehman_mobile_app/features/flights/presentation/widgets/booking_journey_header.dart';
import 'package:rehman_mobile_app/features/flights/presentation/widgets/flight_card.dart';
import 'package:rehman_mobile_app/features/flights/presentation/widgets/flight_search_form.dart';
import 'package:shimmer/shimmer.dart';


class FlightResultsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? searchParams;

  const FlightResultsScreen({super.key, this.searchParams});

  @override
  ConsumerState<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends ConsumerState<FlightResultsScreen>
    with AppLifecycleRefreshMixin<FlightResultsScreen> {
  String _currentSort = 'best';
  Set<int> _selectedStops = {};
  Set<String> _selectedAirlines = {};
  Map<String, dynamic>? _activeParams;

  bool get _isMultiCityLegFlow =>
      kMultiCityLegByLegFlow &&
      (_activeParams?['tripType']?.toString() ?? '') == 'multi';

  /// `true` when this results screen instance was pushed on top of the
  /// review screen to re-pick a single leg. In that case initState
  /// skips `startMultiCityLegFlow` (which would wipe the existing
  /// selections) and instead calls `jumpToLeg` so the other legs stay
  /// intact; selection handling also pops this screen inline instead
  /// of pushing a new review.
  bool get _isRePickScreen => _activeParams?['isRePick'] == true;

  @override
  void initState() {
    super.initState();
    _activeParams = widget.searchParams;
    if (_activeParams != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_isRePickScreen) {
          final legIndex =
              (_activeParams!['rePickLegIndex'] as int?) ?? 0;
          await ref
              .read(flightSearchProvider.notifier)
              .jumpToLeg(legIndex);
        } else if (_isMultiCityLegFlow) {
          await ref
              .read(flightSearchProvider.notifier)
              .startMultiCityLegFlow(_activeParams!);
        } else {
          await ref
              .read(flightSearchProvider.notifier)
              .searchFlights(_activeParams!);
        }
        if (mounted) resetRefreshCountdown();
      });
    }
  }

  @override
  Future<void> onLifecycleRefresh() async {
    if (_activeParams == null) return;
    // Don't auto-refresh the leg-by-leg flow — it would reset the
    // user's progress. Fare-refresh resumes in the booking screen.
    if (_isMultiCityLegFlow) return;
    // Silent: keep the existing list visible while the new results
    // come in, so the user doesn't see a loader / shimmer flash on
    // every periodic tick.
    await ref
        .read(flightSearchProvider.notifier)
        .searchFlights(_activeParams!, silent: true);
  }

  /// Auto re-search at the app-wide flight-fare cadence while the user
  /// sits on results, so fares stay fresh without a manual refresh.
  @override
  Duration? get periodicRefreshInterval => kFlightFareRefreshInterval;

  /// Toolbar count label — shows live count even mid-search so the
  /// user sees results streaming in instead of staring at "Searching..".
  String _buildCountLabel({required int count, required bool isSearching}) {
    final plural = count == 1 ? 'flight' : 'flights';
    if (isSearching) {
      if (count == 0) return 'Searching for flights…';
      return '$count $plural found so far…';
    }
    return '$count $plural found';
  }

  List<Map<String, dynamic>> _getFilteredFlights(List<Map<String, dynamic>> flights) {
    var filtered = flights;

    if (_selectedStops.isNotEmpty) {
      filtered = filtered.where((f) {
        final stops = (f['stops'] as int?) ?? 0;
        if (_selectedStops.contains(2)) {
          // "2+ Stops" means stops >= 2
          return _selectedStops.contains(stops) || (stops >= 2 && _selectedStops.contains(2));
        }
        return _selectedStops.contains(stops);
      }).toList();
    }

    if (_selectedAirlines.isNotEmpty) {
      filtered = filtered.where((f) {
        final airline = f['airlineName'] as String? ?? '';
        return _selectedAirlines.contains(airline);
      }).toList();
    }

    return filtered;
  }

  /// Picks the three "top" flights for the differentiation badges:
  /// cheapest (lowest price), fastest (shortest total duration), and
  /// best (lowest weighted price+duration score, mirroring the Best
  /// sort). Returns -1 for any category that can't be resolved (empty
  /// list, all-infinite values, etc.).
  _TopPicks _computeTopPicks(List<Map<String, dynamic>> flights) {
    if (flights.isEmpty) return const _TopPicks(-1, -1, -1);

    final prices = <double>[];
    final durations = <double>[];
    double minP = double.infinity, maxP = -double.infinity;
    double minD = double.infinity, maxD = -double.infinity;
    int cheapestIdx = -1, fastestIdx = -1;

    for (var i = 0; i < flights.length; i++) {
      final f = flights[i];
      final p = (f['price'] is num)
          ? (f['price'] as num).toDouble()
          : double.tryParse((f['price'] ?? '').toString()) ?? double.infinity;
      // For round-trip and multi-city, sum duration across every leg so
      // "Fastest" reflects the total trip time, not just leg 1.
      final d = _totalTripDurationMinutes(f);
      prices.add(p);
      durations.add(d.toDouble());

      if (p.isFinite && (cheapestIdx == -1 || p < prices[cheapestIdx])) {
        cheapestIdx = i;
      }
      if (d > 0 && (fastestIdx == -1 || d < durations[fastestIdx])) {
        fastestIdx = i;
      }
      if (p.isFinite) {
        if (p < minP) minP = p;
        if (p > maxP) maxP = p;
      }
      if (d > 0) {
        final dd = d.toDouble();
        if (dd < minD) minD = dd;
        if (dd > maxD) maxD = dd;
      }
    }

    final pSpread = maxP - minP;
    final dSpread = maxD - minD;
    int bestIdx = -1;
    double bestScore = double.infinity;
    for (var i = 0; i < flights.length; i++) {
      final p = prices[i];
      final d = durations[i];
      if (!p.isFinite) continue;
      final pn = pSpread > 0 ? (p - minP) / pSpread : 0.0;
      final dn = dSpread > 0 && d > 0 ? (d - minD) / dSpread : 0.0;
      final score = 0.6 * pn + 0.4 * dn;
      if (score < bestScore) {
        bestScore = score;
        bestIdx = i;
      }
    }

    return _TopPicks(bestIdx, cheapestIdx, fastestIdx);
  }

  /// Parses an `Nh Mm` style duration string (e.g. `"7h 30m"`) into
  /// minutes. Returns 0 on parse failure so the caller can use a
  /// `> 0` guard to skip unranked flights.
  int _durationToMinutes(String s) {
    final m = RegExp(r'(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?').firstMatch(s);
    if (m == null) return 0;
    final h = int.tryParse(m.group(1) ?? '') ?? 0;
    final mm = int.tryParse(m.group(2) ?? '') ?? 0;
    return h * 60 + mm;
  }

  /// Total in-air time across every leg of the trip. For one-way this
  /// is just leg 1; for round-trip it adds the return; for multi-city
  /// it sums every hop. Falls back to the top-level `duration` field
  /// when `allLegs` is missing — handles older parsed flights without
  /// breaking the badge logic.
  int _totalTripDurationMinutes(Map<String, dynamic> flight) {
    final legs = (flight['allLegs'] as List?) ?? const [];
    if (legs.isEmpty) {
      return _durationToMinutes((flight['duration'] ?? '').toString());
    }
    var total = 0;
    for (final leg in legs) {
      if (leg is! Map) continue;
      total += _durationToMinutes((leg['duration'] ?? '').toString());
    }
    if (total == 0) {
      return _durationToMinutes((flight['duration'] ?? '').toString());
    }
    return total;
  }

  Set<String> _getAvailableAirlines(List<Map<String, dynamic>> flights) {
    return flights
        .map((f) => f['airlineName'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toSet();
  }

  /// Builds the per-leg params Map the shared `FlightRouteHeader`
  /// consumes so the title row shows the current leg's route and date
  /// instead of the full trip's first/last codes.
  Map<String, dynamic> _currentLegHeaderParams(
      Map<String, dynamic> baseParams, int legIndex) {
    final legs =
        (baseParams['legs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (legIndex >= legs.length) return baseParams;
    final leg = legs[legIndex];
    return {
      ...baseParams,
      'departureCode': leg['departureCode'],
      'arrivalCode': leg['arrivalCode'],
      'outboundDate': leg['outboundDate'],
      'inboundDate': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Snack-only listener: surfaces a brief confirmation when a new
    // leg is added to the selection (forward flow only — re-picks
    // don't grow the list). Navigation is handled explicitly in the
    // flight card's onTap so that, with multiple results screens in
    // the stack (forward results + a pushed re-pick results), only
    // the active one navigates.
    ref.listen<FlightSearchState>(flightSearchProvider, (prev, next) {
      final prevCount = prev?.selectedLegFlights.length ?? 0;
      final nextCount = next.selectedLegFlights.length;
      if (nextCount > prevCount && next.isMultiCityLegFlow) {
        final justPicked = next.selectedLegFlights.last;
        _showLegSelectedSnack(justPicked, nextCount, next.totalLegs);
      }
    });

    final searchState = ref.watch(flightSearchProvider);
    final currencyState = ref.watch(currencyProvider);
    final selectedCurrency = currencyState.selected;
    final params = _activeParams;
    final filteredFlights = _getFilteredFlights(searchState.flights);
    final isLegFlow = searchState.isMultiCityLegFlow;
    final headerParams = isLegFlow && params != null
        ? _currentLegHeaderParams(params, searchState.currentLegIndex)
        : params;

    return PopScope(
      // Re-pick screens can always pop — the state on disk already
      // has the user's original selections intact, so backing out is
      // non-destructive. Only guard the forward flow where mid-build
      // selections would be lost.
      canPop: _isRePickScreen ||
          !isLegFlow ||
          searchState.selectedLegFlights.isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await _confirmDiscardLegFlow(context);
        if (discard && context.mounted) {
          ref.read(flightSearchProvider.notifier).resetMultiCityLegFlow();
          context.pop();
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // Elegant journey header — compact. Status label + filter/
          // sort/modify live below (scroll away naturally with the list)
          // so the header stays tight.
          BookingJourneyHeader(
            title: isLegFlow
                ? 'Leg ${searchState.currentLegIndex + 1} of ${searchState.totalLegs}'
                : params?['tripType'] == 'round-trip'
                    ? 'Round Trip'
                    : params?['tripType'] == 'multi'
                        ? 'Multi-City'
                        : 'One Way',
            params: headerParams,
            showStepper: false,
          ),

          // Thin linear progress bar pinned right below the header
          // while results are streaming in. Disappears the instant the
          // search completes so it doesn't sit there idle.
          if (searchState.isSearching)
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  backgroundColor: Color(0x14000000),
                ),
              ),
            ),

          // Results toolbar — count on the left, actions on the right.
          // Now also shown WHILE searching so the user sees the count
          // climb live ("3 flights found so far…" → "20 flights found").
          if (searchState.flights.isNotEmpty || searchState.isSearching)
            SliverToBoxAdapter(
              child: _ResultsToolbar(
                countLabel: _buildCountLabel(
                  count: filteredFlights.length,
                  isSearching: searchState.isSearching,
                ),
                disabled: false,
                filterActive: _selectedStops.isNotEmpty ||
                    _selectedAirlines.isNotEmpty,
                onFilter: () => _showFilters(context, searchState.flights),
                onModify: isLegFlow
                    ? null
                    : () => _showModifySearch(context),
              ),
            ),

          // Sort row — three chips on their own row beneath the
          // count/Filter toolbar so they have breathing room and the
          // active state is visually obvious.
          if (searchState.flights.isNotEmpty)
            SliverToBoxAdapter(
              child: _SortRow(
                currentSort: _currentSort,
                onBest: () => _applySort('best'),
                onCheapest: () => _applySort('price_asc'),
                onFastest: () => _applySort('duration'),
              ),
            ),

          // Multi-city stepper — shown whenever we're in the leg-by-leg
          // flow so the user always sees where they are in the trip,
          // even before they've picked their first flight.
          if (isLegFlow)
            SliverToBoxAdapter(
              child: _LegStepper(
                searchParams: params,
                totalLegs: searchState.totalLegs,
                currentIndex: searchState.currentLegIndex,
                selectedLegFlights: searchState.selectedLegFlights,
                currency: selectedCurrency,
                onTapDoneLeg: _changeLegFromStepper,
              ),
            ),

          // (Old "Searching..." block removed — replaced by the slim
          // linear progress bar above the toolbar, which is less
          // visually noisy and lives flush against the header.)

          // Active Filters Indicator
          if (_selectedStops.isNotEmpty || _selectedAirlines.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + 4, AppSpacing.md, 0),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (_selectedStops.isNotEmpty)
                      ..._selectedStops.map((s) => Chip(
                            label: Text(
                              s == 0 ? 'Direct' : s == 1 ? '1 Stop' : '2+ Stops',
                              style: AppTextStyles.bodyMd,
                            ),
                            deleteIcon: Icon(Icons.close, size: AppIconSize.md),
                            onDeleted: () {
                              setState(() => _selectedStops.remove(s));
                            },
                            visualDensity: VisualDensity.compact,
                          )),
                    if (_selectedAirlines.isNotEmpty)
                      ..._selectedAirlines.map((a) => Chip(
                            label: Text(
                              a.length > 15 ? '${a.substring(0, 15)}...' : a,
                              style: AppTextStyles.bodyMd,
                            ),
                            deleteIcon: Icon(Icons.close, size: AppIconSize.md),
                            onDeleted: () {
                              setState(() => _selectedAirlines.remove(a));
                            },
                            visualDensity: VisualDensity.compact,
                          )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStops = {};
                          _selectedAirlines = {};
                        });
                      },
                      child: Chip(
                        label: Text('Clear All', style: AppTextStyles.bodyMd.copyWith(color: AppColors.error)),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // (count + filter/sort moved into FlightRouteHeader actions)

          // Flight List or States
          if (searchState.isSearching && searchState.flights.isEmpty)
            SliverPadding(
              padding: AppPadding.cardLg,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildShimmerCard(),
                  childCount: 5,
                ),
              ),
            )
          else if (searchState.flights.isEmpty && !searchState.isSearching)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else if (searchState.error != null && searchState.flights.isEmpty)
            SliverFillRemaining(
              child: _buildErrorState(searchState.error!),
            )
          else if (filteredFlights.isEmpty)
            SliverFillRemaining(
              child: _buildNoFilterResults(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, 100),
              sliver: Builder(builder: (context) {
                // Identify the three "top picks" so the matching tag
                // stays on the correct card regardless of sort order:
                //   • cheapest  → lowest price
                //   • fastest   → shortest total duration
                //   • best      → lowest weighted (price + duration) score
                // We carry the winning indices, not the values, so cards
                // with tied stats only get the tag once.
                final tagged = _computeTopPicks(filteredFlights);
                return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final flight = filteredFlights[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
                      child: FlightCard(
                        flight: flight,
                        isCheapest: index == tagged.cheapestIndex,
                        isBest: index == tagged.bestIndex,
                        isFastest: index == tagged.fastestIndex,
                        selectedCurrency: selectedCurrency,
                        onTap: () async {
                          if (isLegFlow) {
                            // Clear filters so the next leg's list
                            // doesn't inherit stale chips.
                            setState(() {
                              _selectedStops = {};
                              _selectedAirlines = {};
                            });
                            // Snapshot state BEFORE calling the
                            // notifier so we can tell whether this
                            // tap will complete the trip in forward
                            // flow (and therefore should push review
                            // afterwards).
                            final before =
                                ref.read(flightSearchProvider);
                            final wasRePick = before.currentLegIndex <
                                before.selectedLegFlights.length;
                            final willCompleteForward = !wasRePick &&
                                before.currentLegIndex + 1 >=
                                    before.totalLegs;
                            await ref
                                .read(flightSearchProvider.notifier)
                                .selectLegFlight(flight);
                            if (!context.mounted) return;
                            if (_isRePickScreen) {
                              // Pop this re-pick screen — review is
                              // underneath and will rebuild with the
                              // updated selection.
                              context.pop();
                            } else if (willCompleteForward) {
                              context.push(
                                  '/flights/multi-city-review');
                            }
                          } else {
                            // Single source of truth — start the
                            // booking session here so booking /
                            // payment / ticket all read pax + fare
                            // from one place. `extra:` is kept for
                            // backwards compatibility while the
                            // downstream screens migrate.
                            ref
                                .read(bookingSessionProvider.notifier)
                                .start(
                                  flight: flight,
                                  searchParams: params ?? {},
                                );
                            context.push(
                              '/booking',
                              extra: {
                                ...flight,
                                'adultsCount': params?['adultsCount'] ?? 1,
                                'childrenCount':
                                    params?['childrenCount'] ?? 0,
                                'infantsCount': params?['infantsCount'] ?? 0,
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                  childCount: filteredFlights.length,
                ),
              );
              }),
            ),
        ],
      ),
    ),
    );
  }

  /// Brief confirmation when a leg is picked in the multi-city flow —
  /// names the airline and price so the user knows their tap landed,
  /// and previews the next step so the transition doesn't feel abrupt.
  void _showLegSelectedSnack(
      Map<String, dynamic> picked, int doneCount, int totalLegs) {
    final airline = (picked['airlineName'] ?? '').toString();
    final dep = (picked['departureCode'] ?? '').toString();
    final arr = (picked['arrivalCode'] ?? '').toString();
    final isLast = doneCount >= totalLegs;
    final message = isLast
        ? 'Leg $doneCount picked · $dep → $arr · Reviewing trip…'
        : 'Leg $doneCount picked · $dep → $arr${airline.isEmpty ? '' : ' · $airline'}';
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(milliseconds: 1800),
        ),
      );
  }

  /// Guards the back gesture during a multi-city leg flow so the user
  /// doesn't accidentally blow away selections they've already made.
  Future<bool> _confirmDiscardLegFlow(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard trip?'),
        content: const Text(
            'You will lose the legs you have already selected. Start again?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Re-opens a done leg's results list so the user can swap its
  /// flight. Non-destructive — every other leg keeps its existing
  /// selection, and the user lands back on review as soon as they
  /// pick a replacement flight.
  Future<void> _changeLegFromStepper(int targetIndex) async {
    final current = ref.read(flightSearchProvider);
    if (targetIndex >= current.selectedLegFlights.length) return;
    await ref.read(flightSearchProvider.notifier).jumpToLeg(targetIndex);
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flight_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            AppGap.lg,
            Text(
              'No flights found',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppGap.sm,
            Text(
              'Try different dates or airports',
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Modify Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoFilterResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.filter_list_off,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            AppGap.lg,
            Text(
              'No matching flights',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppGap.sm,
            Text(
              'Try adjusting your filters',
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedStops = {};
                  _selectedAirlines = {};
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            AppGap.lg,
            Text(
              'Something went wrong',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppGap.sm,
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            ElevatedButton(
              onPressed: () {
                if (_activeParams == null) return;
                final notifier =
                    ref.read(flightSearchProvider.notifier);
                // In the leg-by-leg flow, retry the current leg so
                // we don't wipe selectedLegFlights / currentLegIndex.
                if (ref.read(flightSearchProvider).isMultiCityLegFlow) {
                  notifier.retryCurrentLeg();
                } else {
                  notifier.searchFlights(_activeParams!);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showModifySearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottom = MediaQuery.of(context).padding.bottom;
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, bottom > 0 ? bottom : 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 10),
                Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 14, 0, 0),
                  child: Row(children: [
                    Text('Modify Search', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ]),
                ),
                FlightSearchForm(
                  initialParams: _activeParams,
                  onSearch: (newParams) {
                    Navigator.pop(context);
                    setState(() {
                      _activeParams = newParams;
                      _selectedStops = {};
                      _selectedAirlines = {};
                      _currentSort = 'best';
                    });
                    ref.read(flightSearchProvider.notifier).searchFlights(newParams);
                  },
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  void _showFilters(BuildContext context, List<Map<String, dynamic>> allFlights) {
    final availableAirlines = _getAvailableAirlines(allFlights);
    var tempStops = Set<int>.from(_selectedStops);
    var tempAirlines = Set<String>.from(_selectedAirlines);

    showAppBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const Spacer(),
              GestureDetector(
                onTap: () { setModalState(() { tempStops = {}; tempAirlines = {}; }); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(20)),
                  child: Text('Reset', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.error)),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            Text('Stops', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            Row(children: [
              _filterChip('Direct', tempStops.contains(0), () => setModalState(() => tempStops.contains(0) ? tempStops.remove(0) : tempStops.add(0))),
              const SizedBox(width: 8),
              _filterChip('1 Stop', tempStops.contains(1), () => setModalState(() => tempStops.contains(1) ? tempStops.remove(1) : tempStops.add(1))),
              const SizedBox(width: 8),
              _filterChip('2+ Stops', tempStops.contains(2), () => setModalState(() => tempStops.contains(2) ? tempStops.remove(2) : tempStops.add(2))),
            ]),

            if (availableAirlines.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('Airlines', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: availableAirlines.map((airline) {
                final selected = tempAirlines.contains(airline);
                return _filterChip(
                  airline.length > 18 ? '${airline.substring(0, 18)}...' : airline,
                  selected,
                  () => setModalState(() => selected ? tempAirlines.remove(airline) : tempAirlines.add(airline)),
                );
              }).toList()),
            ],

            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
              onPressed: () { setState(() { _selectedStops = tempStops; _selectedAirlines = tempAirlines; }); Navigator.pop(ctx); },
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.5),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.textPrimary)),
      ),
    );
  }

  void _applySort(String sortKey) {
    setState(() => _currentSort = sortKey);
    ref.read(flightSearchProvider.notifier).sortFlights(sortKey);
  }
}

/// Horizontal progress stepper rendered above the results list while
/// the user is in the multi-city leg-by-leg flow.
///
/// Shows one node per leg with three states:
///   ✓ Done     — tappable, drops back to re-pick this leg
///   ● Current  — filled primary, pulses gently to draw the eye
///   ○ Pending  — outline only, not yet reachable
///
/// A thin connecting line ties consecutive nodes together, and a
/// running total is shown on the right once the user has picked at
/// least one leg. The whole strip stays inside the scrollable viewport
/// so it doesn't fight the pinned header for vertical space.
class _LegStepper extends StatelessWidget {
  final Map<String, dynamic>? searchParams;
  final int totalLegs;
  final int currentIndex;
  final List<Map<String, dynamic>> selectedLegFlights;
  final Currency? currency;
  final Future<void> Function(int legIndex) onTapDoneLeg;

  const _LegStepper({
    required this.searchParams,
    required this.totalLegs,
    required this.currentIndex,
    required this.selectedLegFlights,
    required this.currency,
    required this.onTapDoneLeg,
  });

  List<Map<String, dynamic>> get _legs {
    final raw = (searchParams?['legs'] as List?) ?? const [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final legs = _legs;
    if (legs.isEmpty || totalLegs == 0) return const SizedBox.shrink();

    double total = 0;
    for (final f in selectedLegFlights) {
      total += (f['price'] as num?)?.toDouble() ?? 0;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm + 2, AppSpacing.md, 0),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md - 2, AppSpacing.md, AppSpacing.md - 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.12), width: 0.6),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.alt_route_rounded,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Your Trip',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3),
              ),
              const Spacer(),
              if (selectedLegFlights.isNotEmpty) ...[
                Text(
                  'Total',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 6),
                Text(
                  formatCurrencyPrice(total, currency),
                  style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < totalLegs; i++) ...[
                  _buildStepNode(context, i, legs),
                  if (i < totalLegs - 1) _buildConnector(i),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(
      BuildContext context, int i, List<Map<String, dynamic>> legs) {
    final leg = i < legs.length ? legs[i] : const <String, dynamic>{};
    final dep = (leg['departureCode'] ?? '').toString();
    final arr = (leg['arrivalCode'] ?? '').toString();
    // `current` takes priority over `done` so re-picking an already
    // selected leg (e.g. the user tapped Change on Leg 1 while Legs 2
    // and 3 are still picked) shows Leg 1 as the active step, not as
    // a completed one.
    final isCurrent = i == currentIndex;
    final isDone = !isCurrent && i < selectedLegFlights.length;
    final isPending = !isDone && !isCurrent;

    final ringColor = isDone
        ? AppColors.success
        : isCurrent
            ? AppColors.primary
            : AppColors.border;
    final fillColor = isDone
        ? AppColors.success
        : isCurrent
            ? AppColors.primary
            : Colors.white;

    final inner = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 15, color: Colors.white)
                : Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isCurrent
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$dep → $arr',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            color: isPending
                ? AppColors.textSecondary
                : AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        if (isDone) ...[
          const SizedBox(height: 2),
          Text(
            formatCurrencyPrice(
                (selectedLegFlights[i]['price'] as num?)?.toDouble() ?? 0,
                currency),
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ] else if (isCurrent) ...[
          const SizedBox(height: 2),
          Text(
            'Choosing…',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ],
    );

    if (!isDone) return Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: inner);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onTapDoneLeg(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: inner,
      ),
    );
  }

  Widget _buildConnector(int i) {
    // Line between step `i` and step `i+1`. Green when the preceding
    // leg is done (progress reached this point), muted otherwise.
    final reached = i < selectedLegFlights.length;
    return Padding(
      padding: const EdgeInsets.only(top: 14), // align with node centers
      child: Container(
        width: 26,
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: reached ? AppColors.success : AppColors.border,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

/// Results toolbar — small compact row that sits above the flight list
/// (not inside the header). Scrolls away with the list so the pinned
/// header stays tight.
class _ResultsToolbar extends StatelessWidget {
  final String countLabel;
  final bool disabled;
  final bool filterActive;
  final VoidCallback? onFilter;
  final VoidCallback? onModify;

  const _ResultsToolbar({
    required this.countLabel,
    required this.disabled,
    required this.filterActive,
    required this.onFilter,
    required this.onModify,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              countLabel,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
          ),
          if (onFilter != null)
            _ToolbarChip(
              icon: Icons.tune_rounded,
              label: 'Filter',
              onTap: onFilter,
              activeDot: filterActive,
              disabled: disabled,
            ),
          if (onFilter != null && onModify != null) const SizedBox(width: 6),
          if (onModify != null)
            _ToolbarChip(
              icon: Icons.edit_outlined,
              label: 'Modify',
              onTap: onModify,
              disabled: disabled,
            ),
        ],
      ),
    );
  }
}

/// Sort selector — three full-width-equally-distributed chips on
/// their own row (Best · Cheapest · Fastest). Tapping one applies
/// that sort and visually highlights the selected chip.
class _SortRow extends StatelessWidget {
  final String currentSort;
  final VoidCallback onBest;
  final VoidCallback onCheapest;
  final VoidCallback onFastest;

  const _SortRow({
    required this.currentSort,
    required this.onBest,
    required this.onCheapest,
    required this.onFastest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          _ToolbarChip(
            icon: Icons.auto_awesome_rounded,
            label: 'Best',
            onTap: onBest,
            selected: currentSort == 'best',
            center: true,
          ),
          const SizedBox(width: 8),
          _ToolbarChip(
            icon: Icons.attach_money_rounded,
            label: 'Cheapest',
            onTap: onCheapest,
            selected: currentSort == 'price_asc',
            center: true,
          ),
          const SizedBox(width: 8),
          _ToolbarChip(
            icon: Icons.flash_on_rounded,
            label: 'Fastest',
            onTap: onFastest,
            selected: currentSort == 'duration',
            center: true,
          ),
        ],
      ),
    );
  }
}

class _ToolbarChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool activeDot;
  final bool selected;
  final bool disabled;
  final bool center;

  const _ToolbarChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.activeDot = false,
    this.selected = false,
    this.disabled = false,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !disabled;
    final fg = selected ? Colors.white : AppColors.primary;
    final bg = selected ? AppColors.primary : Colors.white;
    final border = selected ? AppColors.primary : AppColors.border;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            child: Row(
              mainAxisSize: center ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment:
                  center ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(icon, size: 13, color: fg),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fg,
                    letterSpacing: -0.05,
                  ),
                ),
                if (activeDot) ...[
                  const SizedBox(width: 5),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Indices of the three "top pick" flights for tag rendering. `-1`
/// for any category that couldn't be resolved (empty list, all prices
/// missing, etc.) — callers compare `index == ...` so `-1` reliably
/// matches nothing.
class _TopPicks {
  final int bestIndex;
  final int cheapestIndex;
  final int fastestIndex;
  const _TopPicks(this.bestIndex, this.cheapestIndex, this.fastestIndex);
}
