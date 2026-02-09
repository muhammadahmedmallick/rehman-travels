import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';

class Currency {
  final int id;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  final String countryName;
  final String countryCode;
  final double currencyRate;
  final String currencyFlag;

  const Currency({
    required this.id,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.countryName,
    required this.countryCode,
    required this.currencyRate,
    required this.currencyFlag,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] ?? 0,
      currencyName: json['currencyname'] ?? '',
      currencyCode: json['currencycode'] ?? '',
      currencySymbol: json['currencysymbol'] ?? '',
      countryName: json['countryname'] ?? '',
      countryCode: json['countrycode'] ?? '',
      currencyRate: (json['currencyrate'] ?? 0).toDouble(),
      currencyFlag: json['currencyflag'] ?? '',
    );
  }

  String get flagEmoji {
    switch (currencyCode) {
      case 'PKR':
        return '🇵🇰';
      case 'USD':
        return '🇺🇸';
      case 'EUR':
        return '🇪🇺';
      case 'GBP':
        return '🇬🇧';
      case 'AED':
        return '🇦🇪';
      case 'SAR':
        return '🇸🇦';
      default:
        return '💱';
    }
  }
}

class CurrencyState {
  final bool isLoading;
  final List<Currency> currencies;
  final Currency? selected;
  final String? error;

  const CurrencyState({
    this.isLoading = false,
    this.currencies = const [],
    this.selected,
    this.error,
  });

  CurrencyState copyWith({
    bool? isLoading,
    List<Currency>? currencies,
    Currency? selected,
    String? error,
  }) {
    return CurrencyState(
      isLoading: isLoading ?? this.isLoading,
      currencies: currencies ?? this.currencies,
      selected: selected ?? this.selected,
      error: error,
    );
  }
}

const _prefKey = 'selected_currency_code';

class CurrencyNotifier extends StateNotifier<CurrencyState> {
  final CoreApiClient _apiClient;

  CurrencyNotifier(this._apiClient) : super(const CurrencyState()) {
    _init();
  }

  Future<void> _init() async {
    await loadCurrencies();
  }

  Future<void> loadCurrencies() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(ApiEndpoints.currencies);

      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];

        final currencies = results
            .where((item) =>
                item['status'] == 'published' &&
                item['currencycode'] != 'DEF')
            .map<Currency>((item) => Currency.fromJson(item))
            .toList();

        // Load saved preference
        final prefs = await SharedPreferences.getInstance();
        final savedCode = prefs.getString(_prefKey) ?? 'PKR';

        final selected = currencies.firstWhere(
          (c) => c.currencyCode == savedCode,
          orElse: () => currencies.firstWhere(
            (c) => c.currencyCode == 'PKR',
            orElse: () => currencies.first,
          ),
        );

        state = state.copyWith(
          isLoading: false,
          currencies: currencies,
          selected: selected,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load currencies',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Currency API error: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to load currencies.',
      );
    }
  }

  Future<void> selectCurrency(Currency currency) async {
    state = state.copyWith(selected: currency);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, currency.currencyCode);
  }

  Future<void> refresh() async {
    await loadCurrencies();
  }
}

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, CurrencyState>((ref) {
  return CurrencyNotifier(ref.watch(coreApiClientProvider));
});
