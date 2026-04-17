import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

/// Shared dialog shown when the selected flight disappears between a
/// background refresh and the user's current state (sold out / removed
/// by provider). Dismissing pops the current route so the user lands
/// back on the previous screen (usually results).
///
/// Used from both the flight details and booking screens so the copy
/// and behavior stay consistent.
Future<void> showFlightGoneDialog(BuildContext context) async {
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.event_busy, color: AppColors.error, size: 40),
      title: const Text('Flight no longer available'),
      content: const Text(
        'This flight has been sold out or removed by the provider. '
        'Please pick another option from the results.',
        style: TextStyle(fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            if (context.mounted && context.canPop()) context.pop();
          },
          child: const Text('Back to results'),
        ),
      ],
    ),
  );
}
