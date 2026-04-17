import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../main.dart' show kRecentSearchesBox;
import '../../data/models/recent_search_item.dart';

/// Maximum number of searches to keep on disk. Anything older is evicted.
const int _kMaxStored = 20;

class RecentSearchesNotifier extends StateNotifier<List<RecentSearchItem>> {
  RecentSearchesNotifier() : super(const []) {
    _load();
  }

  Box<String> get _box => Hive.box<String>(kRecentSearchesBox);

  void _load() {
    try {
      final items = <RecentSearchItem>[];
      final corruptKeys = <dynamic>[];
      for (final key in _box.keys) {
        final raw = _box.get(key);
        if (raw == null) continue;
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          final item = RecentSearchItem.fromJson(map);
          // Drop multi-city entries saved by an older build where the
          // per-leg `date` field was written empty — they can't be
          // re-run because the search payload has no dates. Evict them
          // from the box so they stop showing up in "Pick up where you
          // left off" (where tapping would hit an API error).
          if (item.tripType == 'multi') {
            final legs = item.legs ?? const [];
            final hasBadLeg = legs.isEmpty ||
                legs.any((l) => l.date.isEmpty ||
                    l.fromCode.isEmpty ||
                    l.toCode.isEmpty);
            if (hasBadLeg) {
              corruptKeys.add(key);
              continue;
            }
          }
          items.add(item);
        } catch (e) {
          corruptKeys.add(key);
          if (kDebugMode) print('Recent searches: bad entry skipped — $e');
        }
      }
      if (corruptKeys.isNotEmpty) {
        // Fire-and-forget — we don't block the initial load on the
        // cleanup, and Hive writes are fast enough that this finishes
        // before the user can interact with the list anyway.
        _box.deleteAll(corruptKeys);
      }
      items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      state = items;
    } catch (e) {
      if (kDebugMode) print('Recent searches load error: $e');
      state = const [];
    }
  }

  Future<void> add(RecentSearchItem item) async {
    try {
      // Dedup — if the same route/dates/cabin already exists, replace it
      // so the timestamp moves to "now".
      await _box.put(item.dedupKey, jsonEncode(item.toJson()));

      // Evict oldest entries past the cap.
      if (_box.length > _kMaxStored) {
        final all = <MapEntry<String, RecentSearchItem>>[];
        for (final key in _box.keys) {
          final raw = _box.get(key);
          if (raw == null) continue;
          try {
            final parsed =
                RecentSearchItem.fromJson(jsonDecode(raw) as Map<String, dynamic>);
            all.add(MapEntry(key.toString(), parsed));
          } catch (_) {}
        }
        all.sort((a, b) => b.value.savedAt.compareTo(a.value.savedAt));
        for (final extra in all.skip(_kMaxStored)) {
          await _box.delete(extra.key);
        }
      }

      _load();
    } catch (e) {
      if (kDebugMode) print('Recent searches add error: $e');
    }
  }

  Future<void> deleteByKey(String key) async {
    await _box.delete(key);
    _load();
  }

  Future<void> clearAll() async {
    await _box.clear();
    state = const [];
  }
}

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<RecentSearchItem>>(
  (ref) => RecentSearchesNotifier(),
);
