import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/trip_arrow.dart';
import '../../data/utils/airport_city_names.dart';

/// Booking-flow header — dedicated to the checkout journey (passenger
/// details → payment → ticket). Inverts the search-header emphasis: the
/// screen title is the hero, the route is meta. Includes a 3-step
/// progress indicator so the user always knows where they are.
///
/// Usage:
///   slivers: [ BookingJourneyHeader(title: 'Passenger Details',
///                                   params: searchParams,
///                                   currentStep: 1), ... ]
class BookingJourneyHeader extends StatelessWidget {
  final String title;
  final Map<String, dynamic>? params;

  /// 1 = Passenger Details, 2 = Payment, 3 = Ticket.
  final int currentStep;

  final bool showCurrency;
  final VoidCallback? onBack;

  /// Hide the 3-step indicator when the screen isn't part of the
  /// checkout journey (e.g. Flight Details, where the user hasn't
  /// started booking yet). Keeps the same typographic hierarchy —
  /// title + route + meta — so the visual language stays consistent.
  final bool showStepper;

  /// Optional action buttons rendered at the bottom of the header
  /// in place of the stepper. Used on the flight list screen.
  final VoidCallback? onFilter;
  final VoidCallback? onSort;
  final VoidCallback? onModify;
  final bool filterActive;
  final bool actionsDisabled;

  /// Small status line shown above the action buttons, e.g.
  /// "100 flights found".
  final String? statusText;

  const BookingJourneyHeader({
    super.key,
    required this.title,
    this.params,
    this.currentStep = 1,
    this.showCurrency = true,
    this.onBack,
    this.showStepper = false,
    this.onFilter,
    this.onSort,
    this.onModify,
    this.filterActive = false,
    this.actionsDisabled = false,
    this.statusText,
  });

  bool get _hasActions =>
      onFilter != null || onSort != null || onModify != null;

  // Palette — matches the home hero gradient exactly (midnight navy).
  static const _gradStart = Color(0xFF0F172A);
  static const _gradMid = Color(0xFF1E293B);
  static const _gradEnd = Color(0xFF334155);

  static const _steps = ['Details', 'Payment', 'Ticket'];

  @override
  Widget build(BuildContext context) {
    // Height calc — fixed so SliverAppBar doesn't jump while scrolling.
    // IMPORTANT: must mirror the children actually rendered below, or
    // the SliverAppBar reserves dead space that shows up as a gap
    // between the header and the body content.
    const topPad = 2.0;
    const bottomPad = 0.0;
    const topRowH = 30.0; // back pill + title (title lives in this row)
    const titleGap = 14.0; // gap between top row and route/meta block
    // Multi-city chains and round-trip date ranges both run long
    // (`Islamabad → London → Dubai → Karachi` / `Sat, 25 Apr 2026 →
    // Sat, 03 May 2026  ·  Economy  ·  1 Adult`), so both flows get
    // the taller 2-line block. One-way stays tight at 42px.
    final isMulti = _isMultiCityRoute();
    final isRound = _isRoundTrip();
    final metaH = (isMulti || isRound) ? 62.0 : 42.0;
    const stepperGap = 14.0;
    const stepperH = 46.0;
    const actionsGap = 10.0;
    const actionsH = 34.0;
    const statusH = 16.0;
    final hasActions = _hasActions;
    final hasStatus = (statusText ?? '').isNotEmpty;
    final content = topPad +
        topRowH +
        titleGap +
        metaH +
        (showStepper ? stepperGap + stepperH : 0) +
        (hasActions ? actionsGap + actionsH + (hasStatus ? statusH + 4 : 0) : 0) +
        bottomPad;

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      expandedHeight: content,
      toolbarHeight: content,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_gradStart, _gradMid, _gradEnd],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, topPad, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: back + currency
                SizedBox(
                  height: topRowH,
                  child: Row(
                    children: [
                      _BackPill(onBack: onBack),
                      // ── Title (hero of this header) — fits inside topRowH
                      SizedBox(width: titleGap),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.4,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (showCurrency) const CurrencySelector(),
                    ],
                  ),
                ),

                const SizedBox(height: titleGap),

                // ── Route + meta (two lines, muted)
                SizedBox(
                  height: metaH,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _routeLine(),
                        maxLines: isMulti ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _metaLine(),
                        maxLines: (isMulti || isRound) ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                if (showStepper) ...[
                  const SizedBox(height: stepperGap),
                  SizedBox(height: stepperH, child: _buildStepper()),
                ],

                if (hasActions) ...[
                  const SizedBox(height: actionsGap),
                  if (hasStatus) ...[
                    SizedBox(
                      height: statusH,
                      child: Text(
                        statusText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  SizedBox(
                    height: actionsH,
                    child: _buildActionRow(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Meta lines

  /// `true` when the route is multi-city — i.e. the trip type label
  /// says so OR the legs list has more than one entry. Used to decide
  /// whether the route line is allowed to wrap to 2 lines.
  bool _isMultiCityRoute() {
    final t = (params?['tripType'] ?? '').toString().toLowerCase().trim();
    if (t == 'multi' || t == 'multi-city' || t == 'multicity') return true;
    final legsRaw = params?['legs'];
    return legsRaw is List && legsRaw.length > 1;
  }

  bool _isRoundTrip() {
    final t = (params?['tripType'] ?? '').toString().toLowerCase().trim();
    if (t == 'round-trip' || t == 'round_trip' || t == 'roundtrip' || t == 'return') {
      return true;
    }
    final inbound = (params?['inboundDate'] ?? '').toString().trim();
    return inbound.isNotEmpty;
  }

  String _routeLine() {
    // Trip-type drives the arrow style — round-trip gets `⇄`,
    // multi-city chains `→` between hops, one-way gets `→`. Pulled
    // from the central `TripArrow` so every screen renders the same
    // icon for the same trip type.
    final tripTypeRaw = (params?['tripType'] ?? '').toString().toLowerCase().trim();
    final isMulti = tripTypeRaw == 'multi' ||
        tripTypeRaw == 'multi-city' ||
        tripTypeRaw == 'multicity';
    final arrow = TripArrow.padded(tripTypeRaw);
    final legsRaw = params?['legs'];

    // Multi-city — chain every city in the trip so the user sees
    // ISB → LON → DXB → KHI, not just first → last. ONLY when the
    // trip type explicitly says multi-city; round-trip also carries
    // a 2-leg `legs` array (out + return) but the user expects
    // `ISB ⇄ JFK`, not `ISB ⇄ JFK ⇄ ISB`.
    if (isMulti && legsRaw is List && legsRaw.isNotEmpty) {
      final cities = <String>[];
      for (int i = 0; i < legsRaw.length; i++) {
        final leg = legsRaw[i];
        if (leg is! Map) continue;
        final fromCode = (leg['fromCode'] ?? leg['departureCode'] ?? '').toString();
        final fromName = _cityName(leg['fromName'] ?? leg['departureName'], fromCode);
        final toCode = (leg['toCode'] ?? leg['arrivalCode'] ?? '').toString();
        final toName = _cityName(leg['toName'] ?? leg['arrivalName'], toCode);
        if (i == 0 && fromName.isNotEmpty) cities.add(fromName);
        if (toName.isNotEmpty && (cities.isEmpty || cities.last != toName)) {
          cities.add(toName);
        }
      }
      if (cities.length >= 2) return cities.join(arrow);
    }

    final dCode = (params?['departureCode'] ?? '').toString();
    final aCode = (params?['arrivalCode'] ?? '').toString();
    final dName = _cityName(params?['departureName'], dCode);
    final aName = _cityName(params?['arrivalName'], aCode);
    if (dName.isEmpty && aName.isEmpty) return '';
    return '$dName$arrow$aName';
  }

  String _cityName(dynamic raw, String codeFallback) {
    final s = (raw ?? '').toString().trim();
    if (s.isNotEmpty) return s;
    // Provider didn't carry a city name — look it up from the IATA
    // code so the header shows "Islamabad" instead of "ISB". Falls
    // back to the bare code only when the lookup also misses.
    return cityNameFromCode(codeFallback);
  }

  String _metaLine() {
    final parts = <String>[];
    final dateLabel = _dateLabel();
    if (dateLabel.isNotEmpty) parts.add(dateLabel);
    parts.add(_cabinLabel((params?['cabin'] ?? 'Y').toString()));
    final pax = _paxLabel();
    if (pax.isNotEmpty) parts.add(pax);
    return parts.join('    ·    ');
  }

  String _dateLabel() {
    final outbound = (params?['outboundDate'] ?? '').toString();
    final inbound = (params?['inboundDate'] ?? '').toString();
    final tripTypeRaw =
        (params?['tripType'] ?? '').toString().toLowerCase().trim();
    final isRound = tripTypeRaw == 'round-trip' ||
        tripTypeRaw == 'round_trip' ||
        tripTypeRaw == 'roundtrip' ||
        tripTypeRaw == 'return';
    final out = AppDate.tryFromStringWithDay(outbound, fallback: outbound);
    if (isRound && inbound.isNotEmpty) {
      final back = AppDate.tryFromStringWithDay(inbound, fallback: inbound);
      if (back.isNotEmpty) return '$out  →  $back';
    }
    return out;
  }

  String _cabinLabel(String code) {
    final c = code.toUpperCase().trim();
    if (c == 'C' || c == 'J' || c == 'BUSINESS') return 'Business';
    if (c == 'F' || c == 'FIRST') return 'First';
    if (c == 'S' || c == 'W' || c == 'PREMIUM' || c == 'PREMIUM ECONOMY') {
      return 'Premium Economy';
    }
    return 'Economy';
  }

  String _paxLabel() {
    final a = (params?['adultsCount'] as int?) ?? 1;
    final c = (params?['childrenCount'] as int?) ?? 0;
    final i = (params?['infantsCount'] as int?) ?? 0;
    final total = a + c + i;
    if (total <= 0) return '';
    return '$total ${total == 1 ? 'Traveller' : 'Travellers'}';
  }

  // ─────────────────────────────────────────────────────────────────────
  // Stepper

  Widget _buildStepper() {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line between steps
          final leftIndex = i ~/ 2;
          final complete = leftIndex < currentStep - 1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: complete
                      ? AppColors.secondary
                      : Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          );
        }
        final idx = i ~/ 2;
        final isCurrent = idx == currentStep - 1;
        final isComplete = idx < currentStep - 1;
        return _StepNode(
          index: idx + 1,
          label: _steps[idx],
          isCurrent: isCurrent,
          isComplete: isComplete,
        );
      }),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Action row (Filter / Sort / Modify)

  Widget _buildActionRow() {
    final children = <Widget>[];
    if (onFilter != null) {
      children.add(Expanded(
        child: _HeaderActionButton(
          icon: Icons.tune_rounded,
          label: 'Filter',
          onTap: onFilter,
          activeDot: filterActive,
          disabled: actionsDisabled,
        ),
      ));
    }
    if (onFilter != null && (onSort != null || onModify != null)) {
      children.add(const SizedBox(width: 10));
    }
    if (onSort != null) {
      children.add(Expanded(
        child: _HeaderActionButton(
          icon: Icons.swap_vert_rounded,
          label: 'Sort',
          onTap: onSort,
          disabled: actionsDisabled,
        ),
      ));
    }
    if (onSort != null && onModify != null) {
      children.add(const SizedBox(width: 10));
    }
    if (onModify != null) {
      children.add(Expanded(
        child: _HeaderActionButton(
          icon: Icons.edit_outlined,
          label: 'Modify',
          onTap: onModify,
          disabled: actionsDisabled,
          showChevron: false,
        ),
      ));
    }
    return Row(children: children);
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool activeDot;
  final bool disabled;
  final bool showChevron;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.activeDot = false,
    this.disabled = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !disabled;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.16),
            width: 0.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 13),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                if (activeDot) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                if (showChevron) ...[
                  const SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white.withValues(alpha: 0.55),
                    size: 13,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────

class _BackPill extends StatelessWidget {
  final VoidCallback? onBack;
  const _BackPill({this.onBack});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onBack ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.14),
            width: 0.6,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  final int index;
  final String label;
  final bool isCurrent;
  final bool isComplete;

  const _StepNode({
    required this.index,
    required this.label,
    required this.isCurrent,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    final active = isCurrent || isComplete;
    final bg = isCurrent
        ? AppColors.secondary
        : isComplete
            ? AppColors.secondary.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.08);
    final border = isCurrent
        ? AppColors.secondary
        : isComplete
            ? AppColors.secondary.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.22);
    final iconColor = isCurrent
        ? Colors.white
        : isComplete
            ? AppColors.secondary
            : Colors.white.withValues(alpha: 0.5);
    final labelColor = active
        ? Colors.white
        : Colors.white.withValues(alpha: 0.55);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 1.2),
          ),
          alignment: Alignment.center,
          child: isComplete
              ? Icon(Icons.check_rounded, size: 13, color: iconColor)
              : Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: iconColor,
                  ),
                ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
            color: labelColor,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
