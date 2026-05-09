/// One stored entry in the debug-only PNR tracker.
///
/// Captured the moment Exalted returns a PNR (whether the booking
/// flow then succeeds, fails, or is abandoned). The Settings → Debug
/// PNRs screen renders these as a list with a delete icon — tap
/// triggers the `/orderCancel` API for cleanup so the agent account
/// doesn't accumulate test PNRs while we iterate.
class DebugPnrRecord {
  /// Itinerary reference / PNR — stable identifier for orderCancel.
  final String pnr;

  /// Provider booking reference (often equals [pnr]).
  final String reference;

  /// Echo token from the orderCreate response.
  final String echoToken;

  /// Session id for SOAP-style providers (Sabre).
  final String jSessionId;

  /// Provider name (Sabre, Airblue, etc.) — required by `/orderCancel`.
  final String airType;

  /// Validating carrier (e.g. PK, EK).
  final String vCarrier;

  /// Total fare in PKR — used as `paymentAmount` on the cancel call.
  final double amount;

  /// Human label for the list row: "MUDASSIR/ALI MR · ISB → JFK".
  final String passengerLabel;
  final String routeLabel;

  /// When this PNR was created locally (for sorting).
  final DateTime createdAt;

  const DebugPnrRecord({
    required this.pnr,
    required this.reference,
    required this.echoToken,
    required this.jSessionId,
    required this.airType,
    required this.vCarrier,
    required this.amount,
    required this.passengerLabel,
    required this.routeLabel,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'pnr': pnr,
        'reference': reference,
        'echoToken': echoToken,
        'jSessionId': jSessionId,
        'airType': airType,
        'vCarrier': vCarrier,
        'amount': amount,
        'passengerLabel': passengerLabel,
        'routeLabel': routeLabel,
        'createdAt': createdAt.toIso8601String(),
      };

  factory DebugPnrRecord.fromJson(Map<String, dynamic> j) => DebugPnrRecord(
        pnr: (j['pnr'] ?? '').toString(),
        reference: (j['reference'] ?? '').toString(),
        echoToken: (j['echoToken'] ?? '').toString(),
        jSessionId: (j['jSessionId'] ?? '').toString(),
        airType: (j['airType'] ?? '').toString(),
        vCarrier: (j['vCarrier'] ?? '').toString(),
        amount: (j['amount'] is num)
            ? (j['amount'] as num).toDouble()
            : double.tryParse(j['amount']?.toString() ?? '') ?? 0,
        passengerLabel: (j['passengerLabel'] ?? '').toString(),
        routeLabel: (j['routeLabel'] ?? '').toString(),
        createdAt: DateTime.tryParse(j['createdAt']?.toString() ?? '') ??
            DateTime.now(),
      );
}
