import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'fare_rules_view.dart';

/// Opens a draggable bottom sheet showing the fare rules for a flight.
///
/// Used from the results card and the itinerary screen so the user
/// can read the rules without losing their place.
Future<void> showFareRulesSheet(
  BuildContext context,
  Map<String, dynamic> flight,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 12, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.article_outlined,
                            size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Fare Rules',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close, size: 22),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: AppShadows.soft,
                      ),
                      child: FareRulesView(flight: flight, flat: true),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
