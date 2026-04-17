import '../../../../core/utils/app_lifecycle_refresh_mixin.dart';

/// Process-wide anchor used to keep the flight-fare refresh countdown
/// in sync across screens in the booking flow (itinerary → booking).
///
/// Each screen that opts in records its own timer locally, but uses
/// this shared `lastTickAt` as the truth for when the next refresh
/// should fire. Without this, navigating from the itinerary screen
/// to the booking screen would reset the 3-minute countdown to a
/// fresh interval and the user would see stale price for longer
/// than intended.
///
/// Intentionally a plain static — no Riverpod provider — because it
/// only holds one `DateTime` and has no listeners. The screens read
/// it on demand inside their own periodic tick handlers.
class FareRefreshClock {
  FareRefreshClock._();

  /// Most recent anchor tick time. Null when no screen in the flow
  /// has opened yet (or the clock was cleared). The mixin writes here
  /// after each completed refresh so subsequent screens line up.
  static DateTime? lastTickAt;

  /// Idempotent entry point — called from the first screen in the
  /// booking flow. If the clock is stale (older than one refresh
  /// interval) it's reset to now so the user doesn't walk into an
  /// instant forced refresh on a fresh session.
  static void startIfIdle() {
    final now = DateTime.now();
    final last = lastTickAt;
    if (last == null ||
        now.difference(last) > kFlightFareRefreshInterval) {
      lastTickAt = now;
    }
  }

  /// Clears the clock. Called when the user leaves the booking flow
  /// (pops back past the itinerary screen) so the next session
  /// starts with a fresh countdown.
  static void clear() {
    lastTickAt = null;
  }
}
