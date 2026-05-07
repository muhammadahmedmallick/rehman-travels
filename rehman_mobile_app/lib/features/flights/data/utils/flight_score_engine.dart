import '../models/filter_sort_config.dart';

/// Backend-driven flight scoring engine. Walks the [FilterSortConfig]
/// from `/api/core/filter-config/flights/` and produces:
///
///   • `bestScore`   — weighted 0-100 score per flight, used for the
///                     "Best" sort and the BEST tag.
///   • `cheapestRank` / `fastestRank` — 1-based positions, used by
///                     the corresponding tags + sort chips.
///
/// Falls through to safe defaults whenever a factor is missing from
/// the config so a partially-populated payload still produces sane
/// numbers — the result screen always renders.
///
/// Formulas (per [ScoreFactor.formula]):
///   • `RATIO_INVERSE` — `(min / value) * 100` (lower-is-better)
///   • `DIRECT`        — `value` (already 0-100)
///   • `LOOKUP`        — `lookup_table[value]` with `'3+'` bucket
///   • `CUSTOM`        — hand-rolled per factor name (timing,
///                        layover_quality)
class FlightScoreEngine {
  FlightScoreEngine(this.config);

  final FilterSortConfig? config;

  bool get isConfigured => config != null && config!.factors.isNotEmpty;

  /// Computes everything in one pass and returns a parallel list of
  /// [FlightScore] indexed the same as [flights].
  List<FlightScore> score(List<Map<String, dynamic>> flights) {
    if (flights.isEmpty) return const [];

    // 1. Extract raw values + range bounds for ratio normalisation.
    final prices = <double>[];
    final durations = <double>[]; // minutes
    final stopsList = <int>[];
    final timings = <int>[]; // departure minute-of-day
    final layovers = <int>[]; // longest layover minutes
    final airlineRatings = <double>[];

    for (final f in flights) {
      prices.add(_priceOf(f));
      durations.add(_durationMinutesOf(f).toDouble());
      stopsList.add(_stopsOf(f));
      timings.add(_departureMinuteOf(f));
      layovers.add(_longestLayoverMinutesOf(f));
      airlineRatings.add(_airlineRatingOf(f));
    }

    final priceMin = _minFinite(prices);
    final durationMin = _minPositive(durations);

    // 2. Per-flight weighted score.
    final scores = List<FlightScore>.generate(flights.length, (i) {
      final perFactor = <String, double>{};
      double weightedSum = 0;
      double weightTotal = 0;

      config?.factors.forEach((name, factor) {
        final raw = _rawValueFor(name, flights[i],
            priceVal: prices[i],
            durationVal: durations[i],
            stopsVal: stopsList[i],
            timingVal: timings[i],
            layoverVal: layovers[i],
            airlineRatingVal: airlineRatings[i]);
        final s = _applyFormula(name, factor, raw,
            priceMin: priceMin, durationMin: durationMin);
        perFactor[name] = s;
        weightedSum += s * factor.weight;
        weightTotal += factor.weight;
      });

      // If config is empty / unconfigured, fall back to a price+duration
      // weighted blend (60/40) so callers still get a usable score.
      double bestScore;
      if (weightTotal > 0) {
        bestScore = weightedSum / weightTotal;
      } else {
        final priceSpread = (_maxFinite(prices) - priceMin).abs();
        final durSpread =
            (_maxFinite(durations) - durationMin).abs();
        final pn = priceSpread > 0 ? (prices[i] - priceMin) / priceSpread : 0;
        final dn = durSpread > 0 ? (durations[i] - durationMin) / durSpread : 0;
        bestScore = (1 - (0.6 * pn + 0.4 * dn)) * 100;
      }

      // Round to config-specified decimals (default 2).
      final decimals = config?.roundToDecimals ?? 2;
      bestScore = double.parse(bestScore.toStringAsFixed(decimals));

      return FlightScore(
        index: i,
        bestScore: bestScore,
        priceValue: prices[i],
        durationMinutes: durations[i],
        perFactor: perFactor,
      );
    });

    // 3. Ranks — 1-based positions for each ranking rule.
    _applyRank(scores, 'cheapest_rank',
        sortBy: 'price', ascending: true);
    _applyRank(scores, 'fastest_rank',
        sortBy: 'duration_minutes', ascending: true);
    _applyRank(scores, 'best_rank',
        sortBy: 'best_score', ascending: false);

    return scores;
  }

  /// Returns the list of tag strings (e.g. `['BEST', 'CHEAPEST']`)
  /// that apply to the given score per the config's `tag_rules`.
  List<String> tagsFor(FlightScore s) {
    if (config == null || config!.tagRules.isEmpty) return const [];
    final tags = <String>[];
    for (final rule in config!.tagRules) {
      if (_evaluateCondition(rule.condition, s)) {
        tags.add(rule.tag);
      }
    }
    return tags;
  }

  /// Resolves the rule for a single tag (used to look up its colour /
  /// icon). `null` when the tag isn't in the config.
  TagRule? ruleFor(String tag) {
    if (config == null) return null;
    final t = tag.toUpperCase();
    for (final r in config!.tagRules) {
      if (r.tag == t) return r;
    }
    return null;
  }

  // ─── Internals ─────────────────────────────────────────────────

  double _rawValueFor(
    String name,
    Map<String, dynamic> flight, {
    required double priceVal,
    required double durationVal,
    required int stopsVal,
    required int timingVal,
    required int layoverVal,
    required double airlineRatingVal,
  }) {
    switch (name) {
      case 'price':
        return priceVal;
      case 'duration':
        return durationVal;
      case 'stops':
        return stopsVal.toDouble();
      case 'timing':
        return timingVal.toDouble();
      case 'layover_quality':
        return layoverVal.toDouble();
      case 'airline_rating':
        return airlineRatingVal;
      default:
        // Unknown factor — try direct field lookup on the flight map
        // so backend can add new factors without an app release.
        final v = flight[name];
        if (v is num) return v.toDouble();
        return 0;
    }
  }

  double _applyFormula(
    String name,
    ScoreFactor factor,
    double raw, {
    required double priceMin,
    required double durationMin,
  }) {
    switch (factor.formula) {
      case 'RATIO_INVERSE':
        // Lower-is-better — scaled relative to the cheapest / fastest
        // option in this set. Returns 100 for the best, lower for
        // worse, never below 0.
        if (raw <= 0) return 0;
        final ref = name == 'price'
            ? priceMin
            : (name == 'duration' ? durationMin : raw);
        if (ref <= 0) return 0;
        final score = (ref / raw) * 100;
        return score.clamp(0, 100).toDouble();
      case 'DIRECT':
        return raw.clamp(0, 100).toDouble();
      case 'LOOKUP':
        return _lookup(factor.lookupTable, raw);
      case 'CUSTOM':
        return _customScore(name, raw);
      default:
        return 0;
    }
  }

  double _lookup(Map<String, num> table, double raw) {
    // Try exact integer key first ("0", "1", "2"), then `3+` bucket
    // for the long tail.
    if (table.isEmpty) return 0;
    final intKey = raw.toInt().toString();
    if (table.containsKey(intKey)) return table[intKey]!.toDouble();
    if (raw >= 3 && table.containsKey('3+')) {
      return table['3+']!.toDouble();
    }
    // Fallback — closest-key match.
    final keys = table.keys
        .map((k) => int.tryParse(k))
        .whereType<int>()
        .toList()
      ..sort();
    if (keys.isEmpty) return 0;
    final last = keys.last;
    return table['$last']!.toDouble();
  }

  /// CUSTOM hand-rolls per factor name.
  /// • `timing` — input is minute-of-day for departure. 6AM-10PM
  ///   counts as the prime band; red-eye (12AM-5AM) penalised.
  /// • `layover_quality` — input is longest single-layover minutes.
  ///   60-120 min ideal; <30 risky, >360 (overnight) penalised.
  double _customScore(String name, double raw) {
    switch (name) {
      case 'timing':
        if (raw <= 0) return 50;
        if (raw >= 360 && raw < 1320) return 100; // 06:00-22:00
        if (raw >= 1320 && raw < 1440) return 70; // 22:00-24:00
        if (raw < 300) return 30; // 00:00-05:00 red-eye
        return 60;
      case 'layover_quality':
        if (raw <= 0) return 100; // direct flight has no layover
        if (raw >= 60 && raw <= 120) return 100;
        if (raw < 30) return 40;
        if (raw <= 60) return 80;
        if (raw <= 240) return 70;
        if (raw <= 360) return 50;
        return 25; // overnight / very long
      default:
        return 50;
    }
  }

  // Rank assignment — reads the config's `ranking_rules` so the
  // backend can flip ASC/DESC on any rank without an app release.
  void _applyRank(
    List<FlightScore> scores,
    String rankName, {
    required String sortBy,
    required bool ascending,
  }) {
    final rule = config?.rankingRules[rankName];
    final ascend = rule == null ? ascending : !rule.isDescending;
    final actualSortBy = rule?.sortBy.isNotEmpty == true ? rule!.sortBy : sortBy;

    final indices = List<int>.generate(scores.length, (i) => i);
    indices.sort((a, b) {
      final va = _sortValue(scores[a], actualSortBy);
      final vb = _sortValue(scores[b], actualSortBy);
      final cmp = va.compareTo(vb);
      return ascend ? cmp : -cmp;
    });

    for (var pos = 0; pos < indices.length; pos++) {
      final s = scores[indices[pos]];
      final r = pos + 1;
      switch (rankName) {
        case 'best_rank':
          s.bestRank = r;
          break;
        case 'cheapest_rank':
          s.cheapestRank = r;
          break;
        case 'fastest_rank':
          s.fastestRank = r;
          break;
      }
    }
  }

  double _sortValue(FlightScore s, String key) {
    switch (key) {
      case 'best_score':
        return s.bestScore;
      case 'price':
        return s.priceValue;
      case 'duration_minutes':
        return s.durationMinutes;
      default:
        // Unknown sort key — fallback to best score so the rank still
        // produces *some* ordering rather than identical values.
        return s.bestScore;
    }
  }

  // Tag condition evaluator — tiny DSL ("best_rank == 1", "price < 50000")
  // is enough to cover the documented tag rules. Anything more
  // exotic falls through and returns false.
  bool _evaluateCondition(String expr, FlightScore s) {
    final parts = expr.trim().split(RegExp(r'\s+'));
    if (parts.length != 3) return false;
    final lhsName = parts[0];
    final op = parts[1];
    final rhsRaw = parts[2];

    final lhs = switch (lhsName) {
      'best_rank' => s.bestRank?.toDouble() ?? double.infinity,
      'cheapest_rank' => s.cheapestRank?.toDouble() ?? double.infinity,
      'fastest_rank' => s.fastestRank?.toDouble() ?? double.infinity,
      'best_score' => s.bestScore,
      'price' => s.priceValue,
      'duration_minutes' => s.durationMinutes,
      _ => double.nan,
    };
    if (lhs.isNaN) return false;

    final rhs = double.tryParse(rhsRaw);
    if (rhs == null) return false;

    switch (op) {
      case '==':
        return lhs == rhs;
      case '!=':
        return lhs != rhs;
      case '<':
        return lhs < rhs;
      case '<=':
        return lhs <= rhs;
      case '>':
        return lhs > rhs;
      case '>=':
        return lhs >= rhs;
      default:
        return false;
    }
  }

  // ─── Raw extractors from the parsed flight map ────────────────

  double _priceOf(Map<String, dynamic> f) {
    final p = f['price'];
    if (p is num) return p.toDouble();
    return double.tryParse(p?.toString() ?? '') ?? double.infinity;
  }

  int _durationMinutesOf(Map<String, dynamic> f) {
    int total = 0;
    final legs = (f['allLegs'] as List?) ?? const [];
    for (final leg in legs) {
      if (leg is Map) {
        total += _parseHmDuration((leg['duration'] ?? '').toString());
      }
    }
    if (total > 0) return total;
    return _parseHmDuration((f['duration'] ?? '').toString());
  }

  int _parseHmDuration(String s) {
    final m = RegExp(r'(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?').firstMatch(s);
    if (m == null) return 0;
    final h = int.tryParse(m.group(1) ?? '') ?? 0;
    final mm = int.tryParse(m.group(2) ?? '') ?? 0;
    return h * 60 + mm;
  }

  int _stopsOf(Map<String, dynamic> f) {
    final s = f['stops'];
    if (s is int) return s;
    if (s is num) return s.toInt();
    return int.tryParse(s?.toString() ?? '') ?? 0;
  }

  int _departureMinuteOf(Map<String, dynamic> f) {
    final t = (f['departureTime'] ?? '').toString().trim();
    if (t.isEmpty) return -1;
    final parts = t.split(':');
    if (parts.length < 2) return -1;
    final h = int.tryParse(parts[0]) ?? 0;
    final mm = int.tryParse(parts[1]) ?? 0;
    return h * 60 + mm;
  }

  int _longestLayoverMinutesOf(Map<String, dynamic> f) {
    int longest = 0;
    final legs = (f['allLegs'] as List?) ?? const [];
    for (final leg in legs) {
      if (leg is! Map) continue;
      final segs = (leg['segments'] as List?) ?? const [];
      for (var i = 0; i < segs.length - 1; i++) {
        final prev = segs[i];
        final next = segs[i + 1];
        if (prev is! Map || next is! Map) continue;
        final prevArr = (prev['arrivalTime'] ?? '').toString();
        final nextDep = (next['departureTime'] ?? '').toString();
        final wait = _waitMinutes(prevArr, nextDep);
        if (wait > longest) longest = wait;
      }
    }
    return longest;
  }

  int _waitMinutes(String arr, String dep) {
    if (arr.isEmpty || dep.isEmpty) return 0;
    try {
      final a = arr.split(':').map(int.parse).toList();
      final d = dep.split(':').map(int.parse).toList();
      var diff = (d[0] * 60 + d[1]) - (a[0] * 60 + a[1]);
      if (diff < 0) diff += 1440;
      return diff;
    } catch (_) {
      return 0;
    }
  }

  double _airlineRatingOf(Map<String, dynamic> f) {
    final r = f['airlineRating'] ?? f['airline_rating'];
    if (r is num) return r.toDouble();
    return 50; // neutral default if the API doesn't carry a rating
  }

  double _minFinite(List<double> xs) {
    var m = double.infinity;
    for (final x in xs) {
      if (x.isFinite && x < m) m = x;
    }
    return m;
  }

  double _maxFinite(List<double> xs) {
    var m = -double.infinity;
    for (final x in xs) {
      if (x.isFinite && x > m) m = x;
    }
    return m;
  }

  double _minPositive(List<double> xs) {
    var m = double.infinity;
    for (final x in xs) {
      if (x > 0 && x < m) m = x;
    }
    return m == double.infinity ? 1 : m;
  }
}

/// Per-flight scoring output. Mutable on purpose — the engine writes
/// the rank fields after the initial best-score pass.
class FlightScore {
  final int index;
  double bestScore;
  final double priceValue;
  final double durationMinutes;
  final Map<String, double> perFactor;
  int? bestRank;
  int? cheapestRank;
  int? fastestRank;

  FlightScore({
    required this.index,
    required this.bestScore,
    required this.priceValue,
    required this.durationMinutes,
    required this.perFactor,
  });
}
