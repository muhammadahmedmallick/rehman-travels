import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_back_button.dart';
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
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final isRoundTrip = returnLeg != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sliver App Bar with Flight Route
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: AppBackButton(),
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs + 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    _getAirlineLogo(airlineCode),
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Center(
                      child: Text(
                        airlineCode,
                        style: AppTextStyles.labelSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                AppGap.hSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        airlineName,
                        style: AppTextStyles.titleSm.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${flight['flightNumber'] ?? ''} · ${isRoundTrip ? '$departureCode ⇄ $arrivalCode' : '$departureCode → $arrivalCode'}',
                        style: AppTextStyles.hint.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                AppGap.md,


                // Outbound Flight Details
                _SectionCard(
                  title: isRoundTrip ? 'Departure Flight' : 'Flight Details',
                  icon: Icons.flight_takeoff_outlined,
                  children: [
                    _FlightRouteWidget(
                      departureCode: departureCode,
                      arrivalCode: arrivalCode,
                      departureTime: flight['departureTime'] ?? '--:--',
                      arrivalTime: flight['arrivalTime'] ?? '--:--',
                      duration: flight['duration'] ?? '--',
                      stops: flight['stops'] ?? 0,
                    ),
                    AppGap.md,
                    _DetailRow(label: 'Aircraft', value: flight['aircraft'] ?? 'Boeing 737'),
                    _DetailRow(label: 'Class', value: flight['cabin'] ?? 'Economy'),
                    _DetailRow(
                      label: 'Baggage',
                      value: flight['baggage'] ?? '30kg',
                      icon: Icons.luggage_outlined,
                    ),
                  ],
                ),

                // Return Flight Details (if round-trip)
                if (isRoundTrip)
                  _SectionCard(
                    title: 'Return Flight',
                    icon: Icons.flight_land_outlined,
                    children: [
                      _FlightRouteWidget(
                        departureCode: returnLeg['departureCode'] ?? '',
                        arrivalCode: returnLeg['arrivalCode'] ?? '',
                        departureTime: returnLeg['departureTime'] ?? '--:--',
                        arrivalTime: returnLeg['arrivalTime'] ?? '--:--',
                        duration: returnLeg['duration'] ?? '--',
                        stops: returnLeg['stops'] ?? 0,
                      ),
                      AppGap.md,
                      _DetailRow(label: 'Flight', value: returnLeg['flightNumber'] ?? '--'),
                      _DetailRow(
                        label: 'Baggage',
                        value: returnLeg['baggage'] ?? flight['baggage'] ?? '30kg',
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
                  padding: AppPadding.screenH,
                  child: OutlinedButton(
                    onPressed: () => _showFareRules(context, flight),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.description_outlined, size: AppIconSize.lg),
                        AppGap.hSm,
                        const Text('View Fare Rules'),
                      ],
                    ),
                  ),
                ),

                AppGap.md,

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
                      'PKR ${_formatPrice(price)}',
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          children: [
            AppGap.sm,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: AppPadding.screenHLg.copyWith(top: AppSpacing.lg, bottom: AppSpacing.lg),
              child: Row(
                children: [
                  Text(
                    'Fare Rules',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primary),
                      AppGap.md,
                      Text(
                        'Loading fare rules...',
                        style: AppTextStyles.bodyLg.copyWith(
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
                      AppGap.md,
                      Text(
                        _error!,
                        style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
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
