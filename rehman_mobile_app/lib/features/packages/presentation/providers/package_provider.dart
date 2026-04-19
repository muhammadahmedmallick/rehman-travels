import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// --- Enum ---

enum PackageViewMode { reels, grid }

// --- Model ---

class PackageModel {
  final int id;
  final String? thumbnailUrl;
  final String? bannerUrl;
  final String? videoUrl;
  final String packageType;
  final String title;
  final String slug;
  final String? description;
  final String? tags;
  final List<String> tagsList;
  final String? contactNo;
  final String? whatsappNo;
  final String? informationalMessage;
  final double? startingFrom;
  final String? formattedStartingFrom;
  final double price;
  final String currency;
  final String? formattedPrice;
  final String? location;
  final bool isActive;
  final bool isFeatured;
  final int displayOrder;
  final String createdAt;
  final String updatedAt;

  const PackageModel({
    required this.id,
    this.thumbnailUrl,
    this.bannerUrl,
    this.videoUrl,
    this.packageType = '',
    required this.title,
    required this.slug,
    this.description,
    this.tags,
    this.tagsList = const [],
    this.contactNo,
    this.whatsappNo,
    this.informationalMessage,
    this.startingFrom,
    this.formattedStartingFrom,
    this.price = 0,
    this.currency = 'PKR',
    this.formattedPrice,
    this.location,
    this.isActive = true,
    this.isFeatured = false,
    this.displayOrder = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? 0,
      thumbnailUrl: json['thumbnail_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      videoUrl: json['video_url'] as String?,
      packageType: json['package_type'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      tagsList: (json['tags_list'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          [],
      contactNo: json['contact_no'] as String?,
      whatsappNo: json['whatsapp_no'] as String?,
      informationalMessage: json['informational_message'] as String?,
      startingFrom: double.tryParse(json['starting_from']?.toString() ?? ''),
      formattedStartingFrom: json['formatted_starting_from'] as String?,
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      currency: json['currency'] ?? 'PKR',
      formattedPrice: json['formatted_price'] as String?,
      location: json['location'] as String?,
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String _resolve(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${ApiEndpoints.coreApiBaseUrl}$path';
  }

  String? get fullThumbnailUrl {
    final url = _resolve(thumbnailUrl);
    return url.isEmpty ? null : url;
  }

  String? get fullBannerUrl {
    final url = _resolve(bannerUrl);
    return url.isEmpty ? null : url;
  }

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  bool get isYouTube =>
      videoUrl?.contains('youtube.com') == true ||
      videoUrl?.contains('youtu.be') == true;

  String? get youtubeVideoId {
    if (!isYouTube || videoUrl == null) return null;
    final uri = Uri.tryParse(videoUrl!);
    if (uri == null) return null;
    // youtu.be/ID or youtube.com/shorts/ID
    if (videoUrl!.contains('youtu.be') || uri.pathSegments.contains('shorts')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    }
    return uri.queryParameters['v'];
  }

  String? get youtubeThumbnailUrl {
    final id = youtubeVideoId;
    if (id == null) return null;
    return 'https://img.youtube.com/vi/$id/maxresdefault.jpg';
  }

  String? get primaryImageUrl =>
      youtubeThumbnailUrl ?? fullBannerUrl ?? fullThumbnailUrl;

  bool get hasImages => primaryImageUrl != null;
  bool get hasAnyMedia => hasVideo || hasImages;

  String get displayPrice {
    if (formattedPrice?.isNotEmpty == true) return formattedPrice!;
    if (formattedStartingFrom?.isNotEmpty == true) return formattedStartingFrom!;
    if (price > 0) {
      final str = price.toInt().toString();
      final buf = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
        buf.write(str[i]);
      }
      return '$currency ${buf.toString()}';
    }
    return '';
  }

  String get packageTypeLabel {
    switch (packageType.toLowerCase()) {
      case 'umrah':  return 'Umrah';
      case 'hajj':   return 'Hajj';
      case 'tour':   return 'Tour';
      case 'hotel':  return 'Hotel';
      case 'flight': return 'Flight';
      case 'visa':   return 'Visa';
      case 'combo':  return 'Combo';
      default:       return packageType;
    }
  }
}

// --- List State ---

class PackageListState {
  final bool isLoading;
  final List<PackageModel> packages;
  final String? error;
  final PackageViewMode viewMode;
  final String searchQuery;

  const PackageListState({
    this.isLoading = false,
    this.packages = const [],
    this.error,
    this.viewMode = PackageViewMode.grid,
    this.searchQuery = '',
  });

  List<PackageModel> get filteredPackages {
    if (searchQuery.isEmpty) return packages;
    final q = searchQuery.toLowerCase();
    return packages.where((p) {
      return p.title.toLowerCase().contains(q) ||
          (p.location?.toLowerCase().contains(q) ?? false) ||
          (p.tags?.toLowerCase().contains(q) ?? false) ||
          p.packageType.toLowerCase().contains(q);
    }).toList();
  }

  PackageListState copyWith({
    bool? isLoading,
    List<PackageModel>? packages,
    String? error,
    PackageViewMode? viewMode,
    String? searchQuery,
  }) {
    return PackageListState(
      isLoading: isLoading ?? this.isLoading,
      packages: packages ?? this.packages,
      error: error,
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Demo packages prepended to API results for UI testing
const _demoPackages = [
  PackageModel(
    id: -1,
    slug: 'demo-umrah-1',
    title: 'Umrah Package 2025',
    packageType: 'umrah',
    videoUrl: 'https://www.youtube.com/shorts/4Mrb0iaKi-s',
    location: 'Makkah & Madinah',
    price: 150000,
    currency: 'PKR',
  ),
  PackageModel(
    id: -2,
    slug: 'demo-tour-1',
    title: 'Explore Pakistan',
    packageType: 'tour',
    videoUrl: 'https://www.youtube.com/shorts/6zR84IKdrNM',
    location: 'Northern Pakistan',
    price: 85000,
    currency: 'PKR',
  ),
  PackageModel(
    id: -3,
    slug: 'demo-combo-1',
    title: 'Premium Travel Package',
    packageType: 'combo',
    videoUrl: 'https://www.youtube.com/shorts/MLPOps-QSbE',
    location: 'International',
    price: 200000,
    currency: 'PKR',
  ),
  PackageModel(
    id: -4,
    slug: 'demo-hajj-1',
    title: 'Hajj Package 2025',
    packageType: 'hajj',
    videoUrl: 'https://www.youtube.com/shorts/Gt8Ii1umLus',
    location: 'Makkah · Madinah · Mina',
    price: 850000,
    currency: 'PKR',
  ),
  PackageModel(
    id: -5,
    slug: 'demo-flight-1',
    title: 'International Flights',
    packageType: 'flight',
    videoUrl: 'https://www.youtube.com/shorts/PC9O_V6603M',
    location: 'Worldwide Destinations',
    price: 120000,
    currency: 'PKR',
  ),
  PackageModel(
    id: -6,
    slug: 'demo-hotel-1',
    title: 'Luxury Hotel Stays',
    packageType: 'hotel',
    videoUrl: 'https://www.youtube.com/shorts/Qf3BKyUJRUo',
    location: 'Premium Destinations',
    price: 45000,
    currency: 'PKR',
  ),
  PackageModel(
    id: -7,
    slug: 'demo-visa-1',
    title: 'Visa Services',
    packageType: 'visa',
    videoUrl: 'https://www.youtube.com/shorts/KL94usCKLpU',
    location: 'All Countries',
    price: 25000,
    currency: 'PKR',
  ),
];

class PackageListNotifier extends StateNotifier<PackageListState> {
  final CoreApiClient _apiClient;

  PackageListNotifier(this._apiClient) : super(const PackageListState()) {
    loadPackages();
  }

  Future<void> loadPackages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(
        ApiEndpoints.mobilePackages,
        queryParameters: {'ordering': 'display_order,-created_at'},
      );
      if (response.statusCode == 200) {
        // API returns paginated { count, next, previous, results: [...] }
        List data;
        if (response.data is Map) {
          data = (response.data['results'] as List?) ?? [];
        } else {
          data = response.data is List ? response.data as List : [];
        }
        final packages = data
            .map<PackageModel>((item) =>
                PackageModel.fromJson(item as Map<String, dynamic>))
            .where((p) => p.isActive)
            .toList();
        state = state.copyWith(isLoading: false, packages: [..._demoPackages, ...packages]);
      } else {
        state = state.copyWith(
            isLoading: false, error: 'Failed to load packages');
      }
    } catch (e) {
      if (kDebugMode) print('Package list error: $e');
      state = state.copyWith(isLoading: false, packages: _demoPackages, error: e.toString());
    }
  }

  void toggleViewMode() {
    final next = state.viewMode == PackageViewMode.reels
        ? PackageViewMode.grid
        : PackageViewMode.reels;
    state = state.copyWith(viewMode: next);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> refresh() async => loadPackages();
}

// Which reel index to open on next entering reels mode
final initialReelIndexProvider = StateProvider<int>((ref) => 0);

// --- Provider ---

final packageListProvider =
    StateNotifierProvider<PackageListNotifier, PackageListState>((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return PackageListNotifier(apiClient);
});
