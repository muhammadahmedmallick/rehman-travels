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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 1),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                code,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
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
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).padding.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, bottom > 0 ? bottom : 12),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.55),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 10),
              Container(width: 32, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text('Select Currency', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: currencyState.currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencyState.currencies[index];
                    final isSelected = currencyState.selected?.currencyCode == currency.currencyCode;
                    return InkWell(
                      onTap: () {
                        ref.read(currencyProvider.notifier).selectCurrency(currency);
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : const Color(0xFFF5F6FA),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(child: Text(currency.flagEmoji, style: const TextStyle(fontSize: 22))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(currency.currencyName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text('${currency.currencyCode} (${currency.currencySymbol})', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                          ])),
                          if (currency.currencyRate > 0)
                            Text('${currency.currencyRate.toStringAsFixed(2)} PKR', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                          const SizedBox(width: 10),
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB), width: isSelected ? 0 : 1.5),
                            ),
                            child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        );
      },
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
