import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankAccount {
  final String bankName;
  final String bankLogo;
  final String accountTitle;
  final String accountNumber;
  final String iban;
  final String branchName;
  final String branchCode;
  final String swiftCode;
  final int colorValue;

  const BankAccount({
    required this.bankName,
    required this.bankLogo,
    required this.accountTitle,
    required this.accountNumber,
    required this.iban,
    required this.branchName,
    required this.branchCode,
    required this.swiftCode,
    required this.colorValue,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankName: json['bankName'] ?? '',
      bankLogo: json['bankLogo'] ?? '',
      accountTitle: json['accountTitle'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      iban: json['iban'] ?? '',
      branchName: json['branchName'] ?? '',
      branchCode: json['branchCode'] ?? '',
      swiftCode: json['swiftCode'] ?? '',
      colorValue: json['colorValue'] ?? 0xFF1E3A5F,
    );
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
  BankNotifier() : super(const BankState()) {
    loadBankAccounts();
  }

  Future<void> loadBankAccounts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - will be replaced with API response
      final mockAccounts = [
        const BankAccount(
          bankName: 'Meezan Bank',
          bankLogo: 'MB',
          accountTitle: 'REHMAN TRAVELS (PVT) LTD',
          accountNumber: '0102-0107654321',
          iban: 'PK36MEZN0001020107654321',
          branchName: 'Gulshan-e-Iqbal Branch',
          branchCode: '0102',
          swiftCode: 'MEABOREE',
          colorValue: 0xFF00695C,
        ),
        const BankAccount(
          bankName: 'HBL',
          bankLogo: 'HBL',
          accountTitle: 'REHMAN TRAVELS (PVT) LTD',
          accountNumber: '1234-56789012-01',
          iban: 'PK52HABB0012345678901201',
          branchName: 'Karachi Main Branch',
          branchCode: '1234',
          swiftCode: 'HABOREE',
          colorValue: 0xFF006B3F,
        ),
        const BankAccount(
          bankName: 'UBL',
          bankLogo: 'UBL',
          accountTitle: 'REHMAN TRAVELS (PVT) LTD',
          accountNumber: '2587-145236987-1',
          iban: 'PK84UNIL0025871452369871',
          branchName: 'Clifton Branch',
          branchCode: '2587',
          swiftCode: 'UABOREE',
          colorValue: 0xFF1A237E,
        ),
        const BankAccount(
          bankName: 'Bank Alfalah',
          bankLogo: 'BA',
          accountTitle: 'REHMAN TRAVELS (PVT) LTD',
          accountNumber: '0055-1001234567',
          iban: 'PK22ALFH0055100123456700',
          branchName: 'Shahrah-e-Faisal Branch',
          branchCode: '0055',
          swiftCode: 'ALIBOREO',
          colorValue: 0xFFB71C1C,
        ),
        const BankAccount(
          bankName: 'MCB Bank',
          bankLogo: 'MCB',
          accountTitle: 'REHMAN TRAVELS (PVT) LTD',
          accountNumber: '0521-74521369-8',
          iban: 'PK67MUCB0052174521369800',
          branchName: 'PECHS Branch',
          branchCode: '0521',
          swiftCode: 'MUCCOREO',
          colorValue: 0xFF4A148C,
        ),
      ];

      state = state.copyWith(
        isLoading: false,
        accounts: mockAccounts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadBankAccounts();
  }
}

final bankProvider = StateNotifierProvider<BankNotifier, BankState>((ref) {
  return BankNotifier();
});
