import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter_sort_config.dart';

/// Hardcoded copy of the flights filter / sort config — used as the
/// fallback whenever the CMS API at `:3000/filter-sort-configs` isn't
/// reachable yet. Keep this in sync with the document the backend
/// team maintains; the moment the API ships, the fallback only fires
/// for transient network failures.
const Map<String, dynamic> kFallbackFlightFilterConfig = {
  'listing_name': 'flights',
  'version': '1.0',
  'config_data': {
    'calculation_config': {
      'factors': {
        'price': {
          'weight': 0.4,
          'formula': 'RATIO_INVERSE',
          'description': 'Lower price = higher score',
        },
        'stops': {
          'weight': 0.2,
          'formula': 'LOOKUP',
          'description': 'Direct flights preferred',
          'lookup_table': {
            '0': 100,
            '1': 70,
            '2': 40,
            '3+': 10,
          },
        },
        'timing': {
          'weight': 0.03,
          'formula': 'CUSTOM',
          'description': '6AM-10PM good, red-eye penalty',
        },
        'duration': {
          'weight': 0.3,
          'formula': 'RATIO_INVERSE',
          'description': 'Shorter duration = higher score',
        },
        'airline_rating': {
          'weight': 0.02,
          'formula': 'DIRECT',
          'description': 'Airline reputation score',
        },
        'layover_quality': {
          'weight': 0.05,
          'formula': 'CUSTOM',
          'description': '1-2 hour layover ideal, overnight penalty',
        },
      },
      'filters': {
        'stops': {
          'type': 'checkbox',
          'label': 'Stops',
          'options': [
            {'label': 'Direct', 'value': '0'},
            {'label': '1 Stop', 'value': '1'},
            {'label': '2+ Stops', 'value': '2+'},
          ],
        },
        'airlines': {
          'type': 'multi-select',
          'label': 'Airlines',
          'dynamic': true,
        },
        'price_range': {
          'type': 'slider',
          'label': 'Price Range',
          'currency': 'PKR',
          'max_field': 'price_max',
          'min_field': 'price_min',
        },
        'departure_time': {
          'type': 'range',
          'label': 'Departure Time',
          'ranges': [
            {
              'end': '12:00',
              'label': 'Morning (6AM-12PM)',
              'start': '06:00',
              'value': 'morning',
            },
            {
              'end': '18:00',
              'label': 'Afternoon (12PM-6PM)',
              'start': '12:00',
              'value': 'afternoon',
            },
            {
              'end': '23:59',
              'label': 'Evening (6PM-12AM)',
              'start': '18:00',
              'value': 'evening',
            },
            {
              'end': '06:00',
              'label': 'Night (12AM-6AM)',
              'start': '00:00',
              'value': 'night',
            },
          ],
        },
      },
      'tag_rules': [
        {
          'tag': 'BEST',
          'icon': 'star',
          'condition': 'best_rank == 1',
          'badge_color': '#28a745',
        },
        {
          'tag': 'CHEAPEST',
          'icon': 'dollar',
          'condition': 'cheapest_rank == 1',
          'badge_color': '#007bff',
        },
        {
          'tag': 'FASTEST',
          'icon': 'bolt',
          'condition': 'fastest_rank == 1',
          'badge_color': '#ffc107',
        },
      ],
      'ranking_rules': {
        'best_rank': {
          'order': 'DESC',
          'sort_by': 'best_score',
          'description': 'Overall best value',
        },
        'fastest_rank': {
          'order': 'ASC',
          'sort_by': 'duration_minutes',
          'description': 'Shortest duration first',
        },
        'cheapest_rank': {
          'order': 'ASC',
          'sort_by': 'price',
          'description': 'Lowest price first',
        },
      },
      'round_to_decimals': 2,
    },
  },
};

/// Fetches the filter / sort config from the admin CMS service that
/// owns the rules. Stateless — every call hits the network so the
/// rules CMS-side stay in sync with the app instantly. **No on-device
/// caching** by design (per product requirement: each search should
/// pick up whatever the portal currently has).
///
/// Hit happens when the user taps **Search Flights** — the result
/// screen reads `flightFilterConfigProvider`, which fires this
/// service. `autoDispose` on the provider guarantees the next search
/// triggers another fresh fetch instead of reusing a stale result.
class FilterConfigService {
  FilterConfigService();

  /// Base URL of the filter-sort-config CMS. Update here if the
  /// deployment host or port changes.
  static const String _baseUrl = 'http://3.222.113.143:3000';

  /// `/by-listing/{name}` is the documented Option 2 — try this first
  /// because it returns just one row instead of the whole list. If the
  /// CMS hasn't deployed that route, fall back to the list endpoint.
  static const String _byListingEndpointPrefix = '/filter-sort-configs/by-listing';

  /// List endpoint — returns every config row across all listings
  /// (flights, hotels, etc). The mobile filters client-side for the
  /// listing it cares about.
  static const String _listEndpoint = '/filter-sort-configs';

  /// Hits the network and returns the parsed config. **Never returns
  /// null** for the `flights` listing — falls through to the
  /// hardcoded `kFallbackFlightFilterConfig` whenever the CMS at
  /// `:3000` is offline / not yet deployed. Other listings (hotels,
  /// etc.) still return null on failure since we don't ship a
  /// fallback for those yet.
  Future<FilterSortConfig?> fetchFresh(String listing) async {
    // Attempt 1 — single-config endpoint.
    final single = await _fetchByListing(listing);
    if (single != null) {
      return FilterSortConfig.fromJson(single);
    }

    // Attempt 2 — list endpoint, filter for the listing we want.
    final list = await _fetchList();
    if (list != null) {
      final match = list.firstWhere(
        (row) => (row['listing_name'] ?? '').toString().toLowerCase() ==
            listing.toLowerCase(),
        orElse: () => const <String, dynamic>{},
      );
      if (match.isNotEmpty) {
        return FilterSortConfig.fromJson(match);
      }
      if (kDebugMode) {
        debugPrint('FilterConfig: no row for "$listing" in list response');
      }
    }

    // Both attempts failed — for `flights` use the hardcoded
    // fallback so the engine + filter UI keep working until the
    // CMS comes online.
    if (listing.toLowerCase() == 'flights') {
      if (kDebugMode) {
        debugPrint('FilterConfig: API unreachable, using hardcoded fallback');
      }
      return FilterSortConfig.fromJson(kFallbackFlightFilterConfig);
    }
    return null;
  }

  // ─── Internals ─────────────────────────────────────────────────

  Future<Map<String, dynamic>?> _fetchByListing(String listing) async {
    final url =
        Uri.parse('$_baseUrl$_byListingEndpointPrefix/$listing');
    try {
      if (kDebugMode) debugPrint('FilterConfig: GET $url');
      final body = await _getJson(url);
      if (body is Map<String, dynamic>) return body;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('FilterConfig: by-listing fetch failed — $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchList() async {
    final url = Uri.parse('$_baseUrl$_listEndpoint');
    try {
      if (kDebugMode) debugPrint('FilterConfig: GET $url');
      final body = await _getJson(url);
      // Two valid response shapes — bare list `[ {...}, {...} ]` or a
      // paginated wrapper `{ results: [...] }`. Both are common.
      if (body is List) {
        return body.whereType<Map<String, dynamic>>().toList();
      }
      if (body is Map<String, dynamic>) {
        final results = body['results'];
        if (results is List) {
          return results.whereType<Map<String, dynamic>>().toList();
        }
        if (body['listing_name'] != null) {
          // Single-row response treated as a one-item list — handles
          // the case where the CMS renders /filter-sort-configs as
          // a single resource for some reason.
          return [body];
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('FilterConfig: list fetch failed — $e');
      return null;
    }
  }

  /// Plain `HttpClient` GET → JSON decode. Bypasses Dio / CoreApiClient
  /// because the CMS host has no auth headers + is on a different
  /// port from the rest of the app's API surface.
  Future<dynamic> _getJson(Uri uri) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final req = await client.getUrl(uri);
      req.headers.set('Accept', 'application/json');
      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();
      if (kDebugMode) {
        final preview = body.length > 240 ? '${body.substring(0, 240)}…' : body;
        debugPrint(
            'FilterConfig: ${resp.statusCode} ← ${uri.path} (${body.length}B): $preview');
      }
      if (resp.statusCode != 200) return null;
      return jsonDecode(body);
    } finally {
      client.close(force: false);
    }
  }
}

/// Singleton service provider — no Riverpod dependencies needed
/// because the service hits a fixed URL with a raw `HttpClient`.
final filterConfigServiceProvider = Provider<FilterConfigService>((ref) {
  return FilterConfigService();
});

/// `autoDispose` so every fresh search → fresh result-screen mount →
/// fresh CMS fetch. The result screen reads this; while loading,
/// callers fall back to their hard-coded defaults via
/// `asData?.value` checks so the UI never blanks.
final flightFilterConfigProvider =
    FutureProvider.autoDispose<FilterSortConfig?>((ref) async {
  final service = ref.read(filterConfigServiceProvider);
  return service.fetchFresh('flights');
});
