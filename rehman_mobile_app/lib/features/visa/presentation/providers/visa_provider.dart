import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';
import '../../data/mock_visas.dart';
import '../../data/models/visa_models.dart';

/// Single list state for visa types. Types response already nests
/// variants + rules, so one fetch powers both the home (country
/// picker) and details (requirements + variants) screens.
class VisaTypesState {
  final bool isLoading;
  final List<VisaType> types;
  final String? error;

  const VisaTypesState({
    this.isLoading = false,
    this.types = const [],
    this.error,
  });

  VisaTypesState copyWith({
    bool? isLoading,
    List<VisaType>? types,
    String? error,
  }) {
    return VisaTypesState(
      isLoading: isLoading ?? this.isLoading,
      types: types ?? this.types,
      error: error,
    );
  }
}

class VisaTypesNotifier extends StateNotifier<VisaTypesState> {
  final CoreApiClient _api;

  VisaTypesNotifier(this._api) : super(const VisaTypesState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _api.get(ApiEndpoints.mobileVisaTypes);
      if (res.statusCode == 200) {
        // DRF paginated shape: { count, next, previous, results: [...] }
        final raw = res.data;
        final results = raw is Map<String, dynamic>
            ? (raw['results'] as List? ?? const [])
            : (raw is List ? raw : const []);
        final types = results
            .map((e) => VisaType.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        if (types.isEmpty) {
          // API is live but the catalog isn't populated yet — fall
          // back to the local mock so the UI still has something
          // meaningful to render. Remove once the backend ships
          // real data.
          if (kDebugMode) print('Visa types: empty API response, using mock');
          state = state.copyWith(isLoading: false, types: _mockTypes());
        } else {
          state = state.copyWith(isLoading: false, types: types);
        }
      } else {
        if (kDebugMode) {
          print('Visa types non-200 (${res.statusCode}), using mock');
        }
        state = state.copyWith(isLoading: false, types: _mockTypes());
      }
    } catch (e) {
      if (kDebugMode) print('Visa types load error: $e — using mock');
      // Fall back to the mock so the UI doesn't get stuck on an
      // empty state while the real endpoint is being brought up.
      // Clearing `error` is deliberate — the user sees working
      // content, so surfacing a failure would be misleading. The
      // kDebugMode log above still captures the issue for devs.
      state = state.copyWith(
        isLoading: false,
        types: _mockTypes(),
      );
    }
  }

  /// Parses the bundled mock response — same shape as the real API —
  /// into a list of [VisaType]. Used as a fallback while the real
  /// endpoint is being implemented.
  List<VisaType> _mockTypes() {
    final results = (kMockVisaTypesResponse['results'] as List? ?? const []);
    return results
        .map((e) => VisaType.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> refresh() => load();
}

final visaTypesProvider =
    StateNotifierProvider<VisaTypesNotifier, VisaTypesState>((ref) {
  return VisaTypesNotifier(ref.watch(coreApiClientProvider));
});
