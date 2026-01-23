import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class VisaDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> visaData;

  const VisaDetailsScreen({
    super.key,
    required this.visaData,
  });

  @override
  State<VisaDetailsScreen> createState() => _VisaDetailsScreenState();
}

class _VisaDetailsScreenState extends State<VisaDetailsScreen> {
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
    // Collapse threshold - when most of expanded area is scrolled
    final isCollapsed = _scrollController.offset > 200;
    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.visaData['country'] ?? 'United Arab Emirates';
    final countryCode = widget.visaData['countryCode'] ?? 'UAE';
    final visaType = widget.visaData['visaType'] ?? 'Tourist Visa';
    final duration = widget.visaData['duration'] ?? '30 Days';
    final processing = widget.visaData['processing'] ?? '3-5 Working Days';
    final price = widget.visaData['price'] ?? 15000;
    final imageUrl = widget.visaData['imageUrl'];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Image with Sliver App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _getCountryColors(countryCode)[0],
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isCollapsed
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            // Show title when collapsed
            title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getCountryFlag(countryCode),
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        country,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        visaType,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isCollapsed
                        ? Colors.transparent
                        : Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image or Gradient
                  if (imageUrl != null)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildGradientBackground(countryCode),
                    )
                  else
                    _buildGradientBackground(countryCode),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),

                  // Country Info Overlay
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country Flag Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getCountryFlag(countryCode),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                countryCode,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          country,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visaType,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Info Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickInfoCard(
                      icon: Icons.calendar_today_outlined,
                      label: 'Duration',
                      value: duration,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickInfoCard(
                      icon: Icons.access_time,
                      label: 'Processing',
                      value: processing,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickInfoCard(
                      icon: Icons.verified_outlined,
                      label: 'Entry',
                      value: widget.visaData['entry'] ?? 'Single',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Requirements Section
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Requirements',
              icon: Icons.checklist_outlined,
              children: const [
                _RequirementItem(
                  icon: Icons.badge_outlined,
                  title: 'Valid Passport',
                  description: 'Minimum 6 months validity from travel date',
                ),
                _RequirementItem(
                  icon: Icons.photo_camera_outlined,
                  title: 'Passport Photos',
                  description: '2 recent passport-size photographs (white background)',
                ),
                _RequirementItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Bank Statement',
                  description: 'Last 3 months bank statement',
                ),
                _RequirementItem(
                  icon: Icons.flight_outlined,
                  title: 'Flight Booking',
                  description: 'Confirmed return flight ticket',
                ),
                _RequirementItem(
                  icon: Icons.hotel_outlined,
                  title: 'Hotel Booking',
                  description: 'Confirmed hotel reservation',
                ),
              ],
            ),
          ),

          // Process Section
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'How It Works',
              icon: Icons.route_outlined,
              children: const [
                _ProcessStep(
                  number: '1',
                  title: 'Submit Documents',
                  description: 'Upload your required documents online',
                ),
                _ProcessStep(
                  number: '2',
                  title: 'Review & Verification',
                  description: 'Our team reviews your application',
                ),
                _ProcessStep(
                  number: '3',
                  title: 'Embassy Processing',
                  description: 'Application submitted to embassy',
                ),
                _ProcessStep(
                  number: '4',
                  title: 'Visa Delivered',
                  description: 'Receive your visa via email/courier',
                  isLast: true,
                ),
              ],
            ),
          ),

          // Important Notes
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Note',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Processing time may vary. Embassy reserves the right to request additional documents or reject applications.',
                          style: TextStyle(
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
            ),
          ),

          // Pricing Section
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Price Details',
              icon: Icons.receipt_long_outlined,
              children: [
                _PriceRow(label: 'Visa Fee', value: 'PKR ${_formatPrice((price * 0.7).toInt())}'),
                _PriceRow(label: 'Service Charge', value: 'PKR ${_formatPrice((price * 0.2).toInt())}'),
                _PriceRow(label: 'Processing Fee', value: 'PKR ${_formatPrice((price * 0.1).toInt())}'),
                const Divider(height: 24),
                _PriceRow(
                  label: 'Total',
                  value: 'PKR ${_formatPrice(price)}',
                  isBold: true,
                  valueColor: AppColors.secondary,
                ),
              ],
            ),
          ),

          // Space for bottom bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
                    const Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'PKR ${_formatPrice(price)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to visa application
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Apply Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBackground(String countryCode) {
    final colors = _getCountryColors(countryCode);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          _getCountryFlag(countryCode),
          style: const TextStyle(fontSize: 80),
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
    }
    return price.toString();
  }
}

// Quick Info Card
class _QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickInfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

// Section Card
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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

// Requirement Item
class _RequirementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _RequirementItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            size: 18,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

// Process Step
class _ProcessStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isLast;

  const _ProcessStep({
    required this.number,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Price Row
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
