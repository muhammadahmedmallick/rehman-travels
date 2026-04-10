import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../providers/flight_search_provider.dart';

class FlightDetailsScreen extends ConsumerStatefulWidget {
  final String flightId;
  final Map<String, dynamic>? flightData;

  const FlightDetailsScreen({
    super.key,
    required this.flightId,
    this.flightData,
  });

  @override
  ConsumerState<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends ConsumerState<FlightDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isCollapsed = _scrollController.offset > 140;
    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  /// Extract real price breakdown from rawData, with per-passenger-type details
  Map<String, dynamic> _getPriceBreakdown(Map<String, dynamic> flight) {
    final totalPrice = (flight['price'] as num?)?.toDouble() ?? 0;
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;

    final adults = _parseInt(flight['adultsCount']) ?? 1;
    final children = _parseInt(flight['childrenCount']) ?? 0;
    final infants = _parseInt(flight['infantsCount']) ?? 0;

    if (priceData != null) {
      final adultFare = _parseDouble(priceData['grossFarePerAdult'] ?? priceData['baseFarePerAdult']);
      final childFare = _parseDouble(priceData['grossFarePerChild'] ?? priceData['baseFarePerChild']);
      final infantFare = _parseDouble(priceData['grossFarePerInfant'] ?? priceData['baseFarePerInfant']);
      final baseFare = _parseDouble(priceData['baseFare'] ?? priceData['baseFarePerAdult']);
      final taxes = _parseDouble(priceData['taxes'] ?? priceData['taxesPerAdult']);

      return {
        'adults': adults,
        'children': children,
        'infants': infants,
        'adultFare': adultFare > 0 ? adultFare : (baseFare > 0 ? baseFare : totalPrice / adults.clamp(1, 99)),
        'childFare': childFare,
        'infantFare': infantFare,
        'baseFare': baseFare > 0 ? baseFare : totalPrice * 0.85,
        'taxes': taxes > 0 ? taxes : totalPrice * 0.15,
        'total': totalPrice,
      };
    }

    // Fallback to estimated split
    return {
      'adults': adults,
      'children': children,
      'infants': infants,
      'adultFare': totalPrice / adults.clamp(1, 99),
      'childFare': 0.0,
      'infantFare': 0.0,
      'baseFare': totalPrice * 0.85,
      'taxes': totalPrice * 0.15,
      'total': totalPrice,
    };
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flightData ?? {};
    final price = flight['price'] ?? 15000;
    final airlineName = flight['airlineName'] ?? 'Pakistan International Airlines';
    final airlineCode = flight['airlineCode'] ?? _getAirlineCode(airlineName);
    final departureCode = flight['departureCode'] ?? 'ISB';
    final arrivalCode = flight['arrivalCode'] ?? 'KHI';
    final selectedCurrency = ref.watch(currencyProvider).selected;
    final priceBreakdown = _getPriceBreakdown(flight);
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final isRoundTrip = returnLeg != null;
    final allLegs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Collapsible App Bar
          SliverAppBar(
            expandedHeight: isRoundTrip ? 200 : 140,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: AppBackButton(),
            actions: const [CurrencySelector(), SizedBox(width: 12)],
            title: Text(
              '$departureCode ${isRoundTrip ? '⇄' : '→'} $arrivalCode',
              style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      _headerRoute(
                        departureCode, arrivalCode,
                        flight['departureTime'] ?? '--:--', flight['arrivalTime'] ?? '--:--',
                        flight['duration'] ?? '--', flight['stops'] ?? 0,
                      ),
                      if (isRoundTrip) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(children: [
                            Expanded(child: Container(height: 0.5, color: Colors.white.withValues(alpha: 0.2))),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Return', style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.5)))),
                            Expanded(child: Container(height: 0.5, color: Colors.white.withValues(alpha: 0.2))),
                          ]),
                        ),
                        _headerRoute(
                          returnLeg!['departureCode'] ?? '', returnLeg['arrivalCode'] ?? '',
                          returnLeg['departureTime'] ?? '--:--', returnLeg['arrivalTime'] ?? '--:--',
                          returnLeg['duration'] ?? '--', returnLeg['stops'] ?? 0,
                          isReturn: true,
                        ),
                      ],
                    ]),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(children: [
              // Airline card
              Container(
                margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceLight, border: Border.all(color: AppColors.border, width: 0.5)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(_getAirlineLogo(airlineCode), fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Center(child: Text(airlineCode, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary)))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(airlineName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    Text(flight['flightNumber'] ?? '', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ((flight['isRefundable'] ?? false) ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (flight['isRefundable'] ?? false) ? 'Refundable' : 'Non-Refundable',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: (flight['isRefundable'] ?? false) ? AppColors.success : AppColors.error),
                    ),
                  ),
                ]),
              ),

              // Departure card
              _flightInfoCard(
                label: isRoundTrip ? 'Departure' : 'Flight Info',
                depCode: departureCode,
                arrCode: arrivalCode,
                depTime: flight['departureTime'] ?? '--:--',
                arrTime: flight['arrivalTime'] ?? '--:--',
                duration: flight['duration'] ?? '--',
                stops: flight['stops'] ?? 0,
                baggage: flight['baggage'] ?? '20kg',
                cabin: _getCabinLabel(flight['cabin']?.toString() ?? ''),
                provider: flight['provider'] ?? '',
                isReturn: false,
              ),

              // Departure segments (stopover details)
              _buildSegmentsCard(
                label: isRoundTrip ? 'Departure Route' : 'Route Details',
                allLegs: allLegs,
                legIndex: 0,
              ),

              // Return card
              if (isRoundTrip)
                _flightInfoCard(
                  label: 'Return',
                  depCode: returnLeg!['departureCode'] ?? '',
                  arrCode: returnLeg['arrivalCode'] ?? '',
                  depTime: returnLeg['departureTime'] ?? '--:--',
                  arrTime: returnLeg['arrivalTime'] ?? '--:--',
                  duration: returnLeg['duration'] ?? '--',
                  stops: returnLeg['stops'] ?? 0,
                  baggage: returnLeg['baggage'] ?? flight['baggage'] ?? '20kg',
                  cabin: _getCabinLabel(flight['cabin']?.toString() ?? ''),
                  provider: flight['provider'] ?? '',
                  isReturn: true,
                ),

              // Return segments (stopover details)
              if (isRoundTrip)
                _buildSegmentsCard(
                  label: 'Return Route',
                  allLegs: allLegs,
                  legIndex: 1,
                ),

              // Fare Rules - inline card with auto-load
              _FareRulesCard(flight: flight),

              // Price Breakdown
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Price Breakdown', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 10),
                  // Per-passenger-type pricing
                  if ((priceBreakdown['adults'] as int) > 0) ...[
                    _passengerPriceSection(
                      'Adult',
                      priceBreakdown['adults'] as int,
                      (priceBreakdown['adultFare'] as num).toDouble(),
                      selectedCurrency,
                    ),
                  ],
                  if ((priceBreakdown['children'] as int) > 0) ...[
                    _passengerPriceSection(
                      'Child',
                      priceBreakdown['children'] as int,
                      (priceBreakdown['childFare'] as num).toDouble(),
                      selectedCurrency,
                    ),
                  ],
                  if ((priceBreakdown['infants'] as int) > 0) ...[
                    _passengerPriceSection(
                      'Infant',
                      priceBreakdown['infants'] as int,
                      (priceBreakdown['infantFare'] as num).toDouble(),
                      selectedCurrency,
                    ),
                  ],
                  _priceRow('Taxes & Fees', formatCurrencyPrice((priceBreakdown['taxes'] as num).toDouble(), selectedCurrency)),
                  const Divider(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                    Text(formatCurrencyPrice((priceBreakdown['total'] as num).toDouble(), selectedCurrency), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.success)),
                  ]),
                ]),
              ),

              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: AppTextStyles.bodyMd.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatCurrencyPrice((price is num ? price.toDouble() : double.tryParse(price.toString()) ?? 0), selectedCurrency),
                      style: AppTextStyles.priceLg.copyWith(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              AppGap.hLg,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.push(AppRoutes.booking, extra: widget.flightData);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Book Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flightInfoCard({
    required String label, required String depCode, required String arrCode,
    required String depTime, required String arrTime, required String duration,
    required dynamic stops, required String baggage, required String cabin,
    required String provider, required bool isReturn,
  }) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        const SizedBox(height: 12),
        // Route visual
        Row(children: [
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(depTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ])),
          Expanded(flex: 3, child: Column(children: [
            Text(duration, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 4),
            Row(children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5))),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Transform.rotate(
                angle: isReturn ? -1.5708 : 1.5708,
                child: Icon(Icons.flight, size: 14, color: AppColors.primary),
              ),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
            ]),
            const SizedBox(height: 3),
            Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: stopsInt == 0 ? AppColors.success : AppColors.textSecondary)),
          ])),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(arrTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ])),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        _infoRow(Icons.airline_seat_recline_normal, 'Class', cabin),
        _infoRow(Icons.luggage_outlined, 'Baggage', baggage),
        _infoRow(Icons.business, 'Provider', provider),
      ]),
    );
  }

  Widget _buildSegmentsCard({required String label, required List<Map<String, dynamic>> allLegs, required int legIndex}) {
    if (legIndex >= allLegs.length) return const SizedBox.shrink();
    final leg = allLegs[legIndex];
    final segments = (leg['segments'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // Only show if there are 2+ segments (i.e. there's a stopover)
    if (segments.length < 2) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.route_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text('${segments.length - 1} Stop${segments.length > 2 ? 's' : ''}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.warning)),
          ),
        ]),
        const SizedBox(height: 14),
        for (int i = 0; i < segments.length; i++) ...[
          _buildSegmentRow(segments[i]),
          if (i < segments.length - 1)
            _buildLayoverIndicator(segments[i], segments[i + 1]),
        ],
      ]),
    );
  }

  Widget _buildSegmentRow(Map<String, dynamic> seg) {
    final depCode = seg['departureCode'] ?? '';
    final arrCode = seg['arrivalCode'] ?? '';
    final depCity = seg['departureCity'] ?? '';
    final arrCity = seg['arrivalCity'] ?? '';
    final depTime = seg['departureTime'] ?? '--:--';
    final arrTime = seg['arrivalTime'] ?? '--:--';
    final duration = seg['duration'] ?? '';
    final flightNum = seg['flightNumber'] ?? '';
    final airlineCode = seg['airlineCode'] ?? '';
    final aircraft = seg['aircraft'] ?? '';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        // Airline + flight number
        Row(children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border, width: 0.5)),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://www.rehmantravel.com/logos/${airlineCode.toUpperCase()}.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Center(child: Text(airlineCode, style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: AppColors.primary))),
            ),
          ),
          const SizedBox(width: 6),
          Text(flightNum, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          if (aircraft.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text('· $aircraft', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ]),
        const SizedBox(height: 8),
        // Route
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            if (depCity.isNotEmpty) Text(depCity, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(depTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ])),
          Expanded(child: Column(children: [
            if (duration.isNotEmpty) Text(duration, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 3),
            Row(children: [
              Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1))),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Icon(Icons.flight, size: 12, color: AppColors.primary),
              Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
              Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
            ]),
          ])),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            if (arrCity.isNotEmpty) Text(arrCity, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(arrTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ])),
        ]),
      ]),
    );
  }

  Widget _buildLayoverIndicator(Map<String, dynamic> arrSeg, Map<String, dynamic> depSeg) {
    final layoverCity = arrSeg['arrivalCity'] ?? arrSeg['arrivalCode'] ?? '';
    final layoverCode = arrSeg['arrivalCode'] ?? '';

    // Calculate layover time from arrival → next departure
    String layoverTime = '';
    final arrTime = arrSeg['arrivalTime']?.toString() ?? '';
    final depTime = depSeg['departureTime']?.toString() ?? '';
    if (arrTime.contains(':') && depTime.contains(':')) {
      try {
        final arrParts = arrTime.split(':');
        final depParts = depTime.split(':');
        final arrMin = int.parse(arrParts[0]) * 60 + int.parse(arrParts[1]);
        var depMin = int.parse(depParts[0]) * 60 + int.parse(depParts[1]);
        if (depMin < arrMin) depMin += 24 * 60; // next day
        final diff = depMin - arrMin;
        if (diff > 0) {
          final h = diff ~/ 60;
          final m = diff % 60;
          layoverTime = h > 0 ? '${h}h ${m}m' : '${m}m';
        }
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.access_time, size: 14, color: AppColors.warning),
        ),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Layover in $layoverCity${layoverCode.isNotEmpty && layoverCode != layoverCity ? ' ($layoverCode)' : ''}',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning),
          ),
          if (layoverTime.isNotEmpty)
            Text('Waiting time: $layoverTime', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }

  Widget _headerRoute(String depCode, String arrCode, String depTime, String arrTime, String duration, dynamic stops, {bool isReturn = false}) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(depCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(depTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
      Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Text(duration, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Row(children: [
            Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5))),
            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.4))),
            Transform.rotate(angle: isReturn ? -1.5708 : 1.5708, child: const Icon(Icons.flight, size: 14, color: Colors.white)),
            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.4))),
            Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
          ]),
          const SizedBox(height: 3),
          Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
        ]),
      )),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(arrCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(arrTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
    ]);
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.primary)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ]),
    );
  }

  Widget _passengerPriceSection(String type, int count, double farePerPerson, Currency? currency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('$type × $count', style: TextStyle(fontSize: 12, color: AppColors.primary)),
        Text(formatCurrencyPrice(farePerPerson * count, currency), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ]),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.primary)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ]),
    );
  }

  String _getCabinLabel(String cabin) {
    final lower = cabin.toLowerCase().trim();
    if (lower.isEmpty || lower == 'y' || lower == 'economy' || lower == 'm') return 'Economy';
    if (lower == 'c' || lower == 'business' || lower == 'j') return 'Business';
    if (lower == 'f' || lower == 'first') return 'First';
    if (lower == 'w' || lower == 'premium economy' || lower == 'premium') return 'Premium Economy';
    return cabin;
  }

  String _getAirlineCode(String airline) {
    if (airline.toLowerCase().contains('pia') || airline.toLowerCase().contains('pakistan')) {
      return 'PK';
    } else if (airline.toLowerCase().contains('airsial')) {
      return 'PF';
    } else if (airline.toLowerCase().contains('airblue')) {
      return 'PA';
    } else if (airline.toLowerCase().contains('serene')) {
      return 'ER';
    } else if (airline.toLowerCase().contains('emirates')) {
      return 'EK';
    } else if (airline.toLowerCase().contains('qatar')) {
      return 'QR';
    } else if (airline.toLowerCase().contains('etihad')) {
      return 'EY';
    } else if (airline.toLowerCase().contains('turkish')) {
      return 'TK';
    } else if (airline.toLowerCase().contains('saudia') || airline.toLowerCase().contains('saudi')) {
      return 'SV';
    } else if (airline.toLowerCase().contains('flydubai')) {
      return 'FZ';
    } else if (airline.toLowerCase().contains('air arabia')) {
      return 'G9';
    } else if (airline.length >= 2) {
      return airline.substring(0, 2).toUpperCase();
    }
    return airline;
  }

  String _getAirlineLogo(String code) {
    return 'https://www.rehmantravel.com/logos/${code.toUpperCase()}.png';
  }

}

// Fare Rules inline card with auto-load + skeleton
class _FareRulesCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> flight;
  const _FareRulesCard({required this.flight});

  @override
  ConsumerState<_FareRulesCard> createState() => _FareRulesCardState();
}

class _FareRulesCardState extends ConsumerState<_FareRulesCard> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _fareRules = [];

  @override
  void initState() {
    super.initState();
    _fetchFareRules();
  }

  Future<void> _fetchFareRules() async {
    final flight = widget.flight;
    final fareRuleKey = flight['fareRuleKey'];
    final jSessionId = flight['jSessionId'];
    final provider = flight['provider'];
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;

    if (fareRuleKey == null || jSessionId == null || provider == null) {
      setState(() { _isLoading = false; _fareRules = _defaults(); });
      return;
    }

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.postWithHeader(
        ApiEndpoints.fareRules,
        data: {
          'fareRuleKeys': [{'fareRuleRefKey': fareRuleKey}],
          'jSessionId': jSessionId,
          'airType': priceData?['airType'] ?? '',
          'vCarrier': priceData?['validatingCarrier'] ?? '',
        },
        extraHeaders: {'Action-Type': provider},
      );
      if (!mounted) return;

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('fareRules')) {
        final rules = data['fareRules'];
        if (rules is List && rules.isNotEmpty) {
          setState(() {
            _isLoading = false;
            _fareRules = rules.map((r) {
              if (r is Map<String, dynamic>) {
                return {'title': r['category'] ?? r['title'] ?? 'Rule', 'description': r['text'] ?? r['description'] ?? r['rules'] ?? ''};
              }
              return {'title': 'Rule', 'description': r.toString()};
            }).toList();
          });
          return;
        }
      }
      setState(() { _isLoading = false; _fareRules = _defaults(); });
    } catch (_) {
      if (!mounted) return;
      setState(() { _isLoading = false; _fareRules = _defaults(); });
    }
  }

  List<Map<String, dynamic>> _defaults() => [
    {'icon': Icons.cancel_outlined, 'title': 'Cancellation', 'description': 'Charges may apply as per airline policy.'},
    {'icon': Icons.edit_calendar_outlined, 'title': 'Date Changes', 'description': 'Date change allowed with a fee. Subject to availability.'},
    {'icon': Icons.luggage_outlined, 'title': 'Baggage', 'description': '${widget.flight['baggage'] ?? '20kg'} checked baggage included.'},
    {'icon': Icons.event_busy_outlined, 'title': 'No Show', 'description': 'No show penalty applies. Tickets may become non-refundable.'},
  ];

  IconData _icon(String title) {
    final l = title.toLowerCase();
    if (l.contains('cancel')) return Icons.cancel_outlined;
    if (l.contains('change') || l.contains('date')) return Icons.edit_calendar_outlined;
    if (l.contains('baggage')) return Icons.luggage_outlined;
    if (l.contains('no show')) return Icons.event_busy_outlined;
    if (l.contains('refund')) return Icons.money_off_outlined;
    return Icons.article_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fare Rules', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        const SizedBox(height: 10),
        if (_isLoading) ...[
          // Skeleton loading
          for (int i = 0; i < 3; i++) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 80, height: 10, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(width: double.infinity, height: 8, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4))),
                ])),
              ]),
            ),
          ],
        ] else ...[
          for (final rule in _fareRules) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                  child: Icon(rule['icon'] as IconData? ?? _icon(rule['title'] ?? ''), size: 14, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(rule['title'] ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text(rule['description'] ?? '', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
                ])),
              ]),
            ),
          ],
        ],
      ]),
    );
  }
}

// === UNUSED LEGACY WIDGETS BELOW ===
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppIconSize.lg, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.titleSm.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppGap.md,
          ...children,
        ],
      ),
    );
  }
}

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final IconData? icon;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppIconSize.lg - 2, color: AppColors.textSecondary),
                AppGap.hSm,
              ],
              Text(
                label,
                style: AppTextStyles.bodyLg.copyWith(
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.titleSm.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.textPrimary,
                  )
                : AppTextStyles.bodyLg.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
          ),
        ],
      ),
    );
  }
}

// Flight Route Visualization Widget (used inside section cards)
class _FlightRouteWidget extends StatelessWidget {
  final String departureCode;
  final String arrivalCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int stops;

  const _FlightRouteWidget({
    required this.departureCode,
    required this.arrivalCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Departure
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(departureTime, style: AppTextStyles.titleLg),
              AppGap.xs,
              Text(departureCode, style: AppTextStyles.caption),
            ],
          ),
        ),

        // Flight Path
        Expanded(
          child: Column(
            children: [
              Text(duration, style: AppTextStyles.hint),
              AppGap.xs,
              Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: AppColors.border)),
                  Icon(Icons.flight, size: AppIconSize.sm, color: AppColors.primary),
                  Expanded(child: Container(height: 1, color: AppColors.border)),
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              AppGap.xs,
              Text(
                stops == 0 ? 'Direct' : '$stops Stop${stops > 1 ? 's' : ''}',
                style: AppTextStyles.hint.copyWith(
                  fontSize: 9,
                  color: stops == 0 ? AppColors.success : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),

        // Arrival
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(arrivalTime, style: AppTextStyles.titleLg),
              AppGap.xs,
              Text(arrivalCode, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

// Fare Rule Item Widget
class _FareRuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FareRuleItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: AppIconSize.lg, color: AppColors.primary),
          ),
          AppGap.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMd,
                ),
                AppGap.xs,
                Text(
                  description,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
