import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../bank/presentation/providers/bank_provider.dart';
import '../../../branches/presentation/providers/branch_provider.dart';
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
            // Bank Transfer with inline bank details
            _buildBankTransferOption(),
            // Cash In Office with branch details
            _buildCashOption(),

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

  Widget _buildCashOption() {
    final isSelected = _selectedMethod == 'cash';
    return Padding(
      padding: AppPadding.screenH.copyWith(top: 0, bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = 'cash'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
          ),
          child: Column(children: [
            Padding(
              padding: AppPadding.cardLg,
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
                  child: Icon(Icons.storefront, size: AppIconSize.lg, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                ),
                AppGap.hMd,
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Cash In Office', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w600)),
                  Text('Pay at our branch locations', style: AppTextStyles.hint),
                ])),
              ]),
            ),
            if (isSelected) _buildBranchDetails(),
          ]),
        ),
      ),
    );
  }

  Widget _buildBranchDetails() {
    final branchState = ref.watch(branchProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: branchState.isLoading
            ? const Padding(padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
            : branchState.branches.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: branchState.branches.map((branch) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(branch.flagEmoji, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(branch.branchName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(branch.branchAddress, style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3)),
                            if (branch.hasPhone) ...[
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('tel:${branch.branchPhone}')),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.phone, size: 12, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(branch.branchPhone, style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                            ],
                          ])),
                          if (branch.hasMap)
                            GestureDetector(
                              onTap: () => launchUrl(Uri.parse(branch.mapAddress), mode: LaunchMode.externalApplication),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                child: Icon(Icons.map_outlined, size: 16, color: AppColors.primary),
                              ),
                            ),
                        ]),
                      );
                    }).toList(),
                  ),
      ),
    );
  }

  Widget _buildBankTransferOption() {
    final isSelected = _selectedMethod == 'bank_transfer';
    return Padding(
      padding: AppPadding.screenH.copyWith(top: 0, bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = 'bank_transfer'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
          ),
          child: Column(children: [
            // Header row
            Padding(
              padding: AppPadding.cardLg,
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
                  child: Icon(Icons.account_balance, size: AppIconSize.lg, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                ),
                AppGap.hMd,
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pay Via Online Bank', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w600)),
                  Text('Transfer from your bank account', style: AppTextStyles.hint),
                ])),
              ]),
            ),
            // Bank details (animated expand)
            if (isSelected) _buildBankDetails(),
          ]),
        ),
      ),
    );
  }

  Widget _buildBankDetails() {
    final bankState = ref.watch(bankProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: AppPadding.screenH.copyWith(top: 0, bottom: 8),
        child: bankState.isLoading
            ? const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
            : bankState.accounts.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: bankState.accounts.map((account) {
                      final color = Color(account.colorValue);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color.withValues(alpha: 0.2)),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            dense: true,
                            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                            leading: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                              child: Center(child: Text(account.bankLogo, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))),
                            ),
                            title: Text(account.bankName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                            subtitle: Text(account.branchCode, style: TextStyle(fontSize: 9, color: AppColors.textHint)),
                            children: [
                              _bankRow('Title', account.accountTitle),
                              _bankRow('Account', account.accountNumber),
                              _bankRow('IBAN', account.iban),
                              if (account.swiftCode.isNotEmpty) _bankRow('SWIFT', account.swiftCode),
                              const SizedBox(height: 6),
                              // Copy All button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _copyAllBankDetails(account),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: color,
                                    side: BorderSide(color: color.withValues(alpha: 0.3)),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    minimumSize: const Size(0, 34),
                                  ),
                                  icon: Icon(Icons.copy_all_rounded, size: 14, color: color),
                                  label: Text('Copy All Details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }

  Widget _bankRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: [const Icon(Icons.check_circle, color: Colors.white, size: 16), const SizedBox(width: 6), Text('$label copied', style: const TextStyle(fontSize: 13))]),
            backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1),
          ));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            SizedBox(width: 50, child: Text(label, style: TextStyle(fontSize: 9, color: AppColors.textHint, fontWeight: FontWeight.w600))),
            Expanded(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
            Icon(Icons.copy_rounded, size: 12, color: AppColors.textHint),
          ]),
        ),
      ),
    );
  }

  void _copyAllBankDetails(BankAccount account) {
    final text = '${account.bankName}\n'
        'Title: ${account.accountTitle}\n'
        'Account: ${account.accountNumber}\n'
        'IBAN: ${account.iban}'
        '${account.swiftCode.isNotEmpty ? '\nSWIFT: ${account.swiftCode}' : ''}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.check_circle, color: Colors.white, size: 16), const SizedBox(width: 6), const Text('All details copied', style: TextStyle(fontSize: 13))]),
      backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2),
    ));
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
        // Bank Transfer or Cash - go directly to ticket screen
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
