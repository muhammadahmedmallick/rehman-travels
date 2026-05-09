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

  /// Optional airline name shown as the row prefix, e.g.
  /// `Emirates (Adult x 2)` — matches the sastaticket layout. When
  /// null/empty the row falls back to just `Adult x 2`.
  final String? airlineName;

  const PriceBreakdownCard({
    super.key,
    required this.breakdown,
    required this.currency,
    this.extraRows = const [],
    this.withChrome = true,
    this.title = 'Price Details',
    this.airlineName,
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

        // One row per individual passenger — `Etihad Airways (Adult 1)`,
        // `Etihad Airways (Adult 2)`, etc. — so the breakdown reflects
        // the exact number of travellers paying.
        for (int i = 0; i < adults; i++)
          _paxRow('Adult', i + 1, adults, adultFare, currency),
        for (int i = 0; i < children; i++)
          _paxRow('Child', i + 1, children, childFare, currency),
        for (int i = 0; i < infants; i++)
          _paxRow('Infant', i + 1, infants, infantFare, currency),

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

  /// One row per individual passenger:
  /// `Etihad Airways (Adult 1) ............ PKR 944,946`
  /// `Etihad Airways (Adult 2) ............ PKR 944,946`
  /// When there's only one passenger of that type the index is dropped:
  /// `Etihad Airways (Child) ............ PKR 855,206`.
  Widget _paxRow(
      String type, int index, int total, double perPaxFare, Currency? c) {
    final airline = (airlineName ?? '').trim();
    final typeLabel = total > 1 ? '$type $index' : type;
    final label = airline.isNotEmpty ? '$airline ($typeLabel)' : typeLabel;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatCurrencyPrice(perPaxFare, c),
            style: const TextStyle(
              fontSize: 13.5,
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
