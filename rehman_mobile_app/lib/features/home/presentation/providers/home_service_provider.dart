import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home-screen service switcher — persists across app restarts so
/// the user returns to the same tab they were last using.
enum HomeService { flights, buses, packages, visas, esim }

const String _kPrefsKey = 'home_selected_service';

class HomeServiceNotifier extends StateNotifier<HomeService> {
  HomeServiceNotifier() : super(HomeService.flights) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kPrefsKey);
      if (saved == null) return;
      final match = HomeService.values.firstWhere(
        (s) => s.name == saved,
        orElse: () => HomeService.flights,
      );
      state = match;
    } catch (e) {
      if (kDebugMode) print('HomeService load error: $e');
    }
  }

  Future<void> select(HomeService service) async {
    state = service;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPrefsKey, service.name);
    } catch (e) {
      if (kDebugMode) print('HomeService save error: $e');
    }
  }
}

final homeServiceProvider =
    StateNotifierProvider<HomeServiceNotifier, HomeService>(
  (ref) => HomeServiceNotifier(),
);
