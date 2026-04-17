import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'itinerary_view.dart';

/// Single reusable wrapper that renders an [ItineraryView] inside a
/// tap-to-expand card.
///
/// Used on the booking and payment screens — both are form / summary
/// pages where a full itinerary would push the primary action below
/// the fold. The card header shows a one-line route summary; tapping
/// it slides the full itinerary in with [AnimatedCrossFade].
class CollapsibleItineraryCard extends StatefulWidget {
  final Map<String, dynamic> flight;
  final Map<String, dynamic>? searchParams;

  /// Whether the card starts expanded. Defaults to `false` because
  /// both current usage sites want a compact summary up front.
  final bool initiallyExpanded;

  const CollapsibleItineraryCard({
    super.key,
    required this.flight,
    this.searchParams,
    this.initiallyExpanded = false,
  });

  @override
  State<CollapsibleItineraryCard> createState() =>
      _CollapsibleItineraryCardState();
}

class _CollapsibleItineraryCardState extends State<CollapsibleItineraryCard> {
  late bool _expanded = widget.initiallyExpanded;

  /// Builds the one-line summary shown in the collapsed header.
  /// Handles all three trip shapes — one-way (non-stop or stops),
  /// round-trip, and multi-city — so the label reads sensibly for
  /// whatever the user booked.
  String _summary() {
    final flight = widget.flight;
    final allLegs = (flight['allLegs'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        const [];
    final firstLeg = allLegs.isNotEmpty ? allLegs.first : flight;
    final lastLeg = allLegs.isNotEmpty ? allLegs.last : flight;
    final dep =
        (firstLeg['departureCode'] ?? flight['departureCode'] ?? '').toString();
    final arr =
        (lastLeg['arrivalCode'] ?? flight['arrivalCode'] ?? '').toString();
    final legCount = allLegs.isEmpty ? 1 : allLegs.length;
    if (legCount > 1) return '$dep → $arr · $legCount legs';
    final stops = flight['stops'];
    final stopsInt = stops is num
        ? stops.toInt()
        : (stops is String ? int.tryParse(stops) ?? 0 : 0);
    return stopsInt == 0
        ? '$dep → $arr · Non-stop'
        : '$dep → $arr · $stopsInt stop${stopsInt > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.soft,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Flight Itinerary',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to view flight details',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(
                        height: 1, color: AppColors.divider, thickness: 1),
                    // Nudge ItineraryView up a touch so its own top
                    // padding doesn't stack on the divider.
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Transform.translate(
                        offset: const Offset(0, -6),
                        child: ItineraryView(
                          flight: widget.flight,
                          searchParams: widget.searchParams,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
            ),
          ],
        ),
      ),
    );
  }
}
