import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';
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
        state = state.copyWith(isLoading: false, types: types);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load visas (${res.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => load();
}

final visaTypesProvider =
    StateNotifierProvider<VisaTypesNotifier, VisaTypesState>((ref) {
  return VisaTypesNotifier(ref.watch(coreApiClientProvider));
});

/// Fetches a single visa type (with full variants + rules) by id from
/// `/api/mobile/visas/types/{id}`. The list endpoint omits per-variant
/// rules, so the details screen must call this to render requirements.
final visaTypeDetailProvider =
    FutureProvider.family<VisaType, int>((ref, id) async {
  final api = ref.watch(coreApiClientProvider);
  final res = await api.get(ApiEndpoints.mobileVisaTypeDetail(id));
  if (res.statusCode != 200) {
    throw Exception('Failed to load visa detail (${res.statusCode})');
  }
  final data = Map<String, dynamic>.from(res.data as Map);
  return VisaType.fromJson(data);
});
