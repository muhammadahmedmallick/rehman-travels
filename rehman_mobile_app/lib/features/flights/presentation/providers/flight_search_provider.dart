import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// Flight Search State
class FlightSearchState extends Equatable {
  final bool isSearching;
  final List<Map<String, dynamic>> flights;
  final String? error;
  final int processedCount;
  final int totalProviders;
  final String currentProvider;

  const FlightSearchState({
    this.isSearching = false,
    this.flights = const [],
    this.error,
    this.processedCount = 0,
    this.totalProviders = 3,
    this.currentProvider = '',
  });

  FlightSearchState copyWith({
    bool? isSearching,
    List<Map<String, dynamic>>? flights,
    String? error,
    int? processedCount,
    int? totalProviders,
    String? currentProvider,
  }) {
    return FlightSearchState(
      isSearching: isSearching ?? this.isSearching,
      flights: flights ?? this.flights,
      error: error,
      processedCount: processedCount ?? this.processedCount,
      totalProviders: totalProviders ?? this.totalProviders,
      currentProvider: currentProvider ?? this.currentProvider,
    );
  }

  @override
  List<Object?> get props => [
        isSearching,
        flights,
        error,
        processedCount,
        totalProviders,
        currentProvider,
      ];
}

// Flight Search Notifier
class FlightSearchNotifier extends StateNotifier<FlightSearchState> {
  final ApiClient _apiClient;

  // Available providers
  static const List<String> _providers = ['Sabre', 'AirSial', 'Airblue'];

  FlightSearchNotifier(this._apiClient) : super(const FlightSearchState());

  Future<void> searchFlights(Map<String, dynamic> params) async {
    // Reset state
    state = FlightSearchState(
      isSearching: true,
      totalProviders: _providers.length,
    );

    if (kDebugMode) {
      print('=== FLIGHT SEARCH STARTED ===');
      print('Params: $params');
    }

    final allFlights = <Map<String, dynamic>>[];
    int processedCount = 0;
    String? lastError;

    // Call each provider sequentially
    for (final provider in _providers) {
      // Skip AirSial and Airblue for non-Economy class
      if (params['cabin'] != 'Y' && (provider == 'AirSial' || provider == 'Airblue')) {
        processedCount++;
        state = state.copyWith(
          processedCount: processedCount,
          currentProvider: provider,
        );
        continue;
      }

      state = state.copyWith(currentProvider: provider);

      if (kDebugMode) {
        print('=== Searching $provider ===');
      }

      try {
        final flights = await _searchProvider(provider, params);
        allFlights.addAll(flights);

        processedCount++;
        state = state.copyWith(
          processedCount: processedCount,
          flights: List.from(allFlights),
        );

        if (kDebugMode) {
          print('$provider returned ${flights.length} flights');
        }
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

    // Sort flights by price
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
      if (lastError != null) print('Last error: $lastError');
    }
  }

  Future<List<Map<String, dynamic>>> _searchProvider(
    String provider,
    Map<String, dynamic> params,
  ) async {
    if (kDebugMode) {
      print('$provider: Making API request to ${ApiEndpoints.flightSearch}');
    }

    final response = await _apiClient.postWithHeader(
      ApiEndpoints.flightSearch,
      data: {
        'departureCode': params['departureCode'],
        'arrivalCode': params['arrivalCode'],
        'outboundDate': params['outboundDate'],
        'inboundDate': params['inboundDate'] ?? '',
        'cabin': params['cabin'] ?? 'Y',
        'adultsCount': params['adultsCount'] ?? 1,
        'childrenCount': params['childrenCount'] ?? 0,
        'infantsCount': params['infantsCount'] ?? 0,
        'tripType': params['tripType'] ?? 'one-way',
        'currencyCode': 'PKR',
      },
      extraHeaders: {'action-type': provider},
    );

    if (kDebugMode) {
      print('$provider response status: ${response.statusCode}');
      print('$provider response type: ${response.data.runtimeType}');
      if (response.data is List) {
        print('$provider response length: ${(response.data as List).length}');
      } else {
        print('$provider response data: ${response.data}');
      }
    }

    final data = response.data;
    if (data == null || data is! List) {
      if (kDebugMode) {
        print('$provider: Response is not a list, returning empty');
      }
      return [];
    }

    return _parseProviderResponse(data, provider);
  }

  List<Map<String, dynamic>> _parseProviderResponse(List data, String provider) {
    final flights = <Map<String, dynamic>>[];

    for (final item in data) {
      if (item is! Map<String, dynamic>) continue;

      try {
        final price = item['price'] as Map<String, dynamic>?;
        final legs = item['legs'] as Map<String, dynamic>?;
        final leg1 = legs?['leg1'] as Map<String, dynamic>?;
        final segments = leg1?['segments'] as List?;
        final stopPoints = item['stopPoints'];

        // Get baggage info
        final baggageAllowance = item['baggageAllowance'] as Map<String, dynamic>?;
        final baggageLeg1 = baggageAllowance?['leg1'] as Map<String, dynamic>?;
        final baggageSegments = baggageLeg1?['segments'] as List?;
        String baggage = '20kg';
        if (baggageSegments != null && baggageSegments.isNotEmpty) {
          final firstBaggage = baggageSegments.first as Map<String, dynamic>?;
          baggage = firstBaggage?['baggageAllowance'] ?? '20kg';
        }

        flights.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString() +
              flights.length.toString(),
          'provider': provider,
          'airlineName': price?['airlineName'] ?? 'Unknown Airline',
          'flightNumber': leg1?['marketingAirlines'] ?? '',
          'departureCode': leg1?['departureAirport'] ?? '',
          'arrivalCode': leg1?['arrivalAirport'] ?? '',
          'departureTime': leg1?['departureTime'] ?? '--:--',
          'arrivalTime': leg1?['arrivalTime'] ?? '--:--',
          'duration': leg1?['elapsedTime'] ?? '',
          'price': _parsePrice(price?['publicFare'] ?? price?['grossFarePerAdult']),
          'isRefundable': price?['isRefundable'] == 'true',
          'stops': int.tryParse(stopPoints?.toString() ?? '0') ?? ((segments?.length ?? 1) - 1),
          'baggage': baggage,
          'jSessionId': item['jSessionId'],
          'bookingInfo': item['bookingInfo'],
          'fareRuleKey': item['fareRuleKey'],
          'rawData': item,
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing flight: $e');
        }
      }
    }

    return flights;
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price.replaceAll(',', '')) ?? 0;
    }
    return 0;
  }

  void clearResults() {
    state = const FlightSearchState();
  }
}

// Provider
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final flightSearchProvider =
    StateNotifierProvider<FlightSearchNotifier, FlightSearchState>((ref) {
  return FlightSearchNotifier(ref.watch(apiClientProvider));
});
