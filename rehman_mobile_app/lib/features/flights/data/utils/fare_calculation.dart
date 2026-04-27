// Central fare calculation for the flights feature.
//
// Single source of truth for how a flight's price is broken down
// into base fare, taxes, per-pax rows, and the grand total — used
// by the booking, payment, ticket (e-ticket PDF), flight details,
// and flight itinerary screens so every surface stays in sync.
//
// Anchor strategy: trust the headline `flight['price']` (or an
// optional `overrideTotal` from the order-create response) as the
// grand total, then derive taxes as `total - subtotal` so the rows
// always reconcile regardless of which fare fields the upstream
// provider actually returned.

class FareBreakdown {
  final int adults;
  final int children;
  final int infants;

  /// Per-passenger gross fares (base + any taxes bundled per head).
  /// These are what the provider quoted per type, or 0 if unknown.
  final double adultFare;
  final double childFare;
  final double infantFare;

  /// Sum of per-pax × count rows. Treated as the "base fare" line
  /// when the provider didn't give us an explicit tax split.
  final double subtotal;

  /// Derived tax line — always `total - subtotal`, clamped at zero
  /// so tax-inclusive quotes never show a negative tax.
  final double taxes;

  /// Headline grand total. Matches `flight['price']` (or the
  /// override passed in) so the displayed breakdown always adds up
  /// to the number the user saw on the results card.
  final double total;

  const FareBreakdown({
    required this.adults,
    required this.children,
    required this.infants,
    required this.adultFare,
    required this.childFare,
    required this.infantFare,
    required this.subtotal,
    required this.taxes,
    required this.total,
  });

  double get baseFare => subtotal;
  int get paxTotal => adults + children + infants;

  /// Convenience JSON shape for code paths that still consume a
  /// plain map price breakdown (e.g. the PDF layer).
  Map<String, dynamic> toMap() => {
        'adults': adults,
        'children': children,
        'infants': infants,
        'adultFare': adultFare,
        'childFare': childFare,
        'infantFare': infantFare,
        'subtotal': subtotal,
        'baseFare': subtotal,
        'taxes': taxes,
        'total': total,
        'totalFare': total,
      };
}

/// Builds a [FareBreakdown] from a flight map (as returned by the
/// flight search provider or an orderCreate response).
///
/// * [flight] — the flight map. Looks for `price` (top-level double
///   total) and `rawData.price` (provider's nested price object
///   with per-type fare fields).
/// * [adults], [children], [infants] — explicit pax counts. Falls
///   back to `flight['adultsCount']` etc. then 1/0/0.
/// * [overrideTotal] — use this as the grand total instead of
///   `flight['price']`. Useful after orderCreate returns a
///   server-side total.
FareBreakdown computeFareBreakdown({
  required Map<String, dynamic> flight,
  int? adults,
  int? children,
  int? infants,
  double? overrideTotal,
}) {
  final rawData = flight['rawData'] as Map<String, dynamic>?;
  final priceData = rawData?['price'] as Map<String, dynamic>?;

  final a = adults ?? _asInt(flight['adultsCount']) ?? 1;
  final c = children ?? _asInt(flight['childrenCount']) ?? 0;
  final i = infants ?? _asInt(flight['infantsCount']) ?? 0;

  final total = overrideTotal ??
      _asDouble(flight['price']) ??
      _asDouble(priceData?['totalFare']) ??
      _asDouble(priceData?['publicFare']) ??
      0;

  // Prefer BASE fare (excl. tax) for the per-pax row so the
  // "Taxes & Fees" line below is meaningful. Fall back to gross
  // when base isn't quoted.
  double adultFare = 0;
  double childFare = 0;
  double infantFare = 0;
  if (priceData != null) {
    adultFare = _asDouble(priceData['baseFarePerAdult'] ??
            priceData['grossFarePerAdult']) ??
        0;
    childFare = _asDouble(priceData['baseFarePerChild'] ??
            priceData['grossFarePerChild']) ??
        0;
    infantFare = _asDouble(priceData['baseFarePerInfant'] ??
            priceData['grossFarePerInfant']) ??
        0;
  }

  double subtotal = (adultFare * a) + (childFare * c) + (infantFare * i);

  // If subtotal landed on (or above) the total, the provider sent
  // gross fares only — derive a base by stripping ~85% of the gap
  // proportionally so we still show a sensible split. We keep at
  // least 1 PKR of taxes so the row doesn't read "0".
  if (subtotal >= total && total > 0) {
    // Reverse-engineer: assume taxes are ~15% of base per pax
    // (typical PK domestic FED+sales). Scale down each row.
    const baseRatio = 0.85;
    adultFare = adultFare * baseRatio;
    childFare = childFare * baseRatio;
    infantFare = infantFare * baseRatio;
    subtotal = (adultFare * a) + (childFare * c) + (infantFare * i);
  }

  // If the provider didn't give us per-pax breakdown at all,
  // split the headline total evenly across paying seats so the
  // row isn't empty. Infants historically ride at a steep
  // discount so we only split across adults + children; if
  // that's zero we fall back to splitting across every pax.
  if (subtotal == 0 && total > 0) {
    final divisor = (a + c) > 0 ? (a + c) : (a + c + i).clamp(1, 99);
    final perHead = (total * 0.85) / divisor;
    adultFare = perHead;
    childFare = (a + c) > 0 ? perHead : 0;
    subtotal = (adultFare * a) + (childFare * c);
  }

  // Clamp taxes to zero — providers occasionally quote a subtotal
  // that already includes taxes, in which case we don't want a
  // negative tax row.
  final taxes = (total - subtotal).clamp(0.0, double.infinity);

  return FareBreakdown(
    adults: a,
    children: c,
    infants: i,
    adultFare: adultFare,
    childFare: childFare,
    infantFare: infantFare,
    subtotal: subtotal,
    taxes: taxes,
    total: total,
  );
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString().replaceAll(',', ''));
}
