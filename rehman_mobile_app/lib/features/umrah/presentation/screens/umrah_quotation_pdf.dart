import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../providers/umrah_calculator_provider.dart';

class UmrahQuotationPdf {
  static const _primary = PdfColor.fromInt(0xFF05153F);
  static const _headerBlue = PdfColor.fromInt(0xFF1E3A8A);
  static const _accent = PdfColor.fromInt(0xFFD4A017);
  static const _borderGrey = PdfColor.fromInt(0xFFCCCCCC);
  static const _lightBg = PdfColor.fromInt(0xFFF5F6FA);

  static Future<pw.Document> build({
    required UmrahCalculatorState state,
    required CalcResponse result,
  }) async {
    final doc = pw.Document();
    final baseFont = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final theme = pw.ThemeData.withFont(base: baseFont, bold: boldFont);

    // Split hotels by city using input data
    final makkahHotels = <_HotelRow>[];
    final madinahHotels = <_HotelRow>[];
    for (var i = 0; i < state.hotels.length; i++) {
      final input = state.hotels[i];
      final meta = state.init.hotels.where((h) => h.id == input.hotelId);
      final hotelMeta = meta.isNotEmpty ? meta.first : null;
      final breakdown = i < result.breakdown.hotelDetails.length
          ? result.breakdown.hotelDetails[i]
          : null;
      final row = _HotelRow(
        index: i + 1,
        name: hotelMeta?.name ?? input.hotelName ?? '-',
        type: hotelMeta?.typeLabel ?? '',
        basis: hotelMeta?.basisLabel ?? '',
        checkIn: breakdown?.checkIn ?? _fmt(input.checkIn),
        checkOut: breakdown?.checkOut ?? _fmt(input.checkOut),
        double_: input.doubleRooms,
        triple: input.tripleRooms,
        quad: input.quadRooms,
        quint: input.quintRooms,
        nights: breakdown?.nights ?? input.nights,
        price: breakdown?.price ?? 0,
      );
      if (input.location.toLowerCase() == 'makkah') {
        makkahHotels.add(row);
      } else {
        madinahHotels.add(row);
      }
    }

    final sectorName = state.init.sectors
        .where((s) => s.id == state.sectorId)
        .map((s) => s.name)
        .firstWhere((_) => true, orElse: () => '');
    final vehicleName = state.init.vehicles
        .where((v) => v.id == state.vehicleId)
        .map((v) => v.name)
        .firstWhere((_) => true, orElse: () => '');
    final visaName = state.init.visas
        .where((v) => v.id == state.visaId)
        .map((v) => v.nationality)
        .firstWhere((_) => true, orElse: () => '');

    final totalTravelers = state.adults + state.children + state.infants;
    final quoteNumber =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.fromLTRB(24, 24, 24, 24),
        build: (context) => [
          _topHeader(quoteNumber),
          pw.SizedBox(height: 10),
          _sectionBand('Umrah Quotation'),
          _quotedToTable(state),
          pw.SizedBox(height: 10),
          if (makkahHotels.isNotEmpty) ...[
            _sectionBand('Makkah Hotel'),
            _hotelsTable(makkahHotels),
            pw.SizedBox(height: 8),
          ],
          if (madinahHotels.isNotEmpty) ...[
            _sectionBand('Madinah Hotel'),
            _hotelsTable(madinahHotels),
            pw.SizedBox(height: 8),
          ],
          _transportVisaRow(
            vehicleName: vehicleName,
            visaName: visaName,
            travelerCount: totalTravelers,
            totalNights: result.totalNights,
            transportEnabled: state.transportEnabled,
            visaEnabled: state.visaEnabled,
          ),
          pw.SizedBox(height: 10),
          if (sectorName.isNotEmpty || state.transportEnabled) ...[
            _sectionBand('Sector'),
            _sectorRow(sectorName, result),
            pw.SizedBox(height: 10),
          ],
          _grandTotalRow(result),
          pw.SizedBox(height: 14),
          _requirementsNote(),
          pw.SizedBox(height: 14),
          _contactStrip(),
          pw.SizedBox(height: 6),
          _footer(),
        ],
      ),
    );
    return doc;
  }

  // ---------- Sections ----------

  static pw.Widget _topHeader(String quoteNumber) {
    final now = DateTime.now();
    final dateStr =
        '${_dayName(now.weekday)} ${now.day} ${_monthName(now.month)} ${now.year}  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _primary, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('REHMAN TRAVELS',
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: _primary)),
              pw.Text('Your trusted travel partner',
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ]),
            pw.Text('IATA',
                style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF0066B3))),
          ],
        ),
        pw.Divider(color: _borderGrey, height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Quote # : $quoteNumber',
                style: pw.TextStyle(
                    fontSize: 9, fontWeight: pw.FontWeight.bold)),
            pw.Text(dateStr, style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ]),
    );
  }

  static pw.Widget _sectionBand(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: _headerBlue,
        borderRadius: pw.BorderRadius.circular(2),
      ),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _quotedToTable(UmrahCalculatorState s) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderGrey, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _lightBg),
          children: [
            _th('Name'),
            _th('Mobile'),
            _th('Email'),
          ],
        ),
        pw.TableRow(children: [
          _td(s.customerFirstName),
          _td(s.customerMobile),
          _td(s.customerEmail),
        ]),
      ],
    );
  }

  static pw.Widget _hotelsTable(List<_HotelRow> hotels) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderGrey, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(0.5),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1.5),
        4: pw.FlexColumnWidth(1.3),
        5: pw.FlexColumnWidth(1.3),
        6: pw.FlexColumnWidth(0.8),
        7: pw.FlexColumnWidth(0.8),
        8: pw.FlexColumnWidth(0.7),
        9: pw.FlexColumnWidth(0.7),
        10: pw.FlexColumnWidth(0.8),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _lightBg),
          children: [
            _th('No'),
            _th('Hotel Name'),
            _th('Type'),
            _th('Basis'),
            _th('Check In'),
            _th('Check Out'),
            _th('Dbl'),
            _th('Tpl'),
            _th('Qd'),
            _th('Qnt'),
            _th('Nts'),
          ],
        ),
        ...hotels.map((h) => pw.TableRow(children: [
              _td('${h.index}'),
              _td(h.name),
              _td(h.type),
              _td(h.basis),
              _td(h.checkIn),
              _td(h.checkOut),
              _td('${h.double_}'),
              _td('${h.triple}'),
              _td('${h.quad}'),
              _td('${h.quint}'),
              _td('${h.nights}'),
            ])),
      ],
    );
  }

  static pw.Widget _transportVisaRow({
    required String vehicleName,
    required String visaName,
    required int travelerCount,
    required int totalNights,
    required bool transportEnabled,
    required bool visaEnabled,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderGrey, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1.8),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _lightBg),
          children: [
            _th('Transport'),
            _th('Umrah Visa'),
            _th('Total Nights'),
          ],
        ),
        pw.TableRow(children: [
          _td(transportEnabled && vehicleName.isNotEmpty
              ? vehicleName
              : 'Not included'),
          _td(visaEnabled
              ? 'Umrah Visa ${visaName.isNotEmpty ? '($visaName)' : ''} for $travelerCount Pax'
              : 'Not included'),
          _td('$totalNights Night${totalNights == 1 ? '' : 's'} / ${totalNights + 1} Days'),
        ]),
      ],
    );
  }

  static pw.Widget _sectorRow(String sectorName, CalcResponse r) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _borderGrey, width: 0.5),
      ),
      child: pw.Text(
        sectorName.isEmpty ? '-' : sectorName,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  static pw.Widget _grandTotalRow(CalcResponse r) {
    final totals = r.totals;
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _lightBg,
        border: pw.Border.all(color: _accent, width: 1),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Grand Total',
              style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: _primary)),
          pw.Row(children: [
            _currencyPill('SAR', totals.sar),
            pw.SizedBox(width: 8),
            _currencyPill('USD', totals.usd),
            pw.SizedBox(width: 8),
            _currencyPill('GBP', totals.gbp),
          ]),
        ],
      ),
    );
  }

  static pw.Widget _currencyPill(String code, double v) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: _primary,
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Text('$code ${_num(v)}',
          style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _requirementsNote() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _borderGrey, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Requirements',
                    style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: _primary)),
                pw.SizedBox(height: 4),
                _bullet('Passport valid for 6 months'),
                _bullet('Copy of CNIC / PID'),
                _bullet('1 passport-size photograph with any background'),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _borderGrey, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Note',
                    style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: _primary)),
                pw.SizedBox(height: 4),
                _bullet('No booking(s) made yet.'),
                _bullet('Availability and rates are subject to change at the time of confirmation.'),
                _bullet('Standard check-in is 5 PM and check-out is 12 NOON.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _contactStrip() {
    pw.Widget city(String name, String phone) => pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            alignment: pw.Alignment.center,
            child: pw.Column(children: [
              pw.Text(name,
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold)),
              pw.Text(phone,
                  style: const pw.TextStyle(
                      color: PdfColors.white, fontSize: 9)),
            ]),
          ),
        );
    return pw.Container(
      decoration: const pw.BoxDecoration(color: _primary),
      child: pw.Row(children: [
        city('Islamabad', '+92 51 111 786 785'),
        city('Lahore', '+92 42 111 786 785'),
        city('Peshawar', '+92 91 111 786 785'),
        city('UK', '+44 7985 257 780'),
      ]),
    );
  }

  static pw.Widget _footer() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text('www.rehmantravel.com',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
      ],
    );
  }

  // ---------- Helpers ----------

  static pw.Widget _th(String t) => pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(t,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _primary)),
      );

  static pw.Widget _td(String t) => pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(t,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 9)),
      );

  static pw.Widget _bullet(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('• ', style: const pw.TextStyle(fontSize: 9)),
            pw.Expanded(
                child: pw.Text(t, style: const pw.TextStyle(fontSize: 9))),
          ],
        ),
      );

  static String _num(double v) {
    final s = v.toStringAsFixed(0);
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  static String _fmt(DateTime? d) {
    if (d == null) return '-';
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  static String _dayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(weekday - 1).clamp(0, 6)];
  }

  static String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[(month - 1).clamp(0, 11)];
  }
}

class _HotelRow {
  final int index;
  final String name;
  final String type;
  final String basis;
  final String checkIn;
  final String checkOut;
  final int double_;
  final int triple;
  final int quad;
  final int quint;
  final int nights;
  final double price;

  const _HotelRow({
    required this.index,
    required this.name,
    required this.type,
    required this.basis,
    required this.checkIn,
    required this.checkOut,
    required this.double_,
    required this.triple,
    required this.quad,
    required this.quint,
    required this.nights,
    required this.price,
  });
}
