import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// --- Models ---

class UmrahPackage {
  final int id;
  final String packageTitle;
  final String urlLink;
  final String? cardImage;
  final String? bannerImage;
  final String price;
  final String currencyType;
  final String? shortDescription;
  final String? categories;
  final int sequence;

  const UmrahPackage({
    required this.id,
    required this.packageTitle,
    required this.urlLink,
    this.cardImage,
    this.bannerImage,
    this.price = '0',
    this.currencyType = 'PKR',
    this.shortDescription,
    this.categories,
    this.sequence = 0,
  });

  factory UmrahPackage.fromJson(Map<String, dynamic> json) {
    return UmrahPackage(
      id: json['id'] ?? 0,
      packageTitle: json['packageTitle'] ?? '',
      urlLink: json['urlLink'] ?? '',
      cardImage: json['cardImage'],
      bannerImage: json['bannerImage'],
      price: json['price']?.toString() ?? '0',
      currencyType: json['currencyType'] ?? 'PKR',
      shortDescription: json['shortDescription'],
      categories: json['categories'],
      sequence: json['sequence'] ?? 0,
    );
  }

  String? get imageUrl {
    if (cardImage == null || cardImage!.isEmpty) return null;
    return '${ApiEndpoints.baseUrl}/assets/Umrah/$cardImage';
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

/// A content section — text, heading, table, or bullets
class ContentSection {
  final String type; // 'text', 'heading', 'table', 'bullets'
  final String? content;
  final List<List<String>> headers;
  final List<List<String>> rows;
  final List<String> items; // for bullets

  const ContentSection({
    required this.type,
    this.content,
    this.headers = const [],
    this.rows = const [],
    this.items = const [],
  });

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    final type = json['type'] ?? 'text';
    if (type == 'table') {
      return ContentSection(
        type: 'table',
        headers: (json['headers'] as List?)
                ?.map<List<String>>((row) =>
                    (row as List).map<String>((c) => c.toString()).toList())
                .toList() ??
            [],
        rows: (json['rows'] as List?)
                ?.map<List<String>>((row) =>
                    (row as List).map<String>((c) => c.toString()).toList())
                .toList() ??
            [],
      );
    }
    if (type == 'bullets') {
      return ContentSection(
        type: 'bullets',
        items: (json['items'] as List?)
                ?.map<String>((i) => i.toString())
                .toList() ??
            [],
      );
    }
    return ContentSection(
      type: type,
      content: json['content']?.toString(),
    );
  }
}

class UmrahPackageDetail {
  final int id;
  final String packageTitle;
  final String urlLink;
  final String? metaTitle;
  final String? cardImage;
  final String? bannerImage;
  final String price;
  final String currencyType;
  final String? categories;
  final int status;
  final List<ContentSection> overview;
  final List<ContentSection> description;
  final List<ContentSection> includes;
  final List<ContentSection> excludes;

  const UmrahPackageDetail({
    required this.id,
    required this.packageTitle,
    required this.urlLink,
    this.metaTitle,
    this.cardImage,
    this.bannerImage,
    this.price = '0',
    this.currencyType = 'PKR',
    this.categories,
    this.status = 1,
    this.overview = const [],
    this.description = const [],
    this.includes = const [],
    this.excludes = const [],
  });

  factory UmrahPackageDetail.fromJson(Map<String, dynamic> json) {
    final details = json['packageDetails'] ?? {};

    return UmrahPackageDetail(
      id: details['id'] ?? 0,
      packageTitle: details['packageTitle'] ?? '',
      urlLink: details['urlLink'] ?? '',
      metaTitle: details['metaTitle'],
      cardImage: details['cardImage'],
      bannerImage: details['bannerImage'],
      price: details['price']?.toString() ?? '0',
      currencyType: details['currencyType'] ?? 'PKR',
      categories: details['categories'],
      status: details['status'] ?? 1,
      overview: _parseSections(json['overview']),
      description: _parseSections(json['description']),
      includes: _parseSections(json['includes']),
      excludes: _parseSections(json['excludes']),
    );
  }

  static List<ContentSection> _parseSections(dynamic list) {
    if (list == null || list is! List) return [];
    return list
        .map<ContentSection>((item) => ContentSection.fromJson(item))
        .toList();
  }

  String? get imageUrl {
    if (bannerImage != null && bannerImage!.isNotEmpty) {
      return '${ApiEndpoints.baseUrl}/assets/Umrah/$bannerImage';
    }
    if (cardImage != null && cardImage!.isNotEmpty) {
      return '${ApiEndpoints.baseUrl}/assets/Umrah/$cardImage';
    }
    return null;
  }

  double get priceValue => double.tryParse(price.replaceAll(',', '')) ?? 0.0;

  String get formattedPrice {
    if (priceValue <= 0) return '';
    final intPrice = priceValue.toInt();
    final formatted = intPrice.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$currencyType $formatted';
  }
}

// --- States & Notifiers ---

class UmrahListState {
  final bool isLoading;
  final List<UmrahPackage> packages;
  final String? error;

  const UmrahListState({this.isLoading = false, this.packages = const [], this.error});

  UmrahListState copyWith({bool? isLoading, List<UmrahPackage>? packages, String? error}) {
    return UmrahListState(
      isLoading: isLoading ?? this.isLoading,
      packages: packages ?? this.packages,
      error: error,
    );
  }
}

class UmrahListNotifier extends StateNotifier<UmrahListState> {
  final CoreApiClient _apiClient;

  UmrahListNotifier(this._apiClient) : super(const UmrahListState()) {
    loadPackages();
  }

  Future<void> loadPackages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(ApiEndpoints.umrahPackageList);
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [];
        final packages = data.map<UmrahPackage>((item) => UmrahPackage.fromJson(item)).toList();
        state = state.copyWith(isLoading: false, packages: packages);
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load packages');
      }
    } catch (e) {
      if (kDebugMode) print('Umrah list error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async => loadPackages();
}

class UmrahDetailState {
  final bool isLoading;
  final UmrahPackageDetail? detail;
  final String? error;

  const UmrahDetailState({this.isLoading = false, this.detail, this.error});

  UmrahDetailState copyWith({bool? isLoading, UmrahPackageDetail? detail, String? error}) {
    return UmrahDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      error: error,
    );
  }
}

class UmrahDetailNotifier extends StateNotifier<UmrahDetailState> {
  final CoreApiClient _apiClient;

  UmrahDetailNotifier(this._apiClient) : super(const UmrahDetailState());

  Future<void> loadPackageDetail(String urlLink) async {
    state = const UmrahDetailState(isLoading: true);
    try {
      final response = await _apiClient.get(
        ApiEndpoints.umrahPackageByUrl,
        queryParameters: {'url': urlLink},
      );
      if (response.statusCode == 200) {
        final detail = UmrahPackageDetail.fromJson(response.data);
        state = UmrahDetailState(detail: detail);
      } else {
        state = UmrahDetailState(error: 'Failed to load package details');
      }
    } catch (e) {
      if (kDebugMode) print('Umrah detail error: $e');
      state = UmrahDetailState(error: e.toString());
    }
  }
}

// --- Providers ---

final umrahListProvider = StateNotifierProvider<UmrahListNotifier, UmrahListState>((ref) {
  return UmrahListNotifier(ref.watch(coreApiClientProvider));
});

final umrahDetailProvider = StateNotifierProvider<UmrahDetailNotifier, UmrahDetailState>((ref) {
  return UmrahDetailNotifier(ref.watch(coreApiClientProvider));
});
