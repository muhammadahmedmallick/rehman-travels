// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/utils/baggage_format.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/time_format.dart';
import '../../data/utils/airport_city_names.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../providers/booking_session_provider.dart';
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
  final bool isBest;
  final bool isFastest;
  final Currency? selectedCurrency;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onTap,
    this.isCheapest = false,
    this.isBest = false,
    this.isFastest = false,
    this.selectedCurrency,
  });

  List<Map<String, dynamic>> get _allLegs =>
      (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

  /// Multi-city if either:
  ///   • the flight carries `tripType == 'multi'` (search context), OR
  ///   • the parsed response has 3+ legs (legacy heuristic)
  /// Some providers collapse multi-city responses into 1–2 `allLegs`
  /// entries even though the user searched for 3+ stops, so trusting
  /// only `allLegs.length > 2` makes those cards silently render as
  /// round-trip (just first → last). The tripType check fixes that.
  bool get _isMultiCity {
    final t = (flight['tripType'] ?? '').toString().toLowerCase();
    if (t == 'multi' || t == 'multi-city' || t == 'multicity') return true;
    return _allLegs.length > 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airline = (flight['airlineName'] ?? 'Unknown Airline').toString();
    final airlineCode =
        (flight['airlineCode'] ?? _getAirlineCode(airline)).toString();
    final price = flight['price'] ?? 0;
    final isRefundable = flight['isRefundable'] == true;
    // Prefer the cabin the user actually searched for — providers
    // sometimes return Economy text on Business searches.
    final searchState = ref.watch(flightSearchProvider);
    final searchParams = searchState.searchParams;
    // In the multi-city leg-by-leg flow (both forward selection and
    // the "Change this leg" re-pick entry from review), this tap picks
    // a leg — not an immediate booking. Label the CTA accordingly so
    // the intent is obvious.
    final isLegSelection = searchState.isMultiCityLegFlow;
    final ctaLabel = isLegSelection ? 'Select Flight' : 'Book Now';
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
          // Border priority: Best > Cheapest > Fastest > default. Only
          // one accent at a time so the card doesn't look chaotic when
          // multiple superlatives apply to the same flight.
          border: Border.all(
            color: isBest
                ? AppColors.secondary
                : isCheapest
                    ? AppColors.success
                    : isFastest
                        ? AppColors.warning
                        : AppColors.border,
            width: (isBest || isCheapest || isFastest) ? 1.5 : 0.5,
          ),
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
              // Debug-only chip showing which provider returned this
              // flight (sabre / airsial / airblue / etc.) so we can
              // tell at a glance where each result came from. Stripped
              // out of release builds by the kDebugMode guard.
              if (kDebugMode) ...[
                const SizedBox(height: 6),
                _providerDebugChip(
                    (flight['provider'] ?? 'unknown').toString()),
              ],
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
                    onTap: () {
                      // Start the booking session here so the
                      // itinerary screen (and every screen after)
                      // reads pax counts / fare from one source
                      // instead of recomputing from `extra:`.
                      final searchParams =
                          ref.read(flightSearchProvider).searchParams ?? {};
                      ref.read(bookingSessionProvider.notifier).start(
                            flight: flight,
                            searchParams: searchParams,
                          );
                      context.push(
                        AppRoutes.flightItinerary,
                        extra: flight,
                      );
                    },
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
                      onPressed: onTap,
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
                      child: Text(ctaLabel),
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
    // Up to three OTA-style differentiation tags can stack on the
    // header row: Best (champagne / secondary), Cheapest (green),
    // Fastest (amber). Refundable is shown only when no superlative
    // tag applies, so it doesn't fight for space on the top picks.
    final tags = <Widget>[];
    if (isBest) tags.add(_badge('Best', AppColors.secondary));
    if (isCheapest) tags.add(_badge('Cheapest', AppColors.success));
    if (isFastest) tags.add(_badge('Fastest', AppColors.warning));
    if (tags.isEmpty && isRefundable) {
      tags.add(_badge('Refundable', AppColors.info));
    }

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
        if (tags.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: tags,
          ),
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

  /// Debug-only chip that names the provider this flight came from
  /// (sabre / airsial / airblue / etc.). Helps tell at a glance which
  /// upstream returned a given result while debugging the chunked
  /// flight-search response.
  Widget _providerDebugChip(String provider) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.deepPurple.withValues(alpha: 0.3),
            width: 0.6,
          ),
        ),
        child: Text(
          'DEBUG · provider: $provider',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.deepPurple,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _legRow(_LegData leg, String fallbackAirlineCode) {
    final code = leg.airlineCode.isNotEmpty ? leg.airlineCode : fallbackAirlineCode;
    final stopsLabel = leg.stops == 0
        ? 'Direct'
        : '${leg.stops} stop${leg.stops > 1 ? 's' : ''}';
    final stopsColor = leg.stops == 0 ? AppColors.success : AppColors.textSecondary;
    final firstFlightNo = leg.flightNumber.split(',').first.trim();
    // Append the via-hub on multi-stop legs so users can see where the
    // layover happens: "1 stop · KHI".
    final viaHub = leg.stops > 0 ? _firstHubCode(leg) : '';
    final stopsText = (leg.stops > 0 && viaHub.isNotEmpty)
        ? '$stopsLabel · $viaHub'
        : stopsLabel;

    String resolveCity(String code, String payloadCity) {
      final looked = tryCityNameFromCode(code);
      if (looked != null) return looked;
      final p = payloadCity.trim();
      if (p.isNotEmpty && p.toUpperCase() != code.toUpperCase()) return p;
      return code;
    }

    final depPlace = resolveCity(leg.depCode, leg.depCity);
    final arrPlace = resolveCity(leg.arrCode, leg.arrCity);
    final depTimeStr = formatFlightTime(leg.depTime);
    final arrTimeStr = formatFlightTime(leg.arrTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Airline header — logo + name + flight no (e.g. "PIA · PK 301").
        // No stops/duration on this row anymore; those live in the
        // dotted-line block below where the spatial relationship is
        // clearer (between the dep + arr times).
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    leg.airlineName.isNotEmpty
                        ? leg.airlineName
                        : (firstFlightNo.isNotEmpty ? firstFlightNo : code),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        firstFlightNo.isNotEmpty ? firstFlightNo : code,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (viaHub.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          '· via $viaHub',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ] else if (leg.stops == 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '· Direct',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (leg.dateLabel.isNotEmpty)
              Text(
                leg.dateLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.1,
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal timeline: dep | dotted line w/ plane | arr.
        // Mockup pattern — large times, small codes + cities below.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Departure
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  depTimeStr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  leg.depCode,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  depPlace,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            // Connector — duration above, dotted line w/ plane, stops below
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      leg.duration,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 14,
                      child: CustomPaint(
                        size: const Size(double.infinity, 14),
                        painter: _DottedRoutePainter(
                          color: AppColors.border,
                          endColor: AppColors.primary,
                        ),
                        child: Center(
                          child: Container(
                            color: AppColors.cardBg,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: const Icon(
                              Icons.flight,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stopsText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: stopsColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Arrival
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  arrTimeStr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  leg.arrCode,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  arrPlace,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Pulls the IATA code for the first stop (layover hub) on a
  /// multi-stop leg so the card can render "1 stop · KHI".
  String _firstHubCode(_LegData leg) {
    if (leg.segments.length < 2) return '';
    final first = leg.segments.first;
    final hub = (first['arrivalCode'] ?? first['arrivalAirportCode'] ?? '')
        .toString()
        .trim();
    return hub.toUpperCase();
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
    return AppDate.tryFromStringWithDay(raw);
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
    if (lower == 's' || lower == 'w' || lower == 'premium economy' || lower == 'premium') {
      return 'Premium Economy';
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

/// Paints the dotted route line that runs between the dep and arr
/// times on a flight card. The body of the line is dashed in the
/// neutral border colour; the right-end dot is solid primary so the
/// arrival point reads as the destination at a glance. The plane
/// icon child is positioned in the centre by the host `Stack` —
/// this painter just draws under it.
class _DottedRoutePainter extends CustomPainter {
  final Color color;
  final Color endColor;

  const _DottedRoutePainter({required this.color, required this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Dashed line — 4pt dash, 4pt gap.
    const dashWidth = 4.0;
    const dashGap = 4.0;
    var x = 4.0;
    while (x < size.width - 4.0) {
      canvas.drawLine(
          Offset(x, centerY), Offset(x + dashWidth, centerY), paint);
      x += dashWidth + dashGap;
    }

    // Hollow ring at the start (dep side).
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset(0, centerY), 3.5, ringPaint);

    // Solid dot at the end (arr side).
    final endPaint = Paint()..color = endColor;
    canvas.drawCircle(Offset(size.width, centerY), 3.5, endPaint);
  }

  @override
  bool shouldRepaint(covariant _DottedRoutePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.endColor != endColor;
}
