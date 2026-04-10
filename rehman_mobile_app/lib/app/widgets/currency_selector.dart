import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../../features/currency/presentation/providers/currency_provider.dart';

/// Compact currency selector button + bottom sheet picker.
/// Reusable across all screens.
class CurrencySelector extends ConsumerWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyState = ref.watch(currencyProvider);
    final selected = currencyState.selected;
    final code = selected?.currencyCode ?? 'PKR';
    final flag = selected?.flagEmoji ?? '🇵🇰';

    return GestureDetector(
      onTap: () => _showPicker(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              code,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref) {
    final currencyState = ref.read(currencyProvider);
    if (currencyState.isLoading) return;
    if (currencyState.currencies.isEmpty) {
      ref.read(currencyProvider.notifier).refresh();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CurrencyBottomSheet(
        currencies: currencyState.currencies,
        selected: currencyState.selected,
        onSelect: (currency) {
          ref.read(currencyProvider.notifier).selectCurrency(currency);
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

/// Currency picker bottom sheet – extracted for reuse.
class CurrencyBottomSheet extends StatelessWidget {
  final List<Currency> currencies;
  final Currency? selected;
  final ValueChanged<Currency> onSelect;

  const CurrencyBottomSheet({
    super.key,
    required this.currencies,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Icon(Icons.currency_exchange, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text('Select Currency', style: AppTextStyles.titleLg),
            ]),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = selected?.currencyCode == currency.currencyCode;
                return InkWell(
                  onTap: () => onSelect(currency),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.transparent,
                    child: Row(children: [
                      Text(currency.flagEmoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(currency.currencyName, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: AppColors.textPrimary)),
                        const SizedBox(height: 1),
                        Text('${currency.currencyCode} (${currency.currencySymbol})', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ])),
                      if (currency.currencyRate > 0)
                        Text('${currency.currencyRate.toStringAsFixed(2)} PKR', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                      const SizedBox(width: 8),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                      else
                        Icon(Icons.circle_outlined, color: AppColors.textHint, size: 20),
                    ]),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}

/// Helper to convert PKR price to selected currency.
/// Returns formatted string like "USD 54.20" or "PKR 15,000".
String formatCurrencyPrice(double pkrPrice, Currency? currency) {
  if (currency == null || currency.currencyCode == 'PKR' || currency.currencyRate <= 0) {
    return 'PKR ${_formatNum(pkrPrice)}';
  }
  final converted = pkrPrice / currency.currencyRate;
  return '${currency.currencyCode} ${_formatNum(converted)}';
}

String _formatNum(double value) {
  if (value >= 1000) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
  return value.toStringAsFixed(2);
}
