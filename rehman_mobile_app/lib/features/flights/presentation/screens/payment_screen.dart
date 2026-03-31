import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../providers/flight_search_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentScreen({super.key, required this.bookingData});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedMethod = '';
  bool _isProcessing = false;

  Map<String, dynamic> get booking => widget.bookingData;
  String get pnr => booking['pnr']?.toString() ?? booking['itineraryRef']?.toString() ?? '';
  String get reference => booking['reference']?.toString() ?? pnr;
  String get echoToken => booking['echoToken']?.toString() ?? pnr;
  String get airType => booking['airType']?.toString() ?? booking['provider']?.toString() ?? '';
  String get vCarrier {
    final vc = booking['vCarrier']?.toString() ?? '';
    if (vc.isNotEmpty) return vc;
    // Fallback: get airlineCode from flightData
    final flightData = booking['flightData'] as Map<String, dynamic>?;
    return flightData?['airlineCode']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Payment', style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
        leading: AppBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking confirmed banner
            Container(
              width: double.infinity,
              padding: AppPadding.cardLg,
              color: AppColors.success.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: AppIconSize.xl),
                  AppGap.hMd,
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Booking Confirmed · PNR: $pnr', style: AppTextStyles.titleSm.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
                  ])),
                ],
              ),
            ),

            AppGap.md,

            // Booking summary
            _buildBookingSummary(),

            AppGap.lg,

            // Payment Options
            Padding(
              padding: AppPadding.screenH,
              child: Text('Select Payment Method', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
            ),
            AppGap.sm,

            _buildPaymentOption(
              id: 'alfalah',
              icon: Icons.credit_card,
              title: 'Debit / Credit Card',
              subtitle: 'Pay securely via Bank Alfalah',
            ),
            _buildPaymentOption(
              id: 'bank_transfer',
              icon: Icons.account_balance,
              title: 'Pay Via Online Bank',
              subtitle: 'Transfer from your bank account',
            ),
            _buildPaymentOption(
              id: 'cash',
              icon: Icons.storefront,
              title: 'Cash In Office',
              subtitle: 'Pay at our branch locations',
            ),

            AppGap.lg,

            // Security badge
            Padding(
              padding: AppPadding.screenH,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline, size: AppIconSize.sm, color: AppColors.textHint),
                AppGap.hXs,
                Text('SSL Secured · We do not store your payment details', style: AppTextStyles.hint),
              ]),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _selectedMethod.isNotEmpty
          ? Container(
              padding: AppPadding.cardLg,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: SafeArea(child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                child: _isProcessing
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_getButtonText()),
              )),
            )
          : null,
    );
  }

  Widget _buildBookingSummary() {
    final flightData = booking['flightData'] as Map<String, dynamic>? ?? {};
    final passengers = booking['passengers'] as List? ?? [];

    return Padding(
      padding: AppPadding.screenH,
      child: Container(
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (passengers.isNotEmpty) ...[
            Row(children: [
              Icon(Icons.people_outline, size: AppIconSize.lg, color: AppColors.primary),
              AppGap.hSm,
              Text('Passengers', style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w700)),
            ]),
            AppGap.sm,
            ...passengers.map((p) {
              final pax = p as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${pax['nameTitle'] ?? pax['title'] ?? ''} ${pax['firstName'] ?? ''} ${pax['lastName'] ?? ''} (${pax['type'] ?? ''})', style: AppTextStyles.bodyMd),
              );
            }),
            AppGap.md,
          ],
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Amount to Pay', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
            Text('PKR ${_formatPrice(flightData['price'] ?? booking['totalPrice'] ?? 0)}', style: AppTextStyles.priceLg),
          ]),
        ]),
      ),
    );
  }

  Widget _buildPaymentOption({required String id, required IconData icon, required String title, required String subtitle}) {
    final isSelected = _selectedMethod == id;
    return Padding(
      padding: AppPadding.screenH.copyWith(top: 0, bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = id),
        child: Container(
          padding: AppPadding.cardLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
          ),
          child: Row(children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? AppColors.primary : AppColors.textHint, width: 2)),
              child: isSelected ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary))) : null,
            ),
            AppGap.hMd,
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Icon(icon, size: AppIconSize.lg, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            ),
            AppGap.hMd,
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: AppTextStyles.hint),
            ])),
          ]),
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (_selectedMethod) {
      case 'alfalah': return 'Pay with Card';
      case 'bank_transfer': return 'Pay via Bank Transfer';
      case 'cash': return 'Confirm Cash Payment';
      default: return 'Continue';
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      final apiClient = ref.read(apiClientProvider);

      if (_selectedMethod == 'alfalah') {
        // Card payment - call Alfalah API to get payment URL
        final response = await apiClient.postWithHeader(
          '/payonline/cheapest-fare-order-alfalah-pay-online-request',
          data: {
            'airType': airType,
            'vCarrier': vCarrier,
            'itineraryRef': pnr,
            'reference': reference,
            'echoToken': echoToken,
          },
          extraHeaders: {'Action-Type': 'AlfalahPay'},
        );

        if (!mounted) return;

        final data = response.data;
        if (data is Map<String, dynamic> && data['payUrl'] != null) {
          setState(() => _isProcessing = false);
          final url = Uri.parse(data['payUrl']);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        } else {
          if (!mounted) return;
          setState(() => _isProcessing = false);
          _goToTicketScreen();
        }
      } else {
        // Bank Transfer or Cash
        String endpoint;
        if (_selectedMethod == 'bank_transfer') {
          endpoint = '/viaonline/cheapest-fare-order-pay-via-online-bank-request';
        } else {
          endpoint = '/cash/cheapest-fare-order-pay-cash-request';
        }

        // Process payment (non-blocking)
        try {
          await apiClient.postWithHeader(
            endpoint,
            data: {
              'airType': airType,
              'vCarrier': vCarrier,
              'itineraryRef': pnr,
              'reference': reference,
              'echoToken': echoToken,
            },
            extraHeaders: {'Action-Type': 'Create'},
          );
        } catch (e) {
          if (kDebugMode) print('Payment API error (non-blocking): $e');
        }

        if (!mounted) return;
        setState(() => _isProcessing = false);

        _goToTicketScreen();
      }
    } catch (e) {
      if (kDebugMode) print('Payment error: $e');
      if (!mounted) return;
      setState(() => _isProcessing = false);
      _showError(e.toString());
    }
  }

  void _goToTicketScreen() {
    context.push(AppRoutes.ticket, extra: booking);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $msg'), backgroundColor: AppColors.error));
  }

  String _formatPrice(dynamic price) {
    if (price is int) return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (price is double) return price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return price.toString();
  }
}
