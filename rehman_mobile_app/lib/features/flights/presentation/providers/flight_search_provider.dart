import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/core_api_client.dart';
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
  List<Object?> get props => [
        isSearching,
        flights,
        error,
        processedCount,
        totalProviders,
        currentProvider,
        searchParams,
      ];
}

// Flight Search Notifier
class FlightSearchNotifier extends StateNotifier<FlightSearchState> {
  final ApiClient _apiClient;
  final CoreApiClient _coreApiClient;

  // Fallback providers matching live website (if API call fails)
  static const List<String> _fallbackProviders = [
    'Sabre', 'Airsial', 'Airblue', 'Airarabia', 'Flydubai',
    'Flyjinnah', 'Airemirate', 'Isaaviations', 'SabreNdc', 'Polani',
  ];

  FlightSearchNotifier(this._apiClient, this._coreApiClient) : super(const FlightSearchState());

  /// Fetch providers from Django API
  Future<List<String>> _fetchProviders() async {
    try {
      final response = await _coreApiClient.get<Map<String, dynamic>>(
        ApiEndpoints.flightProviders,
      );
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data!['providers'] as List?;
        if (list != null && list.isNotEmpty) {
          return list.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch providers, using fallback: $e');
      }
    }
    return _fallbackProviders;
  }

  Future<void> searchFlights(Map<String, dynamic> params) async {
    // Reset state and store search params
    state = FlightSearchState(
      isSearching: true,
      searchParams: params,
    );

    if (kDebugMode) {
      print('=== FLIGHT SEARCH STARTED ===');
      print('Params: $params');
    }

    // Fetch providers from API
    final providers = await _fetchProviders();

    state = state.copyWith(totalProviders: providers.length);

    if (kDebugMode) {
      print('Providers: $providers');
    }

    final allFlights = <Map<String, dynamic>>[];
    int processedCount = 0;
    String? lastError;

    // Call each provider sequentially
    for (final provider in providers) {
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

  void sortFlights(String sortBy) {
    final sorted = List<Map<String, dynamic>>.from(state.flights);

    switch (sortBy) {
      case 'price_asc':
        sorted.sort((a, b) {
          final priceA = (a['price'] as num?) ?? double.infinity;
          final priceB = (b['price'] as num?) ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_desc':
        sorted.sort((a, b) {
          final priceA = (a['price'] as num?) ?? double.infinity;
          final priceB = (b['price'] as num?) ?? double.infinity;
          return priceB.compareTo(priceA);
        });
        break;
      case 'duration':
        sorted.sort((a, b) {
          final dA = _parseDurationMinutes(a['duration'] ?? '');
          final dB = _parseDurationMinutes(b['duration'] ?? '');
          return dA.compareTo(dB);
        });
        break;
      case 'departure':
        sorted.sort((a, b) {
          final tA = a['departureTime'] ?? '99:99';
          final tB = b['departureTime'] ?? '99:99';
          return tA.toString().compareTo(tB.toString());
        });
        break;
    }

    state = state.copyWith(flights: sorted);
  }

  int _parseDurationMinutes(String duration) {
    // Parse formats like "1h 30m", "2h", "45m", "PT1H30M"
    final hMatch = RegExp(r'(\d+)\s*h', caseSensitive: false).firstMatch(duration);
    final mMatch = RegExp(r'(\d+)\s*m', caseSensitive: false).firstMatch(duration);
    final hours = hMatch != null ? int.tryParse(hMatch.group(1)!) ?? 0 : 0;
    final minutes = mMatch != null ? int.tryParse(mMatch.group(1)!) ?? 0 : 0;
    return hours * 60 + minutes;
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
        'stop': params['stop'] ?? '',
        'adultsCount': params['adultsCount'] ?? 1,
        'childrenCount': params['childrenCount'] ?? 0,
        'infantsCount': params['infantsCount'] ?? 0,
        'tripType': params['tripType'] ?? 'one-way',
        'currencyCode': 'PKR',
        'locale': 'ar',
      },
      extraHeaders: {'Action-Type': provider},
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

        // Extract airline code from marketingAirlines (e.g. "PK301" -> "PK")
        final marketingAirlines = leg1?['marketingAirlines']?.toString() ?? '';
        final firstAirline = marketingAirlines.split(',').first.trim();
        final airlineCode = firstAirline.length >= 2 ? firstAirline.substring(0, 2) : '';

        // Parse return leg (leg2) if exists (round-trip)
        final leg2 = legs?['leg2'] as Map<String, dynamic>?;
        Map<String, dynamic>? returnLeg;
        if (leg2 != null) {
          final returnMarketingAirlines = leg2['marketingAirlines']?.toString() ?? '';
          final returnFirstAirline = returnMarketingAirlines.split(',').first.trim();
          final returnAirlineCode = returnFirstAirline.length >= 2 ? returnFirstAirline.substring(0, 2) : '';
          final leg2Segments = leg2['segments'] as List?;

          // Return leg baggage
          final baggageLeg2 = baggageAllowance?['leg2'] as Map<String, dynamic>?;
          final baggageLeg2Segments = baggageLeg2?['segments'] as List?;
          String returnBaggage = baggage;
          if (baggageLeg2Segments != null && baggageLeg2Segments.isNotEmpty) {
            final firstReturnBaggage = baggageLeg2Segments.first as Map<String, dynamic>?;
            returnBaggage = firstReturnBaggage?['baggageAllowance'] ?? baggage;
          }

          returnLeg = {
            'airlineCode': returnAirlineCode,
            'flightNumber': returnMarketingAirlines,
            'departureCode': leg2['departureAirport'] ?? '',
            'arrivalCode': leg2['arrivalAirport'] ?? '',
            'departureTime': leg2['departureTime'] ?? '--:--',
            'arrivalTime': leg2['arrivalTime'] ?? '--:--',
            'duration': leg2['elapsedTime'] ?? '',
            'stops': (leg2Segments?.length ?? 1) - 1,
            'baggage': returnBaggage,
          };
        }

        flights.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString() +
              flights.length.toString(),
          'provider': provider,
          'airlineName': price?['airlineName'] ?? 'Unknown Airline',
          'airlineCode': airlineCode,
          'flightNumber': marketingAirlines,
          'departureCode': leg1?['departureAirport'] ?? '',
          'arrivalCode': leg1?['arrivalAirport'] ?? '',
          'departureTime': leg1?['departureTime'] ?? '--:--',
          'arrivalTime': leg1?['arrivalTime'] ?? '--:--',
          'duration': leg1?['elapsedTime'] ?? '',
          'price': _parsePrice(price?['publicFare'] ?? price?['grossFarePerAdult']),
          'isRefundable': price?['isRefundable'] == 'true',
          'stops': int.tryParse(stopPoints?.toString() ?? '0') ?? ((segments?.length ?? 1) - 1),
          'baggage': baggage,
          'returnLeg': returnLeg,
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
  return FlightSearchNotifier(
    ref.watch(apiClientProvider),
    ref.watch(coreApiClientProvider),
  );
});

// Global booking journey state - tracks if user is in booking flow (for auth redirect)
final isBookingJourneyProvider = StateProvider<bool>((ref) => false);

// Stores flight data when user is redirected to login during booking
final pendingBookingDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
