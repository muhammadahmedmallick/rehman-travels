import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// --- Models ---

class PakTourService {
  final int id;
  final String packageTitle;
  final String urlLink;
  final String? cardImage;
  final String price;
  final String currencyType;
  final int? tourDays;
  final int? tourNights;
  final String? tourAvailability;
  final String? priceLabel;
  final String? departureLocation;
  final String? destinationLocation;

  const PakTourService({
    required this.id,
    required this.packageTitle,
    required this.urlLink,
    this.cardImage,
    this.price = '0',
    this.currencyType = 'PKR',
    this.tourDays,
    this.tourNights,
    this.tourAvailability,
    this.priceLabel,
    this.departureLocation,
    this.destinationLocation,
  });

  factory PakTourService.fromJson(Map<String, dynamic> json) {
    return PakTourService(
      id: json['id'] ?? 0,
      packageTitle: json['packageTitle'] ?? '',
      urlLink: json['urlLink'] ?? '',
      cardImage: json['cardImage'],
      price: json['price']?.toString() ?? '0',
      currencyType: json['currencyType'] ?? 'PKR',
      tourDays: json['tourDays'],
      tourNights: json['tourNights'],
      tourAvailability: json['tourAvailability'],
      priceLabel: json['priceLabel'],
      departureLocation: json['departureLocation'],
      destinationLocation: json['destinationLocation'],
    );
  }

  String? get imageUrl {
    if (cardImage == null || cardImage!.isEmpty) return null;
    return '${ApiEndpoints.baseUrl}/assets/Domestic%20Tour/$cardImage';
  }

  String get durationText {
    if (tourDays != null && tourNights != null) {
      return '${tourDays}D/${tourNights}N';
    }
    return '';
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

  String get priceLabelText {
    if (priceLabel != null && priceLabel!.isNotEmpty) return '/ $priceLabel';
    return '';
  }

  String get routeText {
    if (departureLocation != null && destinationLocation != null) {
      return '$departureLocation - $destinationLocation';
    }
    return '';
  }
}

class PakTourDetail {
  final int id;
  final String packageTitle;
  final String urlLink;
  final String? metaTitle;
  final String? metaDescription;
  final String? description;
  final String? shortDescription;
  final String? cardImage;
  final String? bannerImage;
  final String? includes;
  final String? excludes;
  final String price;
  final String currencyType;
  final int status;
  final int? tourDays;
  final int? tourNights;
  final String? tourAvailability;
  final String? priceLabel;
  final String? discountPrice;
  final String? departureLocation;
  final String? destinationLocation;
  final String? tourServices;
  final String? map;
  final String? daysDetails;
  final List<dynamic> tourImages;

  const PakTourDetail({
    required this.id,
    required this.packageTitle,
    required this.urlLink,
    this.metaTitle,
    this.metaDescription,
    this.description,
    this.shortDescription,
    this.cardImage,
    this.bannerImage,
    this.includes,
    this.excludes,
    this.price = '0',
    this.currencyType = 'PKR',
    this.status = 1,
    this.tourDays,
    this.tourNights,
    this.tourAvailability,
    this.priceLabel,
    this.discountPrice,
    this.departureLocation,
    this.destinationLocation,
    this.tourServices,
    this.map,
    this.daysDetails,
    this.tourImages = const [],
  });

  factory PakTourDetail.fromJson(Map<String, dynamic> json) {
    final tourDetails = json['tourDetails'] ?? {};
    final tourPackage = json['tourPackage'] ?? {};

    return PakTourDetail(
      id: tourDetails['id'] ?? 0,
      packageTitle: tourDetails['packageTitle'] ?? '',
      urlLink: tourDetails['urlLink'] ?? '',
      metaTitle: tourDetails['metaTitle'],
      metaDescription: tourDetails['metaDescription'],
      description: tourDetails['description'],
      shortDescription: tourDetails['shortDescription'],
      cardImage: tourDetails['cardImage'],
      bannerImage: tourDetails['bannerImage'],
      includes: tourDetails['includes'],
      excludes: tourDetails['excludes'],
      price: tourDetails['price']?.toString() ?? '0',
      currencyType: tourDetails['currencyType'] ?? 'PKR',
      status: tourDetails['status'] ?? 1,
      tourDays: tourPackage['tourDays'],
      tourNights: tourPackage['tourNights'],
      tourAvailability: tourPackage['tourAvailability'],
      priceLabel: tourPackage['priceLabel'],
      discountPrice: tourPackage['discountPrice'],
      departureLocation: tourPackage['departureLocation'],
      destinationLocation: tourPackage['destinationLocation'],
      tourServices: tourPackage['tourServices'],
      map: tourPackage['map'],
      daysDetails: tourPackage['daysDetails'],
      tourImages: json['tourImages'] ?? [],
    );
  }

  String? get imageUrl {
    if (cardImage != null && cardImage!.isNotEmpty) {
      return '${ApiEndpoints.baseUrl}/assets/Domestic%20Tour/$cardImage';
    }
    return null;
  }

  double get priceValue => double.tryParse(price.replaceAll(',', '')) ?? 0.0;

  double get discountPriceValue =>
      double.tryParse(discountPrice?.replaceAll(',', '') ?? '') ?? 0.0;

  String get durationText {
    if (tourDays != null && tourNights != null) {
      return '${tourDays}D/${tourNights}N';
    }
    return '';
  }

  String get priceLabelText {
    if (priceLabel != null && priceLabel!.isNotEmpty) return '/ $priceLabel';
    return '';
  }
}

// --- List State ---

class PakTourListState {
  final bool isLoading;
  final List<PakTourService> tours;
  final String? error;
  final String searchQuery;

  const PakTourListState({
    this.isLoading = false,
    this.tours = const [],
    this.error,
    this.searchQuery = '',
  });

  List<PakTourService> get filteredTours {
    if (searchQuery.isEmpty) return tours;
    final query = searchQuery.toLowerCase();
    return tours.where((t) {
      return t.packageTitle.toLowerCase().contains(query) ||
          (t.departureLocation?.toLowerCase().contains(query) ?? false) ||
          (t.destinationLocation?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  PakTourListState copyWith({
    bool? isLoading,
    List<PakTourService>? tours,
    String? error,
    String? searchQuery,
  }) {
    return PakTourListState(
      isLoading: isLoading ?? this.isLoading,
      tours: tours ?? this.tours,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PakTourListNotifier extends StateNotifier<PakTourListState> {
  final CoreApiClient _apiClient;

  PakTourListNotifier(this._apiClient) : super(const PakTourListState()) {
    loadTours();
  }

  Future<void> loadTours() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(ApiEndpoints.pakTourList);
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [];
        final tours = data.map<PakTourService>((item) => PakTourService.fromJson(item)).toList();
        state = state.copyWith(isLoading: false, tours: tours);
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load tours');
      }
    } catch (e) {
      if (kDebugMode) print('Pak tour list error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> refresh() async {
    await loadTours();
  }
}

// --- Detail State ---

class PakTourDetailState {
  final bool isLoading;
  final PakTourDetail? detail;
  final String? error;

  const PakTourDetailState({
    this.isLoading = false,
    this.detail,
    this.error,
  });

  PakTourDetailState copyWith({
    bool? isLoading,
    PakTourDetail? detail,
    String? error,
  }) {
    return PakTourDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      error: error,
    );
  }
}

class PakTourDetailNotifier extends StateNotifier<PakTourDetailState> {
  final CoreApiClient _apiClient;

  PakTourDetailNotifier(this._apiClient) : super(const PakTourDetailState());

  Future<void> loadTourDetail(String urlLink) async {
    state = const PakTourDetailState(isLoading: true);
    try {
      final response = await _apiClient.get(
        ApiEndpoints.pakTourByUrl,
        queryParameters: {'url': urlLink},
      );
      if (response.statusCode == 200) {
        final detail = PakTourDetail.fromJson(response.data);
        state = PakTourDetailState(detail: detail);
      } else {
        state = PakTourDetailState(error: 'Failed to load tour details');
      }
    } catch (e) {
      if (kDebugMode) print('Pak tour detail error: $e');
      state = PakTourDetailState(error: e.toString());
    }
  }
}

// --- Providers ---

final pakTourListProvider = StateNotifierProvider<PakTourListNotifier, PakTourListState>((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return PakTourListNotifier(apiClient);
});

final pakTourDetailProvider = StateNotifierProvider<PakTourDetailNotifier, PakTourDetailState>((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return PakTourDetailNotifier(apiClient);
});
