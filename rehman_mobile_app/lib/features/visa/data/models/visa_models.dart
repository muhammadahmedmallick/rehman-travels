// Visa domain models for the mobile visa feature.
//
// Response shape mirrors `/api/mobile/visas/types/` — each VisaType
// carries its own VisaVariants inline, and each variant carries its
// own VisaRules. The details screen only needs one list response.

class VisaRule {
  final int id;
  final String title;
  final String ruleType;
  final String icon; // FontAwesome class like "fa-passport"

  const VisaRule({
    required this.id,
    required this.title,
    required this.ruleType,
    required this.icon,
  });

  factory VisaRule.fromJson(Map<String, dynamic> j) => VisaRule(
        id: (j['id'] as num?)?.toInt() ?? 0,
        title: (j['title'] ?? '').toString(),
        ruleType: (j['rule_type'] ?? '').toString(),
        icon: (j['icon'] ?? '').toString(),
      );
}

class VisaVariant {
  final int id;
  final String title;
  final double price;
  final String currency;
  final List<VisaRule> rules;

  const VisaVariant({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.rules,
  });

  factory VisaVariant.fromJson(Map<String, dynamic> j) => VisaVariant(
        id: (j['id'] as num?)?.toInt() ?? 0,
        title: (j['title'] ?? '').toString(),
        price: (j['price'] as num?)?.toDouble() ??
            double.tryParse((j['price'] ?? '').toString()) ??
            0,
        currency: (j['currency'] ?? 'PKR').toString(),
        rules: ((j['rules'] as List?) ?? const [])
            .map((e) => VisaRule.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

class VisaType {
  final int id;
  final String title;
  final String subtitle;
  final String countryCode;
  final List<VisaVariant> variants;

  const VisaType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.countryCode,
    required this.variants,
  });

  factory VisaType.fromJson(Map<String, dynamic> j) => VisaType(
        id: (j['id'] as num?)?.toInt() ?? 0,
        title: (j['title'] ?? '').toString(),
        subtitle: (j['subtitle'] ?? '').toString(),
        countryCode: (j['country_code'] ?? '').toString(),
        variants: ((j['variants'] as List?) ?? const [])
            .map((e) =>
                VisaVariant.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  /// Lowest variant price — used for the "Starting from" footer on
  /// the details screen and for the card subtitle on listings.
  double? get startingFromPrice {
    if (variants.isEmpty) return null;
    return variants
        .map((v) => v.price)
        .reduce((a, b) => a < b ? a : b);
  }

  String get displayCurrency =>
      variants.isNotEmpty ? variants.first.currency : 'PKR';
}
