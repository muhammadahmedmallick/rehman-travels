import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../main.dart' show kDebugPnrsBox;
import '../../data/models/debug_pnr_record.dart';

/// Hive-backed list of every PNR Exalted has handed back to the app
/// during a debug session. Settings → Debug PNRs reads this; the
/// booking screen writes to it on every successful (and partial /
/// errorType=true) orderCreate response.
class DebugPnrNotifier extends StateNotifier<List<DebugPnrRecord>> {
  DebugPnrNotifier() : super(const []) {
    _load();
  }

  Box<String> get _box => Hive.box<String>(kDebugPnrsBox);

  void _load() {
    if (!kDebugMode) {
      // Release builds never read the box — keep it empty so the
      // settings screen doesn't accidentally render anything.
      state = const [];
      return;
    }
    final items = <DebugPnrRecord>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw == null) continue;
      try {
        items.add(DebugPnrRecord.fromJson(
            jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {
        // Drop garbage — easier than migrating broken rows.
        _box.delete(key);
      }
    }
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> add(DebugPnrRecord record) async {
    if (!kDebugMode) return;
    if (record.pnr.trim().isEmpty) return;
    try {
      await _box.put(record.pnr, jsonEncode(record.toJson()));
      _load();
    } catch (e) {
      if (kDebugMode) print('DebugPnr add error: $e');
    }
  }

  Future<void> remove(String pnr) async {
    if (!kDebugMode) return;
    try {
      await _box.delete(pnr);
      _load();
    } catch (e) {
      if (kDebugMode) print('DebugPnr remove error: $e');
    }
  }

  Future<void> clearAll() async {
    if (!kDebugMode) return;
    await _box.clear();
    state = const [];
  }
}

final debugPnrsProvider =
    StateNotifierProvider<DebugPnrNotifier, List<DebugPnrRecord>>(
  (ref) => DebugPnrNotifier(),
);
