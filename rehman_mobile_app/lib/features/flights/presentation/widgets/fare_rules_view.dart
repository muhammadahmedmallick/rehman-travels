import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../providers/flight_search_provider.dart';

/// Auto-loads and renders the fare rules for a flight.
///
/// Used both inside the flight details screen and as a bottom sheet
/// from the results card so the user can see fare rules without
/// leaving the list.
class FareRulesView extends ConsumerStatefulWidget {
  final Map<String, dynamic> flight;

  /// When true, the widget renders without an outer card chrome
  /// (used inside the bottom sheet which already has its own padding).
  final bool flat;

  const FareRulesView({
    super.key,
    required this.flight,
    this.flat = false,
  });

  @override
  ConsumerState<FareRulesView> createState() => _FareRulesViewState();
}

class _FareRulesViewState extends ConsumerState<FareRulesView> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _fareRules = const [];

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
      if (mounted) {
        setState(() {
          _isLoading = false;
          _fareRules = _defaults();
        });
      }
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
                  'description': r['text'] ?? r['description'] ?? r['rules'] ?? '',
                };
              }
              return {'title': 'Rule', 'description': r.toString()};
            }).toList();
          });
          return;
        }
      }
      setState(() {
        _isLoading = false;
        _fareRules = _defaults();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _fareRules = _defaults();
      });
    }
  }

  List<Map<String, dynamic>> _defaults() => [
        {
          'icon': Icons.cancel_outlined,
          'title': 'Cancellation',
          'description': 'Charges may apply as per airline policy.',
        },
        {
          'icon': Icons.edit_calendar_outlined,
          'title': 'Date Changes',
          'description': 'Date change allowed with a fee. Subject to availability.',
        },
        {
          'icon': Icons.luggage_outlined,
          'title': 'Baggage',
          'description':
              '${widget.flight['baggage'] ?? '20kg'} checked baggage included.',
        },
        {
          'icon': Icons.event_busy_outlined,
          'title': 'No Show',
          'description': 'No show penalty applies. Tickets may become non-refundable.',
        },
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

  Widget _ruleCard({
    required IconData icon,
    required Color accent,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accent.withValues(alpha: 0.25), width: 0.5),
            ),
            child: Icon(icon, size: 20, color: accent),
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
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
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

  /// Semantic accent color per rule category.
  Color _accent(String title) {
    final l = title.toLowerCase();
    if (l.contains('cancel')) return AppColors.error;
    if (l.contains('change') || l.contains('date')) return AppColors.info;
    if (l.contains('baggage')) return AppColors.success;
    if (l.contains('no show')) return AppColors.warning;
    if (l.contains('refund')) return AppColors.secondary;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.flat) ...[
          const Text(
            'Fare Rules',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (_isLoading)
          for (int i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80, height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity, height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
        else
          for (final rule in _fareRules) ...[
            _ruleCard(
              icon: rule['icon'] as IconData? ?? _icon(rule['title']?.toString() ?? ''),
              accent: _accent(rule['title']?.toString() ?? ''),
              title: rule['title']?.toString() ?? '',
              description: rule['description']?.toString() ?? '',
            ),
            const SizedBox(height: 10),
          ],
      ],
    );

    if (widget.flat) return body;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.soft,
      ),
      child: body,
    );
  }
}

/// Opens [FareRulesView] in a draggable bottom sheet so the user can
/// inspect a flight's fare rules without leaving the results list.
Future<void> showFareRulesSheet(
  BuildContext context,
  Map<String, dynamic> flight,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(),
                _SheetHeader(flight: flight, onClose: () => Navigator.of(ctx).pop()),
                const Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FareRulesView(flight: flight, flat: true),
                        const SizedBox(height: 14),
                        _SheetFooterNote(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Center(
        child: Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final Map<String, dynamic> flight;
  final VoidCallback onClose;
  const _SheetHeader({required this.flight, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final airline = (flight['airlineName'] ?? 'Airline').toString();
    final depCode = (flight['departureCode'] ?? '').toString();
    final arrCode = (flight['arrivalCode'] ?? '').toString();
    final isRefundable = flight['isRefundable'] == true;
    final hasReturn = flight['returnLeg'] != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.gavel_outlined,
                    size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Fare Rules',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 22),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: Text(
                  '$airline  ·  $depCode ${hasReturn ? '⇄' : '→'} $arrCode',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isRefundable ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: (isRefundable ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  isRefundable ? 'Refundable' : 'Non-refundable',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isRefundable ? AppColors.success : AppColors.error,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetFooterNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'These rules summarize the airline\'s fare conditions. '
              'Final terms apply at the time of booking and are subject to change.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
