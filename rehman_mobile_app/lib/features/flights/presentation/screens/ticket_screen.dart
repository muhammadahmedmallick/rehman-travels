import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../../../../core/utils/time_format.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../data/utils/fare_calculation.dart';
import '../providers/booking_session_provider.dart';
import '../providers/flight_search_provider.dart';

class TicketScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingData;

  const TicketScreen({super.key, required this.bookingData});

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  bool _isSendingEmail = false;
  bool _isGeneratingPdf = false;
  final _ticketKey = GlobalKey();

  Map<String, dynamic> get booking => widget.bookingData;
  Map<String, dynamic> get flight => (booking['flightData'] as Map<String, dynamic>?) ?? {};
  Map<String, dynamic> get rawData => (flight['rawData'] as Map<String, dynamic>?) ?? {};
  Map<String, dynamic> get priceData => (rawData['price'] as Map<String, dynamic>?) ?? {};
  List get passengers => (booking['passengers'] as List?) ?? [];

  String get pnr => booking['pnr']?.toString() ?? '';
  String get reference => booking['reference']?.toString() ?? pnr;
  String get airType => booking['airType']?.toString() ?? '';

  /// Payment outcome — single source of truth is the booking
  /// session (set by the payment screen). Falls back to the route
  /// payload only when the screen is reached without a session
  /// (deep-link, restored navigation). Defaults to `due` so a
  /// missing flag never silently shows "Confirmed".
  String get paymentStatus {
    final session = ref.read(bookingSessionProvider);
    if (session != null) return session.paymentStatusLabel;
    return (booking['paymentStatus']?.toString().toLowerCase() ?? 'due');
  }
  bool get isPaid => paymentStatus == 'paid';
  String get paymentStatusLabel => isPaid ? 'Confirmed' : 'Payment Due';
  Color get paymentStatusColor =>
      isPaid ? const Color(0xFF2ECC71) : const Color(0xFFE67E22);
  String get vCarrier => booking['vCarrier']?.toString() ?? flight['airlineCode']?.toString() ?? '';
  String get email => booking['email']?.toString() ?? '';
  String get phone => booking['phone']?.toString() ?? '';
  String get airlineName => priceData['airlineName'] ?? flight['airlineName'] ?? 'Airline';
  String get cabin {
    final raw = (flight['cabin'] ?? '').toString().toLowerCase().trim();
    if (raw.isEmpty || raw == 'y' || raw == 'economy' || raw == 'm') return 'Economy';
    if (raw == 'c' || raw == 'business' || raw == 'j') return 'Business';
    if (raw == 'f' || raw == 'first') return 'First';
    if (raw == 'w' || raw == 'premium' || raw == 'premium economy') return 'Premium Economy';
    return flight['cabin'].toString();
  }
  String get depCode => flight['departureCode'] ?? '';
  String get arrCode => flight['arrivalCode'] ?? '';
  String get depTime => formatFlightTime(flight['departureTime']?.toString());
  String get arrTime => formatFlightTime(flight['arrivalTime']?.toString());
  String get duration => flight['duration'] ?? '';
  String get flightNumber => flight['flightNumber'] ?? '';
  String get baggage => flight['baggage'] ?? '20kg';
  bool get isRefundable => flight['isRefundable'] == true;

  int get stopsInt {
    final stops = flight['stops'] ?? 0;
    return stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
  }

  // First passenger name for "Traveller Name"
  String get leadPassengerName {
    if (passengers.isEmpty) return '';
    final p = passengers[0] as Map<String, dynamic>;
    final title = p['nameTitle'] ?? p['title'] ?? '';
    final first = p['firstName'] ?? '';
    final last = p['lastName'] ?? '';
    return '$last/ $first $title'.trim().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Hardware back / swipe back should land on Home — the only
      // sensible destination once the ticket has been issued.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.mounted) context.go(AppRoutes.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text('E-Ticket', style: AppTextStyles.titleSm.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          // Home icon instead of a back arrow — booking is already
          // issued and there's no meaningful "back" from a ticket.
          // Styled to match the app-wide back button chrome (same
          // pill background, size, position).
          leading: IconButton(
            tooltip: 'Home',
            onPressed: () => context.go(AppRoutes.home),
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: AppIconSize.lg,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            RepaintBoundary(key: _ticketKey, child: _buildTicketCard()),
            const SizedBox(height: 100),
          ]),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  SINGLE TICKET CARD
  // ═══════════════════════════════════════════
  Widget _buildTicketCard() {
    // Fare breakdown — single source of truth in fare_calculation.dart.
    // The ticket widget (and the PDF screenshot of it) therefore shows
    // exactly the same numbers as the booking/payment/details screens.
    final adults =
        passengers.where((p) => (p as Map)['type'] == 'adult').length;
    final children =
        passengers.where((p) => (p as Map)['type'] == 'child').length;
    final infants =
        passengers.where((p) => (p as Map)['type'] == 'infant').length;
    final fare = computeFareBreakdown(
      flight: flight,
      adults: adults > 0 ? adults : null,
      children: children,
      infants: infants,
      overrideTotal: _parseNum(booking['totalPrice']).toDouble() > 0
          ? _parseNum(booking['totalPrice']).toDouble()
          : null,
    );
    final baseFare = fare.baseFare;
    final taxes = fare.taxes;
    final totalPrice = fare.total;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ══════ REHMAN TRAVELS BANNER ══════
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Image.asset('assets/icons/ticket_logo.png', height: 32, fit: BoxFit.cover),
        ),

        // ══════ PAYMENT-DUE BANNER ══════
        // Only shown when the charge hasn't landed (failed card,
        // bank transfer, cash). Tells the user the booking is held
        // and a rep will follow up — they should not assume the
        // ticket is ticketed yet.
        if (!isPaid) _buildPaymentDueBanner(),

        // ══════ TRAVELLER + CONTACT DETAILS ══════
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Left - Traveller
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Traveller Name's", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              ...passengers.map((p) {
                final pax = p as Map<String, dynamic>;
                final title = pax['nameTitle'] ?? pax['title'] ?? '';
                final first = pax['firstName'] ?? '';
                final last = pax['lastName'] ?? '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('$last/ $first $title'.trim().toUpperCase(), style: const TextStyle(fontSize: 11, height: 1.3)),
                );
              }),
            ])),
            const SizedBox(width: 12),
            // Right - Contact Details
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Contact Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              _detailRow('Supplier', '$airType/GDS'),
              _detailRow('PNR', pnr),
              _detailRow('Status', paymentStatusLabel),
              if (phone.isNotEmpty) _detailRow('Mobile No', phone),
              if (email.isNotEmpty) _detailRow('Email', email),
            ])),
          ]),
        ),

        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // ══════ FULL ITINERARY — per-segment timeline ══════
        ..._buildFullItinerary(),

        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // ══════ CLASS + BAGGAGE ══════
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(width: 100, child: Text('Class', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
            Expanded(child: Text(cabin, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(width: 100, child: Text('Baggage', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
            Expanded(child: Text(
              _baggageSummary(),
              style: const TextStyle(fontSize: 11),
            )),
          ]),
        ),

        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // ══════ FARE BREAKDOWN ══════
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            border: Border(top: BorderSide(color: const Color(0xFFE5E7EB))),
          ),
          child: Table(
            columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
            children: [
              _fareTableRow('FOP', 'REHMAN GROUP OF TRAVELS'),
              if (baseFare > 0) _fareTableRow('Fare', _currencyPrice(baseFare.toDouble())),
              if (taxes > 0) _fareTableRow('Taxes', _currencyPrice(taxes.toDouble())),
              TableRow(
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                    child: Text('Total Fare', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 14, 10),
                    child: Text(_currencyPrice(totalPrice.toDouble()),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ══════ FOOTER NOTE ══════
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Text(
            'Data protection notice: your personal data will be processed in accordance with the applicable carriers privacy policy. '
            'You should read this documentation, which applies to your booking and specifies how your personal data is collected, stored, used, disclosed and transferred.',
            style: TextStyle(fontSize: 8, color: AppColors.textHint, height: 1.4),
          ),
        ),
      ]),
    );
  }

  // ═══════════════════════════════════════════
  //  FULL PER-SEGMENT ITINERARY
  // ═══════════════════════════════════════════

  /// Collects every segment across all legs (outbound + return +
  /// multi-city) and returns a flat list of widgets: a segment card,
  /// a layover strip between same-leg segments, and a "Return journey"
  /// divider between the outbound and inbound legs.
  /// Compact baggage string built per-leg. Shows the outbound and
  /// return allowances separately when they differ, otherwise a single
  /// "ADT DEP-ARR 25kg / adult" line.
  String _baggageSummary() {
    final allLegs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final lines = <String>[];
    if (allLegs.isNotEmpty) {
      for (final leg in allLegs) {
        final segs = (leg['segments'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
        if (segs.isEmpty) continue;
        final first = segs.first;
        final last = segs.last;
        final d = (first['departureCode'] ?? '').toString();
        final a = (last['arrivalCode'] ?? '').toString();
        final bag = (leg['baggage'] ?? first['baggage'] ?? flight['baggage'] ?? '').toString();
        if (d.isEmpty || a.isEmpty) continue;
        lines.add('ADT $d-$a ${bag.isEmpty ? "" : "$bag "}/ adult'.replaceAll('  ', ' '));
      }
    }
    if (lines.isEmpty) {
      lines.add('ADT $depCode-$arrCode $baggage / adult');
      if (flight['returnLeg'] != null) {
        final rBag = ((flight['returnLeg'] as Map)['baggage'] ?? baggage).toString();
        lines.add('ADT $arrCode-$depCode $rBag / adult');
      }
    }
    return lines.join('\n');
  }

  List<Widget> _buildFullItinerary() {
    final allLegs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    // Fall back to a single synthetic leg built from the top-level
    // flight fields when the provider didn't give us segments.
    final legs = allLegs.isNotEmpty
        ? allLegs
        : <Map<String, dynamic>>[
            {
              'segments': [
                {
                  'departureCode': flight['departureCode'],
                  'arrivalCode': flight['arrivalCode'],
                  'departureTime': flight['departureTime'],
                  'arrivalTime': flight['arrivalTime'],
                  'duration': flight['duration'],
                  'flightNumber': flight['flightNumber'],
                  'airlineName': flight['airlineName'],
                  'airlineCode': flight['airlineCode'],
                  'baggage': flight['baggage'],
                },
              ],
            },
            if (flight['returnLeg'] != null)
              {
                'segments': [
                  {
                    'departureCode': (flight['returnLeg'] as Map)['departureCode'],
                    'arrivalCode': (flight['returnLeg'] as Map)['arrivalCode'],
                    'departureTime': (flight['returnLeg'] as Map)['departureTime'],
                    'arrivalTime': (flight['returnLeg'] as Map)['arrivalTime'],
                    'duration': (flight['returnLeg'] as Map)['duration'],
                    'flightNumber': (flight['returnLeg'] as Map)['flightNumber'],
                    'airlineName': (flight['returnLeg'] as Map)['airlineName'] ?? flight['airlineName'],
                    'airlineCode': (flight['returnLeg'] as Map)['airlineCode'] ?? flight['airlineCode'],
                    'baggage': (flight['returnLeg'] as Map)['baggage'] ?? flight['baggage'],
                  },
                ],
              },
          ];

    final widgets = <Widget>[];
    for (var legIndex = 0; legIndex < legs.length; legIndex++) {
      if (legIndex > 0) {
        widgets.add(_legDivider(legIndex == 1 ? 'Return Journey' : 'Flight ${legIndex + 1}'));
      }
      final segs = (legs[legIndex]['segments'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
      for (var i = 0; i < segs.length; i++) {
        widgets.add(_segmentCard(segs[i], isReturn: legIndex == 1));
        if (i < segs.length - 1) {
          widgets.add(_layoverStrip(segs[i], segs[i + 1]));
        }
      }
    }
    return widgets;
  }

  Widget _legDivider(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _segmentCard(Map<String, dynamic> seg, {required bool isReturn}) {
    final depCode = (seg['departureCode'] ?? '').toString();
    final arrCode = (seg['arrivalCode'] ?? '').toString();
    final depTimeStr = formatFlightTime(seg['departureTime']?.toString());
    final arrTimeStr = formatFlightTime(seg['arrivalTime']?.toString());
    final depCity = (seg['departureCity'] ?? '').toString();
    final arrCity = (seg['arrivalCity'] ?? '').toString();
    final durationStr = (seg['duration'] ?? '').toString();
    final flightNum = (seg['flightNumber'] ?? '').toString();
    final segAirlineName = (seg['airlineName'] ?? airlineName).toString();
    final segAirlineCode = (seg['airlineCode'] ?? vCarrier).toString();
    final aircraft = (seg['aircraft'] ?? seg['aircraftType'] ?? '').toString();
    final segBaggage = (seg['baggage'] ?? flight['baggage'] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28, padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
            child: Image.network(
              'https://www.rehmantravel.com/logos/${segAirlineCode.toUpperCase()}.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Center(child: Text(segAirlineCode, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary))),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(segAirlineName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
          if (flightNum.isNotEmpty)
            Text(flightNum, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depCode, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(depTimeStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            if (depCity.isNotEmpty)
              Text(depCity, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
          ])),
          Expanded(flex: 3, child: Column(children: [
            if (durationStr.isNotEmpty)
              Text(durationStr, style: TextStyle(fontSize: 10, color: AppColors.textHint)),
            const SizedBox(height: 4),
            SizedBox(height: 22, child: Stack(alignment: Alignment.center, children: [
              Row(children: [
                _dot(false),
                Expanded(child: Container(height: 1.5, color: AppColors.border)),
                _dot(true),
              ]),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                child: Transform.rotate(
                  angle: isReturn ? -1.5708 : 1.5708,
                  child: Icon(Icons.flight, size: 12, color: AppColors.primary),
                ),
              ),
            ])),
          ])),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrCode, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(arrTimeStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            if (arrCity.isNotEmpty)
              Text(arrCity, style: TextStyle(fontSize: 9, color: AppColors.textSecondary), textAlign: TextAlign.right),
          ])),
        ]),
        if (aircraft.isNotEmpty || segBaggage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 4, children: [
            if (aircraft.isNotEmpty)
              _segMetaChip(Icons.flight_outlined, aircraft),
            if (segBaggage.isNotEmpty)
              _segMetaChip(Icons.luggage_outlined, '$segBaggage / adult'),
            _segMetaChip(
                isPaid
                    ? Icons.check_circle_outline
                    : Icons.access_time_rounded,
                paymentStatusLabel,
                color: paymentStatusColor),
          ]),
        ],
      ]),
    );
  }

  Widget _segMetaChip(IconData icon, String label, {Color? color}) {
    final c = color ?? AppColors.textSecondary;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: c),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _layoverStrip(Map<String, dynamic> prev, Map<String, dynamic> next) {
    final airport = (prev['arrivalCity'] ?? prev['arrivalCode'] ?? '').toString();
    String wait = '';
    final arrMin = timeToMinutes((prev['arrivalTime'] ?? '').toString());
    final depMin = timeToMinutes((next['departureTime'] ?? '').toString());
    if (arrMin != null && depMin != null) {
      var diff = depMin - arrMin;
      if (diff < 0) diff += 1440;
      if (diff > 0) {
        final h = diff ~/ 60;
        final m = diff % 60;
        wait = h > 0 ? '${h}h ${m}m' : '${m}m';
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(children: [
        Icon(Icons.swap_horiz, size: 12, color: AppColors.warning),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            wait.isNotEmpty ? 'Layover: $wait in $airport' : 'Layover in $airport',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warning),
          ),
        ),
      ]),
    );
  }

  // ═══════════════════════════════════════════
  //  BOTTOM BAR
  // ═══════════════════════════════════════════
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        child: Row(children: [
          // Share button
          OutlinedButton(
            onPressed: _isGeneratingPdf ? null : _sharePdf,
            style: OutlinedButton.styleFrom(minimumSize: const Size(56, 48), padding: EdgeInsets.zero),
            child: _isGeneratingPdf
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.share_outlined, size: 18),
                    Text('Share', style: TextStyle(fontSize: 9)),
                  ]),
          ),
          const SizedBox(width: 10),
          // Download E-Ticket button (primary color, not golden)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isSendingEmail ? null : _downloadPdf,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48),
                backgroundColor: AppColors.primary,
              ),
              icon: _isSendingEmail
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.download_outlined, size: 18, color: Colors.white),
              label: Text(_isSendingEmail ? 'Downloading...' : 'Download E-Ticket', style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════

  Widget _headerRoute(String dep, String arr, String dTime, String aTime, String dur, dynamic stops, bool isReturn) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(dep, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(dTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
      Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Text(dur, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Row(children: [
            Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5))),
            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.4))),
            Transform.rotate(angle: isReturn ? -1.5708 : 1.5708, child: const Icon(Icons.flight, size: 14, color: Colors.white)),
            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.4))),
            Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
          ]),
          const SizedBox(height: 3),
          Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
        ]),
      )),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(arr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(aTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
    ]);
  }

  Widget _dot(bool filled) {
    return Container(
      width: 6, height: 6,
      decoration: filled
          ? const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)
          : BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
    );
  }

  /// Amber strip rendered between the brand banner and traveller
  /// row when the ticket is held under "Payment Due". Mirrors the
  /// failure-dialog copy so the user has the same context after
  /// dismissing the dialog and landing here.
  Widget _buildPaymentDueBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      color: paymentStatusColor.withValues(alpha: 0.10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.access_time_rounded,
              size: 18, color: paymentStatusColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payment Due',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: paymentStatusColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Your booking is held. Our representative will '
                  'connect with you shortly to complete the payment.',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(text: TextSpan(style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.3), children: [
        TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
        TextSpan(text: value),
      ])),
    );
  }

  TableRow _fareTableRow(String label, String value) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
          child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
          child: Text(value, style: const TextStyle(fontSize: 11), textAlign: TextAlign.right),
        ),
      ],
    );
  }

  num _parseNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }

  String _currencyPrice(double pkrAmount) {
    final selected = ref.read(currencyProvider).selected;
    return formatCurrencyPrice(pkrAmount, selected);
  }

  // ═══════════════════════════════════════════
  //  SHARE - Screenshot of ticket widget as PDF
  // ═══════════════════════════════════════════
  Future<void> _sharePdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      final boundary = _ticketKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Could not capture ticket');

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Could not convert to image');

      final imageBytes = byteData.buffer.asUint8List();

      final doc = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain));
          },
        ),
      );

      final pdfBytes = await doc.save();
      await Printing.sharePdf(bytes: pdfBytes, filename: 'eticket_$pnr.pdf');
    } catch (e) {
      if (kDebugMode) print('Share error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }


  // ─── DOWNLOAD PDF TO DEVICE ───
  Future<void> _downloadPdf() async {
    setState(() => _isSendingEmail = true);
    try {
      final boundary = _ticketKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Could not capture ticket');

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Could not convert to image');

      final imageBytes = byteData.buffer.asUint8List();

      final doc = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain)),
      ));

      final pdfBytes = await doc.save();

      // Save to device
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes, name: 'eticket_$pnr.pdf');

      if (!mounted) return;
      setState(() => _isSendingEmail = false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(children: [
          Icon(Icons.check_circle, color: Colors.white, size: 18), SizedBox(width: 8),
          Text('E-Ticket downloaded!'),
        ]),
        backgroundColor: AppColors.success, duration: Duration(seconds: 3),
      ));
    } catch (e) {
      if (kDebugMode) print('Download error: $e');
      if (!mounted) return;
      setState(() => _isSendingEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  // ─── SEND PDF EMAIL ───
  Future<void> _sendPdfEmail() async {
    setState(() => _isSendingEmail = true);

    try {
      final exaltedClient = ref.read(exaltedApiClientProvider);

      if (kDebugMode) print('=== Exalted orderRetrieve for email...');
      final response = await exaltedClient.post('/orderRetrieve', data: {
        'airType': airType,
        'pnr': pnr,
        'reference': booking['reference']?.toString() ?? pnr,
        'echoToken': booking['echoToken']?.toString() ?? pnr,
        'jSessionId': booking['jSessionId']?.toString() ?? pnr,
        'vCarrier': vCarrier,
        'currencyRate': 'PKR',
        'currencyCode': '1',
        'receivableAccount': 'REHMAN GROUP OF TRAVELS',
        'paymentAmount': (booking['totalPrice'] ?? flight['price'] ?? 0).toString(),
      });

      if (!mounted) return;

      final data = response.data;
      if (kDebugMode) print('=== orderRetrieve response: ${data.runtimeType}');

      if (data == null || (data is Map && data['errorType'] == 'true')) {
        throw Exception(data?['error']?.toString() ?? 'Could not load ticket data');
      }

      // Try to send email via website (fallback)
      try {
        final apiClient = ref.read(apiClientProvider);
        await apiClient.postWithHeader(
          '/ticketing/cheapest-fare-flight-order-retrieve-send-pdf-email',
          data: {'orderRetrieveProvider': data is Map<String, dynamic> ? data : {}},
          extraHeaders: {'Action-Type': 'Create'},
        );
      } catch (e) {
        if (kDebugMode) print('=== Website email fallback error: $e');
      }

      if (!mounted) return;
      setState(() => _isSendingEmail = false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20), SizedBox(width: 8),
          Expanded(child: Text('E-Ticket PDF sent to your email!')),
        ]),
        backgroundColor: AppColors.success, duration: Duration(seconds: 4),
      ));
    } catch (e) {
      if (kDebugMode) print('=== Email error: $e');
      if (!mounted) return;
      setState(() => _isSendingEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $e'), backgroundColor: AppColors.error),
      );
    }
  }
}
