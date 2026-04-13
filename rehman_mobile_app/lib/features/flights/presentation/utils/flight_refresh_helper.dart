import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

/// Time buckets for background→foreground refresh behavior.
enum FlightRefreshBucket {
  /// Under the refresh threshold — do nothing.
  fresh,

  /// Between refresh and expired thresholds — silent refresh,
  /// show rate-change banner if the price differs.
  warn,

  /// Over the expired threshold — show session-expired dialog
  /// and kick back to home.
  expired,
}

FlightRefreshBucket bucketFor(Duration elapsed) {
  // TESTING: short thresholds so the flow is easy to verify.
  // Production values should be 3 min / 10 min.
  if (elapsed > const Duration(minutes: 1)) return FlightRefreshBucket.expired;
  if (elapsed > const Duration(seconds: 30)) return FlightRefreshBucket.warn;
  return FlightRefreshBucket.fresh;
}

class FlightRefreshHelper {
  /// Warning banner for the 3–10 min bucket.
  static void showWarningBanner(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.refresh, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'You\'ve been away for a while — rates have been refreshed.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ]),
        backgroundColor: AppColors.warning,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Rate-change banner when the price of a specific flight changes.
  static void showRateChangedBanner(
    BuildContext context, {
    required double oldPrice,
    required double newPrice,
    required String currencySymbol,
  }) {
    if (!context.mounted) return;
    final increased = newPrice > oldPrice;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(
            increased ? Icons.trending_up : Icons.trending_down,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Rate updated: $currencySymbol ${_fmt(oldPrice)} → $currencySymbol ${_fmt(newPrice)}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ]),
        backgroundColor: increased ? AppColors.error : AppColors.success,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Dialog shown when the selected flight is no longer available.
  static Future<void> showSeatsGoneDialog(BuildContext context) async {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.event_busy, color: AppColors.error, size: 40),
        title: const Text('Flight no longer available'),
        content: const Text(
          'This flight is sold out or the provider removed it. Please pick another option from the results.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Pop back to results screen.
              final router = GoRouter.of(context);
              if (router.canPop()) router.pop();
            },
            child: const Text('Back to results'),
          ),
        ],
      ),
    );
  }

  /// Dialog shown when user returns after > 10 minutes. Routes home.
  static Future<void> showExpiredAndGoHome(BuildContext context) async {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.schedule, color: AppColors.warning, size: 40),
        title: const Text('Session expired'),
        content: const Text(
          'You\'ve been away for more than 10 minutes. Flight rates change frequently, so please search again.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (context.mounted) context.go('/');
            },
            child: const Text('Search again'),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    return v.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}
