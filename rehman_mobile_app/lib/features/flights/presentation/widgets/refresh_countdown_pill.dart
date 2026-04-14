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
        ? 'Refreshing...'
        : paused
            ? 'Refresh paused'
            : (secs <= 0
                ? 'Refreshing...'
                : 'Rates refresh in ${_fmt(remaining)}');

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

  String _fmt(Duration d) {
    final s = d.inSeconds;
    if (s < 60) return '${s}s';
    final m = d.inMinutes;
    final rem = s % 60;
    return rem == 0 ? '${m}m' : '${m}m ${rem}s';
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
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.scaffoldBg,
      alignment: Alignment.center,
      child: RefreshCountdownPill(
        nextRefreshIn: nextRefreshIn,
        isPaused: isPaused,
        isRefreshing: isRefreshing,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant PinnedRefreshCountdownHeader oldDelegate) {
    // Callbacks are captured in mixin state — we always want a rebuild
    // so the pill's 1-second ticker keeps repainting.
    return true;
  }
}
