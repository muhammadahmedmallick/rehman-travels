import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../app/widgets/full_screen_loader.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../../bank/presentation/providers/bank_provider.dart';
import '../../../branches/presentation/providers/branch_provider.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/flight_leg_card.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentScreen({super.key, required this.bookingData});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedMethod = 'alfalah';
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
    final flightData = booking['flightData'] as Map<String, dynamic>? ?? {};
    final passengers = booking['passengers'] as List? ?? [];
    final returnLeg = flightData['returnLeg'] as Map<String, dynamic>?;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Always land on Home from the payment screen — the booking has
        // already been created, so going back into the booking flow would
        // just confuse the user.
        if (context.mounted) context.go('/');
      },
      child: FullScreenLoader(
      isLoading: _isProcessing,
      message: 'Processing payment...',
      child: Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Payment', style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
        leading: AppBackButton(onPressed: () => context.go('/')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PNR Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.success.withValues(alpha: 0.08),
              child: Row(children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Text('Booking Confirmed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                const Spacer(),
                RichText(text: TextSpan(children: [
                  TextSpan(text: 'Booking Reference: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
                  TextSpan(text: pnr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ])),
              ]),
            ),

            // Payment Methods
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Text('Select Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),

            _buildPaymentOption(id: 'alfalah', icon: Icons.credit_card, title: 'Debit / Credit Card', subtitle: 'Pay securely via Bank Alfalah'),
            _buildBankTransferOption(),
            _buildCashOption(),

            // Flight Details — shared FlightLegCard
            FlightLegCard(
              leg: {
                ...flightData,
                'segments': _legSegments(flightData, 0),
              },
              label: returnLeg != null ? 'Outbound' : 'Flight Info',
            ),
            if (returnLeg != null)
              FlightLegCard(
                leg: {
                  ...returnLeg,
                  'cabin': returnLeg['cabin'] ?? flightData['cabin'],
                  'baggage': returnLeg['baggage'] ?? flightData['baggage'],
                  'isRefundable':
                      returnLeg['isRefundable'] ?? flightData['isRefundable'],
                  'segments': _legSegments(flightData, 1),
                },
                label: 'Return',
              ),

            // Passengers Card
            if (passengers.isNotEmpty)
              _buildPassengerCard(passengers),

            // Security
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline, size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('SSL Secured · We do not store your payment details', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
              ]),
            ),
            const SizedBox(height: 80),
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
    ),
    ),
    );
  }

  /// Extracts segments for the given leg index from `flight['allLegs']`,
  /// falling back to the leg map's own `segments` when `allLegs` isn't
  /// populated. Keeps the FlightLegCard timeline working even when the
  /// provider payload shape varies.
  List _legSegments(Map<String, dynamic> flight, int index) {
    final allLegs =
        (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    if (allLegs.length > index) {
      final segs = allLegs[index]['segments'];
      if (segs is List) return segs;
    }
    final segs = flight['segments'];
    if (segs is List) return segs;
    return const [];
  }

  Widget _buildFlightDetailCard(Map<String, dynamic> flight, Map<String, dynamic>? returnLeg) {
    final airlineCode = (flight['airlineCode'] ?? '').toString().toUpperCase();
    final isRefundable = flight['isRefundable'] ?? false;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          leading: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceLight, border: Border.all(color: AppColors.border, width: 0.5)),
            clipBehavior: Clip.antiAlias,
            child: Image.network('https://www.rehmantravel.com/logos/$airlineCode.png', fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Center(child: Text(airlineCode, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary)))),
          ),
          title: Row(children: [
            Expanded(child: Text(flight['airlineName'] ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary), overflow: TextOverflow.ellipsis)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: (isRefundable ? AppColors.success : AppColors.error).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(isRefundable ? 'Refundable' : 'Non-Refundable', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: isRefundable ? AppColors.success : AppColors.error)),
            ),
          ]),
          subtitle: Row(children: [
            Text(flight['flightNumber'] ?? '', style: TextStyle(fontSize: 10, color: AppColors.primary)),
            const Spacer(),
            Text('Tap for details', style: TextStyle(fontSize: 9, color: AppColors.accent)),
          ]),
          children: [
            // Departure
            _miniRoute('Departure', flight['departureCode'] ?? '', flight['arrivalCode'] ?? '', flight['departureTime'] ?? '', flight['arrivalTime'] ?? '', flight['duration'] ?? '', flight['stops'] ?? 0, false),
            if (returnLeg != null) ...[
              const Divider(height: 14),
              _miniRoute('Return', returnLeg['departureCode'] ?? '', returnLeg['arrivalCode'] ?? '', returnLeg['departureTime'] ?? '', returnLeg['arrivalTime'] ?? '', returnLeg['duration'] ?? '', returnLeg['stops'] ?? 0, true),
            ],
            const Divider(height: 14),
            _infoRow(Icons.airline_seat_recline_normal, 'Class', flight['cabin'] ?? 'Economy'),
            _infoRow(Icons.luggage_outlined, 'Baggage', flight['baggage'] ?? '20kg'),
            _infoRow(Icons.business, 'Provider', flight['provider'] ?? ''),
            _infoRow(Icons.attach_money, 'Total', () {
              final p = flight['price'] ?? booking['totalPrice'] ?? 0;
              final d = p is num ? p.toDouble() : double.tryParse(p.toString()) ?? 0;
              return formatCurrencyPrice(d, ref.read(currencyProvider).selected);
            }()),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(List passengers) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.people_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('Passengers (${passengers.length})', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ]),
        const SizedBox(height: 10),
        ...passengers.asMap().entries.map((entry) {
          final i = entry.key;
          final pax = entry.value as Map<String, dynamic>;
          final name = '${pax['nameTitle'] ?? ''} ${pax['firstName'] ?? ''} ${pax['lastName'] ?? ''}'.trim();
          final type = (pax['type'] ?? 'adult').toString();
          final typeLabel = type == 'adult' ? 'ADULT' : type == 'child' ? 'CHILD' : 'INFANT';
          final dob = pax['dateOfBirth'] ?? '';
          final gender = pax['gender'] ?? '';

          return Container(
            margin: EdgeInsets.only(bottom: i < passengers.length - 1 ? 8 : 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(name.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.3))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(typeLabel, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ]),
              if (dob.isNotEmpty || gender.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: [
                  const SizedBox(width: 34),
                  if (dob.isNotEmpty) ...[
                    Icon(Icons.cake_outlined, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(dob, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                  ],
                  if (dob.isNotEmpty && gender.isNotEmpty) const SizedBox(width: 12),
                  if (gender.isNotEmpty) ...[
                    Icon(gender == 'Male' ? Icons.male : Icons.female, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(gender, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                  ],
                ]),
              ],
            ]),
          );
        }),
        // Contact info
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            if (booking['email'] != null) Row(children: [
              Icon(Icons.email_outlined, size: 13, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(booking['email'] ?? '', style: TextStyle(fontSize: 11, color: AppColors.primary)),
            ]),
            if (booking['phone'] != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.phone_outlined, size: 13, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(booking['phone'] ?? '', style: TextStyle(fontSize: 11, color: AppColors.primary)),
              ]),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _miniRoute(String label, String dep, String arr, String depTime, String arrTime, String dur, dynamic stops, bool isReturn) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dep, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
          Text(depTime, style: TextStyle(fontSize: 10, color: AppColors.primary)),
        ])),
        Expanded(flex: 3, child: Column(children: [
          Text(dur, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 3),
          Row(children: [
            Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1))),
            Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
            Transform.rotate(angle: isReturn ? -1.5708 : 1.5708, child: Icon(Icons.flight, size: 12, color: AppColors.primary)),
            Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
            Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
          ]),
          const SizedBox(height: 2),
          Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: stopsInt == 0 ? AppColors.success : AppColors.primary)),
        ])),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(arr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
          Text(arrTime, style: TextStyle(fontSize: 10, color: AppColors.primary)),
        ])),
      ]),
    ]);
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.primary)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ]),
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
                            initiallyExpanded:true,
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

}
