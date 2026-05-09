import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

/// Small pill that counts down to the next automatic price refresh.
///
/// Completely decoupled from the mixin: the host passes a `nextRefreshIn`
/// callback that reads the mixin's current value, and the widget runs
/// its own 1-second ticker to rebuild the label.
///
/// Example:
/// ```dart
/// RefreshCountdownPill(
///   nextRefreshIn: () => nextRefreshIn(),
///   isPaused: () => isRefreshPaused,
/// )
/// ```
class RefreshCountdownPill extends StatefulWidget {
  /// Returns the time until the next refresh, or `null` when no
  /// periodic refresh is configured.
  final Duration? Function() nextRefreshIn;

  /// Returns `true` when the countdown is paused (e.g. screen hidden).
  final bool Function()? isPaused;

  /// Returns `true` when a refresh is in flight right now. UI swaps
  /// to a "Refreshing..." label while this is true so the countdown
  /// doesn't mislead the user.
  final bool Function()? isRefreshing;

  const RefreshCountdownPill({
    super.key,
    required this.nextRefreshIn,
    this.isPaused,
    this.isRefreshing,
  });

  @override
  State<RefreshCountdownPill> createState() => _RefreshCountdownPillState();
}

class _RefreshCountdownPillState extends State<RefreshCountdownPill> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.nextRefreshIn();
    if (remaining == null) return const SizedBox.shrink();
    final paused = widget.isPaused?.call() ?? false;
    final refreshing = widget.isRefreshing?.call() ?? false;

    final secs = remaining.inSeconds;
    final label = refreshing
        ? 'Loading...'
        : paused
            ? 'Refresh paused'
            : (secs <= 0
                ? 'Refreshing...'
                : 'Complete your booking in ${_fmt(remaining)}');

    final color = refreshing
        ? AppColors.primary
        : paused
            ? AppColors.textSecondary
            : (secs <= 10 ? AppColors.warning : AppColors.primary);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (refreshing)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          else
            Icon(
              paused
                  ? Icons.pause_circle_outline
                  : Icons.schedule_outlined,
              size: 16,
              color: color,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (!paused && secs > 0) ...[
            const SizedBox(width: 8),
            Tooltip(
              message:
                  'Airlines update prices frequently. We re-check with the provider so you always see the latest fare before booking.',
              triggerMode: TooltipTriggerMode.tap,
              child: Icon(
                Icons.info_outline,
                size: 14,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Digital-clock format: `MM:SS` under one hour, `H:MM:SS`
  /// beyond. Zero-padded minutes and seconds so the pill doesn't
  /// jitter as digits shrink (e.g. `04:59 → 04:58 → 04:57`).
  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) return '$h:$mm:$ss';
    return '$mm:$ss';
  }
}

/// `SliverPersistentHeader` delegate that pins a [RefreshCountdownPill]
/// directly under the flight route header so it stays visible while
/// the user scrolls through the itinerary / passenger forms.
///
/// Height matches the pill's visual footprint (vertical margins + content
/// roughly 48 px). The background is painted so the pill doesn't show
/// the scrollable content bleeding through from underneath.
class PinnedRefreshCountdownHeader extends SliverPersistentHeaderDelegate {
  final Duration? Function() nextRefreshIn;
  final bool Function()? isPaused;
  final bool Function()? isRefreshing;

  const PinnedRefreshCountdownHeader({
    required this.nextRefreshIn,
    this.isPaused,
    this.isRefreshing,
  });

  @override
  double get minExtent => 32;

  @override
  double get maxExtent => 32;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Renders as a flat ribbon directly stitched to the bottom of the
    // booking header — same dark navy as the header's gradient end so
    // there's no visual seam between them.
    return _PinnedCountdownStrip(
      nextRefreshIn: nextRefreshIn,
      isPaused: isPaused,
      isRefreshing: isRefreshing,
    );
  }

  @override
  bool shouldRebuild(covariant PinnedRefreshCountdownHeader oldDelegate) {
    // Callbacks are captured in mixin state — we always want a rebuild
    // so the pill's 1-second ticker keeps repainting.
    return true;
  }
}

/// Flat strip variant of the countdown — no margin, no rounded corners,
/// blends into the header. 1-second ticker so the digits update live.
class _PinnedCountdownStrip extends StatefulWidget {
  final Duration? Function() nextRefreshIn;
  final bool Function()? isPaused;
  final bool Function()? isRefreshing;

  const _PinnedCountdownStrip({
    required this.nextRefreshIn,
    this.isPaused,
    this.isRefreshing,
  });

  @override
  State<_PinnedCountdownStrip> createState() => _PinnedCountdownStripState();
}

class _PinnedCountdownStripState extends State<_PinnedCountdownStrip> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.nextRefreshIn();
    final paused = widget.isPaused?.call() ?? false;
    final refreshing = widget.isRefreshing?.call() ?? false;
    final secs = remaining?.inSeconds ?? 0;

    final label = refreshing
        ? 'Refreshing rates…'
        : paused
            ? 'Refresh paused'
            : (remaining == null || secs <= 0
                ? 'Refreshing rates…'
                : 'Rates refresh in ${_fmt(remaining)}');

    final urgent = !refreshing && !paused && secs > 0 && secs <= 30;

    return Container(
      color: const Color(0xFF334155), // matches header gradient end
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (refreshing)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else
            Icon(
              paused ? Icons.pause_circle_outline : Icons.schedule_outlined,
              size: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: urgent
                  ? const Color(0xFFFFD54F)
                  : Colors.white.withValues(alpha: 0.92),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) return '$h:$mm:$ss';
    return '$mm:$ss';
  }
}
