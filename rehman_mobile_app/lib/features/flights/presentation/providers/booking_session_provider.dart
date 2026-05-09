import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/booking_session.dart';
import '../../data/utils/fare_calculation.dart';

/// Holds the live [BookingSession] for the currently in-progress
/// booking. `null` when the user isn't inside the booking journey.
///
/// Every screen between flight-card-tap and ticket should read /
/// write through this provider rather than passing data via
/// `extra:` route arguments.
final bookingSessionProvider =
    StateNotifierProvider<BookingSessionNotifier, BookingSession?>(
  (ref) => BookingSessionNotifier(),
);

class BookingSessionNotifier extends StateNotifier<BookingSession?> {
  BookingSessionNotifier() : super(null);

  /// Called when the user taps a flight on the results screen. Resets
  /// any prior session and computes the fare once so all downstream
  /// screens render the same numbers.
  ///
  /// Pax counts are pulled from [searchParams] first, with the flight
  /// map as a fallback (some legacy code paths put them on the flight).
  void start({
    required Map<String, dynamic> flight,
    required Map<String, dynamic> searchParams,
  }) {
    int asInt(dynamic v, int fallback) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? fallback;
    }

    final adults = asInt(
      searchParams['adultsCount'] ?? flight['adultsCount'],
      1,
    );
    final children = asInt(
      searchParams['childrenCount'] ?? flight['childrenCount'],
      0,
    );
    final infants = asInt(
      searchParams['infantsCount'] ?? flight['infantsCount'],
      0,
    );

    final fare = computeFareBreakdown(
      flight: flight,
      adults: adults,
      children: children,
      infants: infants,
    );

    state = BookingSession(
      flight: flight,
      searchParams: searchParams,
      adults: adults,
      children: children,
      infants: infants,
      fare: fare,
    );
  }

  /// Drop-in update when the periodic fare-refresh returns a new
  /// flight quote — recomputes fare so the breakdown stays in sync
  /// with the headline price the user sees.
  void refreshFlight(Map<String, dynamic> flight) {
    final s = state;
    if (s == null) return;
    final fare = computeFareBreakdown(
      flight: flight,
      adults: s.adults,
      children: s.children,
      infants: s.infants,
    );
    state = s.copyWith(flight: flight, fare: fare);
  }

  /// Booking screen calls this on submit, just before / after firing
  /// orderCreate, so the payment + ticket screens can read passengers
  /// + contact info from the session instead of via `extra:`.
  void setPassengersAndContact({
    required List<Map<String, dynamic>> passengers,
    required String email,
    required String phone,
  }) {
    final s = state;
    if (s == null) return;
    state = s.copyWith(
      passengers: passengers,
      email: email,
      phone: phone,
      stage: BookingStage.passengerDetails,
    );
  }

  /// orderCreate succeeded — store the PNR + tokens needed for the
  /// payment request. After this the payment screen can read
  /// everything it needs from the session.
  void setOrder({
    required String pnr,
    required String? reference,
    required String? echoToken,
    required String? jSessionId,
    required String? airType,
    required String? vCarrier,
    Map<String, dynamic>? orderData,
  }) {
    final s = state;
    if (s == null) return;
    state = s.copyWith(
      pnr: pnr,
      reference: reference ?? pnr,
      echoToken: echoToken ?? pnr,
      jSessionId: jSessionId,
      airType: airType,
      vCarrier: vCarrier,
      orderData: orderData,
      stage: BookingStage.awaitingPayment,
    );
  }

  /// Bank IPN confirmed payment.
  void markPaid({String? alfalahOrderId}) {
    final s = state;
    if (s == null) return;
    state = s.copyWith(
      stage: BookingStage.paid,
      alfalahOrderId: alfalahOrderId,
      paidAt: DateTime.now(),
    );
  }

  /// User chose Pay Later, or payment failed and they navigated to
  /// the ticket screen anyway — booking exists, payment outstanding.
  void markDue() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(stage: BookingStage.paymentDue);
  }

  /// Wipes the session — call when navigating back to the home tab
  /// after a completed booking, or when the user explicitly cancels.
  void clear() {
    state = null;
  }
}
