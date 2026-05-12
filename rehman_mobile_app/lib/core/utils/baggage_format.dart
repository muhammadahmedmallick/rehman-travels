// App-wide baggage helpers.
//
// Provider responses use a handful of different shapes for baggage:
//   "20 KG"
//   "20kg"
//   "20K"
//   "23 Kg x 2"
//   "Check-in baggage (23 Kg x 2)"
//   "2 PC"
//   "Check-in baggage not Included"
//   "Nil"
//   ""
//
// These helpers normalize that into a single structured value the UI
// can display consistently: e.g. "2 × 23 kg (46 kg total)" or "No bag".
//
// Single source of truth — change the format here and every screen
// updates.

class BaggageInfo {
  /// Number of bags / pieces. 0 when no allowance.
  final int pieces;

  /// Weight per bag in kg. 0 when not specified.
  final int weightPerBagKg;

  /// True when the raw response indicated no allowance.
  final bool none;

  const BaggageInfo({
    this.pieces = 0,
    this.weightPerBagKg = 0,
    this.none = false,
  });

  int get totalKg => pieces * weightPerBagKg;
  bool get hasWeight => weightPerBagKg > 0;
  bool get hasPieces => pieces > 0;

  /// Compact label used on results cards: "23 kg" / "2 × 23 kg" / "No bag".
  String get shortLabel {
    if (none || (!hasWeight && !hasPieces)) return 'No bag';
    if (pieces > 1 && hasWeight) return '$pieces × $weightPerBagKg kg';
    if (hasWeight) return '$weightPerBagKg kg';
    if (hasPieces) return '$pieces ${pieces == 1 ? 'pc' : 'pcs'}';
    return 'No bag';
  }

  /// Verbose label used on details / booking / payment screens:
  /// "2 × 23 kg (46 kg total)" / "23 kg" / "No checked baggage".
  String get longLabel {
    if (none || (!hasWeight && !hasPieces)) return 'No checked baggage';
    if (pieces > 1 && hasWeight) {
      return '$pieces bags × $weightPerBagKg kg ($totalKg kg total)';
    }
    if (hasWeight && pieces == 1) return '1 bag × $weightPerBagKg kg';
    if (hasWeight) return '$weightPerBagKg kg';
    if (hasPieces) return '$pieces ${pieces == 1 ? 'piece' : 'pieces'}';
    return 'No checked baggage';
  }
}

/// Parses any baggage string the API may return into [BaggageInfo].
///
/// When [cabin] is provided and the backend only gave us a piece count
/// (e.g. `"1 PC"`), we enrich the result with the IATA-standard
/// per-cabin weight so the UI can show `"1 × 23 kg"` instead of an
/// ambiguous `"1 pc"`.
BaggageInfo parseBaggage(dynamic raw, {String? cabin}) {
  final result = _parseBaggageRaw(raw);
  // Enrich: if we know pieces but not weight, fall back to a cabin
  // default. Matches the IATA piece-concept defaults most carriers use.
  if (result.hasPieces && !result.hasWeight && cabin != null) {
    final weight = _defaultWeightForCabin(cabin);
    if (weight > 0) {
      return BaggageInfo(
        pieces: result.pieces,
        weightPerBagKg: weight,
        none: false,
      );
    }
  }
  return result;
}

int _defaultWeightForCabin(String cabin) {
  final c = cabin.toUpperCase().trim();
  if (c == 'C' || c == 'J' || c == 'BUSINESS') return 32;
  if (c == 'F' || c == 'FIRST') return 40;
  if (c == 'W' || c == 'PREMIUM' || c == 'PREMIUM ECONOMY') return 25;
  // Economy / default
  return 23;
}

BaggageInfo _parseBaggageRaw(dynamic raw) {
  if (raw == null) return const BaggageInfo();
  final s = raw.toString().trim();
  if (s.isEmpty) return const BaggageInfo();

  final lower = s.toLowerCase();
  if (lower.contains('not included') ||
      lower.contains('not allowed') ||
      lower == 'nil' ||
      lower == 'no' ||
      lower == 'none' ||
      lower == '0') {
    return const BaggageInfo(none: true);
  }

  // Check for explicit zero baggage: "0 kg", "0Kg", "0 K", etc.
  final zeroWeight = RegExp(r'\b0\s*(?:kg|k\b)', caseSensitive: false).hasMatch(s);
  if (zeroWeight) {
    return const BaggageInfo(none: true);
  }

  // Pattern: "23 kg x 2" / "23kg x 2" / "23K x 2"
  final weightAndCount = RegExp(
    r'(\d+)\s*(?:kg|k\b)\s*[x×*]\s*(\d+)',
    caseSensitive: false,
  ).firstMatch(s);
  if (weightAndCount != null) {
    return BaggageInfo(
      weightPerBagKg: int.tryParse(weightAndCount.group(1) ?? '') ?? 0,
      pieces: int.tryParse(weightAndCount.group(2) ?? '') ?? 1,
    );
  }

  // Pattern: "2 x 23 kg" / "2 PC 23 kg"
  // An explicit separator (`x`, `×`, `*`, `pc`, `pcs`, `pieces`) is
  // required between the two numbers — otherwise "35 kg" would be
  // mis-parsed as 3 × 5 kg.
  final countAndWeight = RegExp(
    r'(\d+)\s*(?:pc|pcs|pieces?|[x×*])\s*(\d+)\s*(?:kg|k\b)',
    caseSensitive: false,
  ).firstMatch(s);
  if (countAndWeight != null) {
    final first = int.tryParse(countAndWeight.group(1) ?? '') ?? 0;
    final second = int.tryParse(countAndWeight.group(2) ?? '') ?? 0;
    // Heuristic: smaller of the two is usually the piece count.
    if (first > 0 && second > 0 && first != second) {
      final pieces = first < second ? first : second;
      final weight = first < second ? second : first;
      return BaggageInfo(pieces: pieces, weightPerBagKg: weight);
    }
  }

  // Single weight: "23 kg" / "23kg" / "23 K"
  final weightOnly = RegExp(
    r'(\d+)\s*(?:kg|k\b)',
    caseSensitive: false,
  ).firstMatch(s);
  if (weightOnly != null) {
    return BaggageInfo(
      weightPerBagKg: int.tryParse(weightOnly.group(1) ?? '') ?? 0,
      pieces: 1,
    );
  }

  // Pieces only: "2 PC" / "2 pieces"
  final piecesOnly = RegExp(
    r'(\d+)\s*(?:pc|pcs|pieces?)',
    caseSensitive: false,
  ).firstMatch(s);
  if (piecesOnly != null) {
    return BaggageInfo(pieces: int.tryParse(piecesOnly.group(1) ?? '') ?? 0);
  }

  // Fall back: nothing parsed — return empty so UI shows "No bag".
  return const BaggageInfo();
}
