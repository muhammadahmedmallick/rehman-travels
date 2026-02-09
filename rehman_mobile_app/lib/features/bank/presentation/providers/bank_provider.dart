import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';

class BankAccount {
  final int id;
  final String bankName;
  final String bankLogo;
  final String accountTitle;
  final String accountNumber;
  final String iban;
  final String branchCode;
  final String swiftCode;
  final String contactNo;
  final int colorValue;

  const BankAccount({
    required this.id,
    required this.bankName,
    required this.bankLogo,
    required this.accountTitle,
    required this.accountNumber,
    required this.iban,
    required this.branchCode,
    required this.swiftCode,
    required this.contactNo,
    required this.colorValue,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    final bankName = json['bankname'] ?? '';
    return BankAccount(
      id: json['id'] ?? 0,
      bankName: bankName,
      bankLogo: _generateLogo(bankName),
      accountTitle: json['accounttitle'] ?? '',
      accountNumber: json['accountno'] ?? '',
      iban: json['ibanno'] ?? '',
      branchCode: json['branchcode'] ?? '',
      swiftCode: json['swiftcode'] ?? '',
      contactNo: json['contactno'] ?? '',
      colorValue: _assignColor(bankName),
    );
  }

  static String _generateLogo(String bankName) {
    final lower = bankName.toLowerCase();
    if (lower.contains('meezan')) return 'MB';
    if (lower.contains('silk')) return 'SB';
    if (lower.contains('hbl') || lower.contains('habib')) return 'HBL';
    if (lower.contains('ubl') || lower.contains('united')) return 'UBL';
    if (lower.contains('alfalah')) return 'BA';
    if (lower.contains('mcb')) return 'MCB';
    if (lower.contains('allied')) return 'ABL';
    if (lower.contains('faysal')) return 'FBL';
    if (lower.contains('askari')) return 'AKB';
    final words = bankName.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return bankName.isNotEmpty ? bankName[0].toUpperCase() : '?';
  }

  static int _assignColor(String bankName) {
    final lower = bankName.toLowerCase();
    if (lower.contains('meezan')) return 0xFF00695C;
    if (lower.contains('silk')) return 0xFF6A1B9A;
    if (lower.contains('hbl') || lower.contains('habib')) return 0xFF006B3F;
    if (lower.contains('ubl') || lower.contains('united')) return 0xFF1A237E;
    if (lower.contains('alfalah')) return 0xFFB71C1C;
    if (lower.contains('mcb')) return 0xFF4A148C;
    if (lower.contains('allied')) return 0xFF0D47A1;
    if (lower.contains('faysal')) return 0xFF1B5E20;
    if (lower.contains('askari')) return 0xFF880E4F;
    return 0xFF1E3A5F;
  }
}

class BankState {
  final bool isLoading;
  final List<BankAccount> accounts;
  final String? error;

  const BankState({
    this.isLoading = false,
    this.accounts = const [],
    this.error,
  });

  BankState copyWith({
    bool? isLoading,
    List<BankAccount>? accounts,
    String? error,
  }) {
    return BankState(
      isLoading: isLoading ?? this.isLoading,
      accounts: accounts ?? this.accounts,
      error: error,
    );
  }
}

class BankNotifier extends StateNotifier<BankState> {
  final CoreApiClient _apiClient;

  BankNotifier(this._apiClient) : super(const BankState()) {
    loadBankAccounts();
  }

  Future<void> loadBankAccounts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(ApiEndpoints.bankDetails);
     
      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];

        final accounts = results
            .where((item) => item['bankstatus'] == '1')
            .map<BankAccount>((item) => BankAccount.fromJson(item))
            .toList();

        state = state.copyWith(
          isLoading: false,
          accounts: accounts,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load bank details',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Bank details API error: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to load bank details. Please check your internet connection.',
      );
    }
  }

  Future<void> refresh() async {
    await loadBankAccounts();
  }
}

final bankProvider = StateNotifierProvider<BankNotifier, BankState>((ref) {
  return BankNotifier(ref.watch(coreApiClientProvider));
});
