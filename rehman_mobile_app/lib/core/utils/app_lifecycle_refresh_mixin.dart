import 'dart:async';

import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// App-wide route observer used by [AppLifecycleRefreshMixin] to know
/// when a screen becomes visible or gets covered by another route.
///
/// Wire this into the router once:
/// `GoRouter(observers: [appRouteObserver], ...)`
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

/// Single source of truth for flight-fare refresh cadence. Change this
/// in one place and every flight screen (results / details / booking)
/// picks up the new interval.
///
/// Fares on upstream providers drift frequently — 30s is a good
/// balance between freshness and API load.
const Duration kFlightFareRefreshInterval = Duration(minutes: 3);

/// One-liner mixin for auto-refreshing data when the app returns to
/// the foreground.
///
/// Attach it to any `State<T>` subclass:
///
/// ```dart
/// class _MyState extends State<My> with AppLifecycleRefreshMixin<My> {
///   @override
///   Future<void> onLifecycleRefresh() =>
///       ref.read(myProvider.notifier).reload();
/// }
/// ```
///
/// When the app goes background → foreground and the away time is
/// longer than [lifecycleRefreshThreshold] (default 30s), the mixin
/// calls [onLifecycleRefresh]. During the call a subtle
/// "Refreshing prices..." MaterialBanner is shown, and failures
/// surface a retry SnackBar.
///
/// Only fires when the hosting route is the currently visible route,
/// so stacked screens don't all refresh at once.
mixin AppLifecycleRefreshMixin<T extends StatefulWidget>
    on State<T>
    implements RouteAware {
  /// Override this to re-call whatever API / BLoC event / Riverpod
  /// notifier the screen uses to refresh its data.
  Future<void> onLifecycleRefresh();

  /// Override to change the threshold. Anything under this is ignored.
  Duration get lifecycleRefreshThreshold => const Duration(minutes: 2);

  /// Override to enable a periodic auto-refresh while the screen stays
  /// visible. Null = disabled (default). Useful for the results screen
  /// where fares drift even if the user is just sitting idle.
  Duration? get periodicRefreshInterval => null;

  /// True while the refresh ticker is paused (screen is hidden behind
  /// another route). UIs that show a countdown can use this to swap
  /// the label to "Paused".
  bool get isRefreshPaused => !_isVisible;

  /// True while a refresh is currently in flight (API call running).
  /// UIs can use this to show a "Refreshing..." state in the countdown.
  bool get isRefreshing => _refreshing;

  /// Read-only access to when the last periodic tick ran. UIs that
  /// want to render a countdown can combine this with
  /// [periodicRefreshInterval] to compute remaining time.
  DateTime? get lastRefreshTickAt => _lastTickAt;

  /// Time until the next auto-refresh. `null` when the screen has no
  /// periodic refresh configured.
  Duration? nextRefreshIn() {
    final interval = periodicRefreshInterval;
    if (interval == null) return null;
    final last = _lastTickAt;
    if (last == null) return interval;
    final elapsed = DateTime.now().difference(last);
    final remaining = interval - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  DateTime? _bgAt;
  bool _refreshing = false;
  Timer? _periodicTimer;
  DateTime? _lastTickAt; // When the last periodic tick ran (or the timer started)
  bool _isVisible = true;
  late final _LifecycleObserver _observer;

  @override
  void initState() {
    super.initState();
    _observer = _LifecycleObserver(_onLifecycleChange);
    WidgetsBinding.instance.addObserver(_observer);
    _startPeriodicRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the app-wide RouteObserver so we get push/pop events
    // and can pause the periodic timer when another screen is stacked
    // on top of this one.
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _periodicTimer?.cancel();
    WidgetsBinding.instance.removeObserver(_observer);
    super.dispose();
  }

  // ---------- RouteAware ----------

  /// This screen just became visible after initial push.
  @override
  void didPush() {
    _isVisible = true;
  }

  /// Another screen was pushed on top — this one is now hidden.
  @override
  void didPushNext() {
    _isVisible = false;
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  /// The screen that was covering this one popped — we're visible again.
  @override
  void didPopNext() {
    _isVisible = true;
    _resumePeriodicRefresh();
  }

  /// This screen is getting popped off the stack.
  @override
  void didPop() {
    _isVisible = false;
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  // ---------- Periodic refresh ----------

  /// Starts (or restarts) a fresh one-shot timer that fires after
  /// [periodicRefreshInterval]. We use one-shot timers (not
  /// `Timer.periodic`) so the next cycle is always `interval` after
  /// the *previous refresh finished*, not `interval` after the tick
  /// that happened while the API call was still in flight. Keeps the
  /// countdown pill honest even when the backend is slow.
  void _startPeriodicRefresh() {
    final interval = periodicRefreshInterval;
    if (interval == null) return;
    _periodicTimer?.cancel();
    _lastTickAt = DateTime.now();
    _periodicTimer = Timer(interval, _onPeriodicTick);
  }

  /// Resets the countdown to a full interval starting now, without
  /// firing a refresh. Host screens call this after their initial data
  /// load finishes so the timer starts "counting down" from when the
  /// user actually sees the data — not from when the screen opened.
  void resetRefreshCountdown() {
    if (!mounted || periodicRefreshInterval == null) return;
    _startPeriodicRefresh();
  }

  /// Called when this screen regains visibility (e.g. user popped the
  /// booking screen and is back on results). If more than [interval]
  /// has passed since the last tick we fire immediately, otherwise we
  /// schedule the remaining time.
  void _resumePeriodicRefresh() {
    final interval = periodicRefreshInterval;
    if (interval == null) return;
    final last = _lastTickAt;
    if (last == null) {
      _startPeriodicRefresh();
      return;
    }
    final elapsed = DateTime.now().difference(last);
    if (elapsed >= interval) {
      _onPeriodicTick();
    } else {
      final remaining = interval - elapsed;
      _periodicTimer?.cancel();
      _periodicTimer = Timer(remaining, _onPeriodicTick);
    }
  }

  void _onPeriodicTick() {
    if (!mounted || !_isVisible) {
      return;
    }
    // Double-check against ModalRoute in case the observer missed a
    // transition (e.g. first frame of init).
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) {
      return;
    }
    // Don't update _lastTickAt here — the countdown pill would reset
    // to a full interval while the API call is still running and
    // that's misleading. We update after the refresh finishes in
    // _runRefresh() by calling _startPeriodicRefresh().
    _runRefresh();
  }

  // ---------- Lifecycle (app background → foreground) ----------

  void _onLifecycleChange(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _bgAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed && _bgAt != null) {
      final elapsed = DateTime.now().difference(_bgAt!);
      _bgAt = null;
      if (!mounted || !_isVisible) return;
      // Only react when this screen is the currently visible route —
      // stacked screens behind the top one stay quiet.
      if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;
      if (elapsed < lifecycleRefreshThreshold) return;
      _runRefresh();
    }
  }

  Future<void> _runRefresh() async {
    if (_refreshing || !mounted) return;
    _refreshing = true;
    try {
      await onLifecycleRefresh();
    } catch (e) {
      if (mounted) _showErrorSnack(e.toString());
    } finally {
      _refreshing = false;
      if (mounted) {
        _hideRefreshBanner();
        // Restart the countdown from now — next refresh fires
        // exactly one interval after this one actually finished.
        _startPeriodicRefresh();
      }
    }
  }

  
  void _hideRefreshBanner() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentMaterialBanner();
  }

  void _showErrorSnack(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentMaterialBanner();
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 6),
        content: Text(
          'Failed to refresh prices',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _runRefresh,
        ),
      ),
    );
  }
}

/// Internal helper that receives lifecycle callbacks and forwards to
/// the mixin. Kept private so callers don't touch it directly.
class _LifecycleObserver with WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onStateChange;
  _LifecycleObserver(this.onStateChange);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChange(state);
  }
}
