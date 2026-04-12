import 'package:flutter/material.dart';
import '../models/price_models.dart';

/// Widget for displaying price breakdown
class PriceBreakdownCard extends StatelessWidget {
  final PriceBreakdown breakdown;

  const PriceBreakdownCard({
    Key? key,
    required this.breakdown,
  }) : super(key: key);

  String _formatPrice(double? price) {
    if (price == null) return 'N/A';
    return price.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final totals = breakdown.totals;
    final summary = breakdown.summary;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDADCE0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 16),
            // Hotels breakdown
            if (breakdown.breakdown.hotels != null) ...[
              _BreakdownSection(
                title: 'Hotels',
                amount: breakdown.breakdown.hotels!.totalPrice ?? 0,
              ),
              const SizedBox(height: 12),
            ],
            // Transport breakdown
            if (breakdown.breakdown.transport != null &&
                breakdown.breakdown.transport!.totalPrice != null &&
                breakdown.breakdown.transport!.totalPrice! > 0) ...[
              _BreakdownSection(
                title: 'Transport',
                amount: breakdown.breakdown.transport!.totalPrice ?? 0,
              ),
              const SizedBox(height: 12),
            ],
            // Visa breakdown
            if (breakdown.breakdown.visa != null &&
                breakdown.breakdown.visa!.totalPrice != null &&
                breakdown.breakdown.visa!.totalPrice! > 0) ...[
              _BreakdownSection(
                title: 'Visa',
                amount: breakdown.breakdown.visa!.totalPrice ?? 0,
              ),
              const SizedBox(height: 12),
            ],
            // Flight breakdown
            if (breakdown.breakdown.flight != null &&
                breakdown.breakdown.flight!.totalPrice != null &&
                breakdown.breakdown.flight!.totalPrice! > 0) ...[
              _BreakdownSection(
                title: 'Flight',
                amount: breakdown.breakdown.flight!.totalPrice ?? 0,
              ),
              const SizedBox(height: 12),
            ],
            // Divider
            const Divider(height: 24, color: Color(0xFFDADCE0)),
            // Total prices
            _PriceTotal(
              label: 'Total Price (SAR)',
              price: _formatPrice(totals?.sar),
              currency: '﷼',
              isHighlight: true,
            ),
            const SizedBox(height: 8),
            _PriceTotal(
              label: 'Total Price (USD)',
              price: _formatPrice(totals?.usd),
              currency: '\$',
            ),
            const SizedBox(height: 8),
            _PriceTotal(
              label: 'Total Price (GBP)',
              price: _formatPrice(totals?.gbp),
              currency: '£',
            ),
            // Without flight
            if (breakdown.totals?.withoutFlight != null) ...[
              const SizedBox(height: 16),
              const Divider(height: 0, color: Color(0xFFDADCE0)),
              const SizedBox(height: 16),
              Text(
                'Without Flight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _PriceTotal(
                label: 'SAR',
                price: _formatPrice(
                  breakdown.totals?.withoutFlight?.sar,
                ),
                currency: '﷼',
              ),
              const SizedBox(height: 8),
              _PriceTotal(
                label: 'USD',
                price: _formatPrice(
                  breakdown.totals?.withoutFlight?.usd,
                ),
                currency: '\$',
              ),
              const SizedBox(height: 8),
              _PriceTotal(
                label: 'GBP',
                price: _formatPrice(
                  breakdown.totals?.withoutFlight?.gbp,
                ),
                currency: '£',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BreakdownSection extends StatelessWidget {
  final String title;
  final double amount;

  const _BreakdownSection({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6368),
          ),
        ),
        Text(
          '﷼ ${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202124),
          ),
        ),
      ],
    );
  }
}

class _PriceTotal extends StatelessWidget {
  final String label;
  final String price;
  final String currency;
  final bool isHighlight;

  const _PriceTotal({
    Key? key,
    required this.label,
    required this.price,
    required this.currency,
    this.isHighlight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: isHighlight
          ? BoxDecoration(
              color: const Color(0xFF1a73e8).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Padding(
        padding: isHighlight
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
                color: isHighlight
                    ? const Color(0xFF1a73e8)
                    : const Color(0xFF5F6368),
              ),
            ),
            Text(
              '$currency $price',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
                color: isHighlight
                    ? const Color(0xFF1a73e8)
                    : const Color(0xFF202124),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
