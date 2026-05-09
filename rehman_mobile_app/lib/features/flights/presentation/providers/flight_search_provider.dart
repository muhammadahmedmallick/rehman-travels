import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../data/models/filter_sort_config.dart';
import '../../data/utils/flight_score_engine.dart';

// Flight Search State
class FlightSearchState extends Equatable {
  final bool isSearching;
  final List<Map<String, dynamic>> flights;
  final String? error;
  final int processedCount;
  final int totalProviders;
  final String currentProvider;
  final Map<String, dynamic>? searchParams;

  // Multi-city leg-by-leg flow (Sastaticket-style)
  final bool isMultiCityLegFlow;
  final int currentLegIndex;
  final int totalLegs;
  final List<Map<String, dynamic>> selectedLegFlights;
  final bool allLegsSelected;

  const FlightSearchState({
    this.isSearching = false,
    this.flights = const [],
    this.error,
    this.processedCount = 0,
    this.totalProviders = 3,
    this.currentProvider = '',
    this.searchParams,
    this.isMultiCityLegFlow = false,
    this.currentLegIndex = 0,
    this.totalLegs = 0,
    this.selectedLegFlights = const [],
    this.allLegsSelected = false,
  });

  FlightSearchState copyWith({
    bool? isSearching,
    List<Map<String, dynamic>>? flights,
    String? error,
    int? processedCount,
    int? totalProviders,
    String? currentProvider,
    Map<String, dynamic>? searchParams,
    bool? isMultiCityLegFlow,
    int? currentLegIndex,
    int? totalLegs,
    List<Map<String, dynamic>>? selectedLegFlights,
    bool? allLegsSelected,
  }) {
    return FlightSearchState(
      isSearching: isSearching ?? this.isSearching,
      flights: flights ?? this.flights,
      error: error,
      processedCount: processedCount ?? this.processedCount,
      totalProviders: totalProviders ?? this.totalProviders,
      currentProvider: currentProvider ?? this.currentProvider,
      searchParams: searchParams ?? this.searchParams,
      isMultiCityLegFlow: isMultiCityLegFlow ?? this.isMultiCityLegFlow,
      currentLegIndex: currentLegIndex ?? this.currentLegIndex,
      totalLegs: totalLegs ?? this.totalLegs,
      selectedLegFlights: selectedLegFlights ?? this.selectedLegFlights,
      allLegsSelected: allLegsSelected ?? this.allLegsSelected,
    );
  }

  @override
  List<Object?> get props => [
        isSearching, flights, error, processedCount, totalProviders,
        currentProvider, searchParams, isMultiCityLegFlow, currentLegIndex,
        totalLegs, selectedLegFlights, allLegsSelected,
      ];
}

// Flight Search Notifier
class FlightSearchNotifier extends StateNotifier<FlightSearchState> {
  final ApiClient _apiClient;
  final CoreApiClient _coreApiClient;
  final ExaltedApiClient _exaltedApiClient;

  static const List<String> _fallbackProviders = [
    'Sabre', 'Airsial', 'Airblue', 'Airarabia', 'Flydubai',
    'Flyjinnah', 'Airemirate', 'Isaaviations', 'SabreNdc', 'Polani',
  ];

  FlightSearchNotifier(this._apiClient, this._coreApiClient, this._exaltedApiClient) : super(const FlightSearchState());

  // ═══════════════════════════════════════════
  //  PER-LEG RESULTS CACHE
  // ═══════════════════════════════════════════
  //
  // The multi-city leg flow lets the user tab back and forth between
  // legs (via the stepper or the review screen's "Change this leg"
  // link). Without a cache, every tab fires a fresh fan-out across
  // ~12 providers, hammering the backend and leaving the user
  // waiting on a shimmer they already saw seconds ago. We key by a
  // signature of the fields that actually affect results so a
  // re-tap on the same leg reuses whatever we already fetched.
  final Map<String, _LegCacheEntry> _legCache = {};
  static const Duration _legCacheTtl = Duration(minutes: 2);

  /// Monotonic token for in-flight searches. Each new search bumps
  /// it; when a provider response resolves we drop the result if
  /// the token has moved on, so a slow provider from a previous
  /// search can't overwrite fresh state.
  int _searchToken = 0;

  String _legCacheKey(Map<String, dynamic> legParams) {
    final leg = (legParams['legs'] as List?)?.firstOrNull as Map?;
    final dep = (leg?['departureCode'] ?? legParams['departureCode'] ?? '')
        .toString();
    final arr = (leg?['arrivalCode'] ?? legParams['arrivalCode'] ?? '')
        .toString();
    final date = (leg?['outboundDate'] ?? legParams['outboundDate'] ?? '')
        .toString();
    final cabin = (legParams['cabin'] ?? 'Y').toString();
    final a = (legParams['adultsCount'] ?? 1).toString();
    final c = (legParams['childrenCount'] ?? 0).toString();
    final i = (legParams['infantsCount'] ?? 0).toString();
    return '$dep|$arr|$date|$cabin|$a|$c|$i';
  }

  Future<List<String>> _fetchProviders() async {
    try {
      final response = await _coreApiClient.get<Map<String, dynamic>>(ApiEndpoints.flightProviders);
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data!['providers'] as List?;
        if (list != null && list.isNotEmpty) {
          return list.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('Failed to fetch providers, using fallback: $e');
    }
    return _fallbackProviders;
  }

  Future<void> searchFlights(Map<String, dynamic> params,
      {bool silent = false}) async {
    final token = ++_searchToken;
    // Silent refresh (timer-driven) keeps the existing flight list and
    // skips the `isSearching` flag so the UI doesn't flash a loader.
    // The list is swapped in-place once the new results arrive.
    if (silent) {
      state = state.copyWith(searchParams: params, error: null);
    } else {
      state = FlightSearchState(isSearching: true, searchParams: params);
    }

    if (kDebugMode) debugPrint('=== FLIGHT SEARCH STARTED (silent=$silent) ===');

    final providers = await _fetchProviders();
    if (token != _searchToken) return;
    if (!silent) state = state.copyWith(totalProviders: providers.length);

    // Fan providers out in parallel. Each provider's result streams
    // into `state.flights` as it arrives — user sees the first
    // provider's results within ~1s instead of waiting for all.
    //
    // Keep a silent-refresh buffer: we only replace the live list
    // at the END of a silent refresh (so the user never sees a
    // half-populated list during fare-refresh ticks).
    String? lastError;
    final calledProviders = <String>[];
    final silentBuffer = silent ? <Map<String, dynamic>>[] : null;

    for (final provider in providers) {
      if (params['cabin'] != 'Y' &&
          (provider == 'AirSial' || provider == 'Airblue')) {
        continue;
      }
      calledProviders.add(provider);
    }

    if (!silent) {
      state = state.copyWith(processedCount: 0);
    }

    var completedCount = 0;
    final completers = <Future<void>>[];

    for (final provider in calledProviders) {
      completers.add(() async {
        List<Map<String, dynamic>> providerResults;
        try {
          providerResults = await _searchProvider(provider, params);
        } catch (e) {
          if (kDebugMode) debugPrint('[$provider] error: $e');
          lastError = '$provider: $e';
          providerResults = const [];
        }

        // Drop late results from a superseded search.
        if (token != _searchToken) return;

        completedCount++;

        if (silent) {
          // Collect silently — don't touch `state.flights` yet.
          silentBuffer!.addAll(providerResults);
          return;
        }

        // Non-silent: stream results into the live list.
        // Re-sort on every arrival so cheapest always floats to top
        // regardless of which provider responded first.
        final merged = [...state.flights, ...providerResults]
          ..sort(_defaultFlightCompare);

        state = state.copyWith(
          flights: merged,
          processedCount: completedCount,
          currentProvider: provider,
          // Keep isSearching true until every provider is done, so
          // the linear progress bar + "N flights found so far…"
          // stay visible during the streaming window.
          isSearching: completedCount < calledProviders.length,
          error: null,
        );

        if (kDebugMode) {
          debugPrint(
              '=== [$provider] → ${providerResults.length} flights '
              '(total ${merged.length}, $completedCount/${calledProviders.length} done) ===');
        }
      }());
    }

    await Future.wait(completers);

    // Drop late results from a superseded search.
    if (token != _searchToken) return;

    // Silent refresh — now commit the full buffer in one swap so
    // the user never sees a half-populated list mid-refresh. Keep
    // the previous list if the refresh came back empty (transient
    // provider hiccup shouldn't nuke a good list).
    if (silent) {
      final buffered = silentBuffer!..sort(_defaultFlightCompare);
      if (buffered.isEmpty) {
        if (kDebugMode) {
          debugPrint('=== SILENT REFRESH: no results, keeping previous ===');
        }
        return;
      }
      state = state.copyWith(
        flights: buffered,
        processedCount: calledProviders.length,
        currentProvider: '',
        isSearching: false,
        error: null,
      );
      if (kDebugMode) {
        debugPrint('=== SILENT REFRESH COMPLETE: ${buffered.length} flights ===');
      }
      return;
    }

    // Final flush — make sure isSearching is off and error reflects
    // the end state (empty list + error = show error UI).
    state = state.copyWith(
      isSearching: false,
      processedCount: calledProviders.length,
      currentProvider: '',
      error: state.flights.isEmpty ? lastError : null,
    );

    if (kDebugMode) {
      debugPrint('=== SEARCH COMPLETE: ${state.flights.length} flights ===');
    }
  }

  void sortFlights(String sortBy, {FilterSortConfig? config}) {
    final sorted = List<Map<String, dynamic>>.from(state.flights);
    switch (sortBy) {
      case 'best':
        // Backend-driven "Best" when the filter-config has loaded —
        // uses [FlightScoreEngine] to apply the weights / formulas /
        // ranking rules from `/api/core/filter-config/flights/`.
        // Falls back to the local 60/40 price+duration blend if the
        // config isn't available yet, so the screen never blanks.
        if (config != null && config.factors.isNotEmpty) {
          _sortByEngineBestScore(sorted, config);
        } else {
          _sortByBestScore(sorted);
        }
      case 'price_asc':
        sorted.sort((a, b) => ((a['price'] as num?) ?? double.infinity).compareTo((b['price'] as num?) ?? double.infinity));
      case 'price_desc':
        sorted.sort((a, b) => ((b['price'] as num?) ?? double.infinity).compareTo((a['price'] as num?) ?? double.infinity));
      case 'duration':
        sorted.sort((a, b) => _parseDurationMinutes(a['duration'] ?? '').compareTo(_parseDurationMinutes(b['duration'] ?? '')));
      case 'layover_asc':
        // Direct flights (0 stops → 0 layover) land at the top
        // automatically because their layover sum is 0. Ties fall back
        // to price so users still see the cheapest short-layover first.
        sorted.sort((a, b) {
          final la = _totalLayoverMinutes(a);
          final lb = _totalLayoverMinutes(b);
          final cmp = la.compareTo(lb);
          if (cmp != 0) return cmp;
          final pa = (a['price'] as num?) ?? double.infinity;
          final pb = (b['price'] as num?) ?? double.infinity;
          return pa.compareTo(pb);
        });
      case 'departure':
        sorted.sort((a, b) => (a['departureTime'] ?? '99:99').toString().compareTo((b['departureTime'] ?? '99:99').toString()));
    }
    state = state.copyWith(flights: sorted);
  }

  /// Backend-driven "best" sort — runs [FlightScoreEngine] over the
  /// flights, then orders by descending `bestScore` (highest = best).
  /// Used when `/api/core/filter-config/flights/` has been fetched
  /// successfully; otherwise [_sortByBestScore] handles it locally.
  void _sortByEngineBestScore(
    List<Map<String, dynamic>> flights,
    FilterSortConfig config,
  ) {
    if (flights.isEmpty) return;
    final engine = FlightScoreEngine(config);
    final scores = engine.score(flights);
    final indexed = List<int>.generate(flights.length, (i) => i);
    indexed.sort((a, b) {
      final cmp = scores[b].bestScore.compareTo(scores[a].bestScore);
      if (cmp != 0) return cmp;
      // Deterministic tiebreak: cheaper first, then shorter — matches
      // the local fallback's tiebreak logic so the two paths are
      // indistinguishable when the data is similar enough.
      final priceCmp = scores[a].priceValue.compareTo(scores[b].priceValue);
      if (priceCmp != 0) return priceCmp;
      return scores[a].durationMinutes.compareTo(scores[b].durationMinutes);
    });
    final reordered = [for (final i in indexed) flights[i]];
    flights
      ..clear()
      ..addAll(reordered);
  }

  /// Weighted "best" sort — normalizes price and duration to 0..1
  /// across the result set, then ranks by `0.6*price + 0.4*duration`.
  /// Falls back to cheapest-first when the price spread is zero (all
  /// fares identical), so the ordering is still deterministic.
  void _sortByBestScore(List<Map<String, dynamic>> flights) {
    if (flights.isEmpty) return;

    double minP = double.infinity, maxP = -double.infinity;
    double minD = double.infinity, maxD = -double.infinity;
    final prices = <double>[];
    final durations = <double>[];

    for (final f in flights) {
      final p = (f['price'] as num?)?.toDouble() ?? double.infinity;
      final d = _parseDurationMinutes((f['duration'] ?? '').toString()).toDouble();
      prices.add(p);
      durations.add(d);
      if (p.isFinite) {
        if (p < minP) minP = p;
        if (p > maxP) maxP = p;
      }
      if (d > 0) {
        if (d < minD) minD = d;
        if (d > maxD) maxD = d;
      }
    }

    final pSpread = (maxP - minP);
    final dSpread = (maxD - minD);
    if (pSpread <= 0 && dSpread <= 0) {
      flights.sort(_defaultFlightCompare);
      return;
    }

    double scoreOf(int i) {
      final p = prices[i];
      final d = durations[i];
      final pn = pSpread > 0 && p.isFinite ? (p - minP) / pSpread : 0.0;
      final dn = dSpread > 0 && d > 0 ? (d - minD) / dSpread : 0.0;
      return 0.6 * pn + 0.4 * dn;
    }

    final indexed = List.generate(flights.length, (i) => i);
    indexed.sort((a, b) {
      final cmp = scoreOf(a).compareTo(scoreOf(b));
      if (cmp != 0) return cmp;
      // Deterministic tiebreak: cheaper first, then shorter.
      final priceCmp = prices[a].compareTo(prices[b]);
      if (priceCmp != 0) return priceCmp;
      return durations[a].compareTo(durations[b]);
    });

    final reordered = [for (final i in indexed) flights[i]];
    flights
      ..clear()
      ..addAll(reordered);
  }

  /// Default cheapest-first comparator with deterministic tiebreakers
  /// (layover → duration → stops). Used by every "fresh sort" entry
  /// point — main search and per-leg multi-city — so two flights with
  /// the same price always land in the same order regardless of which
  /// provider answered first.
  int _defaultFlightCompare(
      Map<String, dynamic> a, Map<String, dynamic> b) {
    final priceA = (a['price'] as num?) ?? double.infinity;
    final priceB = (b['price'] as num?) ?? double.infinity;
    final byPrice = priceA.compareTo(priceB);
    if (byPrice != 0) return byPrice;

    final byLayover =
        _totalLayoverMinutes(a).compareTo(_totalLayoverMinutes(b));
    if (byLayover != 0) return byLayover;

    final byDuration = _parseDurationMinutes((a['duration'] ?? '').toString())
        .compareTo(_parseDurationMinutes((b['duration'] ?? '').toString()));
    if (byDuration != 0) return byDuration;

    final stopsA = (a['stops'] as int?) ?? 0;
    final stopsB = (b['stops'] as int?) ?? 0;
    return stopsA.compareTo(stopsB);
  }

  int _parseDurationMinutes(String duration) {
    final hMatch = RegExp(r'(\d+)\s*h', caseSensitive: false).firstMatch(duration);
    final mMatch = RegExp(r'(\d+)\s*m', caseSensitive: false).firstMatch(duration);
    final hours = hMatch != null ? int.tryParse(hMatch.group(1)!) ?? 0 : 0;
    final minutes = mMatch != null ? int.tryParse(mMatch.group(1)!) ?? 0 : 0;
    return hours * 60 + minutes;
  }

  /// Sums layover minutes across every connection in every leg. For a
  /// non-stop flight this is 0; for a 2-stop trip it's gap1 + gap2.
  /// Cross-day connections are honored via the segment's `arrivalDate`
  /// / `departureDate` so an overnight wait doesn't read as a negative
  /// number and flip sort order. Mirrors the math in `_ConnectionStrip._waitTime`.
  int _totalLayoverMinutes(Map<String, dynamic> flight) {
    final legs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>();
    if (legs == null || legs.isEmpty) return 0;
    int total = 0;
    for (final leg in legs) {
      final segs = (leg['segments'] as List?)?.cast<Map<String, dynamic>>();
      if (segs == null || segs.length < 2) continue;
      for (int i = 0; i < segs.length - 1; i++) {
        final prev = segs[i];
        final next = segs[i + 1];
        final arrMin = _timeToMinutes((prev['arrivalTime'] ?? '').toString());
        final depMin = _timeToMinutes((next['departureTime'] ?? '').toString());
        if (arrMin == null || depMin == null) continue;
        var diff = depMin - arrMin;
        final arrDate = (prev['arrivalDate'] ?? '').toString();
        final depDate = (next['departureDate'] ?? '').toString();
        if (arrDate.isNotEmpty && depDate.isNotEmpty && arrDate != depDate) {
          try {
            final a = DateTime.parse(arrDate);
            final d = DateTime.parse(depDate);
            diff += d.difference(a).inDays * 1440;
          } catch (_) {
            if (diff < 0) diff += 1440;
          }
        } else if (diff < 0) {
          diff += 1440;
        }
        if (diff > 0) total += diff;
      }
    }
    return total;
  }

  int? _timeToMinutes(String hhmm) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(hhmm);
    if (m == null) return null;
    final h = int.tryParse(m.group(1)!);
    final min = int.tryParse(m.group(2)!);
    if (h == null || min == null) return null;
    return h * 60 + min;
  }

  // ═══════════════════════════════════════════
  //  SEARCH PROVIDER - Direct Exalted API
  // ═══════════════════════════════════════════
  Future<List<Map<String, dynamic>>> _searchProvider(
    String provider,
    Map<String, dynamic> params,
  ) async {
    final legs = params['legs'] as List<dynamic>?;
    final tripType = params['tripType']?.toString() ?? 'one-way';

    // Strip display-only fields (departureName / arrivalName) from
    // each leg before posting — the backend rejects extra keys.
    // Those fields are preserved in searchParams state so the UI can
    // still resolve per-leg city names for headers and cards.
    List<Map<String, dynamic>> cleanLegs(List<dynamic> src) {
      return src
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e)
            ..remove('departureName')
            ..remove('arrivalName'))
          .toList();
    }

    // Build payload for Exalted API (legs format)
    final payload = {
      'legs': legs != null
          ? cleanLegs(legs)
          : [
              {
                'departureCode': params['departureCode'],
                'arrivalCode': params['arrivalCode'],
                'outboundDate': params['outboundDate'],
              },
            ],
      'adultsCount': (params['adultsCount'] ?? 1).toString(),
      'childrenCount': (params['childrenCount'] ?? 0).toString(),
      'infantsCount': (params['infantsCount'] ?? 0).toString(),
      'cabin': params['cabin'] ?? 'Y',
      'stop': params['stop'] ?? '',
      'currencyCode': params['currencyCode'] ?? 'PKR',
      'tripType': tripType,
      //'requestType': 50,
      'locale': 'ar',
    };

    if (kDebugMode) print('$provider: POST /$provider with legs: ${(legs ?? []).length}');

    final response = await _exaltedApiClient.post('/$provider', data: payload);

    var responseData = response.data;

    if (kDebugMode) {
      print('$provider response status: ${response.statusCode}');
      print('$provider response type: ${responseData.runtimeType}');
      // Log first 500 chars of response for debugging
      final preview = responseData.toString();
      print('$provider response preview: ${preview.length > 500 ? preview.substring(0, 500) : preview}');
    }

    // Handle wrapped response: {status: "Success", data: [...]}
    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is List) {
        responseData = responseData['data'];
      } else if (responseData['flights'] is List) {
        responseData = responseData['flights'];
      } else {
        // Maybe the map itself contains flight data as a single result
        if (kDebugMode) print('$provider: Response is Map, keys: ${responseData.keys.toList()}');
        return [];
      }
    }

    if (responseData == null || responseData is! List) {
      if (kDebugMode) print('$provider: Response is not a list, returning empty');
      return [];
    }

    if (kDebugMode) print('$provider: Parsing ${responseData.length} flights');

    return _parseProviderResponse(
      responseData,
      provider,
      tripType,
      requestedCabin: (params['cabin'] ?? 'Y').toString(),
      searchLegs: (params['legs'] as List?)
              ?.whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          const [],
    );
  }

  /// Default checked-baggage allowance per cabin class — used as a
  /// fallback only when the provider response doesn't include baggage
  /// info for a leg. Keeps Business/First searches from showing the
  /// Economy default of 20kg.
  String _defaultBaggageForCabin(String cabin) {
    final c = cabin.toUpperCase().trim();
    if (c == 'C' || c == 'J' || c == 'BUSINESS') return '40kg';
    if (c == 'F' || c == 'FIRST') return '50kg';
    if (c == 'W' || c == 'PREMIUM' || c == 'PREMIUM ECONOMY') return '30kg';
    return '20kg';
  }

  // ═══════════════════════════════════════════
  //  PARSE RESPONSE - Handles multi-leg
  // ═══════════════════════════════════════════
  List<Map<String, dynamic>> _parseProviderResponse(
    List data,
    String provider,
    String tripType, {
    String requestedCabin = 'Y',
    List<Map<String, dynamic>> searchLegs = const [],
  }) {
    final flights = <Map<String, dynamic>>[];

    for (final item in data) {
      if (item is! Map<String, dynamic>) continue;

      try {
        final price = item['price'] as Map<String, dynamic>?;
        final legs = item['legs'] as Map<String, dynamic>?;
        final baggageAllowance = item['baggageAllowance'] as Map<String, dynamic>?;
        final stopPoints = item['stopPoints'];

        // Parse all legs dynamically (leg1, leg2, leg3, ...)
        final allLegs = <Map<String, dynamic>>[];
        if (legs != null) {
          for (int i = 1; i <= 6; i++) {
            final legKey = 'leg$i';
            final leg = legs[legKey] as Map<String, dynamic>?;
            if (leg == null) break;

            final segments = leg['segments'] as List?;
            final marketingAirlines = leg['marketingAirlines']?.toString() ?? '';
            final firstAirline = marketingAirlines.split(',').first.trim();
            final airlineCode = firstAirline.length >= 2 ? firstAirline.substring(0, 2) : '';

            // Baggage for this leg — fall back to a cabin-aware default
            // so Business/First searches don't display Economy's 20kg
            // when the provider response is missing baggage info.
            final cabinDefault = _defaultBaggageForCabin(requestedCabin);
            final baggageLeg = baggageAllowance?[legKey] as Map<String, dynamic>?;
            final baggageSegments = baggageLeg?['segments'] as List?;
            String baggage = cabinDefault;
            if (baggageSegments != null && baggageSegments.isNotEmpty) {
              final firstBaggage = baggageSegments.first as Map<String, dynamic>?;
              final raw = (firstBaggage?['baggageAllowance'] ?? '').toString().trim();
              if (raw.isNotEmpty) baggage = raw;
            }

            // Trust the user's searched airport codes / city names
            // for this leg. Some providers occasionally return a
            // stale alias (e.g. PEW in place of ISB for Islamabad
            // flights) which confuses users on the card AND when
            // they expand the itinerary. We override the leg-level
            // headline AND the edge segments (first segment's
            // departure, last segment's arrival) so "Peshawar (PEW)"
            // never appears on a search for Islamabad. Connecting
            // hub segments in the middle are left untouched — those
            // represent real stops and may legitimately differ.
            final providerDepCode = (leg['departureAirport'] ?? '').toString();
            final providerArrCode = (leg['arrivalAirport'] ?? '').toString();
            final searchedLeg =
                (i - 1) < searchLegs.length ? searchLegs[i - 1] : null;
            final searchedDep =
                (searchedLeg?['departureCode'] ?? '').toString();
            final searchedArr =
                (searchedLeg?['arrivalCode'] ?? '').toString();
            final searchedDepName =
                (searchedLeg?['departureName'] ?? '').toString();
            final searchedArrName =
                (searchedLeg?['arrivalName'] ?? '').toString();
            final headlineDep =
                searchedDep.isNotEmpty ? searchedDep : providerDepCode;
            final headlineArr =
                searchedArr.isNotEmpty ? searchedArr : providerArrCode;

            // Parse individual segments for stopover details.
            // Override the outer edges (first segment's departure
            // and last segment's arrival) to match the searched
            // airport so the expanded itinerary stays consistent
            // with the card headline.
            final parsedSegments = <Map<String, dynamic>>[];
            if (segments != null) {
              for (int segIdx = 0; segIdx < segments.length; segIdx++) {
                final seg = segments[segIdx];
                if (seg is! Map<String, dynamic>) continue;
                final isFirst = segIdx == 0;
                final isLast = segIdx == segments.length - 1;

                var depCode =
                    (seg['departureAirportCode'] ?? '').toString();
                var depCity = (seg['departureCity'] ?? '').toString();
                var arrCode = (seg['arrivalAirportCode'] ?? '').toString();
                var arrCity = (seg['arrivalCity'] ?? '').toString();

                if (isFirst && searchedDep.isNotEmpty) {
                  depCode = searchedDep;
                  if (searchedDepName.isNotEmpty) depCity = searchedDepName;
                }
                if (isLast && searchedArr.isNotEmpty) {
                  arrCode = searchedArr;
                  if (searchedArrName.isNotEmpty) arrCity = searchedArrName;
                }

                parsedSegments.add({
                  'departureCode': depCode,
                  'departureCity': depCity,
                  'departureTime': seg['departureTime'] ?? '',
                  'departureDate': seg['departureDate'] ?? '',
                  'arrivalCode': arrCode,
                  'arrivalCity': arrCity,
                  'arrivalTime': seg['arrivalTime'] ?? '',
                  'arrivalDate': seg['arrivalDate'] ?? '',
                  'duration': seg['durationTime'] ?? '',
                  'flightNumber':
                      '${seg['marketingAirlineCode'] ?? ''}${seg['marketingFlightNumber'] ?? ''}',
                  'airlineCode':
                      seg['marketingAirlineCode'] ?? airlineCode,
                  'aircraft': seg['aircraftCode'] ?? '',
                  'cabin': seg['cabin'] ?? '',
                  'operatingAirline': seg['operatingAirlineCode'] ?? '',
                });
              }
            }
            if (kDebugMode &&
                searchedDep.isNotEmpty &&
                providerDepCode.isNotEmpty &&
                searchedDep != providerDepCode) {
              debugPrint(
                  '[$provider] leg$i dep code mismatch: provider=$providerDepCode searched=$searchedDep — using searched');
            }
            if (kDebugMode &&
                searchedArr.isNotEmpty &&
                providerArrCode.isNotEmpty &&
                searchedArr != providerArrCode) {
              debugPrint(
                  '[$provider] leg$i arr code mismatch: provider=$providerArrCode searched=$searchedArr — using searched');
            }

            allLegs.add({
              'airlineCode': airlineCode,
              'flightNumber': marketingAirlines,
              'departureCode': headlineDep,
              'arrivalCode': headlineArr,
              'departureTime': leg['departureTime'] ?? '--:--',
              'arrivalTime': leg['arrivalTime'] ?? '--:--',
              'duration': leg['elapsedTime'] ?? '',
              'stops': (segments?.length ?? 1) - 1,
              'baggage': baggage,
              'segments': parsedSegments,
              'stopAirports': leg['pointAirports']?.toString() ?? '',
            });
          }
        }

        if (allLegs.isEmpty) continue;

        final leg1 = allLegs[0];
        // For multi-city the trip's destination is the LAST leg's
        // arrival, not leg1's. Round-trip / one-way still anchor on
        // leg1 (round-trip's leg2 is the return back to origin).
        final isMulti = tripType == 'multi';
        final lastLeg = allLegs.last;

        flights.add({
          'id': '${DateTime.now().millisecondsSinceEpoch}${flights.length}',
          'provider': provider,
          'airlineName': price?['airlineName'] ?? 'Unknown Airline',
          'airlineCode': leg1['airlineCode'],
          'flightNumber': leg1['flightNumber'],
          'departureCode': leg1['departureCode'],
          'arrivalCode':
              isMulti ? lastLeg['arrivalCode'] : leg1['arrivalCode'],
          'departureTime': leg1['departureTime'],
          'arrivalTime':
              isMulti ? lastLeg['arrivalTime'] : leg1['arrivalTime'],
          'duration': leg1['duration'],
          'price': _parsePrice(price?['publicFare'] ?? price?['grossFarePerAdult']),
          'isRefundable': price?['isRefundable'] == 'true',
          'stops': int.tryParse(stopPoints?.toString() ?? '0') ?? leg1['stops'],
          'baggage': leg1['baggage'],
          'cabin': price?['cabin'] ?? '',
          'tripType': tripType,
          // Backward compat: returnLeg is leg2 if exists (only
          // meaningful for round-trip — multi-city renders from
          // `allLegs` instead).
          'returnLeg': (!isMulti && allLegs.length >= 2) ? allLegs[1] : null,
          // All legs for multi-city
          'allLegs': allLegs,
          'jSessionId': item['jSessionId'],
          'bookingInfo': item['bookingInfo'],
          'fareRuleKey': item['fareRuleKey'],
          'rawData': item,
        });
      } catch (e) {
        if (kDebugMode) print('Error parsing flight: $e');
      }
    }

    return flights;
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price.replaceAll(',', '')) ?? 0;
    return 0;
  }

  void clearResults() {
    state = const FlightSearchState();
  }

  // ═══════════════════════════════════════════
  //  MULTI-CITY LEG-BY-LEG FLOW (Sastaticket-style)
  // ═══════════════════════════════════════════

  /// Kicks off a leg-by-leg multi-city search. The first leg is fetched
  /// immediately; subsequent legs fire when the user calls
  /// [selectLegFlight] for the current leg.
  Future<void> startMultiCityLegFlow(Map<String, dynamic> params) async {
    final legs = (params['legs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (legs.isEmpty) {
      state = state.copyWith(
        isSearching: false,
        error: 'No legs provided for multi-city search',
      );
      return;
    }

    state = FlightSearchState(
      isMultiCityLegFlow: true,
      totalLegs: legs.length,
      currentLegIndex: 0,
      selectedLegFlights: const [],
      searchParams: params,
    );

    await _searchSingleLeg(0);
  }

  /// Fetches results for a single leg by index.
  ///
  /// Three optimisations vs. the naive loop it replaced:
  ///
  ///   1. **Per-leg cache** — if we already fetched this exact leg
  ///      within `_legCacheTtl`, reuse the cached flight list and
  ///      skip the network entirely. Tabbing between legs in the
  ///      stepper / re-picking from review no longer hammers 12
  ///      providers on every tap.
  ///
  ///   2. **Parallel fan-out** — when we DO hit the network, all
  ///      providers run concurrently via `Future.wait` instead of
  ///      awaiting them one-by-one. Total latency drops from the
  ///      sum of every provider to the slowest single provider.
  ///
  ///   3. **Staleness guard** — every search bumps `_searchToken`
  ///      and checks it before writing state, so a slow provider
  ///      response from an earlier search can't overwrite the
  ///      results of a newer one the user triggered by tapping
  ///      again.
  Future<void> _searchSingleLeg(int legIndex) async {
    final params = state.searchParams;
    if (params == null) return;
    final legs = (params['legs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (legIndex >= legs.length) return;

    final leg = legs[legIndex];

    // Per-leg params for the API call — single leg, one-way shape.
    final legParams = <String, dynamic>{
      ...params,
      'legs': [leg],
      'tripType': 'one-way',
      'departureCode': leg['departureCode'],
      'arrivalCode': leg['arrivalCode'],
      'outboundDate': leg['outboundDate'],
    };

    // Mirror this leg's display names onto the stored multi-city
    // searchParams so every widget that reads
    // `searchParams['departureName']` (header, FlightCard fallback,
    // etc.) shows the current leg's city — not stale values from the
    // original trip's first/last leg. We keep the full `legs[]`
    // array intact because the review / booking screens rely on it.
    final mirroredParams = <String, dynamic>{
      ...params,
      'departureCode': leg['departureCode'],
      'arrivalCode': leg['arrivalCode'],
      'departureName':
          leg['departureName'] ?? params['departureName'] ?? '',
      'arrivalName': leg['arrivalName'] ?? params['arrivalName'] ?? '',
      'outboundDate': leg['outboundDate'],
    };

    // Cache hit? Skip the network entirely. This is the hot path
    // when the user is tapping between already-searched legs via
    // the stepper or review screen's Change link.
    final cacheKey = _legCacheKey(legParams);
    final cached = _legCache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _legCacheTtl) {
      state = state.copyWith(
        isSearching: false,
        flights: List<Map<String, dynamic>>.from(cached.flights),
        currentLegIndex: legIndex,
        searchParams: mirroredParams,
        error: null,
        currentProvider: '',
      );
      return;
    }

    // Bump the token before kicking off the new search so any
    // in-flight provider calls from a previous search get dropped
    // when they finally resolve.
    final token = ++_searchToken;

    state = state.copyWith(
      isSearching: true,
      flights: const [],
      currentLegIndex: legIndex,
      searchParams: mirroredParams,
      error: null,
    );

    final providers = await _fetchProviders();
    if (token != _searchToken) return;
    state = state.copyWith(totalProviders: providers.length);

    // Build the per-provider futures, skipping the ones that don't
    // support the requested cabin. Wrap each call with its own
    // try/catch so one failing provider doesn't abort the batch.
    final futures = <Future<List<Map<String, dynamic>>>>[];
    final calledProviders = <String>[];
    for (final provider in providers) {
      if (legParams['cabin'] != 'Y' &&
          (provider == 'AirSial' || provider == 'Airblue')) {
        continue;
      }
      calledProviders.add(provider);
      futures.add(() async {
        try {
          return await _searchProvider(provider, legParams);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[$provider] leg$legIndex error: $e');
          }
          return const <Map<String, dynamic>>[];
        }
      }());
    }

    final results = await Future.wait(futures);
    // Drop the result if a newer search has started since we kicked
    // this one off — avoids stomping the newer state.
    if (token != _searchToken) return;

    final allFlights = <Map<String, dynamic>>[];
    for (final r in results) {
      allFlights.addAll(r);
    }
    // Default sort: cheapest first, with deterministic tiebreakers so
    // identical-price flights don't fall back to provider response
    // order (which would surface a 4h-layover variant above a 1h one
    // just because Sabre answered before AirSial). Tie chain:
    //   price → total layover → total duration → stops.
    allFlights.sort(_defaultFlightCompare);

    // Persist to cache so the next tap on this leg is instant.
    _legCache[cacheKey] = _LegCacheEntry(
      flights: List<Map<String, dynamic>>.from(allFlights),
      fetchedAt: DateTime.now(),
    );

    state = state.copyWith(
      isSearching: false,
      flights: allFlights,
      processedCount: calledProviders.length,
      currentProvider: '',
      error: allFlights.isEmpty ? 'No flights returned' : null,
    );
  }

  /// Called when the user taps a flight card during the multi-city
  /// leg-by-leg flow. Two modes:
  ///
  ///   1. **Forward** — the user is still building the trip. Append
  ///      this flight to `selectedLegFlights`, advance to the next
  ///      leg, and fire its search. If this was the final leg, flip
  ///      `allLegsSelected` so the results screen's listener can push
  ///      the review screen.
  ///
  ///   2. **Re-pick** — `currentLegIndex` already has an entry (user
  ///      came back here via "Change this leg" in the stepper or the
  ///      review screen). REPLACE that specific entry in place and
  ///      leave every other leg untouched. If the trip was already
  ///      complete, re-raise `allLegsSelected` so the listener sends
  ///      the user straight back to review.
  Future<void> selectLegFlight(Map<String, dynamic> flight) async {
    if (!state.isMultiCityLegFlow) return;

    final idx = state.currentLegIndex;
    final updated = List<Map<String, dynamic>>.from(state.selectedLegFlights);
    final isRePick = idx < updated.length;

    if (isRePick) {
      updated[idx] = flight;
      final complete = updated.length >= state.totalLegs;
      if (complete) {
        // Re-pick on a finished trip (user came from the review
        // screen). Stay put and let the caller navigate back.
        state = state.copyWith(
          selectedLegFlights: updated,
          allLegsSelected: true,
        );
        return;
      }
      // Re-pick during forward flow (user jumped back via the stepper
      // mid-build). Swap the selection in place, then advance to the
      // first leg that still has no flight picked so the user resumes
      // exactly where they were before tapping the stepper.
      final nextIdx = updated.length;
      state = state.copyWith(
        selectedLegFlights: updated,
        currentLegIndex: nextIdx,
        allLegsSelected: false,
      );
      await _searchSingleLeg(nextIdx);
      return;
    }

    updated.add(flight);
    final nextIndex = idx + 1;
    final isDone = nextIndex >= state.totalLegs;

    state = state.copyWith(
      selectedLegFlights: updated,
      currentLegIndex: isDone ? idx : nextIndex,
      allLegsSelected: isDone,
    );

    if (!isDone) {
      await _searchSingleLeg(nextIndex);
    }
  }

  /// Re-opens a specific leg so the user can swap their flight choice
  /// for that leg *only*. Leaves every other leg's selection intact —
  /// leg definitions (routes / dates) live in `searchParams` and don't
  /// change when a different flight is picked, so later legs remain
  /// valid. Fires exactly one provider search for the target leg.
  Future<void> jumpToLeg(int targetIndex) async {
    if (!state.isMultiCityLegFlow) return;
    if (targetIndex < 0 || targetIndex >= state.totalLegs) return;

    state = state.copyWith(
      currentLegIndex: targetIndex,
      allLegsSelected: false,
    );
    await _searchSingleLeg(targetIndex);
  }

  /// Pops the last selection and re-runs the previous leg's search so
  /// the user can change their mind.
  Future<void> backOneLeg() async {
    if (!state.isMultiCityLegFlow) return;
    if (state.selectedLegFlights.isEmpty) return;

    final updated = List<Map<String, dynamic>>.from(state.selectedLegFlights)
      ..removeLast();
    final prevIndex = updated.length; // index of the leg we're re-doing

    state = state.copyWith(
      selectedLegFlights: updated,
      currentLegIndex: prevIndex,
      allLegsSelected: false,
    );

    await _searchSingleLeg(prevIndex);
  }

  /// Clears all multi-city leg-by-leg state, including any cached
  /// per-leg results so a brand new search doesn't silently reuse
  /// stale flights from the previous trip.
  void resetMultiCityLegFlow() {
    _legCache.clear();
    _searchToken++;
    state = const FlightSearchState();
  }

  /// Re-runs the search for whichever leg the user is currently on.
  /// Used by the error / empty states when the user taps Retry — we
  /// must not fall back to the single-shot `searchFlights` path
  /// because that would wipe all the leg-by-leg state that has built
  /// up (selected flights, `currentLegIndex`, `totalLegs`).
  Future<void> retryCurrentLeg() async {
    if (!state.isMultiCityLegFlow) return;
    await _searchSingleLeg(state.currentLegIndex);
  }

  /// Merges all selected legs into a single flight-shaped map that the
  /// booking screen already knows how to render (via `allLegs`). Sums
  /// per-leg prices into a grand total.
  Map<String, dynamic> buildMergedMultiCityFlight() {
    final selected = state.selectedLegFlights;
    if (selected.isEmpty) return {};

    final mergedLegs = <Map<String, dynamic>>[];
    double totalPrice = 0;
    final airlineNames = <String>{};
    final providers = <String>{};

    for (final f in selected) {
      final legs = (f['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (legs.isNotEmpty) {
        mergedLegs.addAll(legs);
      } else {
        // Fall back to constructing a leg from flat fields.
        mergedLegs.add({
          'airlineCode': f['airlineCode'] ?? '',
          'flightNumber': f['flightNumber'] ?? '',
          'departureCode': f['departureCode'] ?? '',
          'arrivalCode': f['arrivalCode'] ?? '',
          'departureTime': f['departureTime'] ?? '--:--',
          'arrivalTime': f['arrivalTime'] ?? '--:--',
          'duration': f['duration'] ?? '',
          'stops': f['stops'] ?? 0,
          'baggage': f['baggage'] ?? '20kg',
          'segments': const [],
        });
      }
      totalPrice += (f['price'] as num?)?.toDouble() ?? 0;
      final name = (f['airlineName'] ?? '').toString();
      if (name.isNotEmpty) airlineNames.add(name);
      final p = (f['provider'] ?? '').toString();
      if (p.isNotEmpty) providers.add(p);
    }

    final first = mergedLegs.first;
    final last = mergedLegs.last;

    return {
      'id': 'mc_${DateTime.now().millisecondsSinceEpoch}',
      'provider': providers.length == 1 ? providers.first : 'Multi',
      'airlineName':
          airlineNames.length == 1 ? airlineNames.first : 'Mixed Airlines',
      'airlineCode': first['airlineCode'] ?? '',
      'flightNumber': first['flightNumber'] ?? '',
      'departureCode': first['departureCode'] ?? '',
      'arrivalCode': last['arrivalCode'] ?? '',
      'departureTime': first['departureTime'] ?? '--:--',
      'arrivalTime': last['arrivalTime'] ?? '--:--',
      'duration': '',
      'price': totalPrice,
      'isRefundable': false,
      'stops': 0,
      'baggage': first['baggage'] ?? '20kg',
      'cabin': (state.searchParams?['cabin'] ?? 'Y').toString(),
      'tripType': 'multi',
      'returnLeg': null,
      'allLegs': mergedLegs,
      // Use first leg's jSessionId/bookingInfo as primary; selectedLegFlights
      // preserves each leg's originals so the booking layer can issue
      // per-leg PNR calls when backend supports it.
      'jSessionId': selected.first['jSessionId'],
      'bookingInfo': selected.first['bookingInfo'],
      'fareRuleKey': selected.first['fareRuleKey'],
      'rawData': selected.first['rawData'],
      'selectedLegFlights': selected,
    };
  }
}

// Providers
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final flightSearchProvider = StateNotifierProvider<FlightSearchNotifier, FlightSearchState>((ref) {
  return FlightSearchNotifier(
    ref.watch(apiClientProvider),
    ref.watch(coreApiClientProvider),
    ref.watch(exaltedApiClientProvider),
  );
});

final isBookingJourneyProvider = StateProvider<bool>((ref) => false);
final pendingBookingDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// Cached leg results — a tiny immutable pair of the flight list and
/// the timestamp we fetched it at. Keyed by `_legCacheKey` so two
/// legs with the same route/date/pax share one cache slot.
class _LegCacheEntry {
  final List<Map<String, dynamic>> flights;
  final DateTime fetchedAt;
  const _LegCacheEntry({required this.flights, required this.fetchedAt});
}
