import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currency {
  final String code;
  final String symbol;
  final String name;
  final String flag;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.flag,
  });
}

const availableCurrencies = [
  Currency(code: 'PKR', symbol: 'Rs', name: 'Pakistani Rupee', flag: '🇵🇰'),
  Currency(code: 'USD', symbol: '\$', name: 'US Dollar', flag: '🇺🇸'),
  Currency(code: 'EUR', symbol: '€', name: 'Euro', flag: '🇪🇺'),
  Currency(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham', flag: '🇦🇪'),
  Currency(code: 'SAR', symbol: 'ر.س', name: 'Saudi Riyal', flag: '🇸🇦'),
  Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', flag: '🇨🇳'),
];

class CurrencyNotifier extends StateNotifier<Currency> {
  static const _key = 'selected_currency';

  CurrencyNotifier() : super(availableCurrencies.first) {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      final currency = availableCurrencies.firstWhere(
        (c) => c.code == code,
        orElse: () => availableCurrencies.first,
      );
      state = currency;
    }
  }

  Future<void> setCurrency(Currency currency) async {
    state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, currency.code);
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, Currency>((ref) {
  return CurrencyNotifier();
});
