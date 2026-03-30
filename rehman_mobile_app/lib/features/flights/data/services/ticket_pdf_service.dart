import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TicketPdfService {
  static Future<void> generateAndShare(Map<String, dynamic> ticketData) async {
    final pdf = _buildPdf(ticketData);
    final pnr = ticketData['pnr'] ?? 'ticket';
    await Printing.sharePdf(bytes: await pdf.save(), filename: '$pnr.pdf');
  }

  static Future<void> generateAndPrint(Map<String, dynamic> ticketData) async {
    final pdf = _buildPdf(ticketData);
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  static pw.Document _buildPdf(Map<String, dynamic> data) {
    final itinerary = data['flightItinerary'] as Map<String, dynamic>? ?? data;
    final info = itinerary['flightItineraryInfo'] as Map<String, dynamic>? ?? {};
    final persons = itinerary['persons'] as List? ?? [];
    final legs = itinerary['legs'] as List? ?? [];
    final price = itinerary['price'] as Map<String, dynamic>? ?? {};
    final baggage = itinerary['baggage'] as List? ?? [];
    final policy = itinerary['policy'] as List? ?? [];
    final contacts = itinerary['contacts'] as List? ?? [];

    final pnr = info['itineraryRef'] ?? data['pnr'] ?? '';
    final reference = info['reference'] ?? pnr;
    final airType = info['airType'] ?? data['airType'] ?? '';
    final pnrStatus = info['pnrStatus'] ?? 'Open';

    // Passenger name
    String passengerName = '';
    if (persons.isNotEmpty) {
      final p = persons.first as Map<String, dynamic>;
      passengerName = '${p['lastName'] ?? ''}/${p['firstName'] ?? ''} ${p['nameTitle'] ?? ''}'.trim();
    }

    // Contact
    String phone = '';
    String email = '';
    if (contacts.isNotEmpty) {
      for (final c in contacts) {
        final contact = c as Map<String, dynamic>;
        if (contact['phone'] != null && contact['phone'].toString().isNotEmpty) phone = contact['phone'];
        if (contact['email'] != null && contact['email'].toString().isNotEmpty) email = contact['email'];
      }
    }
    if (phone.isEmpty) phone = data['phone'] ?? '';
    if (email.isEmpty) email = data['email'] ?? '';

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => [
          // Header
          _buildHeader(),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 15),

          // Traveller & Contact Details
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label("Traveller Name's"),
                    _value(passengerName.isNotEmpty ? passengerName : 'N/A'),
                    if (persons.length > 1)
                      ...persons.skip(1).map((p) {
                        final pax = p as Map<String, dynamic>;
                        return _value('${pax['lastName'] ?? ''}/${pax['firstName'] ?? ''} ${pax['nameTitle'] ?? ''}'.trim());
                      }),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('Contact Details'),
                    _detailLine('Name', passengerName),
                    _detailLine('Supplier', airType),
                    _detailLine('itineraryRef', pnr),
                    _detailLine('Reference', reference),
                    _detailLine('PNR Status', pnrStatus),
                    if (phone.isNotEmpty) _detailLine('Mobile No', phone),
                    if (email.isNotEmpty) _detailLine('Email', email),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // Flight Itinerary Table
          _buildFlightTable(legs),

          pw.SizedBox(height: 15),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 10),

          // Endorsements
          if (policy.isNotEmpty) ...[
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 160,
                  child: _label('Endorsment/Restrictions'),
                ),
                pw.Expanded(
                  child: pw.Text(
                    policy.map((p) => (p as Map<String, dynamic>)['text'] ?? '').join('\n'),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
          ],

          // Baggage
          if (baggage.isNotEmpty) ...[
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(width: 160, child: _label('Baggage')),
                pw.Expanded(
                  child: pw.Text(
                    baggage.map((b) {
                      final bag = b as Map<String, dynamic>;
                      return '${bag['passengerType'] ?? 'ADT'} ${bag['segment'] ?? ''} ${bag['baggageAllowance'] ?? ''}';
                    }).join(' / '),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
          ],

          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 5),

          // Price Summary
          _buildPriceRow(price),

          pw.SizedBox(height: 15),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 10),

          // Privacy notice
          pw.Text(
            'Data protection notice: your personal data will be processed in accordance with the applicable carriers privacy policy. '
            'And, if your booking is made via a reservation system provider (gds), with its privacy policy.',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),

          pw.SizedBox(height: 20),

          // Footer - branches
          _buildFooter(),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Rehman Travels', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
            pw.Text('rehmantravel.com', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          ],
        ),
        pw.Text('IATA', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
      ],
    );
  }

  static pw.Widget _buildFlightTable(List legs) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(3),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.2),
        5: const pw.FlexColumnWidth(1),
        6: const pw.FlexColumnWidth(1.2),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: ['Day', 'Date', 'City / Terminal / Stopover City', 'Time', 'Duration', 'Flight', 'Status']
              .map((h) => pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(h, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  ))
              .toList(),
        ),
        // Legs
        ...legs.map((leg) {
          final l = leg as Map<String, dynamic>;
          final depCode = l['departureCode'] ?? '';
          final arrCode = l['arrivalCode'] ?? '';
          final depAirport = l['departureAirportCode'] ?? depCode;
          final arrAirport = l['arrivalAirportCode'] ?? arrCode;
          final depTime = l['departureTime'] ?? '';
          final arrTime = l['arrivalTime'] ?? '';
          final duration = l['elapsedTime'] ?? l['duration'] ?? '';
          final flightNo = '${l['operatingAirlineCode'] ?? ''} ${l['operatingFlightNumber'] ?? ''}';
          final status = l['status'] == 'HK' ? 'Confirmed' : (l['status'] ?? '');
          final depDate = l['departureDate'] ?? '';

          // Parse day of week
          String dayName = '';
          try {
            final date = DateTime.parse(depDate);
            const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
            dayName = days[date.weekday - 1];
          } catch (_) {}

          // Format date short
          String dateShort = depDate;
          try {
            final date = DateTime.parse(depDate);
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            dateShort = '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
          } catch (_) {}

          return pw.TableRow(children: [
            _cell(dayName),
            _cell(dateShort),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('DEP $depCode - $depAirport', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('ARR $arrCode - $arrAirport', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(depTime, style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(arrTime, style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ),
            _cell(duration),
            _cell(flightNo),
            _cell(status),
          ]);
        }),
      ],
    );
  }

  static pw.Widget _buildPriceRow(Map<String, dynamic> price) {
    final baseFare = price['baseFare'] ?? 0;
    final taxes = price['taxes'] ?? 0;
    final totalFare = price['totalFare'] ?? 0;

    return pw.Row(children: [
      pw.Expanded(
        flex: 2,
        child: pw.Row(children: [
          _label('FOP'),
          pw.SizedBox(width: 8),
          pw.Text('REHMAN GROUP OF TRAVELS', style: const pw.TextStyle(fontSize: 9)),
        ]),
      ),
      pw.Expanded(child: pw.Row(children: [
        _label('Fare'),
        pw.SizedBox(width: 5),
        pw.Text('Rs$baseFare', style: const pw.TextStyle(fontSize: 9)),
      ])),
      pw.Expanded(child: pw.Row(children: [
        _label('Taxes'),
        pw.SizedBox(width: 5),
        pw.Text('Rs$taxes', style: const pw.TextStyle(fontSize: 9)),
      ])),
      pw.Container(
        padding: const pw.EdgeInsets.all(6),
        color: PdfColors.grey200,
        child: pw.Row(children: [
          pw.Text('Total\nFare', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 8),
          pw.Text('Rs$totalFare', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ]),
      ),
    ]);
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          _branchInfo('Islamabad', '+92 51 111 786 785'),
          _branchInfo('Lahore', '+92 42 111 786 785'),
          _branchInfo('Peshawar', '+92 91 72 51 62 6'),
          _branchInfo('UK', '+44 7985 257780'),
        ],
      ),
    );
  }

  static pw.Widget _branchInfo(String city, String phone) {
    return pw.Column(children: [
      pw.Text(city, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
      pw.Text(phone, style: const pw.TextStyle(fontSize: 8)),
    ]);
  }

  static pw.Widget _label(String text) {
    return pw.Text(text, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold));
  }

  static pw.Widget _value(String text) {
    return pw.Text(text, style: const pw.TextStyle(fontSize: 10));
  }

  static pw.Widget _detailLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.RichText(text: pw.TextSpan(children: [
        pw.TextSpan(text: '$label: ', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.TextSpan(text: value, style: const pw.TextStyle(fontSize: 9)),
      ])),
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }
}
