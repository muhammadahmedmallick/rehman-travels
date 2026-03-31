import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// Flight Search State
class FlightSearchState extends Equatable {
  final bool isSearching;
  final List<Map<String, dynamic>> flights;
  final String? error;
  final int processedCount;
  final int totalProviders;
  final String currentProvider;
  final Map<String, dynamic>? searchParams;

  const FlightSearchState({
    this.isSearching = false,
    this.flights = const [],
    this.error,
    this.processedCount = 0,
    this.totalProviders = 3,
    this.currentProvider = '',
    this.searchParams,
  });

  FlightSearchState copyWith({
    bool? isSearching,
    List<Map<String, dynamic>>? flights,
    String? error,
    int? processedCount,
    int? totalProviders,
    String? currentProvider,
    Map<String, dynamic>? searchParams,
  }) {
    return FlightSearchState(
      isSearching: isSearching ?? this.isSearching,
      flights: flights ?? this.flights,
      error: error,
      processedCount: processedCount ?? this.processedCount,
      totalProviders: totalProviders ?? this.totalProviders,
      currentProvider: currentProvider ?? this.currentProvider,
      searchParams: searchParams ?? this.searchParams,
    );
  }

  @override
  List<Object?> get props => [isSearching, flights, error, processedCount, totalProviders, currentProvider, searchParams];
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

  Future<void> searchFlights(Map<String, dynamic> params) async {
    state = FlightSearchState(isSearching: true, searchParams: params);

    if (kDebugMode) {
      print('=== FLIGHT SEARCH STARTED ===');
      print('Params: $params');
    }

    final providers = await _fetchProviders();
    state = state.copyWith(totalProviders: providers.length);

    if (kDebugMode) print('Providers: $providers');

    final allFlights = <Map<String, dynamic>>[];
    int processedCount = 0;
    String? lastError;

    for (final provider in providers) {
      // Skip AirSial and Airblue for non-Economy class
      if (params['cabin'] != 'Y' && (provider == 'AirSial' || provider == 'Airblue')) {
        processedCount++;
        state = state.copyWith(processedCount: processedCount, currentProvider: provider);
        continue;
      }

      state = state.copyWith(currentProvider: provider);

      if (kDebugMode) print('=== Searching $provider ===');

      try {
        final flights = await _searchProvider(provider, params);
        allFlights.addAll(flights);

        processedCount++;
        state = state.copyWith(processedCount: processedCount, flights: List.from(allFlights));

        if (kDebugMode) print('$provider returned ${flights.length} flights');
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print('$provider error: $e');
          print('Stack trace: $stackTrace');
        }
        lastError = '$provider: $e';
        processedCount++;
        state = state.copyWith(processedCount: processedCount);
      }
    }

    allFlights.sort((a, b) {
      final priceA = (a['price'] as num?) ?? double.infinity;
      final priceB = (b['price'] as num?) ?? double.infinity;
      return priceA.compareTo(priceB);
    });

    state = state.copyWith(
      isSearching: false,
      flights: allFlights,
      currentProvider: '',
      error: allFlights.isEmpty ? lastError : null,
    );

    if (kDebugMode) {
      print('=== SEARCH COMPLETE ===');
      print('Total flights: ${allFlights.length}');
    }
  }

  void sortFlights(String sortBy) {
    final sorted = List<Map<String, dynamic>>.from(state.flights);
    switch (sortBy) {
      case 'price_asc':
        sorted.sort((a, b) => ((a['price'] as num?) ?? double.infinity).compareTo((b['price'] as num?) ?? double.infinity));
      case 'price_desc':
        sorted.sort((a, b) => ((b['price'] as num?) ?? double.infinity).compareTo((a['price'] as num?) ?? double.infinity));
      case 'duration':
        sorted.sort((a, b) => _parseDurationMinutes(a['duration'] ?? '').compareTo(_parseDurationMinutes(b['duration'] ?? '')));
      case 'departure':
        sorted.sort((a, b) => (a['departureTime'] ?? '99:99').toString().compareTo((b['departureTime'] ?? '99:99').toString()));
    }
    state = state.copyWith(flights: sorted);
  }

  int _parseDurationMinutes(String duration) {
    final hMatch = RegExp(r'(\d+)\s*h', caseSensitive: false).firstMatch(duration);
    final mMatch = RegExp(r'(\d+)\s*m', caseSensitive: false).firstMatch(duration);
    final hours = hMatch != null ? int.tryParse(hMatch.group(1)!) ?? 0 : 0;
    final minutes = mMatch != null ? int.tryParse(mMatch.group(1)!) ?? 0 : 0;
    return hours * 60 + minutes;
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

    // Build payload for Exalted API (legs format)
    final payload = {
      'legs': legs ?? [
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
      'requestType': 50,
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

    return _parseProviderResponse(responseData, provider, tripType);
  }

  // ═══════════════════════════════════════════
  //  PARSE RESPONSE - Handles multi-leg
  // ═══════════════════════════════════════════
  List<Map<String, dynamic>> _parseProviderResponse(List data, String provider, String tripType) {
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

            // Baggage for this leg
            final baggageLeg = baggageAllowance?[legKey] as Map<String, dynamic>?;
            final baggageSegments = baggageLeg?['segments'] as List?;
            String baggage = '20kg';
            if (baggageSegments != null && baggageSegments.isNotEmpty) {
              final firstBaggage = baggageSegments.first as Map<String, dynamic>?;
              baggage = firstBaggage?['baggageAllowance'] ?? '20kg';
            }

            allLegs.add({
              'airlineCode': airlineCode,
              'flightNumber': marketingAirlines,
              'departureCode': leg['departureAirport'] ?? '',
              'arrivalCode': leg['arrivalAirport'] ?? '',
              'departureTime': leg['departureTime'] ?? '--:--',
              'arrivalTime': leg['arrivalTime'] ?? '--:--',
              'duration': leg['elapsedTime'] ?? '',
              'stops': (segments?.length ?? 1) - 1,
              'baggage': baggage,
            });
          }
        }

        if (allLegs.isEmpty) continue;

        final leg1 = allLegs[0];

        flights.add({
          'id': '${DateTime.now().millisecondsSinceEpoch}${flights.length}',
          'provider': provider,
          'airlineName': price?['airlineName'] ?? 'Unknown Airline',
          'airlineCode': leg1['airlineCode'],
          'flightNumber': leg1['flightNumber'],
          'departureCode': leg1['departureCode'],
          'arrivalCode': leg1['arrivalCode'],
          'departureTime': leg1['departureTime'],
          'arrivalTime': leg1['arrivalTime'],
          'duration': leg1['duration'],
          'price': _parsePrice(price?['publicFare'] ?? price?['grossFarePerAdult']),
          'isRefundable': price?['isRefundable'] == 'true',
          'stops': int.tryParse(stopPoints?.toString() ?? '0') ?? leg1['stops'],
          'baggage': leg1['baggage'],
          'cabin': price?['cabin'] ?? '',
          'tripType': tripType,
          // Backward compat: returnLeg is leg2 if exists
          'returnLeg': allLegs.length >= 2 ? allLegs[1] : null,
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
