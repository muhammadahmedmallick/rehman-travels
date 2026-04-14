import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/utils/baggage_format.dart';
import '../../../../core/utils/time_format.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../providers/flight_search_provider.dart';
import 'fare_rules_sheet.dart';

/// Skyscanner-inspired flight card.
///
/// Layout:
/// - Header: airline name (or "X & Y Airlines" for mixed) + optional badge.
/// - One row per leg with airline logo, time range, route codes, stops,
///   and duration.
/// - Footer with the total price aligned to the right.
class FlightCard extends ConsumerWidget {
  final Map<String, dynamic> flight;
  final VoidCallback onTap;
  final bool isCheapest;
  final Currency? selectedCurrency;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onTap,
    this.isCheapest = false,
    this.selectedCurrency,
  });

  List<Map<String, dynamic>> get _allLegs =>
      (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
  bool get _isMultiCity => _allLegs.length > 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airline = (flight['airlineName'] ?? 'Unknown Airline').toString();
    final airlineCode =
        (flight['airlineCode'] ?? _getAirlineCode(airline)).toString();
    final price = flight['price'] ?? 0;
    final isRefundable = flight['isRefundable'] == true;
    // Prefer the cabin the user actually searched for — providers
    // sometimes return Economy text on Business searches.
    final searchParams = ref.read(flightSearchProvider).searchParams;
    final searchedCabin = searchParams?['cabin']?.toString() ?? '';
    final cabinForLabel = searchedCabin.isNotEmpty
        ? searchedCabin
        : (flight['cabin']?.toString() ?? '');
    // Fallbacks for city names when the leg payload omits them.
    final searchDepName = searchParams?['departureName']?.toString() ?? '';
    final searchArrName = searchParams?['arrivalName']?.toString() ?? '';

    // Build the list of legs to render.
    final legs = _legsToRender(
      fallbackDepCity: searchDepName,
      fallbackArrCity: searchArrName,
      outboundDateLabel: _formatLegDate(
          (searchParams?['outboundDate'] ?? '').toString()),
      inboundDateLabel: _formatLegDate(
          (searchParams?['inboundDate'] ?? '').toString()),
    );
    final headerAirline = _composeHeaderAirline(legs, airline);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isCheapest
              ? Border.all(color: AppColors.success, width: 1.5)
              : Border.all(color: AppColors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header — airline + optional badge
              _header(headerAirline, isRefundable),
              const SizedBox(height: 12),

              // Legs
              for (var i = 0; i < legs.length; i++) ...[
                _legRow(legs[i], airlineCode),
                if (i < legs.length - 1) ...[
                  const SizedBox(height: 10),
                  Divider(
                    height: 1,
                    color: AppColors.border.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 10),
                ],
              ],

              const SizedBox(height: 12),
              Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
              const SizedBox(height: 10),

              // Footer — info chips + fare rules link + price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _footerInfo(isRefundable, cabinForLabel),
                  Text(
                    formatCurrencyPrice(
                      price is num
                          ? price.toDouble()
                          : double.tryParse(price.toString()) ?? 0,
                      selectedCurrency,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // View details + Fare rules links, plus Book Now CTA.
              // Both links push full-screen pages that share the same
              // ItineraryView widget so the user can flip between them.
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _inlineLink(
                    icon: Icons.flight_takeoff_rounded,
                    label: 'View details',
                    onTap: () => context.push(
                      AppRoutes.flightItinerary,
                      extra: flight,
                    ),
                  ),
                  const SizedBox(width: 14),
                  _inlineLink(
                    icon: Icons.article_outlined,
                    label: 'Fare rules',
                    onTap: () => showFareRulesSheet(context, flight),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push(AppRoutes.booking, extra: flight),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Pieces ----------

  Widget _header(String headerAirline, bool isRefundable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            headerAirline,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isCheapest)
          _badge('Cheapest', AppColors.success)
        else if (isRefundable)
          _badge('Refundable', AppColors.info),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _legRow(_LegData leg, String fallbackAirlineCode) {
    final code = leg.airlineCode.isNotEmpty ? leg.airlineCode : fallbackAirlineCode;
    final stopsLabel = leg.stops == 0 ? 'Direct' : '${leg.stops} stop';
    final stopsColor = leg.stops == 0 ? AppColors.success : AppColors.error;
    // Show only the first flight number on the card; full segment list
    // belongs in the details screen.
    final firstFlightNo = leg.flightNumber.split(',').first.trim();
    // For multi-stop flights, the total leg duration is misleading
    // (includes layover). Show the layover city / wait-time instead
    // so the user understands why the leg is long.
    final layoverInfo = leg.stops > 0 ? _layoverInfoForLeg(leg) : null;
    final depCity = leg.depCity.trim();
    final arrCity = leg.arrCity.trim();
    final depPlace = depCity.isNotEmpty
        ? '$depCity (${leg.depCode})'
        : leg.depCode;
    final arrPlace = arrCity.isNotEmpty
        ? '$arrCity (${leg.arrCode})'
        : leg.arrCode;
    final depTimeStr = formatFlightTime(leg.depTime);
    final arrTimeStr = formatFlightTime(leg.arrTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: logo + flight no on the left, stops + duration on the right
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                _getAirlineLogo(code),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    code,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          firstFlightNo.isNotEmpty
                              ? firstFlightNo
                              : leg.airlineName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (leg.dateLabel.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            leg.dateLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (layoverInfo != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      layoverInfo,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stopsLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: stopsColor,
                  ),
                ),
                Text(
                  leg.duration,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Vertical timeline: dep row + connecting line + arr row, indented
        // under the logo so the bullets line up with the airline column.
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _timelinePoint(time: depTimeStr, place: depPlace, isStart: true),
              _timelineConnector(),
              _timelinePoint(time: arrTimeStr, place: arrPlace, isStart: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timelinePoint({
    required String time,
    required String place,
    required bool isStart,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isStart ? Colors.white : AppColors.primary,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 76,
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            place,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _timelineConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 2, bottom: 2),
      child: Container(
        width: 2,
        height: 14,
        color: AppColors.primary.withValues(alpha: 0.25),
      ),
    );
  }

  Widget _inlineLink({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerInfo(bool isRefundable, String cabinSource) {
    final baggage =
        parseBaggage(flight['baggage'], cabin: cabinSource).shortLabel;
    final cabin = _getCabinLabel(cabinSource);
    return Expanded(
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _footerChip(Icons.airline_seat_recline_normal, cabin, AppColors.primary),
          _footerChip(Icons.luggage_outlined, baggage, AppColors.success),
        ],
      ),
    );
  }

  Widget _footerChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Data prep ----------

  /// Converts any of the common API date shapes into a short
  /// `Mon, 15 Apr` label. Returns `""` on failure so callers can
  /// skip rendering when we have no usable date.
  String _formatLegDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      DateTime parsed;
      if (raw.contains('-') && raw.indexOf('-') == 2) {
        parsed = DateFormat('dd-MM-yyyy').parseStrict(raw);
      } else {
        parsed = DateFormat('yyyy-MM-dd').parseStrict(raw);
      }
      return DateFormat('EEE, d MMM').format(parsed);
    } catch (_) {
      return '';
    }
  }

  List<_LegData> _legsToRender({
    String fallbackDepCity = '',
    String fallbackArrCity = '',
    String outboundDateLabel = '',
    String inboundDateLabel = '',
  }) {
    final result = <_LegData>[];
    if (_isMultiCity) {
      for (var i = 0; i < _allLegs.length; i++) {
        final l = _allLegs[i];
        String rawDate = '';
        final segs = l['segments'];
        if (segs is List && segs.isNotEmpty) {
          final first = segs.first;
          if (first is Map) {
            rawDate = (first['departureDate'] ?? '').toString();
          }
        }
        result.add(_LegData.fromLeg(l, dateLabel: _formatLegDate(rawDate)));
      }
      return result;
    }
    // Outbound — fall back to the city the user actually searched for
    // when the leg payload doesn't carry a city name.
    final outDepCity = (flight['departureCity']?.toString() ?? '').isNotEmpty
        ? flight['departureCity'].toString()
        : fallbackDepCity;
    final outArrCity = (flight['arrivalCity']?.toString() ?? '').isNotEmpty
        ? flight['arrivalCity'].toString()
        : fallbackArrCity;
    // Segments for each leg live under `allLegs` — grab them so the
    // card can show layover info instead of misleading total duration.
    final outSegments = _allLegs.isNotEmpty
        ? (_allLegs[0]['segments'] as List?)
                ?.whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            const <Map<String, dynamic>>[]
        : const <Map<String, dynamic>>[];
    result.add(
      _LegData(
        depCode: (flight['departureCode'] ?? '').toString(),
        arrCode: (flight['arrivalCode'] ?? '').toString(),
        depCity: outDepCity,
        arrCity: outArrCity,
        depTime: (flight['departureTime'] ?? '--:--').toString(),
        arrTime: (flight['arrivalTime'] ?? '--:--').toString(),
        duration: (flight['duration'] ?? '--').toString(),
        stops: _parseInt(flight['stops']) ?? 0,
        airlineCode: (flight['airlineCode'] ?? '').toString(),
        airlineName: (flight['airlineName'] ?? '').toString(),
        flightNumber: (flight['flightNumber'] ?? '').toString(),
        segments: outSegments,
        dateLabel: outboundDateLabel,
      ),
    );
    // Return — swapped fallbacks (return goes destination → origin).
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    if (returnLeg != null) {
      final retDepCity =
          (returnLeg['departureCity']?.toString() ?? '').isNotEmpty
              ? returnLeg['departureCity'].toString()
              : fallbackArrCity;
      final retArrCity =
          (returnLeg['arrivalCity']?.toString() ?? '').isNotEmpty
              ? returnLeg['arrivalCity'].toString()
              : fallbackDepCity;
      final retSegments = _allLegs.length > 1
          ? (_allLegs[1]['segments'] as List?)
                  ?.whereType<Map>()
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList() ??
              const <Map<String, dynamic>>[]
          : (returnLeg['segments'] as List?)
                  ?.whereType<Map>()
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList() ??
              const <Map<String, dynamic>>[];
      result.add(
        _LegData(
          depCode: (returnLeg['departureCode'] ?? '').toString(),
          arrCode: (returnLeg['arrivalCode'] ?? '').toString(),
          depCity: retDepCity,
          arrCity: retArrCity,
          depTime: (returnLeg['departureTime'] ?? '--:--').toString(),
          arrTime: (returnLeg['arrivalTime'] ?? '--:--').toString(),
          duration: (returnLeg['duration'] ?? '--').toString(),
          stops: _parseInt(returnLeg['stops']) ?? 0,
          airlineCode: (returnLeg['airlineCode'] ?? '').toString(),
          airlineName: (returnLeg['airlineName'] ?? '').toString(),
          flightNumber: (returnLeg['flightNumber'] ?? '').toString(),
          segments: retSegments,
          dateLabel: inboundDateLabel,
        ),
      );
    }
    return result;
  }

  /// Builds a short layover summary for a multi-stop leg.
  /// Returns strings like `"via Abu Dhabi · 2h 15m stop"`
  /// or `"via Doha, Dubai"` for 2+ stops.
  /// Falls back to `null` when we don't have enough segment info.
  String? _layoverInfoForLeg(_LegData leg) {
    if (leg.segments.length < 2) return null;
    // Collect layover cities (everything between segment[0].arr and the
    // last segment's arr).
    final cities = <String>[];
    for (var i = 0; i < leg.segments.length - 1; i++) {
      final raw = leg.segments[i]['arrivalCity'] ??
          leg.segments[i]['arrivalCode'] ??
          '';
      final city = raw.toString().trim();
      if (city.isNotEmpty) cities.add(city);
    }
    if (cities.isEmpty) return null;

    if (leg.stops == 1) {
      // Compute wait time between seg[0].arr and seg[1].dep.
      final wait =
          _waitBetween(leg.segments[0], leg.segments[1]);
      if (wait != null && wait.isNotEmpty) {
        return 'via ${cities.first} · $wait stop';
      }
      return 'via ${cities.first}';
    }
    return 'via ${cities.join(', ')}';
  }

  String? _waitBetween(Map<String, dynamic> prev, Map<String, dynamic> next) {
    try {
      final arr = (prev['arrivalTime'] ?? '').toString();
      final dep = (next['departureTime'] ?? '').toString();
      if (arr.isEmpty || dep.isEmpty) return null;
      final a = arr.split(':').map(int.parse).toList();
      final d = dep.split(':').map(int.parse).toList();
      var diff = (d[0] * 60 + d[1]) - (a[0] * 60 + a[1]);
      if (diff < 0) diff += 1440;
      if (diff <= 0) return null;
      final h = diff ~/ 60;
      final m = diff % 60;
      return h > 0 ? '${h}h ${m}m' : '${m}m';
    } catch (_) {
      return null;
    }
  }

  /// "Qatar Airways" or "Qatar Airways & Pegasus Airlines" if mixed.
  String _composeHeaderAirline(List<_LegData> legs, String fallback) {
    final names = <String>{};
    for (final l in legs) {
      final n = l.airlineName.trim();
      if (n.isNotEmpty) names.add(n);
    }
    if (names.isEmpty) return fallback;
    if (names.length == 1) return names.first;
    if (names.length == 2) return '${names.first} & ${names.last}';
    return '${names.first} & ${names.length - 1} others';
  }

  // ---------- Helpers ----------

  String _cleanBaggage(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('not included') || lower.contains('nil')) return 'No bag';
    final match =
        RegExp(r'(\d+)\s*(?:kg|k\b)', caseSensitive: false).firstMatch(raw);
    if (match != null) return '${match.group(1)} kg';
    return raw;
  }

  String _getCabinLabel(String cabin) {
    final lower = cabin.toLowerCase().trim();
    if (lower.isEmpty || lower == 'y' || lower == 'economy' || lower == 'm') {
      return 'Economy';
    }
    if (lower == 'c' || lower == 'business' || lower == 'j') return 'Business';
    if (lower == 'f' || lower == 'first') return 'First';
    if (lower == 'w' || lower == 'premium economy' || lower == 'premium') {
      return 'Premium';
    }
    return cabin;
  }

  String _getAirlineLogo(String code) =>
      'https://www.rehmantravel.com/logos/${code.toUpperCase()}.png';

  String _getAirlineCode(String airlineName) {
    final lower = airlineName.toLowerCase();
    if (lower.contains('pakistan') || lower.contains('pia')) return 'PK';
    if (lower.contains('sial') || lower.contains('airsial')) return 'PF';
    if (lower.contains('airblue')) return 'PA';
    if (lower.contains('serene')) return 'ER';
    if (lower.contains('emirates')) return 'EK';
    if (lower.contains('qatar')) return 'QR';
    if (lower.contains('turkish')) return 'TK';
    if (lower.contains('saudi') || lower.contains('saudia')) return 'SV';
    if (lower.contains('etihad')) return 'EY';
    if (lower.contains('fly jinnah') || lower.contains('flyjinnah')) return '9P';
    return airlineName.length >= 2
        ? airlineName.substring(0, 2).toUpperCase()
        : 'XX';
  }

  int? _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class _LegData {
  final String depCode;
  final String arrCode;
  final String depCity;
  final String arrCity;
  final String depTime;
  final String arrTime;
  final String duration;
  final int stops;
  final String airlineCode;
  final String airlineName;
  final String flightNumber;
  final List<Map<String, dynamic>> segments;
  final String dateLabel; // "Mon, 15 Apr" / "" when unknown

  const _LegData({
    required this.depCode,
    required this.arrCode,
    required this.depCity,
    required this.arrCity,
    required this.depTime,
    required this.arrTime,
    required this.duration,
    required this.stops,
    required this.airlineCode,
    required this.airlineName,
    required this.flightNumber,
    this.segments = const [],
    this.dateLabel = '',
  });

  factory _LegData.fromLeg(Map<String, dynamic> leg, {String dateLabel = ''}) {
    int stopsParsed = 0;
    final s = leg['stops'];
    if (s is int) stopsParsed = s;
    if (s is num) stopsParsed = s.toInt();
    if (s is String) stopsParsed = int.tryParse(s) ?? 0;
    final rawSegs = leg['segments'];
    final segs = rawSegs is List
        ? rawSegs.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : const <Map<String, dynamic>>[];
    return _LegData(
      depCode: (leg['departureCode'] ?? '').toString(),
      arrCode: (leg['arrivalCode'] ?? '').toString(),
      depCity: (leg['departureCity'] ?? '').toString(),
      arrCity: (leg['arrivalCity'] ?? '').toString(),
      depTime: (leg['departureTime'] ?? '--:--').toString(),
      arrTime: (leg['arrivalTime'] ?? '--:--').toString(),
      duration: (leg['duration'] ?? '--').toString(),
      stops: stopsParsed,
      airlineCode: (leg['airlineCode'] ?? '').toString(),
      airlineName: (leg['airlineName'] ?? '').toString(),
      flightNumber: (leg['flightNumber'] ?? '').toString(),
      segments: segs,
      dateLabel: dateLabel,
    );
  }
}
