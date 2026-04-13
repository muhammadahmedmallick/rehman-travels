import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../core/utils/baggage_format.dart';
import '../../../../core/utils/time_format.dart';

/// Reusable "leg" card used on the flight details, booking, and
/// (future) passenger detail screens. Also the visual reference for
/// the ticket PDF renderer so all flight info looks the same.
///
/// The widget reads everything from a single [leg] map — pass the
/// raw flight object (or its `returnLeg`) and optional context.
///
/// When the leg has 2+ segments the card is tap-to-expand, revealing
/// a timeline with per-segment cards, connection strips, optional
/// day-change chip, and cabin / baggage / refundable chips.
class FlightLegCard extends StatefulWidget {
  /// Flight or returnLeg map. Expected keys (all optional — the widget
  /// falls back gracefully):
  /// `airlineCode`, `airlineName`, `flightNumber`, `isRefundable`,
  /// `cabin`, `baggage`, `departureCode`, `arrivalCode`,
  /// `departureCity`, `arrivalCity`, `departureTime`, `arrivalTime`,
  /// `duration`, `stops`, `segments`.
  final Map<String, dynamic> leg;

  /// Optional top label — e.g. "Outbound" / "Return" / "Flight Info".
  final String? label;

  /// Optional pill shown next to the label — e.g. "Saturday, 18 April".
  final String? dateString;

  /// When true, the timeline is shown expanded on first render.
  final bool defaultExpanded;

  /// When false, the card never expands (timeline stays hidden even
  /// if segments are available). Useful for compact booking views.
  final bool collapsible;

  /// Optional margin override (defaults to the details screen spacing).
  final EdgeInsets? margin;

  const FlightLegCard({
    super.key,
    required this.leg,
    this.label,
    this.dateString,
    this.defaultExpanded = false,
    this.collapsible = true,
    this.margin,
  });

  @override
  State<FlightLegCard> createState() => _FlightLegCardState();
}

class _FlightLegCardState extends State<FlightLegCard> {
  late bool _expanded = widget.defaultExpanded;

  // ---------- Data helpers ----------

  Map<String, dynamic> get _leg => widget.leg;
  String _s(String key) => (_leg[key] ?? '').toString();
  int get _stops {
    final v = _leg['stops'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  List<Map<String, dynamic>> get _segments {
    final raw = _leg['segments'];
    if (raw is List) {
      return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return const [];
  }

  String get _airlineLogoUrl =>
      'https://www.rehmantravel.com/logos/${_s('airlineCode').toUpperCase()}.png';

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    final hasSegments = widget.collapsible && _segments.length >= 2;
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: hasSegments ? () => setState(() => _expanded = !_expanded) : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((widget.label ?? '').isNotEmpty ||
                    (widget.dateString ?? '').isNotEmpty) ...[
                  _header(),
                  const SizedBox(height: 12),
                ],
                _summary(),
                if (_expanded && hasSegments) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  _timeline(),
                  if (_arrivesNextDay()) ...[
                    const SizedBox(height: 12),
                    _dayChangeChip(),
                  ],
                  const SizedBox(height: 6),
                  _extraInfoRow(),
                ],
                if (hasSegments) ...[
                  const SizedBox(height: 10),
                  _expandToggle(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        if ((widget.label ?? '').isNotEmpty)
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 0.2,
            ),
          ),
        if ((widget.label ?? '').isNotEmpty &&
            (widget.dateString ?? '').isNotEmpty)
          const SizedBox(width: 10),
        if ((widget.dateString ?? '').isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.dateString!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _summary() {
    final stopsLabel = _stops == 0 ? 'Non-stop' : '$_stops stop';
    final stopsColor = _stops == 0 ? AppColors.success : AppColors.error;
    final route = '${_s('departureCode')} - ${_s('arrivalCode')}';
    final airlineCode = _s('airlineCode');
    final airlineName = _s('airlineName');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            _airlineLogoUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Center(
              child: Text(
                airlineCode,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${formatFlightTime(_s('departureTime'))} - ${formatFlightTime(_s('arrivalTime'))}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                airlineName.isNotEmpty ? airlineName : route,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              stopsLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: stopsColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _s('duration').isEmpty ? '--' : _s('duration'),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Timeline + segment cards ----------

  Widget _timeline() {
    final segs = _segments;
    final widgets = <Widget>[];
    for (var i = 0; i < segs.length; i++) {
      widgets.add(_segmentCard(segs[i]));
      if (i < segs.length - 1) {
        widgets.add(const SizedBox(height: 10));
        widgets.add(_connectionStrip(segs[i], segs[i + 1]));
        widgets.add(const SizedBox(height: 10));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget _segmentCard(Map<String, dynamic> seg) {
    final depTime = formatFlightTime((seg['departureTime'] ?? '--:--').toString());
    final arrTime = formatFlightTime((seg['arrivalTime'] ?? '--:--').toString());
    final depCity = (seg['departureCity'] ?? seg['departureCode'] ?? '').toString();
    final arrCity = (seg['arrivalCity'] ?? seg['arrivalCode'] ?? '').toString();
    final duration = (seg['duration'] ?? '').toString();
    final flightNum = (seg['flightNumber'] ?? '').toString();
    final airlineName = (seg['airlineName'] ?? _s('airlineName')).toString();
    final airlineCode = (seg['airlineCode'] ?? _s('airlineCode')).toString();
    final aircraft = (seg['aircraft'] ?? seg['aircraftType'] ?? '').toString();
    final meal = (seg['meal'] ?? seg['mealService'] ?? seg['mealCode'] ?? '').toString();
    final logoUrl =
        'https://www.rehmantravel.com/logos/${airlineCode.toUpperCase()}.png';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Airline header
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airlineName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (flightNum.isNotEmpty)
                    Text(
                      flightNum,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    airlineCode,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _timelineRow(depTime, depCity, isStart: true),
          _timelineDurationLine(duration),
          _timelineRow(arrTime, arrCity, isStart: false),
          if (aircraft.isNotEmpty || meal.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                if (aircraft.isNotEmpty)
                  _segMeta(Icons.flight_outlined, aircraft),
                if (meal.isNotEmpty)
                  _segMeta(Icons.restaurant_outlined, _mealLabel(meal)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _segMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
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
        return 'Meal';
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
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 70,
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
            height: 24,
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

  Widget _connectionStrip(Map<String, dynamic> prev, Map<String, dynamic> next) {
    final airport = (prev['arrivalCity'] ?? prev['arrivalCode'] ?? '').toString();
    String waitTime = '';
    final arrMin = timeToMinutes((prev['arrivalTime'] ?? '').toString());
    final depMin = timeToMinutes((next['departureTime'] ?? '').toString());
    if (arrMin != null && depMin != null) {
      var diff = depMin - arrMin;
      if (diff < 0) diff += 1440;
      if (diff > 0) {
        final h = diff ~/ 60;
        final m = diff % 60;
        waitTime = h > 0 ? '${h}h ${m}m' : '${m}m';
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              waitTime.isNotEmpty
                  ? '$waitTime connection in $airport'
                  : 'Connection in $airport',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _arrivesNextDay() {
    final depMin = timeToMinutes(_s('departureTime'));
    final arrMin = timeToMinutes(_s('arrivalTime'));
    if (depMin == null || arrMin == null) return false;
    return arrMin < depMin;
  }

  Widget _dayChangeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.nights_stay_outlined, size: 14, color: AppColors.error),
          const SizedBox(width: 8),
          Text(
            'You\'ll arrive the next day',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _extraInfoRow() {
    final cabin = _s('cabin');
    final bag = parseBaggage(_leg['baggage']);
    final isRefundable = _leg['isRefundable'] == true;
    final items = <Widget>[
      if (cabin.isNotEmpty)
        _infoPill(Icons.airline_seat_recline_normal, _cabinLabel(cabin)),
      _infoPill(Icons.luggage_outlined, bag.longLabel),
      _infoPill(
        isRefundable ? Icons.check_circle_outline : Icons.cancel_outlined,
        isRefundable ? 'Refundable' : 'Non-refundable',
        color: isRefundable ? AppColors.success : AppColors.error,
      ),
    ];
    return Wrap(spacing: 8, runSpacing: 8, children: items);
  }

  String _cabinLabel(String code) {
    final l = code.toLowerCase().trim();
    if (l.isEmpty || l == 'y' || l == 'economy' || l == 'm') return 'Economy';
    if (l == 'c' || l == 'business' || l == 'j') return 'Business';
    if (l == 'f' || l == 'first') return 'First';
    if (l == 'w' || l == 'premium' || l == 'premium economy') return 'Premium';
    return code;
  }

  Widget _infoPill(IconData icon, String text, {Color? color}) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: c,
            ),
          ),
        ],
      ),
    );
  }

  Widget _expandToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _expanded ? 'Hide details' : 'View details',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 18,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
