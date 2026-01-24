import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class VisaCard extends StatelessWidget {
  final String country;
  final String countryCode;
  final String visaType;
  final String duration;
  final String processing;
  final int price;
  final VoidCallback onTap;

  const VisaCard({
    super.key,
    required this.country,
    required this.countryCode,
    required this.visaType,
    required this.duration,
    required this.processing,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Flag
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getCountryColors(countryCode),
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Flag background
                  Center(
                    child: Text(
                      _getCountryFlag(countryCode),
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                  // Type Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        visaType,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        processing,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PKR ${_formatPrice(price)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCountryColors(String code) {
    switch (code.toUpperCase()) {
      case 'UAE':
        return [const Color(0xFF00732F), const Color(0xFFCE1126)];
      case 'SAU':
        return [const Color(0xFF006C35), const Color(0xFF004D26)];
      case 'TUR':
        return [const Color(0xFFE30A17), const Color(0xFFC70000)];
      case 'UK':
        return [const Color(0xFF00247D), const Color(0xFFCF142B)];
      case 'USA':
        return [const Color(0xFF3C3B6E), const Color(0xFFB22234)];
      case 'MYS':
        return [const Color(0xFF010066), const Color(0xFFCC0000)];
      case 'THA':
        return [const Color(0xFF2D2A4A), const Color(0xFFA51931)];
      default:
        return [AppColors.primary, AppColors.primaryDark];
    }
  }

  String _getCountryFlag(String code) {
    switch (code.toUpperCase()) {
      case 'UAE':
        return '🇦🇪';
      case 'SAU':
        return '🇸🇦';
      case 'TUR':
        return '🇹🇷';
      case 'UK':
        return '🇬🇧';
      case 'USA':
        return '🇺🇸';
      case 'MYS':
        return '🇲🇾';
      case 'THA':
        return '🇹🇭';
      case 'CHN':
        return '🇨🇳';
      case 'SGP':
        return '🇸🇬';
      default:
        return '🌍';
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
