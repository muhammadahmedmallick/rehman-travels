import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../core/constants/api_endpoints.dart';
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

  /// Extract real price breakdown from rawData, with fallback to estimate
  Map<String, double> _getPriceBreakdown(Map<String, dynamic> flight) {
    final totalPrice = (flight['price'] as num?)?.toDouble() ?? 0;
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;

    if (priceData != null) {
      final baseFare = _parseDouble(priceData['baseFare'] ?? priceData['baseFarePerAdult']);
      final taxes = _parseDouble(priceData['taxes'] ?? priceData['taxesPerAdult']);

      if (baseFare > 0) {
        return {
          'baseFare': baseFare,
          'taxes': taxes > 0 ? taxes : totalPrice - baseFare,
          'total': totalPrice,
        };
      }
    }

    // Fallback to estimated split
    return {
      'baseFare': totalPrice * 0.85,
      'taxes': totalPrice * 0.15,
      'total': totalPrice,
    };
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
    final priceBreakdown = _getPriceBreakdown(flight);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sliver App Bar with Flight Route
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isCollapsed
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            // Collapsed Title
            title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Airline Logo
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      _getAirlineLogo(airlineCode),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Center(
                        child: Text(
                          airlineCode,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$departureCode → $arrivalCode',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        airlineName.length > 20
                            ? '${airlineName.substring(0, 20)}...'
                            : airlineName,
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Airline Logo & Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                _getAirlineLogo(airlineCode),
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Center(
                                  child: Text(
                                    airlineCode,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  airlineName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  flight['flightNumber'] ?? 'PK-201',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
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
                                    flight['departureTime'] ?? '14:30',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    departureCode,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Flight Path
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    flight['duration'] ?? '1h 15m',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
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
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.white.withValues(alpha: 0.4),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.flight, color: Colors.white, size: 14),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.white.withValues(alpha: 0.4),
                                        ),
                                      ),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (flight['stops'] ?? 0) == 0 ? 'Direct' : '${flight['stops']} Stop',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
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
                                  Text(
                                    flight['arrivalTime'] ?? '15:45',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    arrivalCode,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.9),
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
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Flight Details
                _SectionCard(
                  title: 'Flight Details',
                  icon: Icons.flight_outlined,
                  children: [
                    _DetailRow(label: 'Aircraft', value: flight['aircraft'] ?? 'Boeing 737'),
                    _DetailRow(label: 'Class', value: flight['cabin'] ?? 'Economy'),
                    _DetailRow(label: 'Duration', value: flight['duration'] ?? '1h 15m'),
                    _DetailRow(
                      label: 'Baggage',
                      value: flight['baggage'] ?? '30kg',
                      icon: Icons.luggage_outlined,
                    ),
                  ],
                ),

                // Fare Information
                _SectionCard(
                  title: 'Fare Information',
                  icon: Icons.info_outline,
                  children: [
                    _DetailRow(
                      label: 'Refundable',
                      value: (flight['isRefundable'] ?? false) ? 'Yes' : 'No',
                      valueColor: (flight['isRefundable'] ?? false)
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    _DetailRow(label: 'Provider', value: flight['provider'] ?? ''),
                  ],
                ),

                // Fare Rules Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton(
                    onPressed: () => _showFareRules(context, flight),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 20),
                        SizedBox(width: 8),
                        Text('View Fare Rules'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Price Breakdown
                _SectionCard(
                  title: 'Price Breakdown',
                  icon: Icons.receipt_long_outlined,
                  children: [
                    _DetailRow(
                      label: 'Base Fare',
                      value: 'PKR ${_formatPrice(priceBreakdown['baseFare']!)}',
                    ),
                    _DetailRow(
                      label: 'Taxes & Fees',
                      value: 'PKR ${_formatPrice(priceBreakdown['taxes']!)}',
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Total',
                      value: 'PKR ${_formatPrice(priceBreakdown['total']!)}',
                      isBold: true,
                      valueColor: AppColors.secondary,
                    ),
                  ],
                ),

                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
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

  void _showFareRules(BuildContext context, Map<String, dynamic> flight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FareRulesSheet(flight: flight),
    );
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

// Fare Rules Bottom Sheet with API call
class _FareRulesSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> flight;

  const _FareRulesSheet({required this.flight});

  @override
  ConsumerState<_FareRulesSheet> createState() => _FareRulesSheetState();
}

class _FareRulesSheetState extends ConsumerState<_FareRulesSheet> {
  bool _isLoading = true;
  String? _error;
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
      setState(() {
        _isLoading = false;
        _fareRules = _getDefaultFareRules();
      });
      return;
    }

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.postWithHeader(
        ApiEndpoints.fareRules,
        data: {
          'fareRuleKeys': [
            {'fareRuleRefKey': fareRuleKey}
          ],
          'jSessionId': jSessionId,
          'airType': priceData?['airType'] ?? '',
          'vCarrier': priceData?['validatingCarrier'] ?? '',
        },
        extraHeaders: {'Action-Type': provider},
      );

      if (!mounted) return;

      if (kDebugMode) {
        print('Fare rules response: ${response.data}');
      }

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('fareRules')) {
        final rules = data['fareRules'];
        if (rules is List && rules.isNotEmpty) {
          setState(() {
            _isLoading = false;
            _fareRules = rules.map((r) {
              if (r is Map<String, dynamic>) {
                return {
                  'title': r['category'] ?? r['title'] ?? 'Rule',
                  'description': r['text'] ?? r['description'] ?? r['rules'] ?? 'No details available',
                };
              }
              return {'title': 'Rule', 'description': r.toString()};
            }).toList();
          });
          return;
        }
      }

      // If we got a response but no parseable rules, show defaults
      setState(() {
        _isLoading = false;
        _fareRules = _getDefaultFareRules();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Fare rules error: $e');
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = null; // Don't show error, just use fallback
        _fareRules = _getDefaultFareRules();
      });
    }
  }

  List<Map<String, dynamic>> _getDefaultFareRules() {
    return [
      {
        'icon': Icons.cancel_outlined,
        'title': 'Cancellation',
        'description': 'Cancellation charges may apply as per airline policy. Contact us for exact fees.',
      },
      {
        'icon': Icons.edit_calendar_outlined,
        'title': 'Date Changes',
        'description': 'Date change allowed with a fee per passenger. Subject to availability.',
      },
      {
        'icon': Icons.luggage_outlined,
        'title': 'Baggage',
        'description': 'Baggage allowance: ${widget.flight['baggage'] ?? '20kg'} checked baggage included. Carry-on: 7kg.',
      },
      {
        'icon': Icons.event_busy_outlined,
        'title': 'No Show',
        'description': 'No show penalty applies as per airline policy. Tickets may become non-refundable.',
      },
    ];
  }

  IconData _getRuleIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('cancel')) return Icons.cancel_outlined;
    if (lower.contains('change') || lower.contains('date')) return Icons.edit_calendar_outlined;
    if (lower.contains('baggage') || lower.contains('luggage')) return Icons.luggage_outlined;
    if (lower.contains('no show') || lower.contains('noshow')) return Icons.event_busy_outlined;
    if (lower.contains('refund')) return Icons.money_off_outlined;
    if (lower.contains('penalty')) return Icons.warning_outlined;
    return Icons.article_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Fare Rules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'Loading fare rules...',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _fareRules.length,
                  itemBuilder: (context, index) {
                    final rule = _fareRules[index];
                    final icon = rule['icon'] as IconData? ?? _getRuleIcon(rule['title'] ?? '');
                    return _FareRuleItem(
                      icon: icon,
                      title: rule['title'] ?? 'Rule',
                      description: rule['description'] ?? '',
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Section Card Widget
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
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
