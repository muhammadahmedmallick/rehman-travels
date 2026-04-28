import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../app/widgets/full_screen_loader.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../../bank/presentation/providers/bank_provider.dart';
import '../../../branches/presentation/providers/branch_provider.dart';
import '../providers/booking_session_provider.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/collapsible_itinerary_card.dart';
import '../widgets/booking_journey_header.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentScreen({super.key, required this.bookingData});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen>
    with WidgetsBindingObserver {
  String _selectedMethod = 'alfalah';
  bool _isProcessing = false;

  // ── APG payment tracking ──────────────────────────────────────────────────
  /// The transaction_ref we registered with Django before launching the browser.
  /// Null until the user taps "Pay with Card".
  String? _apgTransactionRef;

  /// True once the user has been sent to the APG browser page and we are
  /// waiting for them to return.
  bool _awaitingApgReturn = false;

  /// Polling timer — fires every 3 s while the user is in the browser.
  Timer? _pollTimer;

  /// How many times we have polled without a conclusive answer.
  int _pollCount = 0;
  static const int _maxPolls = 8; // ~24 s max — short window so the
  // user isn't stuck behind a loader if the IPN never arrives.

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Called whenever the app returns to the foreground.
  /// If we were waiting for an APG payment result, kick off a status poll.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingApgReturn) {
      _awaitingApgReturn = false;
      // Don't auto-poll behind a full-screen loader — the user might
      // have cancelled at the gateway and would otherwise be stuck
      // staring at "Processing payment..." for a full minute. Ask
      // first; only poll if they confirm they completed the payment.
      _confirmPaymentReturn();
    }
  }

  // ── Booking helpers ────────────────────────────────────────────────────────

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
      body: CustomScrollView(
        slivers: [
          // Booking-flow header, step 2 of 3. Back tap goes to Home
          // because the booking is already created — jumping back into
          // the booking flow would risk orphaned PNRs.
          BookingJourneyHeader(
            title: 'Payment',
            params: ref.read(flightSearchProvider).searchParams,
            currentStep: 2,
            onBack: () => context.go(AppRoutes.home),
          ),
          SliverToBoxAdapter(
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

            // Flight Details — same collapsible itinerary card used
            // on the booking screen so the trip the user sees renders
            // identically at every step in the flow.
            CollapsibleItineraryCard(
              flight: flightData,
              searchParams: ref.read(flightSearchProvider).searchParams,
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
        ],
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

  String _cabinLabel(String code) {
    final c = code.toUpperCase().trim();
    if (c == 'C' || c == 'J' || c == 'BUSINESS') return 'Business';
    if (c == 'F' || c == 'FIRST') return 'First';
    if (c == 'W' || c == 'PREMIUM' || c == 'PREMIUM ECONOMY') {
      return 'Premium Economy';
    }
    return 'Economy';
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
            _infoRow(
                Icons.airline_seat_recline_normal,
                'Class',
                _cabinLabel((flight['cabin'] ??
                        ref.read(flightSearchProvider).searchParams?['cabin'] ??
                        '')
                    .toString())),
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
          // Gender is only meaningful for adults/children on the
          // confirmation card — infants don't pick a gender on the
          // booking form, so the default "Male" would otherwise leak
          // into the UI and look wrong.
          final gender = type == 'infant' ? '' : (pax['gender'] ?? '');

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

  // ── Payment processing ────────────────────────────────────────────────────

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    try {
      final apiClient    = ref.read(apiClientProvider);
      final coreApiClient = ref.read(coreApiClientProvider);

      if (_selectedMethod == 'alfalah') {
        // ── Step 1: Register a pending APGTransaction in our Django DB ──────
        // This gives us a transaction_ref we can poll later.
        // We use the booking PNR as the ref so APG's IPN response can match it.
        final transactionRef = pnr.isNotEmpty ? pnr : 'RT-${DateTime.now().millisecondsSinceEpoch}';

        // Single source of truth for the amount — read from
        // BookingSession (computed once at flight selection, refreshed
        // on fare-refresh ticks). Falls back to extras only when the
        // session somehow isn't populated yet.
        final session = ref.read(bookingSessionProvider);
        final amount = session != null && session.payableAmount > 0
            ? session.payableAmount
            : (booking['totalPrice'] is num
                ? (booking['totalPrice'] as num).toDouble()
                : double.tryParse(booking['totalPrice']?.toString() ?? '') ??
                    (booking['amount'] is num
                        ? (booking['amount'] as num).toDouble()
                        : 0.0));

        if (kDebugMode) {
          print('=== PAYMENT amount resolved: $amount '
              '(session=${session?.payableAmount}, '
              'booking.totalPrice=${booking['totalPrice']})');
        }

        if (amount <= 0) {
          setState(() => _isProcessing = false);
          _showError('Could not resolve payment amount. Please go back and try again.');
          return;
        }

        try {
          await coreApiClient.post(
            ApiEndpoints.apgInitiate,
            data: {
              'transaction_ref':   transactionRef,
              'booking_pnr':       pnr,
              'booking_reference': reference,
              'air_type':          airType,
              'amount':            amount,
              'currency':          'PKR',
            },
          );
          _apgTransactionRef = transactionRef;
        } catch (e) {
          // Non-fatal: we still launch the payment URL and poll later.
          if (kDebugMode) print('APG initiate warning: $e');
          _apgTransactionRef = transactionRef;
        }

        // ── Step 2: Fetch the APG payment URL from rehmantravel.com ─────────
        // The Laravel `AlfalahClientProvider::create` resolves
        // TransactionAmount in this order:
        //   $request['payAmount']
        //     ?? $request['eqDiscountFare']
        //     ?? $request['eqTotalFare']
        //     ?? 0
        // The HC path (`sendInitiateHCRequest`) reads the amount from
        // the `FlightItineraryInfo` DB row — but mobile bypasses
        // Laravel for orderCreate so that row never exists. Sending
        // every amount-shaped field keeps both code paths working;
        // whichever one Laravel picks up resolves to the same value.
        final amountInt = amount.ceil();
        final response = await apiClient.postWithHeader(
          '/payonline/cheapest-fare-order-alfalah-pay-online-request',
          data: {
            'airType':       airType,
            'vCarrier':      vCarrier,
            'itineraryRef':  pnr,
            'reference':     reference,
            'echoToken':     echoToken,
            'payAmount':     amountInt,
            'eqTotalFare':   amountInt,
            'eqDiscountFare': amountInt,
            'currencyCode':  'PKR',
            'countryCode':   164,
          },
          extraHeaders: {'Action-Type': 'AlfalahPay'},
        );

        if (!mounted) return;

        final data = response.data;
        if (data is Map<String, dynamic> && data['payUrl'] != null) {
          setState(() => _isProcessing = false);
          final url = Uri.parse(data['payUrl'].toString());

          if (await canLaunchUrl(url)) {
            // ── Step 3: Open APG in external browser ─────────────────────
            _awaitingApgReturn = true;
            await launchUrl(url, mode: LaunchMode.externalApplication);
            // WidgetsBindingObserver.didChangeAppLifecycleState will fire
            // when the user comes back — that triggers _startPollingStatus().
          } else {
            _showError('Could not open payment page. Please try again.');
          }
        } else {
          // No payUrl returned — treat as non-card path (shouldn't happen)
          setState(() => _isProcessing = false);
          _goToTicketScreen();
        }

      } else {
        // Bank Transfer or Cash — go straight to the ticket / confirmation screen.
        if (!mounted) return;
        setState(() => _isProcessing = false);
        _goToTicketScreen();
      }
    } catch (e) {
      if (kDebugMode) print('Payment error: $e');
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // ── APG status polling ────────────────────────────────────────────────────

  /// Asks the user whether they actually completed the payment at
  /// the gateway before we kick off any polling. Avoids the old
  /// behaviour where cancelling at APG left the app stuck behind a
  /// "Processing payment..." loader for the full poll window.
  Future<void> _confirmPaymentReturn() async {
    if (!mounted) return;
    final completed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Did you complete the payment?'),
        content: const Text(
          'If you completed the payment at the gateway, we\'ll verify '
          'it now. Otherwise you can return to the booking and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No, cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, verify'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (completed == true) {
      _startPollingStatus();
    } else {
      // User cancelled at APG — keep the screen interactive so they
      // can pick another method or back out without staring at a
      // spinner.
      setState(() => _isProcessing = false);
    }
  }

  /// Start polling the Django status endpoint every 3 seconds.
  void _startPollingStatus() {
    if (!mounted) return;
    setState(() {
      _isProcessing = true;
      _pollCount    = 0;
    });

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _checkPaymentStatus());

    // Also poll immediately on the first tick.
    _checkPaymentStatus();
  }

  Future<void> _checkPaymentStatus() async {
    final ref_ = _apgTransactionRef;
    if (ref_ == null || !mounted) {
      _stopPolling();
      return;
    }

    _pollCount++;
    if (_pollCount > _maxPolls) {
      // Timed out — show an inconclusive result screen and let the user decide.
      _stopPolling();
      if (mounted) {
        setState(() => _isProcessing = false);
        _showPaymentStatusDialog(status: 'pending');
      }
      return;
    }

    try {
      final coreApiClient = ref.read(coreApiClientProvider);
      final response = await coreApiClient.get(ApiEndpoints.apgStatus(ref_));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data   = response.data as Map<String, dynamic>;
        final status = data['status'] as String? ?? 'pending';

        if (status == 'paid' || status == 'failed') {
          _stopPolling();
          setState(() => _isProcessing = false);
          _showPaymentStatusDialog(status: status, data: data);
        }
        // If still 'pending', keep polling.
      }
    } catch (e) {
      if (kDebugMode) print('APG status poll error: $e');
      // Keep polling — transient network errors are expected.
    }
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Show a result dialog based on the polled status.
  void _showPaymentStatusDialog({
    required String status,
    Map<String, dynamic>? data,
  }) {
    if (!mounted) return;

    final isPaid    = status == 'paid';
    final isPending = status == 'pending';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Icon(
            isPaid ? Icons.check_circle : isPending ? Icons.hourglass_top : Icons.cancel,
            color: isPaid ? AppColors.success : isPending ? Colors.orange : AppColors.error,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(
            isPaid    ? 'Payment Successful!'
            : isPending ? 'Payment Pending'
            :             'Payment Failed',
            style: TextStyle(
              fontSize: 16,
              color: isPaid ? AppColors.success : isPending ? Colors.orange : AppColors.error,
            ),
          )),
        ]),
        content: Text(
          isPaid
            ? 'Your payment has been confirmed. We\'ll take you to your booking details.'
            : isPending
              ? 'We haven\'t received a payment confirmation yet. '
                'Please check your booking history shortly, or contact support.'
              : 'Your payment could not be processed. '
                'Please try again or choose a different payment method.',
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          if (!isPaid)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Stay on the payment screen so the user can retry.
              },
              child: const Text('Try Again'),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPaid ? AppColors.success : AppColors.primary,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _goToTicketScreen();
            },
            child: Text(isPaid ? 'View Booking' : 'Continue'),
          ),
        ],
      ),
    );
  }

  // ── Navigation helpers ────────────────────────────────────────────────────

  void _goToTicketScreen() {
    context.push(AppRoutes.ticket, extra: booking);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $msg'), backgroundColor: AppColors.error),
    );
  }

}

/// What the Alfalah WebView hands back when it pops:
/// - `wasCancelled = true` → user backed out without finishing the bank
///   flow (no charge attempt); caller should leave them on payment.
/// - Otherwise the bank redirected away from its domain. `orderId` is
///   the value of the `O` query/path param per APG docs — fed to the
///   IPN OrderStatus endpoint to confirm whether the charge landed.
class _AlfalahWebViewResult {
  final String? orderId;
  final String? finalUrl;
  final bool wasCancelled;

  const _AlfalahWebViewResult.completed({this.orderId, this.finalUrl})
      : wasCancelled = false;
  const _AlfalahWebViewResult.cancelled()
      : orderId = null,
        finalUrl = null,
        wasCancelled = true;
}

/// In-app Alfalah payment WebView. Loads the bank's hosted card page
/// and watches every navigation. The moment the bank redirects to our
/// configured `ReturnURL` (any host that's not bankalfalah.com),
/// we extract the `O` order-id param and pop — the caller then hits
/// the bank's IPN OrderStatus endpoint for the authoritative outcome.
class _AlfalahPaymentWebView extends StatefulWidget {
  final String initialUrl;

  const _AlfalahPaymentWebView({required this.initialUrl});

  @override
  State<_AlfalahPaymentWebView> createState() =>
      _AlfalahPaymentWebViewState();
}

class _AlfalahPaymentWebViewState extends State<_AlfalahPaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _settled = false;

  // APG docs: bank stamps the order id in the return URL under
  // alias `O`. We accept a few common case variants for safety.
  static const _orderIdKeys = ['O', 'o', 'OrderId', 'orderId', 'orderID'];

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('═══════════════════════════════════════════════════════');
      print('║ ALFALAH WebView OPENING: ${widget.initialUrl}');
      print('═══════════════════════════════════════════════════════');
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          if (kDebugMode) print('║ [WebView] page STARTED → $url');
          if (mounted) setState(() => _isLoading = true);
        },
        onPageFinished: (url) {
          if (kDebugMode) print('║ [WebView] page FINISHED → $url');
          if (mounted) setState(() => _isLoading = false);
        },
        onUrlChange: (change) {
          if (kDebugMode) print('║ [WebView] URL CHANGED → ${change.url}');
          _maybeFinish(change.url ?? '');
        },
        onNavigationRequest: (req) {
          if (kDebugMode) print('║ [WebView] NAV REQUEST → ${req.url}');
          _maybeFinish(req.url);
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  void _maybeFinish(String url) {
    if (_settled || url.isEmpty) return;
    if (url.toLowerCase() == widget.initialUrl.toLowerCase()) return;

    // Stay open as long as the user is still on the bank's domain.
    // The moment navigation leaves bankalfalah.com (the bank is
    // redirecting to our configured ReturnURL with status params),
    // grab the order id from the URL and pop. The Laravel return
    // page itself never gets a chance to render in the WebView.
    if (_isBankDomain(url)) return;

    final orderId = _extractOrderId(url);
    if (kDebugMode) {
      print('║ [WebView] LEAVING BANK → $url');
      print('║ [WebView] extracted orderId: $orderId');
    }
    _settled = true;
    if (!mounted) return;
    Navigator.of(context).pop(
      _AlfalahWebViewResult.completed(orderId: orderId, finalUrl: url),
    );
  }

  /// Whether the navigation URL is still on the bank's host (or a
  /// subdomain of it). Anchored to whatever host the initial payUrl
  /// arrived on so the same code works for sandbox and production
  /// (`sandbox.bankalfalah.com`, `payments.bankalfalah.com`, etc.).
  bool _isBankDomain(String url) {
    final initial = Uri.tryParse(widget.initialUrl);
    final current = Uri.tryParse(url);
    if (initial == null || current == null) return false;
    final initialHost = initial.host.toLowerCase();
    final currentHost = current.host.toLowerCase();
    if (currentHost == initialHost) return true;
    // Match registered domain (last two labels) — handles bank
    // sub-redirects across `*.bankalfalah.com` without hard-coding.
    final initialParts = initialHost.split('.');
    final currentParts = currentHost.split('.');
    if (initialParts.length < 2 || currentParts.length < 2) return false;
    final initialRoot =
        '${initialParts[initialParts.length - 2]}.${initialParts.last}';
    final currentRoot =
        '${currentParts[currentParts.length - 2]}.${currentParts.last}';
    return initialRoot == currentRoot;
  }

  /// Pulls the bank's Order ID from the redirect URL. APG docs show
  /// two formats — standard query (`?O=A10&TS=P&RC=00`) and an
  /// unusual path-style (`/TS=P/RC=00/O=A10`). We parse both.
  String? _extractOrderId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // 1. Standard query params.
    for (final key in _orderIdKeys) {
      final v = uri.queryParameters[key];
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }

    // 2. Path-style `/key=value/...` segments (matches the doc's
    //    example `www.google.com/TS=P/RC=00/RD=/O=A10`).
    for (final seg in uri.pathSegments) {
      final eq = seg.indexOf('=');
      if (eq <= 0 || eq == seg.length - 1) continue;
      final k = seg.substring(0, eq);
      final v = seg.substring(eq + 1).trim();
      if (v.isEmpty) continue;
      if (_orderIdKeys.any((k2) => k2.toLowerCase() == k.toLowerCase())) {
        return v;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // Guard the back gesture mid-payment — it's easy to lose a
        // half-completed authorisation by accident.
        final leave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cancel payment?'),
            content: const Text(
                'If you leave now, your booking will not be paid for.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Cancel payment',
                    style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        );
        if (leave == true && context.mounted) {
          Navigator.of(context).pop(const _AlfalahWebViewResult.cancelled());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Secure Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
