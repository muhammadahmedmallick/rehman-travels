import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../data/services/ticket_pdf_service.dart';
import '../providers/flight_search_provider.dart';

class TicketScreen extends ConsumerStatefulWidget {
  final String pnr;
  final String airType;
  final String vCarrier;

  const TicketScreen({
    super.key,
    required this.pnr,
    required this.airType,
    required this.vCarrier,
  });

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _ticketData;

  @override
  void initState() {
    super.initState();
    _fetchTicket();
  }

  Future<void> _fetchTicket() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      // Use X-Inertia header to get JSON instead of HTML
      final response = await apiClient.get(
        '/ticketing/cheapest-fare-flight-order-retrieve',
        queryParameters: {
          'at': widget.airType,
          'irf': widget.pnr,
          'rf': widget.pnr,
          'et': widget.pnr,
          'vc': widget.vCarrier,
          'cc': '',
          'cr': '',
        },
      );

      if (!mounted) return;

      final data = response.data;

      if (data is Map<String, dynamic>) {
        // Direct JSON or Inertia JSON
        final props = data['props'] as Map<String, dynamic>? ?? data;
        final orderRetrieve = props['orderRetrieveProvider'] as Map<String, dynamic>? ?? props;
        setState(() {
          _ticketData = orderRetrieve;
          _isLoading = false;
        });
      } else if (data is String) {
        // HTML response - parse Inertia data-page JSON
        final match = RegExp(r'data-page="([^"]*)"').firstMatch(data);
        if (match != null) {
          final decoded = match.group(1)!
              .replaceAll('&quot;', '"')
              .replaceAll('&amp;', '&')
              .replaceAll('&#039;', "'");
          final pageData = jsonDecode(decoded) as Map<String, dynamic>;
          final props = pageData['props'] as Map<String, dynamic>?;
          final orderRetrieve = props?['orderRetrieveProvider'] as Map<String, dynamic>?;
          setState(() {
            _ticketData = orderRetrieve;
            _isLoading = false;
          });
        } else {
          setState(() { _error = 'Could not parse ticket data'; _isLoading = false; });
        }
      }
    } catch (e) {
      if (kDebugMode) print('Ticket fetch error: $e');
      if (!mounted) return;
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('E-Ticket · ${widget.pnr}', style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
          if (_ticketData != null) ...[
            IconButton(
              onPressed: () => TicketPdfService.generateAndShare({..._ticketData!, 'pnr': widget.pnr, 'airType': widget.airType}),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              tooltip: 'Download PDF',
            ),
            IconButton(
              onPressed: _emailTicket,
              icon: const Icon(Icons.email_outlined),
              tooltip: 'Email Ticket',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Padding(
                  padding: AppPadding.screenH,
                  child: Text('Error: $_error', style: AppTextStyles.bodyMd.copyWith(color: AppColors.error)),
                ))
              : _buildTicketContent(),
    );
  }

  Widget _buildTicketContent() {
    final data = _ticketData ?? {};
    final info = data['flightItineraryInfo'] as Map<String, dynamic>? ?? {};
    final persons = data['persons'] as List? ?? [];
    final legs = data['legs'] as List? ?? [];
    final price = data['price'] as Map<String, dynamic>? ?? {};
    final baggage = data['baggage'] as List? ?? [];
    final policy = data['policy'] as List? ?? [];
    final contacts = data['contacts'] as List? ?? [];

    final pnr = info['itineraryRef'] ?? widget.pnr;
    final airType = info['airType'] ?? widget.airType;
    final pnrStatus = info['status'] ?? 'Open';
    final supplier = info['supplier'] ?? airType;

    String phone = '';
    String email = '';
    for (final c in contacts) {
      final contact = c as Map<String, dynamic>;
      if (contact['phone'] != null) phone = contact['phone'].toString();
      if (contact['email'] != null) email = contact['email'].toString();
    }

    return SingleChildScrollView(
      padding: AppPadding.cardLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PNR Header
          Container(
            width: double.infinity,
            padding: AppPadding.cardLg,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Rehman Travels', style: AppTextStyles.titleLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                const Spacer(),
                Text('IATA', style: AppTextStyles.titleSm.copyWith(color: AppColors.primary)),
              ]),
              AppGap.md,
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Traveller
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Traveller Name's", style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w700)),
                  AppGap.xs,
                  ...persons.map((p) {
                    final pax = p as Map<String, dynamic>;
                    final name = airType == 'Airsial'
                        ? '${pax['firstName'] ?? ''}'
                        : '${pax['lastName'] ?? ''}/${pax['firstName'] ?? ''}';
                    return Text(name, style: AppTextStyles.bodyMd);
                  }),
                ])),
                // Contact details
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Contact Details', style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w700)),
                  AppGap.xs,
                  _infoLine('Supplier', supplier),
                  _infoLine('PNR', pnr),
                  _infoLine('Reference', info['reference'] ?? pnr),
                  _infoLine('Status', pnrStatus),
                  if (phone.isNotEmpty) _infoLine('Mobile', phone),
                  if (email.isNotEmpty) _infoLine('Email', email),
                ])),
              ]),
            ]),
          ),

          AppGap.lg,

          // Flight Itinerary
          Text('Flight Itinerary', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
          AppGap.sm,
          ...legs.map((leg) => _buildLegCard(leg as Map<String, dynamic>)),

          AppGap.md,

          // Endorsements
          if (policy.isNotEmpty) ...[
            _sectionRow('Endorsment/Restrictions',
              policy.map((p) => (p as Map<String, dynamic>)['text'] ?? '').join('\n'),
            ),
            AppGap.md,
          ],

          // Baggage
          if (baggage.isNotEmpty) ...[
            _sectionRow('Baggage',
              baggage.map((b) {
                final bag = b as Map<String, dynamic>;
                return '${bag['passengerType'] ?? ''} ${bag['segment'] ?? ''} ${bag['baggageAllowance'] ?? ''}';
              }).join(' / '),
            ),
            AppGap.md,
          ],

          // Fare Summary
          Container(
            width: double.infinity,
            padding: AppPadding.card,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('FOP', style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w700)),
                Text(info['receivableAccount'] ?? 'REHMAN GROUP OF TRAVELS', style: AppTextStyles.hint),
              ])),
              _fareItem('Fare', 'Rs${price['baseFare'] ?? 0}'),
              _fareItem('Taxes', 'Rs${price['taxes'] ?? 0}'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.xs)),
                child: Column(children: [
                  Text('Total Fare', style: AppTextStyles.labelSm.copyWith(fontWeight: FontWeight.w700)),
                  Text('Rs${price['totalFare'] ?? 0}', style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.w800)),
                ]),
              ),
            ]),
          ),

          AppGap.lg,

          // Privacy notice
          Text(
            'Data protection notice: your personal data will be processed in accordance with the applicable carriers privacy policy.',
            style: AppTextStyles.hint.copyWith(fontSize: 8),
          ),

          AppGap.xl,
        ],
      ),
    );
  }

  Widget _buildLegCard(Map<String, dynamic> leg) {
    final depCode = leg['departureCode'] ?? '';
    final arrCode = leg['arrivalCode'] ?? '';
    final depAirport = leg['departureAirportCode'] ?? depCode;
    final arrAirport = leg['arrivalAirportCode'] ?? arrCode;
    final depTime = leg['departureTime']?.toString().substring(0, 5) ?? '';
    final arrTime = leg['arrivalTime']?.toString().substring(0, 5) ?? '';
    final depDate = leg['departureDate'] ?? '';
    final duration = leg['elapsedTime'] ?? '';
    final flightNo = '${leg['operatingAirlineCode'] ?? ''}${leg['operatingFlightNumber'] ?? ''}';
    final status = leg['status'] == 'HK' ? 'Confirmed' : (leg['status'] ?? '');

    // Day name
    String dayName = '';
    String dateShort = depDate;
    try {
      final date = DateTime.parse(depDate);
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      dayName = days[date.weekday - 1];
      dateShort = '${date.day} ${months[date.month - 1]}';
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppPadding.card,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        // Day + Date
        SizedBox(width: 50, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dayName, style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w700)),
          Text(dateShort, style: AppTextStyles.hint),
        ])),
        AppGap.hSm,
        // Route
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('DEP $depCode - $depAirport', style: AppTextStyles.bodySm),
          Text('ARR $arrCode - $arrAirport', style: AppTextStyles.bodySm),
        ])),
        // Time
        SizedBox(width: 45, child: Column(children: [
          Text(depTime, style: AppTextStyles.bodySm),
          Text(arrTime, style: AppTextStyles.bodySm),
        ])),
        AppGap.hSm,
        // Duration
        SizedBox(width: 45, child: Text(duration, style: AppTextStyles.hint)),
        // Flight
        SizedBox(width: 45, child: Text(flightNo, style: AppTextStyles.bodySm)),
        // Status
        Text(status, style: AppTextStyles.labelSm.copyWith(color: AppColors.success)),
      ]),
    );
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(text: TextSpan(style: AppTextStyles.bodySm, children: [
        TextSpan(text: '$label: ', style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700)),
        TextSpan(text: value),
      ])),
    );
  }

  Widget _sectionRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 130, child: Text(label, style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w700))),
      Expanded(child: Text(value, style: AppTextStyles.bodySm)),
    ]);
  }

  Widget _fareItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(children: [
        Text(label, style: AppTextStyles.labelSm.copyWith(fontWeight: FontWeight.w700)),
        Text(value, style: AppTextStyles.bodySm),
      ]),
    );
  }

  Future<void> _emailTicket() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.postWithHeader(
        '/ticketing/cheapest-fare-flight-order-retrieve-send-pdf-email',
        data: {'orderRetrieveProvider': widget.pnr},
        extraHeaders: {'Action-Type': 'Create'},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket sent to your email!'), backgroundColor: AppColors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error),
      );
    }
  }
}
