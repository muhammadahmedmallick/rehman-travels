import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/utils/baggage_format.dart';
import '../../../../core/utils/time_format.dart';

/// Renders a flight's full itinerary as one section per leg.
///
/// Reused by:
///  - `FlightItineraryScreen` (View Details on the results card)
///  - `FareRulesScreen` (View Fare Rules on the results card)
///
/// Iterates `flight['allLegs']` so multi-city, round-trip, and one-way
/// all render with the same layout — one section per leg, with the
/// destination city as the heading, a date pill, duration/stops row,
/// stacked segment cards, connection strips, and a day-change chip on
/// the final segment when the leg crosses midnight.
class ItineraryView extends StatelessWidget {
  final Map<String, dynamic> flight;

  /// Optional search params — used to derive a per-leg date label
  /// when the segment payload doesn't include `departureDate`.
  final Map<String, dynamic>? searchParams;

  const ItineraryView({
    super.key,
    required this.flight,
    this.searchParams,
  });

  List<Map<String, dynamic>> get _legs {
    final raw = flight['allLegs'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final legs = _legs;
    if (legs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No itinerary information available.')),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < legs.length; i++)
          _LegSection(
            leg: legs[i],
            legIndex: i,
            fallbackDate: _legDateFromSearchParams(i),
            fallbackCabin: _resolvedCabin(),
            fallbackBaggage: flight['baggage'],
            fallbackRefundable: flight['isRefundable'] == true,
          ),
      ],
    );
  }

  /// Provider responses sometimes omit (or downgrade) the cabin code on
  /// individual legs — e.g. Sabre returns an empty string on each leg
  /// even when the fare is Business. Fall back to whatever the user
  /// actually searched for so the class label doesn't silently flip to
  /// Economy on the booking / payment screens.
  String _resolvedCabin() {
    final flightCabin = (flight['cabin'] ?? '').toString().trim();
    if (flightCabin.isNotEmpty && flightCabin.toUpperCase() != 'Y') {
      return flightCabin;
    }
    final searchCabin =
        (searchParams?['cabin'] ?? '').toString().trim();
    return searchCabin.isNotEmpty ? searchCabin : flightCabin;
  }

  /// Multi-city legs in `searchParams['legs']` carry per-leg dates as
  /// `outboundDate`. Round-trip outbound is `outboundDate`, return is
  /// `inboundDate`. Falls back to empty when the search params don't
  /// have anything for this leg.
  String _legDateFromSearchParams(int index) {
    final p = searchParams;
    if (p == null) return '';
    final legsList = p['legs'];
    if (legsList is List && index < legsList.length) {
      final entry = legsList[index];
      if (entry is Map) {
        final d = (entry['outboundDate'] ?? '').toString();
        if (d.isNotEmpty) return d;
      }
    }
    if (index == 0) return (p['outboundDate'] ?? '').toString();
    if (index == 1) return (p['inboundDate'] ?? '').toString();
    return '';
  }
}

// ---------------------------------------------------------------------------
// Per-leg section
// ---------------------------------------------------------------------------

class _LegSection extends StatelessWidget {
  final Map<String, dynamic> leg;
  final int legIndex;
  final String fallbackDate;
  final String fallbackCabin;
  final dynamic fallbackBaggage;
  final bool fallbackRefundable;

  const _LegSection({
    required this.leg,
    required this.legIndex,
    required this.fallbackDate,
    required this.fallbackCabin,
    required this.fallbackBaggage,
    required this.fallbackRefundable,
  });

  List<Map<String, dynamic>> get _segments {
    final raw = leg['segments'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  String get _depCity {
    final segs = _segments;
    if (segs.isNotEmpty) {
      final c = (segs.first['departureCity'] ?? '').toString();
      if (c.isNotEmpty) return c;
    }
    return (leg['departureCode'] ?? '').toString();
  }

  String get _arrCity {
    final segs = _segments;
    if (segs.isNotEmpty) {
      final c = (segs.last['arrivalCity'] ?? '').toString();
      if (c.isNotEmpty) return c;
    }
    return (leg['arrivalCode'] ?? '').toString();
  }

  String get _duration => (leg['duration'] ?? '').toString();

  int get _stops {
    final v = leg['stops'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    final segs = _segments;
    return segs.isEmpty ? 0 : segs.length - 1;
  }

  String get _dateLabel {
    // Prefer the segment-level date (most accurate after API refresh).
    final segs = _segments;
    if (segs.isNotEmpty) {
      final d = (segs.first['departureDate'] ?? '').toString();
      final pretty = _prettyDate(d);
      if (pretty.isNotEmpty) return pretty;
    }
    return _prettyDate(fallbackDate);
  }

  /// Number of calendar days between the leg's first-segment departure
  /// and the last-segment arrival. `0` = same day (no chip shown),
  /// `1` = arrives next day, `2+` = arrives N days later. Falls back
  /// to a time-wraparound check (arrival clock < departure clock) when
  /// segment dates aren't available — in that case the chip shows
  /// "next day" because we can't detect multi-day gaps without dates.
  int get _dayDiff {
    final segs = _segments;
    if (segs.isEmpty) return 0;
    final firstDate = (segs.first['departureDate'] ?? '').toString();
    final lastDate = (segs.last['arrivalDate'] ?? '').toString();
    if (firstDate.isNotEmpty && lastDate.isNotEmpty) {
      try {
        final a = DateTime.parse(firstDate);
        final b = DateTime.parse(lastDate);
        final diff = DateTime(b.year, b.month, b.day)
            .difference(DateTime(a.year, a.month, a.day))
            .inDays;
        if (diff > 0) return diff;
      } catch (_) {
        if (firstDate != lastDate) return 1;
      }
    }
    // Fallback: no dates available, use time wraparound.
    final dep = timeToMinutes((leg['departureTime'] ?? '').toString());
    final arr = timeToMinutes((leg['arrivalTime'] ?? '').toString());
    if (dep != null && arr != null && arr < dep) return 1;
    return 0;
  }

  String get _nextDayLabel {
    final segs = _segments;
    if (segs.isEmpty) return '';
    final lastDate = (segs.last['arrivalDate'] ?? '').toString();
    return _prettyDate(lastDate);
  }

  @override
  Widget build(BuildContext context) {
    final segs = _segments;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading: big destination city, "from <origin>" subtitle.
          Text(
            _arrCity,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'from $_depCity',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          // Date pill.
          if (_dateLabel.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.soft,
              ),
              child: Text(
                _dateLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          const SizedBox(height: 10),
          // Duration + stops summary — twin pills with soft tints so
          // the row reads as a paired metric strip rather than a bare
          // text line.
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _SummaryPill(
                icon: Icons.schedule_rounded,
                label: _duration.isEmpty ? '--' : _duration,
                tint: AppColors.textSecondary,
                bg: AppColors.surfaceLight,
              ),
              _SummaryPill(
                icon: _stops == 0
                    ? Icons.flight_takeoff_rounded
                    : Icons.swap_calls_rounded,
                label: _stops == 0
                    ? 'Non-stop'
                    : '$_stops stop${_stops > 1 ? 's' : ''}',
                tint: _stops == 0 ? AppColors.success : AppColors.info,
                bg: (_stops == 0 ? AppColors.success : AppColors.info)
                    .withValues(alpha: 0.10),
                emphasize: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Segment cards + connection strips.
          for (var i = 0; i < segs.length; i++) ...[
            _SegmentCard(
              segment: segs[i],
              fallbackCabin: fallbackCabin,
              fallbackBaggage: fallbackBaggage,
              fallbackRefundable: fallbackRefundable,
              isLastInLeg: i == segs.length - 1,
            ),
            if (i < segs.length - 1) ...[
              const SizedBox(height: 10),
              _ConnectionStrip(prev: segs[i], next: segs[i + 1]),
              const SizedBox(height: 10),
            ],
          ],
          if (_dayDiff > 0) ...[
            const SizedBox(height: 12),
            _NextDayChip(dayDiff: _dayDiff, label: _nextDayLabel),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Segment card with optional "More info" expansion
// ---------------------------------------------------------------------------

class _SegmentCard extends StatefulWidget {
  final Map<String, dynamic> segment;
  final String fallbackCabin;
  final dynamic fallbackBaggage;
  final bool fallbackRefundable;
  final bool isLastInLeg;

  const _SegmentCard({
    required this.segment,
    required this.fallbackCabin,
    required this.fallbackBaggage,
    required this.fallbackRefundable,
    required this.isLastInLeg,
  });

  @override
  State<_SegmentCard> createState() => _SegmentCardState();
}

class _SegmentCardState extends State<_SegmentCard> {
  bool _expanded = false;

  String _s(String key) => (widget.segment[key] ?? '').toString();

  String get _airlineCode => _s('airlineCode');
  String get _airlineName {
    final n = _s('airlineName');
    if (n.isNotEmpty) return n;
    final code = _airlineCode;
    return code.isNotEmpty ? code : 'Airline';
  }

  String get _airlineLogoUrl =>
      'https://www.rehmantravel.com/logos/${_airlineCode.toUpperCase()}.png';

  String get _depTime => formatFlightTime(_s('departureTime'));
  String get _arrTime => formatFlightTime(_s('arrivalTime'));
  String get _depPlace {
    final city = _s('departureCity');
    if (city.isNotEmpty) return city;
    return _s('departureCode');
  }

  String get _arrPlace {
    final city = _s('arrivalCity');
    if (city.isNotEmpty) return city;
    return _s('arrivalCode');
  }

  String get _duration => _s('duration');

  bool get _hasExtraInfo {
    final aircraft = _s('aircraft');
    final meal = _s('meal').isNotEmpty
        ? _s('meal')
        : (_s('mealService').isNotEmpty ? _s('mealService') : _s('mealCode'));
    return aircraft.isNotEmpty || meal.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Airline header row.
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _airlineName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_s('flightNumber').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        _s('flightNumber'),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  _airlineLogoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Center(
                    child: Text(
                      _airlineCode,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Timeline: departure dot → duration line → arrival dot.
          _timelineRow(_depTime, _depPlace, isStart: true),
          _timelineDurationLine(_duration),
          _timelineRow(_arrTime, _arrPlace, isStart: false),
          if (_hasExtraInfo) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _expanded ? 'Less info' : 'More info',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) _expandedDetails(),
          ],
        ],
      ),
    );
  }

  Widget _timelineRow(String time, String place, {required bool isStart}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStart ? Colors.white : AppColors.primary,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            place,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _timelineDurationLine(String duration) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 22,
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
          const SizedBox(width: 16),
          if (duration.isNotEmpty)
            Text(
              duration,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _expandedDetails() {
    final aircraft = _s('aircraft');
    final mealCode = _s('meal').isNotEmpty
        ? _s('meal')
        : (_s('mealService').isNotEmpty ? _s('mealService') : _s('mealCode'));
    final cabin = _s('cabin').isNotEmpty ? _s('cabin') : widget.fallbackCabin;
    final bag = parseBaggage(widget.fallbackBaggage);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aircraft.isNotEmpty)
            _detailRow(Icons.flight_outlined, aircraft),
          if (cabin.isNotEmpty)
            _detailRow(
              Icons.airline_seat_recline_normal,
              _cabinLabel(cabin),
            ),
          _detailRow(
            Icons.luggage_outlined,
            '${bag.longLabel} / adult',
          ),
          if (mealCode.isNotEmpty)
            _detailRow(Icons.restaurant_outlined, _mealLabel(mealCode)),
          if (widget.isLastInLeg)
            _detailRow(
              widget.fallbackRefundable
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              widget.fallbackRefundable ? 'Refundable' : 'Non-refundable',
              color: widget.fallbackRefundable
                  ? AppColors.success
                  : AppColors.error,
            ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text, {Color? color}) {
    final c = color ?? AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cabinLabel(String code) {
    final l = code.toLowerCase().trim();
    if (l.isEmpty || l == 'y' || l == 'economy' || l == 'm') return 'Economy';
    if (l == 'c' || l == 'business' || l == 'j') return 'Business';
    if (l == 'f' || l == 'first') return 'First';
    if (l == 'w' || l == 'premium' || l == 'premium economy') return 'Premium';
    return code;
  }

  String _mealLabel(String code) {
    switch (code.toUpperCase().trim()) {
      case 'B':
        return 'Breakfast';
      case 'L':
        return 'Lunch';
      case 'D':
        return 'Dinner';
      case 'S':
      case 'K':
        return 'Snack';
      case 'M':
        return 'Meal provided';
      case 'R':
        return 'Refreshments';
      case 'C':
        return 'Continental breakfast';
      case 'H':
        return 'Hot meal';
      case 'N':
        return 'No meal';
      default:
        return code;
    }
  }
}

// ---------------------------------------------------------------------------
// Connection strip between segments
// ---------------------------------------------------------------------------

/// Tiny rounded pill used in the leg summary row for duration + stops.
/// Icon + label inside a soft-tinted background — reads as a quick
/// metric chip rather than a plain text run.
class _SummaryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tint;
  final Color bg;
  final bool emphasize;

  const _SummaryPill({
    required this.icon,
    required this.label,
    required this.tint,
    required this.bg,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: emphasize
            ? Border.all(color: tint.withValues(alpha: 0.25), width: 0.6)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: tint),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w700,
              color: tint,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionStrip extends StatelessWidget {
  final Map<String, dynamic> prev;
  final Map<String, dynamic> next;

  const _ConnectionStrip({required this.prev, required this.next});

  String get _airport {
    final c = (prev['arrivalCity'] ?? '').toString();
    if (c.isNotEmpty) return c;
    return (prev['arrivalCode'] ?? '').toString();
  }

  String get _waitTime {
    final arrMin = timeToMinutes((prev['arrivalTime'] ?? '').toString());
    final depMin = timeToMinutes((next['departureTime'] ?? '').toString());
    if (arrMin == null || depMin == null) return '';
    var diff = depMin - arrMin;
    // Cross-day connections: also factor in the date jump.
    final arrDate = (prev['arrivalDate'] ?? '').toString();
    final depDate = (next['departureDate'] ?? '').toString();
    if (arrDate.isNotEmpty && depDate.isNotEmpty && arrDate != depDate) {
      try {
        final a = DateTime.parse(arrDate);
        final d = DateTime.parse(depDate);
        diff += d.difference(a).inDays * 1440;
      } catch (_) {
        if (diff < 0) diff += 1440;
      }
    } else if (diff < 0) {
      diff += 1440;
    }
    if (diff <= 0) return '';
    final h = diff ~/ 60;
    final m = diff % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  bool get _isLongWait {
    final wait = _waitTime;
    if (wait.isEmpty) return false;
    final hMatch = RegExp(r'(\d+)h').firstMatch(wait);
    final hours = hMatch != null ? int.tryParse(hMatch.group(1)!) ?? 0 : 0;
    return hours >= 4;
  }

  String get _airportCode => (prev['arrivalCode'] ?? '').toString();

  @override
  Widget build(BuildContext context) {
    final wait = _waitTime;
    // A layover isn't an error condition — it's informational. Use
    // info-blue for normal connections and amber for long waits, so
    // the strip reads as a neutral notice instead of a warning.
    final accent = AppColors.info;
    final code = _airportCode;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.09),
            accent.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.22), width: 0.8),
      ),
      child: Row(
        children: [
          // Rail-node: airport code sits in a small pill that doubles as
          // a visual waypoint between the two segment cards.
          Container(
            height: 40,
            constraints: const BoxConstraints(minWidth: 40),
            padding: EdgeInsets.symmetric(
                horizontal: code.isEmpty ? 0 : 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: accent.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: code.isNotEmpty
                ? Text(
                    code.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: accent,
                      letterSpacing: 0.5,
                    ),
                  )
                : Icon(Icons.connecting_airports_rounded,
                    size: 18, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'LAYOVER',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: accent,
                        letterSpacing: 1.4,
                      ),
                    ),
                    if (_isLongWait) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LONG WAIT',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: accent,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  _airport.isEmpty ? 'Connection' : _airport,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (wait.isNotEmpty) ...[
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLongWait
                        ? Icons.hourglass_bottom_rounded
                        : Icons.timelapse_rounded,
                    size: 13,
                    color: accent,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    wait,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: accent,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Arrives next day" chip
// ---------------------------------------------------------------------------

class _NextDayChip extends StatelessWidget {
  final int dayDiff;
  final String label;

  const _NextDayChip({required this.dayDiff, required this.label});

  String get _text => dayDiff <= 1
      ? "You'll arrive the next day"
      : "You'll arrive $dayDiff days later";

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.info,
                ),
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Date helper
// ---------------------------------------------------------------------------

String _prettyDate(String raw) {
  if (raw.isEmpty) return '';
  try {
    DateTime parsed;
    if (raw.contains('-') && raw.indexOf('-') == 2) {
      parsed = DateFormat('dd-MM-yyyy').parseStrict(raw);
    } else {
      parsed = DateTime.parse(raw);
    }
    return DateFormat('EEEE, d MMMM').format(parsed);
  } catch (_) {
    return '';
  }
}
