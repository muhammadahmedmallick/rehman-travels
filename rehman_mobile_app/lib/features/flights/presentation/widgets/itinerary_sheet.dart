import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../providers/flight_search_provider.dart';
import 'fare_rules_view.dart';
import 'flight_leg_card.dart';

/// Opens a bottom sheet showing the full itinerary (outbound + return)
/// using the shared [FlightLegCard] with timelines expanded by default.
///
/// Used from the results screen so the user can inspect a flight's full
/// itinerary without navigating to the details page.
Future<void> showItinerarySheet(
  BuildContext context,
  WidgetRef ref,
  Map<String, dynamic> flight,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.78,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
          final allLegs = (flight['allLegs'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              const [];
          List outboundSegments = const [];
          List returnSegments = const [];
          if (allLegs.isNotEmpty) {
            final s = allLegs[0]['segments'];
            if (s is List) outboundSegments = s;
          }
          if (allLegs.length > 1) {
            final s = allLegs[1]['segments'];
            if (s is List) returnSegments = s;
          } else if (returnLeg != null) {
            final s = returnLeg['segments'];
            if (s is List) returnSegments = s;
          }
          // Pull dates from search params so each leg card shows
          // a friendly date label.
          final searchParams = ref.read(flightSearchProvider).searchParams;
          final outboundDateLabel = _prettyLegDate(
              (searchParams?['outboundDate'] ?? '').toString());
          final inboundDateLabel = _prettyLegDate(
              (searchParams?['inboundDate'] ?? '').toString());

          return Container(
            decoration: const BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
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
                // Header
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
                        child: const Icon(Icons.flight_takeoff_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Itinerary',
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
                // Leg cards
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    child: Column(
                      children: [
                        FlightLegCard(
                          leg: {
                            ...flight,
                            'segments': outboundSegments,
                          },
                          label: returnLeg != null ? 'Outbound' : 'Flight',
                          dateString: outboundDateLabel,
                          defaultExpanded: false,
                        ),
                        if (returnLeg != null)
                          FlightLegCard(
                            leg: {
                              ...returnLeg,
                              'cabin':
                                  returnLeg['cabin'] ?? flight['cabin'],
                              'baggage':
                                  returnLeg['baggage'] ?? flight['baggage'],
                              'isRefundable': returnLeg['isRefundable'] ??
                                  flight['isRefundable'],
                              'segments': returnSegments,
                            },
                            label: 'Return',
                            dateString: inboundDateLabel,
                            defaultExpanded: false,
                          ),
                        // Fare rules — loads automatically, same widget
                        // used on the flight details screen.
                        FareRulesView(flight: flight),
                      ],
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

/// Converts a `dd-MM-yyyy` or `yyyy-MM-dd` date string into a friendly
/// `Mon, 15 Apr 2026` label. Returns `""` on parse failure.
String _prettyLegDate(String raw) {
  if (raw.isEmpty) return '';
  try {
    DateTime parsed;
    if (raw.contains('-') && raw.indexOf('-') == 2) {
      parsed = DateFormat('dd-MM-yyyy').parseStrict(raw);
    } else {
      parsed = DateFormat('yyyy-MM-dd').parseStrict(raw);
    }
    return DateFormat('EEE, d MMM yyyy').format(parsed);
  } catch (_) {
    return '';
  }
}
