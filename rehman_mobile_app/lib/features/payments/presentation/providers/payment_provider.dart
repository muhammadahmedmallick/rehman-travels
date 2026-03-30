import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';

// --- Models ---

class Payment {
  final int id;
  final int agentId;
  final String refNumber;
  final String depositAccount;
  final String createdBy;
  final String createdDateTime;
  final String? approvedBy;
  final String? approvedDateTime;
  final String paymentType;
  final double creditLimit;
  final double currentCreditLimit;
  final String depositDate;
  final double depositAmount;
  final String? attachment;
  final String details;
  final String paymentStatus;
  final String transactionType;

  const Payment({
    required this.id,
    required this.agentId,
    required this.refNumber,
    required this.depositAccount,
    required this.createdBy,
    required this.createdDateTime,
    this.approvedBy,
    this.approvedDateTime,
    required this.paymentType,
    required this.creditLimit,
    required this.currentCreditLimit,
    required this.depositDate,
    required this.depositAmount,
    this.attachment,
    required this.details,
    required this.paymentStatus,
    required this.transactionType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      agentId: json['agentid'] ?? 0,
      refNumber: json['refnumber'] ?? '',
      depositAccount: json['depositaccount'] ?? '',
      createdBy: json['createdby'] ?? '',
      createdDateTime: json['createddatetime'] ?? '',
      approvedBy: json['approvedby'],
      approvedDateTime: json['approveddatetime'],
      paymentType: json['paymenttype'] ?? '',
      creditLimit: (json['creditlimit'] ?? 0).toDouble(),
      currentCreditLimit: (json['currentcreditlimit'] ?? 0).toDouble(),
      depositDate: json['depositdate'] ?? '',
      depositAmount: (json['depositamount'] ?? 0).toDouble(),
      attachment: json['attachment'],
      details: json['details'] ?? '',
      paymentStatus: json['paymentstatus'] ?? '',
      transactionType: json['transactiontype'] ?? '',
    );
  }

  bool get isApproved => paymentStatus == 'approved';
  bool get isDebit => depositAmount < 0;
  String get formattedAmount {
    final abs = depositAmount.abs();
    final formatted = abs.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return isDebit ? '-PKR $formatted' : 'PKR $formatted';
  }
}

class MarkupMarkdown {
  final int id;
  final String title;
  final String itineraryType;
  final String fareType;
  final String serviceFeeType;
  final String passengerType;
  final String serviceType;
  final String markupType;
  final double serviceFee;
  final String airlineType;

  const MarkupMarkdown({
    required this.id,
    required this.title,
    required this.itineraryType,
    required this.fareType,
    required this.serviceFeeType,
    required this.passengerType,
    required this.serviceType,
    required this.markupType,
    required this.serviceFee,
    required this.airlineType,
  });

  factory MarkupMarkdown.fromJson(Map<String, dynamic> json) {
    return MarkupMarkdown(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      itineraryType: json['itinerarytype'] ?? '',
      fareType: json['faretype'] ?? '',
      serviceFeeType: json['servicefeetype'] ?? '',
      passengerType: json['passengertype'] ?? '',
      serviceType: json['servicetype'] ?? '',
      markupType: json['markuptype'] ?? '',
      serviceFee: (json['servicefee'] ?? 0).toDouble(),
      airlineType: json['airlinetype'] ?? '',
    );
  }
}

// --- States ---

class PaymentState {
  final bool isLoading;
  final List<Payment> payments;
  final String? error;

  const PaymentState({
    this.isLoading = false,
    this.payments = const [],
    this.error,
  });

  PaymentState copyWith({
    bool? isLoading,
    List<Payment>? payments,
    String? error,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      payments: payments ?? this.payments,
      error: error,
    );
  }
}

class MarkupState {
  final bool isLoading;
  final List<MarkupMarkdown> markups;
  final String? error;

  const MarkupState({
    this.isLoading = false,
    this.markups = const [],
    this.error,
  });

  MarkupState copyWith({
    bool? isLoading,
    List<MarkupMarkdown>? markups,
    String? error,
  }) {
    return MarkupState(
      isLoading: isLoading ?? this.isLoading,
      markups: markups ?? this.markups,
      error: error,
    );
  }
}

// --- Notifiers ---

class PaymentNotifier extends StateNotifier<PaymentState> {
  final CoreApiClient _apiClient;

  PaymentNotifier(this._apiClient) : super(const PaymentState());

  Future<void> loadPayments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(ApiEndpoints.payments);
      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];
        final payments = results
            .map<Payment>((item) => Payment.fromJson(item))
            .toList();
        state = state.copyWith(isLoading: false, payments: payments);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load payments',
        );
      }
    } catch (e) {
      if (kDebugMode) print('Payments API error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to load payments. Please check your connection.',
      );
    }
  }

  Future<void> createPayment({
    required String paymentMethod,
    required double amount,
    String currency = 'PKR',
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.post(
        ApiEndpoints.payments,
        data: {
          'paymentMethod': paymentMethod,
          'amount': amount,
          'currency': currency,
          if (description != null) 'description': description,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await loadPayments(); // Refresh the list
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create payment',
        );
      }
    } catch (e) {
      if (kDebugMode) print('Create payment error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create payment.',
      );
    }
  }

  Future<void> refresh() async {
    await loadPayments();
  }
}

class MarkupNotifier extends StateNotifier<MarkupState> {
  final CoreApiClient _apiClient;

  MarkupNotifier(this._apiClient) : super(const MarkupState()) {
    loadMarkups();
  }

  Future<void> loadMarkups() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(ApiEndpoints.markupAndMarkdowns);
      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];
        final markups = results
            .map<MarkupMarkdown>((item) => MarkupMarkdown.fromJson(item))
            .toList();
        state = state.copyWith(isLoading: false, markups: markups);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load markup data',
        );
      }
    } catch (e) {
      if (kDebugMode) print('Markup API error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to load markup data.',
      );
    }
  }

  Future<void> refresh() async {
    await loadMarkups();
  }
}

// --- Providers ---

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref.watch(coreApiClientProvider));
});

final markupProvider = StateNotifierProvider<MarkupNotifier, MarkupState>((ref) {
  return MarkupNotifier(ref.watch(coreApiClientProvider));
});
