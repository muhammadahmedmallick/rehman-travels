import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// --- Models ---

class VisaService {
  final int id;
  final String packageTitle;
  final String urlLink;
  final String? metaTitle;
  final String? metaDescription;
  final String? cardImage;
  final String? countryName;
  final String? packageUrl;

  const VisaService({
    required this.id,
    required this.packageTitle,
    required this.urlLink,
    this.metaTitle,
    this.metaDescription,
    this.cardImage,
    this.countryName,
    this.packageUrl,
  });

  factory VisaService.fromJson(Map<String, dynamic> json) {
    return VisaService(
      id: json['id'] ?? 0,
      packageTitle: json['packageTitle'] ?? '',
      urlLink: json['urlLink'] ?? '',
      metaTitle: json['metaTitle'],
      metaDescription: json['metaDescription'],
      cardImage: json['cardImage'],
      countryName: json['countryName'],
      packageUrl: json['packageUrl'],
    );
  }

  String get displayName => countryName ?? packageTitle;

  String? get imageUrl {
    if (cardImage == null || cardImage!.isEmpty) return null;
    return '${ApiEndpoints.coreApiBaseUrl}/media/visa/$cardImage';
  }
}

class VisaDetail {
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
  final String? documentsRequired;
  final String price;
  final int status;
  final String? countryName;
  final String? packageUrl;
  final String? tourUrl;
  final List<dynamic> visaDurations;

  const VisaDetail({
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
    this.documentsRequired,
    this.price = '0.00',
    this.status = 1,
    this.countryName,
    this.packageUrl,
    this.tourUrl,
    this.visaDurations = const [],
  });

  factory VisaDetail.fromJson(Map<String, dynamic> json) {
    final visaDetails = json['visaDetails'] ?? {};
    final visaPackage = json['visaPackage'] ?? {};

    return VisaDetail(
      id: visaDetails['id'] ?? 0,
      packageTitle: visaDetails['packageTitle'] ?? '',
      urlLink: visaDetails['urlLink'] ?? '',
      metaTitle: visaDetails['metaTitle'],
      metaDescription: visaDetails['metaDescription'],
      description: visaDetails['description'],
      shortDescription: visaDetails['shortDescription'],
      cardImage: visaDetails['cardImage'],
      bannerImage: visaDetails['bannerImage'],
      includes: visaDetails['includes'],
      excludes: visaDetails['excludes'],
      documentsRequired: visaDetails['documentsRequired'],
      price: visaDetails['price']?.toString() ?? '0.00',
      status: visaDetails['status'] ?? 1,
      countryName: visaPackage['countryName'],
      packageUrl: visaPackage['packageUrl'],
      tourUrl: visaPackage['tourUrl'],
      visaDurations: json['visaDurations'] ?? [],
    );
  }

  String get displayName => countryName ?? packageTitle;

  String? get imageUrl {
    if (cardImage == null || cardImage!.isEmpty) return null;
    return '${ApiEndpoints.coreApiBaseUrl}/media/visa/$cardImage';
  }

  double get priceValue => double.tryParse(price) ?? 0.0;
}

// --- List State ---

class VisaListState {
  final bool isLoading;
  final List<VisaService> visas;
  final String? error;
  final String searchQuery;

  const VisaListState({
    this.isLoading = false,
    this.visas = const [],
    this.error,
    this.searchQuery = '',
  });

  List<VisaService> get filteredVisas {
    if (searchQuery.isEmpty) return visas;
    final query = searchQuery.toLowerCase();
    return visas.where((v) {
      return v.packageTitle.toLowerCase().contains(query) ||
          (v.countryName?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  VisaListState copyWith({
    bool? isLoading,
    List<VisaService>? visas,
    String? error,
    String? searchQuery,
  }) {
    return VisaListState(
      isLoading: isLoading ?? this.isLoading,
      visas: visas ?? this.visas,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class VisaListNotifier extends StateNotifier<VisaListState> {
  final CoreApiClient _apiClient;

  VisaListNotifier(this._apiClient) : super(const VisaListState()) {
    loadVisas();
  }

  Future<void> loadVisas() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(ApiEndpoints.visaList);
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [];
        final visas = data.map<VisaService>((item) => VisaService.fromJson(item)).toList();
        state = state.copyWith(isLoading: false, visas: visas);
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load visa services');
      }
    } catch (e) {
      if (kDebugMode) print('Visa list error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> refresh() async {
    await loadVisas();
  }
}

// --- Detail State ---

class VisaDetailState {
  final bool isLoading;
  final VisaDetail? detail;
  final String? error;

  const VisaDetailState({
    this.isLoading = false,
    this.detail,
    this.error,
  });

  VisaDetailState copyWith({
    bool? isLoading,
    VisaDetail? detail,
    String? error,
  }) {
    return VisaDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      error: error,
    );
  }
}

class VisaDetailNotifier extends StateNotifier<VisaDetailState> {
  final CoreApiClient _apiClient;

  VisaDetailNotifier(this._apiClient) : super(const VisaDetailState());

  Future<void> loadVisaDetail(String urlLink) async {
    state = const VisaDetailState(isLoading: true);
    try {
      final response = await _apiClient.get(
        ApiEndpoints.visaByUrl,
        queryParameters: {'url': urlLink},
      );
      if (response.statusCode == 200) {
        final detail = VisaDetail.fromJson(response.data);
        state = VisaDetailState(detail: detail);
      } else {
        state = VisaDetailState(error: 'Failed to load visa details');
      }
    } catch (e) {
      if (kDebugMode) print('Visa detail error: $e');
      state = VisaDetailState(error: e.toString());
    }
  }
}

// --- Providers ---

final visaListProvider = StateNotifierProvider<VisaListNotifier, VisaListState>((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return VisaListNotifier(apiClient);
});

final visaDetailProvider = StateNotifierProvider<VisaDetailNotifier, VisaDetailState>((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return VisaDetailNotifier(apiClient);
});
