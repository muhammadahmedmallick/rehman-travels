import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class Destination {
  final int id;
  final int parentId;
  final String packageTitle;
  final String urlLink;
  final String? cardImage;
  final String price;
  final String currencyType;
  final int type;
  final String? countryName;

  const Destination({
    required this.id,
    required this.parentId,
    required this.packageTitle,
    required this.urlLink,
    this.cardImage,
    this.price = '0',
    this.currencyType = 'PKR',
    this.type = 0,
    this.countryName,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? 0,
      parentId: json['parentId'] ?? 0,
      packageTitle: json['packageTitle'] ?? '',
      urlLink: json['urlLink'] ?? '',
      cardImage: json['cardImage'],
      price: json['price']?.toString() ?? '0',
      currencyType: json['currencyType'] ?? 'PKR',
      type: json['type'] ?? 0,
      countryName: json['countryName'],
    );
  }

  String get displayName => countryName ?? packageTitle;

  String? get imageUrl {
    if (cardImage == null || cardImage!.isEmpty) return null;
    if (parentId == 4) {
      return '${ApiEndpoints.coreApiBaseUrl}/media/visa/$cardImage';
    }
    return '${ApiEndpoints.coreApiBaseUrl}/media/umrah/$cardImage';
  }

  String get formattedPrice {
    final priceStr = price.replaceAll(',', '');
    final priceVal = double.tryParse(priceStr) ?? 0;
    if (priceVal <= 0) return '';
    final intPrice = priceVal.toInt();
    final formatted = intPrice.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$currencyType $formatted';
  }
}

class DestinationListState {
  final bool isLoading;
  final List<Destination> destinations;
  final String? error;

  const DestinationListState({
    this.isLoading = false,
    this.destinations = const [],
    this.error,
  });

  DestinationListState copyWith({
    bool? isLoading,
    List<Destination>? destinations,
    String? error,
  }) {
    return DestinationListState(
      isLoading: isLoading ?? this.isLoading,
      destinations: destinations ?? this.destinations,
      error: error,
    );
  }
}

class DestinationListNotifier extends StateNotifier<DestinationListState> {
  final CoreApiClient _apiClient;

  DestinationListNotifier(this._apiClient) : super(const DestinationListState()) {
    loadDestinations();
  }

  Future<void> loadDestinations() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(ApiEndpoints.homeDestinations);
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [];
        final destinations = data
            .map<Destination>((item) => Destination.fromJson(item))
            .toList();
        state = state.copyWith(isLoading: false, destinations: destinations);
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load destinations');
      }
    } catch (e) {
      if (kDebugMode) print('Destinations error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadDestinations();
  }
}

final destinationListProvider =
    StateNotifierProvider<DestinationListNotifier, DestinationListState>((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return DestinationListNotifier(apiClient);
});
