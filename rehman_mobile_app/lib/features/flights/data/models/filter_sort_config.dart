import 'package:equatable/equatable.dart';

/// Parsed shape of the `/api/core/filter-config/flights/` Django
/// response. Keeps the JSON traversal noise out of the score engine
/// and the result screen.
///
/// Schema lives in `FILTER_SORT_CONFIG_IMPLEMENTATION.md` — keep
/// these classes in sync if the backend adds new factors / formulas.
class FilterSortConfig extends Equatable {
  final String listingName;
  final String version;
  final Map<String, ScoreFactor> factors;
  final Map<String, RankingRule> rankingRules;
  final List<TagRule> tagRules;
  final Map<String, FilterDef> filters;
  final int roundToDecimals;

  const FilterSortConfig({
    required this.listingName,
    required this.version,
    required this.factors,
    required this.rankingRules,
    required this.tagRules,
    required this.filters,
    this.roundToDecimals = 2,
  });

  /// Parses the full top-level response from the Django endpoint:
  /// `{ listing_name, version, config_data: { calculation_config: {...} } }`.
  factory FilterSortConfig.fromJson(Map<String, dynamic> j) {
    final cfg = j['config_data'] is Map<String, dynamic>
        ? (j['config_data']['calculation_config'] as Map<String, dynamic>?) ??
            const {}
        : const <String, dynamic>{};

    Map<String, T> mapFromJson<T>(dynamic raw, T Function(Map<String, dynamic>) parse) {
      if (raw is! Map) return {};
      return {
        for (final e in raw.entries)
          if (e.value is Map<String, dynamic>) e.key.toString(): parse(e.value as Map<String, dynamic>),
      };
    }

    return FilterSortConfig(
      listingName: (j['listing_name'] ?? 'flights').toString(),
      version: (j['version'] ?? '1.0').toString(),
      factors: mapFromJson(cfg['factors'], ScoreFactor.fromJson),
      rankingRules: mapFromJson(cfg['ranking_rules'], RankingRule.fromJson),
      tagRules: ((cfg['tag_rules'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(TagRule.fromJson)
          .toList(),
      filters: mapFromJson(cfg['filters'], FilterDef.fromJson),
      roundToDecimals:
          (cfg['round_to_decimals'] as num?)?.toInt() ?? 2,
    );
  }

  @override
  List<Object?> get props => [
        listingName,
        version,
        factors,
        rankingRules,
        tagRules,
        filters,
        roundToDecimals,
      ];
}

/// One scoring factor — driving the weighted "Best" computation.
/// `formula` is one of `RATIO_INVERSE`, `DIRECT`, `LOOKUP`, `CUSTOM`.
class ScoreFactor extends Equatable {
  final double weight;
  final String formula;
  final Map<String, num> lookupTable;
  final String description;

  const ScoreFactor({
    required this.weight,
    required this.formula,
    this.lookupTable = const {},
    this.description = '',
  });

  factory ScoreFactor.fromJson(Map<String, dynamic> j) {
    final raw = j['lookup_table'];
    final table = <String, num>{};
    if (raw is Map) {
      raw.forEach((k, v) {
        if (v is num) table[k.toString()] = v;
      });
    }
    return ScoreFactor(
      weight: (j['weight'] as num?)?.toDouble() ?? 0,
      formula: (j['formula'] ?? 'DIRECT').toString().toUpperCase(),
      lookupTable: table,
      description: (j['description'] ?? '').toString(),
    );
  }

  @override
  List<Object?> get props => [weight, formula, lookupTable, description];
}

class RankingRule extends Equatable {
  final String sortBy;
  final String order; // 'ASC' / 'DESC'
  final String description;

  const RankingRule({
    required this.sortBy,
    this.order = 'ASC',
    this.description = '',
  });

  factory RankingRule.fromJson(Map<String, dynamic> j) => RankingRule(
        sortBy: (j['sort_by'] ?? '').toString(),
        order: (j['order'] ?? 'ASC').toString().toUpperCase(),
        description: (j['description'] ?? '').toString(),
      );

  bool get isDescending => order == 'DESC';

  @override
  List<Object?> get props => [sortBy, order, description];
}

class TagRule extends Equatable {
  final String tag; // e.g. BEST / CHEAPEST / FASTEST
  final String condition; // e.g. "best_rank == 1"
  final String badgeColor; // hex like "#28a745"
  final String icon;

  const TagRule({
    required this.tag,
    required this.condition,
    this.badgeColor = '#000000',
    this.icon = '',
  });

  factory TagRule.fromJson(Map<String, dynamic> j) => TagRule(
        tag: (j['tag'] ?? '').toString().toUpperCase(),
        condition: (j['condition'] ?? '').toString(),
        badgeColor: (j['badge_color'] ?? '#000000').toString(),
        icon: (j['icon'] ?? '').toString(),
      );

  @override
  List<Object?> get props => [tag, condition, badgeColor, icon];
}

/// Definition of a single filter shown in the results screen — type
/// is one of `checkbox`, `multi-select`, `range`, `slider`. Mobile
/// renders the matching widget; non-supported types are skipped
/// gracefully.
class FilterDef extends Equatable {
  final String type;
  final String label;
  final bool dynamic_;
  final List<FilterOption> options;
  final List<FilterRange> ranges;
  final String currency;
  final String? minField;
  final String? maxField;

  const FilterDef({
    required this.type,
    required this.label,
    this.dynamic_ = false,
    this.options = const [],
    this.ranges = const [],
    this.currency = 'PKR',
    this.minField,
    this.maxField,
  });

  factory FilterDef.fromJson(Map<String, dynamic> j) => FilterDef(
        type: (j['type'] ?? '').toString(),
        label: (j['label'] ?? '').toString(),
        dynamic_: j['dynamic'] == true,
        options: ((j['options'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(FilterOption.fromJson)
            .toList(),
        ranges: ((j['ranges'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(FilterRange.fromJson)
            .toList(),
        currency: (j['currency'] ?? 'PKR').toString(),
        minField: j['min_field']?.toString(),
        maxField: j['max_field']?.toString(),
      );

  @override
  List<Object?> get props =>
      [type, label, dynamic_, options, ranges, currency, minField, maxField];
}

class FilterOption extends Equatable {
  final String value;
  final String label;

  const FilterOption({required this.value, required this.label});

  factory FilterOption.fromJson(Map<String, dynamic> j) => FilterOption(
        value: (j['value'] ?? '').toString(),
        label: (j['label'] ?? '').toString(),
      );

  @override
  List<Object?> get props => [value, label];
}

class FilterRange extends Equatable {
  final String value;
  final String label;
  final String start; // 'HH:mm'
  final String end;

  const FilterRange({
    required this.value,
    required this.label,
    required this.start,
    required this.end,
  });

  factory FilterRange.fromJson(Map<String, dynamic> j) => FilterRange(
        value: (j['value'] ?? '').toString(),
        label: (j['label'] ?? '').toString(),
        start: (j['start'] ?? '').toString(),
        end: (j['end'] ?? '').toString(),
      );

  @override
  List<Object?> get props => [value, label, start, end];
}
