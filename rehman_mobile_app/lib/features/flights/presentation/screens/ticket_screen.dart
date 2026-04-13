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
import '../../../../app/widgets/app_back_button.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../../../../core/utils/time_format.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
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
  String get vCarrier => booking['vCarrier']?.toString() ?? flight['airlineCode']?.toString() ?? '';
  String get email => booking['email']?.toString() ?? '';
  String get phone => booking['phone']?.toString() ?? '';
  String get airlineName => priceData['airlineName'] ?? flight['airlineName'] ?? 'Airline';
  String get cabin => flight['cabin'] == 'C' ? 'Business' : flight['cabin'] == 'F' ? 'First' : 'Economy';
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('E-Ticket', style: AppTextStyles.titleSm.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: AppBackButton(onPressed: () => context.go(AppRoutes.home)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          RepaintBoundary(key: _ticketKey, child: _buildTicketCard()),
          const SizedBox(height: 100),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ═══════════════════════════════════════════
  //  SINGLE TICKET CARD
  // ═══════════════════════════════════════════
  Widget _buildTicketCard() {
    final totalPrice = booking['totalPrice'] ?? flight['price'] ?? 0;
    final baseFare = _parseNum(priceData['baseFare'] ?? priceData['baseFarePerAdult']);
    final taxes = _parseNum(priceData['taxes'] ?? priceData['taxesPerAdult']);

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
              _detailRow('Status', 'Confirmed'),
              if (phone.isNotEmpty) _detailRow('Mobile No', phone),
              if (email.isNotEmpty) _detailRow('Email', email),
            ])),
          ]),
        ),

        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // ══════ FLIGHT ITINERARY TABLE ══════
        _buildItineraryRow(
          depCode: depCode,
          arrCode: arrCode,
          depTime: depTime,
          arrTime: arrTime,
          durationStr: duration,
          flightNum: flightNumber,
          isReturn: false,
        ),

        if (flight['returnLeg'] != null) ...[
          const Divider(height: 1, indent: 14, endIndent: 14, color: Color(0xFFE5E7EB)),
          _buildItineraryRow(
            depCode: (flight['returnLeg'] as Map<String, dynamic>)['departureCode'] ?? '',
            arrCode: (flight['returnLeg'] as Map<String, dynamic>)['arrivalCode'] ?? '',
            depTime: formatFlightTime((flight['returnLeg'] as Map<String, dynamic>)['departureTime']?.toString()),
            arrTime: formatFlightTime((flight['returnLeg'] as Map<String, dynamic>)['arrivalTime']?.toString()),
            durationStr: (flight['returnLeg'] as Map<String, dynamic>)['duration'] ?? '',
            flightNum: (flight['returnLeg'] as Map<String, dynamic>)['flightNumber'] ?? flightNumber,
            isReturn: true,
          ),
        ],

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
            Expanded(child: Text('ADT $depCode-$arrCode $baggage${flight['returnLeg'] != null ? ' / ADT $arrCode-$depCode $baggage' : ''}',
              style: const TextStyle(fontSize: 11))),
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
                    child: Text(_currencyPrice((totalPrice is num ? totalPrice.toDouble() : double.tryParse(totalPrice.toString()) ?? 0)),
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

  // ── ITINERARY ROW (Table-like) ──
  Widget _buildItineraryRow({
    required String depCode,
    required String arrCode,
    required String depTime,
    required String arrTime,
    required String durationStr,
    required String flightNum,
    required bool isReturn,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Airline logo + name row
        Row(children: [
          Container(
            width: 28, height: 28, padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
            child: Image.network(
              'https://www.rehmantravel.com/logos/${vCarrier.toUpperCase()}.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Center(child: Text(vCarrier, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary))),
            ),
          ),
          const SizedBox(width: 8),
          Text(airlineName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('DEP $depCode  ·  ARR $arrCode', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 10),
        // Route visual
        Row(children: [
          // DEP
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depCode, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(depTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ])),
          // Route line
          Expanded(flex: 3, child: Column(children: [
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
            const SizedBox(height: 3),
            Text(stopsInt == 0 ? 'Direct' : '$stopsInt Stop', style: TextStyle(fontSize: 9, color: AppColors.textHint)),
          ])),
          // ARR
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrCode, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            const SizedBox(height: 2),
            Text(arrTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ])),
        ]),
        const SizedBox(height: 8),
        // Flight + Status row
        Row(children: [
          Text('Flight: ', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          Text(flightNum, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFF2ECC71).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: const Text('Confirmed', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF2ECC71))),
          ),
        ]),
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
