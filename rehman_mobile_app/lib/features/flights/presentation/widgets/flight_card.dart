import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class FlightCard extends StatelessWidget {
  final Map<String, dynamic> flight;
  final VoidCallback onTap;
  final bool isCheapest;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onTap,
    this.isCheapest = false,
  });

  List<Map<String, dynamic>> get _allLegs => (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  bool get _isMultiCity => _allLegs.length > 2;

  @override
  Widget build(BuildContext context) {
    final airline = flight['airlineName'] ?? 'Unknown Airline';
    final flightNumber = flight['flightNumber'] ?? '';
    final departureTime = flight['departureTime'] ?? '--:--';
    final arrivalTime = flight['arrivalTime'] ?? '--:--';
    final duration = flight['duration'] ?? '--';
    final departureCode = flight['departureCode'] ?? '';
    final arrivalCode = flight['arrivalCode'] ?? '';
    final price = flight['price'] ?? 0;
    final isRefundable = flight['isRefundable'] ?? false;
    final stops = flight['stops'] ?? 0;
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isCheapest ? AppColors.success : AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Cheapest fare banner
            if (isCheapest)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: AppColors.success,
                child: Text(
                  'Cheapest Fare',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelMd.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            // Main Content
            Padding(
              padding: AppPadding.card,
              child: Column(
                children: [
                  _buildAirlineRow(airline, flightNumber, stops),
                  AppGap.md,
                  // Multi-city: show all legs
                  if (_isMultiCity) ...[
                    for (int i = 0; i < _allLegs.length; i++) ...[
                      if (i > 0)
                        _buildLegDivider(i == 1 && returnLeg != null && !_isMultiCity ? 'Return' : 'Flight ${i + 1}'),
                      _buildRouteRow(
                        _allLegs[i]['departureTime'] ?? '--:--',
                        _allLegs[i]['arrivalTime'] ?? '--:--',
                        _allLegs[i]['duration'] ?? '--',
                        _allLegs[i]['departureCode'] ?? '',
                        _allLegs[i]['arrivalCode'] ?? '',
                        _allLegs[i]['stops'] ?? 0,
                        'Flight ${i + 1}',
                      ),
                    ],
                  ] else ...[
                    // Standard: outbound + optional return
                    _buildRouteRow(departureTime, arrivalTime, duration, departureCode, arrivalCode, stops, 'Departure'),
                    if (returnLeg != null) ...[
                      _buildLegDivider('Return'),
                      _buildRouteRow(
                        returnLeg['departureTime'] ?? '--:--', returnLeg['arrivalTime'] ?? '--:--',
                        returnLeg['duration'] ?? '--', returnLeg['departureCode'] ?? '',
                        returnLeg['arrivalCode'] ?? '', returnLeg['stops'] ?? 0, 'Return',
                      ),
                    ],
                  ],
                ],
              ),
            ),

            // Divider
            Container(height: 1, color: AppColors.divider),

            // Footer
            Padding(
              padding: AppPadding.sectionSm,
              child: _buildFooter(flight, isRefundable, price),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirlineRow(String airline, String flightNumber, int stops) {
    return Row(
      children: [
        // Airline Logo
        Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            _getAirlineLogo(flight['airlineCode'] ?? _getAirlineCode(airline)),
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Center(
              child: Text(
                _getAirlineCode(airline),
                style: AppTextStyles.labelSm.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ),
        AppGap.hSm,
        // Airline Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(airline, style: AppTextStyles.labelLg, overflow: TextOverflow.ellipsis),
              Text(flightNumber, style: AppTextStyles.hint),
            ],
          ),
        ),
        // Direct/Stops Badge
        Container(
          padding: AppPadding.badge,
          decoration: BoxDecoration(
            color: stops == 0
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            stops == 0 ? 'Direct' : '$stops Stop${stops > 1 ? 's' : ''}',
            style: AppTextStyles.labelSm.copyWith(
              color: stops == 0 ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegDivider(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(child: Container(height: 1, color: AppColors.divider)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(label, style: AppTextStyles.hint.copyWith(fontSize: 9))),
        Expanded(child: Container(height: 1, color: AppColors.divider)),
      ]),
    );
  }

  Widget _buildRouteRow(
    String departureTime, String arrivalTime, String duration,
    String departureCode, String arrivalCode, int stops, String label,
  ) {
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

        // Flight Duration
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

  Widget _buildFooter(Map<String, dynamic> flight, bool isRefundable, dynamic price) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.luggage_outlined, size: AppIconSize.sm, color: AppColors.textSecondary),
              AppGap.hXs,
              Flexible(
                child: Text(
                  flight['baggage'] ?? '20kg',
                  style: AppTextStyles.hint,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppGap.hSm,
              Icon(
                isRefundable ? Icons.check_circle_outline : Icons.cancel_outlined,
                size: AppIconSize.sm,
                color: isRefundable ? AppColors.success : AppColors.textHint,
              ),
              AppGap.hXs,
              Flexible(
                child: Text(
                  isRefundable ? 'Refundable' : 'Non-refund',
                  style: AppTextStyles.hint.copyWith(
                    color: isRefundable ? AppColors.success : AppColors.textHint,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        AppGap.hSm,
        Text('PKR ${_formatPrice(price)}', style: AppTextStyles.priceMd),
      ],
    );
  }

  String _getAirlineCode(String airline) {
    final lower = airline.toLowerCase();
    if (lower.contains('pia') || lower.contains('pakistan')) return 'PK';
    if (lower.contains('airsial')) return 'PF';
    if (lower.contains('airblue')) return 'PA';
    if (lower.contains('serene')) return 'ER';
    if (lower.contains('emirates')) return 'EK';
    if (lower.contains('qatar')) return 'QR';
    if (lower.contains('etihad')) return 'EY';
    if (lower.contains('turkish')) return 'TK';
    if (lower.contains('saudia') || lower.contains('saudi')) return 'SV';
    if (lower.contains('flydubai')) return 'FZ';
    if (lower.contains('air arabia')) return 'G9';
    if (airline.length >= 2) return airline.substring(0, 2).toUpperCase();
    return airline;
  }

  String _getAirlineLogo(String code) {
    return 'https://www.rehmantravel.com/logos/${code.toUpperCase()}.png';
  }

  String _formatPrice(dynamic price) {
    if (price is int) {
      return price.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } else if (price is double) {
      return price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } else if (price is String) {
      return price;
    }
    return '0';
  }
}
