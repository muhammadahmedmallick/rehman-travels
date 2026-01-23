import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class FlightCard extends StatelessWidget {
  final Map<String, dynamic> flight;
  final VoidCallback onTap;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onTap,
  });

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Airline Row
                  Row(
                    children: [
                      // Airline Logo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          _getAirlineLogo(flight['airlineCode'] ?? _getAirlineCode(airline)),
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Center(
                            child: Text(
                              _getAirlineCode(airline),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Airline Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              airline,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              flightNumber,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Direct/Stops Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: stops == 0
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          stops == 0 ? 'Direct' : '$stops Stop${stops > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: stops == 0 ? AppColors.success : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Flight Route
                  Row(
                    children: [
                      // Departure
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              departureTime,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              departureCode,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Flight Duration
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              duration,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                ),
                                const Icon(
                                  Icons.flight,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Arrival
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              arrivalTime,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              arrivalCode,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: AppColors.divider,
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Features
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.luggage_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            flight['baggage'] ?? '20kg',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          isRefundable ? Icons.check_circle_outline : Icons.cancel_outlined,
                          size: 16,
                          color: isRefundable ? AppColors.success : AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            isRefundable ? 'Refundable' : 'Non-refund',
                            style: TextStyle(
                              fontSize: 12,
                              color: isRefundable ? AppColors.success : AppColors.textHint,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Price
                  Text(
                    'PKR ${_formatPrice(price)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    // Using pics.avs.io for airline logos
    return 'https://pics.avs.io/80/80/${code.toUpperCase()}.png';
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
