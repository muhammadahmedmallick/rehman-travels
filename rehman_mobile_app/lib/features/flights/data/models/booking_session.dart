import '../utils/fare_calculation.dart';

/// Where the user currently sits in the booking journey.
///
/// Drives `paymentStatus` on the ticket screen ("Confirmed" vs
/// "Payment Due") and lets any screen check whether the session
/// has been reset.
enum BookingStage {
  /// Session created, user is reviewing the flight (details / itinerary).
  selected,

  /// User is on the booking screen filling passenger details.
  passengerDetails,

  /// orderCreate succeeded, user is on payment screen.
  awaitingPayment,

  /// Bank IPN confirmed payment, ticket screen shows "Confirmed".
  paid,

  /// User chose "Pay Later" or payment failed — booking exists,
  /// payment is outstanding. Ticket screen shows "Payment Due".
  paymentDue,
}

/// Single source of truth for the entire booking journey — from the
/// moment the user taps a flight card through to the final ticket.
///
/// Every screen in the booking flow (flight details, itinerary,
/// booking, payment, ticket) reads from and writes to this one
/// object via [BookingSessionProvider]. No more passing `extra:`
/// maps between screens; no more recomputing the fare on each
/// screen with possibly-different pax counts.
///
/// Lifecycle:
///   1. Flight card tap → `start(flight, searchParams)` — fare computed once.
///   2. Booking screen → `setPassengers(...)`.
///   3. orderCreate success → `setOrder(pnr, reference, ...)`.
///   4. Payment success → `markPaid(orderId)`.
///   5. Back to home → `clear()`.
class BookingSession {
  /// The selected flight map (live — gets updated by fare-refresh).
  final Map<String, dynamic> flight;

  /// The search context this flight was picked from (route, dates,
  /// cabin) — used by every header / itinerary widget downstream.
  final Map<String, dynamic> searchParams;

  /// Pax counts — single source. Booking screen reads these to
  /// build its passenger forms; payment / ticket screens read them
  /// for display. Mutating these requires a new session
  /// (start over) since fare depends on them.
  final int adults;
  final int children;
  final int infants;

  /// Computed once on `start()` and recomputed only on
  /// `refreshFlight()` so every screen renders the same numbers.
  final FareBreakdown fare;

  /// Filled by the booking screen on submit. Each entry is the
  /// snapshot the booking screen sends to orderCreate (title,
  /// firstName, lastName, dob, type, etc.).
  final List<Map<String, dynamic>> passengers;

  /// Contact details captured on the booking screen.
  final String email;
  final String phone;

  // ── orderCreate response ─────────────────────────────────────────
  final String? pnr;
  final String? reference;
  final String? echoToken;
  final String? jSessionId;
  final String? airType;
  final String? vCarrier;

  /// Full orderCreate response — kept for screens that need access
  /// to the raw payload (e.g. ticket PDF generation).
  final Map<String, dynamic>? orderData;

  // ── Payment ──────────────────────────────────────────────────────
  final BookingStage stage;
  final String? alfalahOrderId;
  final DateTime? paidAt;

  const BookingSession({
    required this.flight,
    required this.searchParams,
    required this.adults,
    required this.children,
    required this.infants,
    required this.fare,
    this.passengers = const [],
    this.email = '',
    this.phone = '',
    this.pnr,
    this.reference,
    this.echoToken,
    this.jSessionId,
    this.airType,
    this.vCarrier,
    this.orderData,
    this.stage = BookingStage.selected,
    this.alfalahOrderId,
    this.paidAt,
  });

  /// Convenience: total amount the user pays — comes from the
  /// orderCreate response when available (server-side total),
  /// otherwise the headline fare total. Single accessor so payment
  /// + ticket screens can't disagree on the number.
  double get payableAmount {
    final orderPrice = orderData?['price'];
    if (orderPrice is Map) {
      final t = orderPrice['totalFare'] ?? orderPrice['totalAmount'];
      if (t is num && t > 0) return t.toDouble();
      final parsed = double.tryParse(t?.toString() ?? '');
      if (parsed != null && parsed > 0) return parsed;
    }
    return fare.total;
  }

  /// `paid` for the green "Confirmed" badge, `due` for the amber
  /// "Payment Due" banner, `pending` while the user is still in
  /// passenger-details / payment screens. Ticket screen reads this
  /// to switch its visual state.
  String get paymentStatusLabel {
    switch (stage) {
      case BookingStage.paid:
        return 'paid';
      case BookingStage.paymentDue:
        return 'due';
      default:
        return 'pending';
    }
  }

  BookingSession copyWith({
    Map<String, dynamic>? flight,
    Map<String, dynamic>? searchParams,
    int? adults,
    int? children,
    int? infants,
    FareBreakdown? fare,
    List<Map<String, dynamic>>? passengers,
    String? email,
    String? phone,
    String? pnr,
    String? reference,
    String? echoToken,
    String? jSessionId,
    String? airType,
    String? vCarrier,
    Map<String, dynamic>? orderData,
    BookingStage? stage,
    String? alfalahOrderId,
    DateTime? paidAt,
  }) {
    return BookingSession(
      flight: flight ?? this.flight,
      searchParams: searchParams ?? this.searchParams,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      fare: fare ?? this.fare,
      passengers: passengers ?? this.passengers,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      pnr: pnr ?? this.pnr,
      reference: reference ?? this.reference,
      echoToken: echoToken ?? this.echoToken,
      jSessionId: jSessionId ?? this.jSessionId,
      airType: airType ?? this.airType,
      vCarrier: vCarrier ?? this.vCarrier,
      orderData: orderData ?? this.orderData,
      stage: stage ?? this.stage,
      alfalahOrderId: alfalahOrderId ?? this.alfalahOrderId,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
