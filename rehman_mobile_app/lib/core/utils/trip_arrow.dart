/// Single source of truth for the route arrow shown between airport
/// codes / city names across the app.
///
/// Rule:
///   • One-way     → `→`
///   • Round-trip  → `⇄`
///   • Multi-city  → `→`  (each leg is itself a one-way hop —
///                          chaining ⇄ between every pair would
///                          imply each city pair is a round-trip)
///   • Unknown     → `→` (safe default)
///
/// Usage:
///   `TripArrow.symbol('round-trip')` → `⇄`
///   `'$dep ${TripArrow.padded(tripType)} $arr'` → `ISB ⇄ DXB`
class TripArrow {
  TripArrow._();

  /// Bare symbol — no surrounding spaces.
  static String symbol(String? tripType) {
    switch ((tripType ?? '').toLowerCase().trim()) {
      case 'round-trip':
      case 'round_trip':
      case 'roundtrip':
      case 'return':
        return '⇄';
      case 'multi':
      case 'multi-city':
      case 'multicity':
      case 'one-way':
      case 'one_way':
      case 'oneway':
      default:
        return '→';
    }
  }

  /// Symbol with single spaces on each side, ready to drop into a
  /// `'$dep ${TripArrow.padded(...)} $arr'` template.
  static String padded(String? tripType) => ' ${symbol(tripType)} ';
}
