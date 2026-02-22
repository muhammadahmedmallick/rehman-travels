import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';

class Branch {
  final int id;
  final String branchName;
  final String branchAddress;
  final String branchPhone;
  final String mapAddress;
  final String branchStatus;
  final int branchSequence;
  final bool showOnHome;

  const Branch({
    required this.id,
    required this.branchName,
    required this.branchAddress,
    required this.branchPhone,
    required this.mapAddress,
    required this.branchStatus,
    required this.branchSequence,
    required this.showOnHome,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      branchName: json['branchname'] ?? '',
      branchAddress: json['branchaddress'] ?? '',
      branchPhone: json['branchphone'] ?? '',
      mapAddress: json['mapaddress'] ?? '',
      branchStatus: json['branchstatus'] ?? '',
      branchSequence: json['branchsequance'] ?? 0,
      showOnHome: json['showonhome'] == '1',
    );
  }

  bool get hasPhone => branchPhone.isNotEmpty && branchPhone != '#';

  bool get hasMap => mapAddress.isNotEmpty && mapAddress != '#' && mapAddress.contains('google');

  String get flagEmoji {
    final lower = branchName.toLowerCase();
    if (lower.contains('islamabad') || lower.contains('lahore') || lower.contains('peshawar') || lower.contains('karachi') || lower.contains('mirpur')) return '🇵🇰';
    if (lower.contains('dubai') || lower.contains('uae')) return '🇦🇪';
    if (lower.contains('makkah') || lower.contains('madinah')) return '🇸🇦';
    if (lower.contains('united kingdom') || lower.contains('uk')) return '🇬🇧';
    return '📍';
  }
}

class BranchState {
  final bool isLoading;
  final List<Branch> branches;
  final String? error;

  const BranchState({
    this.isLoading = false,
    this.branches = const [],
    this.error,
  });

  BranchState copyWith({
    bool? isLoading,
    List<Branch>? branches,
    String? error,
  }) {
    return BranchState(
      isLoading: isLoading ?? this.isLoading,
      branches: branches ?? this.branches,
      error: error,
    );
  }
}

class BranchNotifier extends StateNotifier<BranchState> {
  final CoreApiClient _apiClient;

  BranchNotifier(this._apiClient) : super(const BranchState()) {
    loadBranches();
  }

  Future<void> loadBranches() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(ApiEndpoints.branches);

      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];

        final branches = results
            .where((item) => item['branchstatus'] == 'active')
            .map<Branch>((item) => Branch.fromJson(item))
            .toList();

        // Sort by sequence
        branches.sort((a, b) => a.branchSequence.compareTo(b.branchSequence));

        state = state.copyWith(
          isLoading: false,
          branches: branches,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load branches',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Branches API error: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to load branches.',
      );
    }
  }

  Future<void> refresh() async {
    await loadBranches();
  }
}

final branchProvider = StateNotifierProvider<BranchNotifier, BranchState>((ref) {
  return BranchNotifier(ref.watch(coreApiClientProvider));
});
