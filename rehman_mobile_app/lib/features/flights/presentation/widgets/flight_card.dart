import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../currency/presentation/providers/currency_provider.dart';

class FlightCard extends StatelessWidget {
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

  List<Map<String, dynamic>> get _allLegs => (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  bool get _isMultiCity => _allLegs.length > 2;

  @override
  Widget build(BuildContext context) {
    final airline = flight['airlineName'] ?? 'Unknown Airline';
    final departureTime = flight['departureTime'] ?? '--:--';
    final arrivalTime = flight['arrivalTime'] ?? '--:--';
    final duration = flight['duration'] ?? '--';
    final departureCode = flight['departureCode'] ?? '';
    final arrivalCode = flight['arrivalCode'] ?? '';
    final price = flight['price'] ?? 0;
    final stops = flight['stops'] ?? 0;
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final airlineCode = flight['airlineCode'] ?? _getAirlineCode(airline);
    final rawBaggage = flight['baggage']?.toString() ?? '';
    final baggage = rawBaggage.isEmpty ? 'No Baggage' : _cleanBaggage(rawBaggage);
    final isRefundable = flight['isRefundable'] ?? false;
    final flightNumber = flight['flightNumber']?.toString() ?? '';
    final cabinClass = _getCabinLabel(flight['cabin']?.toString() ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isCheapest ? Border.all(color: AppColors.success, width: 1.5) : null,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(children: [
              // Airline + Flight No + Badge row
              Row(children: [
                // Airline logo (circle)
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceLight, border: Border.all(color: AppColors.border, width: 0.5)),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    _getAirlineLogo(airlineCode),
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Center(child: Text(airlineCode, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(airline, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,color: AppColors.primary), overflow: TextOverflow.ellipsis),
                  if (flightNumber.isNotEmpty)
                    Text(flightNumber, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                ])),
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCheapest ? AppColors.success.withValues(alpha: 0.1) : isRefundable ? AppColors.info.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isCheapest ? 'Recommended' : isRefundable ? 'Refundable' : 'Economy',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: isCheapest ? AppColors.success : isRefundable ? AppColors.info : AppColors.error),
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              // Route row(s)
              if (_isMultiCity) ...[
                for (int i = 0; i < _allLegs.length; i++) ...[
                  if (i > 0) _dottedDivider(),
                  _buildRoute(_allLegs[i]['departureCode'] ?? '', _allLegs[i]['arrivalCode'] ?? '',
                    _allLegs[i]['departureTime'] ?? '--:--', _allLegs[i]['arrivalTime'] ?? '--:--',
                    _allLegs[i]['duration'] ?? '--', _allLegs[i]['stops'] ?? 0, isReturn: i > 0),
                ],
              ] else ...[
                _buildRoute(departureCode, arrivalCode, departureTime, arrivalTime, duration, stopsInt),
                if (returnLeg != null) ...[
                  _dottedDivider(),
                  _buildRoute(returnLeg['departureCode'] ?? '', returnLeg['arrivalCode'] ?? '',
                    returnLeg['departureTime'] ?? '--:--', returnLeg['arrivalTime'] ?? '--:--',
                    returnLeg['duration'] ?? '--', returnLeg['stops'] ?? 0, isReturn: true),
                ],
              ],
            ]),
          ),

          // Dotted divider
          _dottedDivider(),

          // Footer: baggage + price
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(children: [
              Expanded(child: Row(children: [
                Icon(Icons.airline_seat_recline_normal, size: 13, color: AppColors.primary),
                const SizedBox(width: 2),
                Text(cabinClass, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(width: 8),
                Icon(Icons.luggage_outlined, size: 13, color: AppColors.primary),
                const SizedBox(width: 3),
                Flexible(child: Text(baggage, style: TextStyle(fontSize: 10, color: AppColors.primary), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Icon(isRefundable ? Icons.check_circle_outline : Icons.cancel_outlined, size: 11, color: AppColors.primary),
                const SizedBox(width: 2),
                Text(isRefundable ? 'Refund' : 'Non-refund', style: TextStyle(fontSize: 10, color: AppColors.primary)),
              ])),
              const SizedBox(width: 8),
              Text(formatCurrencyPrice((price is num ? price.toDouble() : double.tryParse(price.toString()) ?? 0), selectedCurrency), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.success)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildRoute(String depCode, String arrCode, String depTime, String arrTime, String duration, int stops, {bool isReturn = false}) {
    return Row(children: [
      // Departure
      Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(depCode, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
        const SizedBox(height: 2),
        Text(depTime, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      ])),
      // Route visual
      Expanded(flex: 3, child: Column(children: [
        Text(duration, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Row(children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5))),
          Expanded(child: _dottedLine()),
          Transform.rotate(angle: isReturn ? -1.5708 : 1.5708, child: Icon(Icons.flight, size: 14, color: AppColors.primary)),
          Expanded(child: _dottedLine()),
          Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
        ]),
        const SizedBox(height: 4),
        Text(stops == 0 ? 'Non-stop' : '$stops Stop', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: stops == 0 ? AppColors.success : AppColors.textSecondary)),
      ])),
      // Arrival
      Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(arrCode, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
        const SizedBox(height: 2),
        Text(arrTime, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      ])),
    ]);
  }

  Widget _dottedLine() {
    return LayoutBuilder(builder: (_, constraints) {
      final count = (constraints.maxWidth / 5).floor();
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(count, (_) => Container(width: 2, height: 1, color: AppColors.primary)));
    });
  }

  Widget _dottedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(builder: (_, constraints) {
        final count = (constraints.maxWidth / 6).floor();
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) => Container(width: 3, height: 1, color: AppColors.border)));
      }),
    );
  }

  String _cleanBaggage(String raw) {
    // "Check-in baggage (1 pc of 30 kg)" → "30 kg"
    // "Check-in baggage not Included" → "No Baggage"
    // "20 K" → "20 kg"
    // "20kg" → "20 kg"
    final lower = raw.toLowerCase();
    if (lower.contains('not included') || lower.contains('nil')) return 'No Baggage';
    final match = RegExp(r'(\d+)\s*(?:kg|k\b)', caseSensitive: false).firstMatch(raw);
    if (match != null) return '${match.group(1)} kg';
    return raw;
  }


  String _getCabinLabel(String cabin) {
    final lower = cabin.toLowerCase().trim();
    if (lower.isEmpty || lower == 'y' || lower == 'economy' || lower == 'm') return 'Economy';
    if (lower == 'c' || lower == 'business' || lower == 'j') return 'Business';
    if (lower == 'f' || lower == 'first') return 'First';
    if (lower == 'w' || lower == 'premium economy' || lower == 'premium') return 'Premium Economy';
    return cabin;
  }

  String _getAirlineLogo(String code) => 'https://www.rehmantravel.com/logos/${code.toUpperCase()}.png';

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
    return airlineName.length >= 2 ? airlineName.substring(0, 2).toUpperCase() : 'XX';
  }
}
