import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../currency/presentation/providers/currency_provider.dart';

/// Reusable, app-wide price breakdown card.
///
/// Takes a `breakdown` map (the shape returned by
/// `computeFareBreakdown(...).toMap()` — i.e. with `adults`, `children`,
/// `infants`, `adultFare`, `childFare`, `infantFare`, `subtotal`,
/// `taxes`, `total`) and renders the same card used on the flight
/// details screen:
///   • Icon + title + "Fare details for N passengers" header
///   • Per-pax rows (Adult 1, Adult 2 … Child 1 … Infant 1)
///   • Dashed divider
///   • Sub-total + Taxes
///   • Hairline divider
///   • Total in large golden w900
///
/// Use on: flight details, booking review sheet, payment sheet — so the
/// fare breakdown is identical across the booking journey.
class PriceBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> breakdown;
  final Currency? currency;

  /// Extra rows appended between "Taxes & Fees" and the total — e.g.
  /// `[ ('Convenience Fee', 2110) ]` on the payment sheet.
  final List<MapEntry<String, double>> extraRows;

  /// If false, the outer white card chrome is dropped (useful when
  /// embedding inside another card / sheet that already has chrome).
  final bool withChrome;

  /// Override the default "Price Breakdown" title.
  final String title;

  const PriceBreakdownCard({
    super.key,
    required this.breakdown,
    required this.currency,
    this.extraRows = const [],
    this.withChrome = true,
    this.title = 'Price Breakdown',
  });

  @override
  Widget build(BuildContext context) {
    final adults = breakdown['adults'] as int? ?? 0;
    final children = breakdown['children'] as int? ?? 0;
    final infants = breakdown['infants'] as int? ?? 0;
    final adultFare = (breakdown['adultFare'] as num?)?.toDouble() ?? 0;
    final childFare = (breakdown['childFare'] as num?)?.toDouble() ?? 0;
    final infantFare = (breakdown['infantFare'] as num?)?.toDouble() ?? 0;
    final subtotal = (breakdown['subtotal'] as num?)?.toDouble() ??
        (adultFare * adults + childFare * children + infantFare * infants);
    final taxes = (breakdown['taxes'] as num?)?.toDouble() ?? 0;
    final extrasSum = extraRows.fold<double>(0, (s, r) => s + r.value);
    final baseTotal = (breakdown['total'] as num?)?.toDouble() ?? 0;
    final total = baseTotal + extrasSum;
    final paxTotal = adults + children + infants;

    final inner = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.16),
                    AppColors.secondary.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  size: 18, color: AppColors.secondary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  if (paxTotal > 0)
                    Text(
                      'Fare details for $paxTotal ${paxTotal == 1 ? 'passenger' : 'passengers'}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Per-passenger lines
        ..._paxLines('Adult', adults, adultFare, currency),
        ..._paxLines('Child', children, childFare, currency),
        ..._paxLines('Infant', infants, infantFare, currency),

        // Dashed divider
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _DashedLinePainter(color: AppColors.border),
          ),
        ),

        // Sub-total + Taxes
        _meta('Sub-total', formatCurrencyPrice(subtotal, currency)),
        const SizedBox(height: 6),
        _meta('Taxes & Fees', formatCurrencyPrice(taxes, currency)),

        // Any extra rows (e.g. Convenience Fee)
        for (final r in extraRows) ...[
          const SizedBox(height: 6),
          _meta(r.key, formatCurrencyPrice(r.value, currency)),
        ],

        const Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Divider(height: 1, thickness: 1, color: AppColors.border),
        ),

        // Total
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const Spacer(),
            Text(
              formatCurrencyPrice(total, currency),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.secondary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ],
    );

    if (!withChrome) return inner;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: inner,
    );
  }

  List<Widget> _paxLines(
      String type, int count, double fare, Currency? c) {
    if (count <= 0) return const [];
    if (count == 1) {
      return [_paxLine(type, formatCurrencyPrice(fare, c))];
    }
    return List.generate(count, (i) {
      return _paxLine('$type ${i + 1}', formatCurrencyPrice(fare, c));
    });
  }

  Widget _paxLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 4.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) => old.color != color;
}
