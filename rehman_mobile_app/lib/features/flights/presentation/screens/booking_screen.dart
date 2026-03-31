import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../providers/flight_search_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? flightData;
  const BookingScreen({super.key, this.flightData});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _areaCode = '+92';
  bool _isSubmitting = false;

  late Map<String, dynamic> _resolvedFlightData;
  late int _adultsCount;
  late int _childrenCount;
  late int _infantsCount;
  late List<_PassengerData> _passengers;

  @override
  void initState() {
    super.initState();

    if (widget.flightData != null) {
      _resolvedFlightData = widget.flightData!;
    } else {
      final pendingData = ref.read(pendingBookingDataProvider);
      _resolvedFlightData = pendingData ?? {};
    }

    ref.read(isBookingJourneyProvider.notifier).state = false;

    final searchParams = ref.read(flightSearchProvider).searchParams;
    _adultsCount = (searchParams?['adultsCount'] as int?) ?? 1;
    _childrenCount = (searchParams?['childrenCount'] as int?) ?? 0;
    _infantsCount = (searchParams?['infantsCount'] as int?) ?? 0;

    _passengers = [];
    for (int i = 0; i < _adultsCount; i++) {
      _passengers.add(_PassengerData(type: 'adult', index: i + 1));
    }
    for (int i = 0; i < _childrenCount; i++) {
      _passengers.add(_PassengerData(type: 'child', index: i + 1));
    }
    for (int i = 0; i < _infantsCount; i++) {
      _passengers.add(_PassengerData(type: 'infant', index: i + 1));
    }

    if (kDebugMode) {
      _emailController.text = 'rao.noman082@gmail.com';
      _phoneController.text = '3332256193';
      for (final p in _passengers) {
        p.firstNameController.text = 'Rao';
        p.lastNameController.text = 'Noman';
        p.title = p.type == 'adult' ? 'Mr' : 'Master';
        p.dobController.text = '22-04-1993';
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    for (final p in _passengers) {
      p.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flight = _resolvedFlightData;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: AppBackButton(),
        title: Text('Traveler Information', style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => _showBookingDetails(context, flight),
            icon: const Icon(Icons.info, size: AppIconSize.sm, color: Colors.white),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppGap.md,

            // Contact Information
            _buildSectionHeader('Contact Information', Icons.phone_outlined),
            Padding(
              padding: AppPadding.screenH,
              child: Container(
                padding: AppPadding.cardLg,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.border)),
                child: Column(children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.bodyLg,
                    decoration: InputDecoration(labelText: 'Email Address *', labelStyle: AppTextStyles.caption, hintText: 'your@email.com', prefixIcon: const Icon(Icons.email_outlined, size: AppIconSize.lg)),
                    validator: (v) { if (v == null || v.isEmpty) return 'Email is required'; if (!v.contains('@')) return 'Enter a valid email'; return null; },
                  ),
                  AppGap.md,
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      width: 90,
                      child: DropdownButtonFormField<String>(
                        value: _areaCode,
                        style: AppTextStyles.bodyMd,
                        decoration: InputDecoration(labelText: 'Code *', labelStyle: AppTextStyles.caption, contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14)),
                        items: const [
                          DropdownMenuItem(value: '+92', child: Text('+92')),
                          DropdownMenuItem(value: '+971', child: Text('+971')),
                          DropdownMenuItem(value: '+966', child: Text('+966')),
                          DropdownMenuItem(value: '+44', child: Text('+44')),
                          DropdownMenuItem(value: '+1', child: Text('+1')),
                        ],
                        onChanged: (v) => setState(() => _areaCode = v ?? '+92'),
                      ),
                    ),
                    AppGap.hSm,
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: AppTextStyles.bodyLg,
                        decoration: InputDecoration(labelText: 'Mobile Number *', labelStyle: AppTextStyles.caption, hintText: '3XX XXXXXXX'),
                        validator: (v) { if (v == null || v.isEmpty) return 'Phone is required'; if (v.length < 10) return 'Enter valid number'; return null; },
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
            AppGap.lg,

            // Passenger Forms
            ...List.generate(_passengers.length, (i) => _buildPassengerForm(_passengers[i], i + 1)),

            const SizedBox(height: 100),
          ]),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(flight),
    );
  }

  // ═══════════════════════════════════════════
  //  PASSENGER FORM
  // ═══════════════════════════════════════════
  Widget _buildPassengerForm(_PassengerData pax, int paxNumber) {
    final typeLabel = pax.type == 'adult' ? 'Adult' : pax.type == 'child' ? 'Child' : 'Infant';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionHeader('Passenger $paxNumber ($typeLabel)', Icons.person_outline),
      Padding(
        padding: AppPadding.screenH,
        child: Container(
          padding: AppPadding.cardLg,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Title
            Text('Title *', style: AppTextStyles.labelLg),
            AppGap.sm,
            Wrap(spacing: 8, children: _getTitleOptions(pax.type).map((title) {
              final isSelected = pax.title == title;
              return GestureDetector(
                onTap: () => setState(() => pax.title = title),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(title, style: AppTextStyles.labelLg.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
                ),
              );
            }).toList()),
            AppGap.md,

            // First Name + Last Name
            TextFormField(
              controller: pax.firstNameController, textCapitalization: TextCapitalization.words, style: AppTextStyles.bodyLg,
              decoration: InputDecoration(labelText: 'First Name *', labelStyle: AppTextStyles.caption, hintText: 'As per passport/CNIC'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            AppGap.md,
            TextFormField(
              controller: pax.lastNameController, textCapitalization: TextCapitalization.words, style: AppTextStyles.bodyLg,
              decoration: InputDecoration(labelText: 'Last Name *', labelStyle: AppTextStyles.caption, hintText: 'As per passport/CNIC'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            AppGap.md,

            // Date of Birth
            TextFormField(
              controller: pax.dobController, readOnly: true, style: AppTextStyles.bodyLg,
              decoration: InputDecoration(labelText: 'Date of Birth *', labelStyle: AppTextStyles.caption, hintText: 'DD-MM-YYYY',
                suffixIcon: const Icon(Icons.calendar_today, size: 18)),
              onTap: () => _pickDate(pax.dobController),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ]),
        ),
      ),
      AppGap.lg,
    ]);
  }

  // ═══════════════════════════════════════════
  //  SUBMIT BOOKING - Website format payload
  // ═══════════════════════════════════════════
  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final flight = _resolvedFlightData;
    final searchState = ref.read(flightSearchProvider);
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;

    // Phone: +92-3332256193
    final phoneNumber = '$_areaCode-${_phoneController.text.trim()}';

    // Build persons as array of objects (Exalted format - matches Postman payload)
    final persons = <Map<String, dynamic>>[];
    final passengersForPayment = <Map<String, dynamic>>[];

    for (final p in _passengers) {
      persons.add({
        'type': p.type,
        'nameTitle': p.title,
        'firstName': p.firstNameController.text.trim(),
        'lastName': p.lastNameController.text.trim(),
        'dateOfBirth': p.dobController.text.trim(),
        'gender': (p.title == 'Mr' || p.title == 'Master') ? 'M' : 'F',
        'document': {
          'type': 'P',
          'number': 'AIHDECEFH',
          'expirationDate': '2034-05-29',
          'nationality': 'PK',
          'issueDate': '2023-05-29',
          'issueCountry': 'PK',
        },
      });

      passengersForPayment.add({
        'nameTitle': p.title,
        'firstName': p.firstNameController.text.trim(),
        'lastName': p.lastNameController.text.trim(),
        'type': p.type,
      });
    }

    final outboundDate = searchState.searchParams?['outboundDate'] ?? '';

    // Extract bookingInfo and build bookingKeys
    final bookingInfo = flight['bookingInfo']?.toString() ?? rawData?['bookingInfo']?.toString() ?? '';

    // Build bookingKeys - collect from all legs' bookingKey fields + bookingInfo
    final bookingKeys = <Map<String, dynamic>>[];

    // Check rawData for leg-level bookingKeys
    final rawLegs = rawData?['legs'] as Map<String, dynamic>?;
    if (rawLegs != null) {
      for (int i = 1; i <= 6; i++) {
        final leg = rawLegs['leg$i'] as Map<String, dynamic>?;
        if (leg == null) break;
        final bk = leg['bookingKey']?.toString();
        if (bk != null && bk.isNotEmpty) {
          bookingKeys.add({'bookingRefKey': bk});
        }
      }
    }

    // Fallback: use bookingInfo as single key
    if (bookingKeys.isEmpty && bookingInfo.isNotEmpty) {
      bookingKeys.add({'bookingRefKey': bookingInfo});
    }

    if (kDebugMode) {
      print('=== FLIGHT provider: ${flight['provider']}');
      print('=== FLIGHT jSessionId: ${flight['jSessionId']?.toString().substring(0, 30)}...');
      print('=== FLIGHT bookingInfo: ${bookingInfo.substring(0, bookingInfo.length > 30 ? 30 : bookingInfo.length)}...');
      print('=== FLIGHT bookingKeys count: ${bookingKeys.length}');
      print('=== FLIGHT vCarrier: ${priceData?['validatingCarrier'] ?? flight['airlineCode']}');
    }

    // Exalted orderCreate payload (matches Postman exactly)
    final payload = {
      'jSessionId': flight['jSessionId'] ?? '',
      'adultsCount': _adultsCount.toString(),
      'childrenCount': _childrenCount.toString(),
      'infantsCount': _infantsCount.toString(),
      'phoneNumber': phoneNumber,
      'email': _emailController.text.trim(),
      'airType': flight['provider'] ?? '',
      'vCarrier': priceData?['validatingCarrier'] ?? flight['airlineCode'] ?? '',
      'currencyRate': '1',
      'currencyCode': 'PKR',
      'departureDate': outboundDate,
      'partyAccount': 'Rehman Group of Travels',
      'contactInfo': [
        {'type': 'H', 'phone': phoneNumber},
        {'type': 'O', 'phone': '009251111177777'},
      ],
      'persons': persons,
      'bookingKeys': bookingKeys,
      'bookingInfo': bookingInfo,
      'seats': [''],
      'baggage': [''],
      'meals': [''],
    };

    if (kDebugMode) {
      print('=== EXALTED ORDER CREATE PAYLOAD:');
      print(jsonEncode(payload));
    }

    try {
      final exaltedClient = ref.read(exaltedApiClientProvider);
      final response = await exaltedClient.post('/orderCreate', data: payload);

      if (!mounted) return;

      var data = response.data;
      if (kDebugMode) {
        print('=== ORDER CREATE RESPONSE: $data');
        print('=== STATUS: ${response.statusCode}');
      }

      // Parse JSON string if needed
      if (data is String && data.isNotEmpty && data.trimLeft().startsWith('{')) {
        try { data = jsonDecode(data); } catch (_) {}
      }

      String? pnr;
      String? reference;
      String? echoToken;
      String? vCarrierResp;
      String? jSessionIdResp;
      Map<String, dynamic>? orderData;

      if (data is Map<String, dynamic>) {
        // Exalted response: { flightItinerary: { flightItineraryInfo: { itineraryRef, ... }, price: {...}, persons: [...], legs: [...] } }
        final itinerary = data['flightItinerary'] as Map<String, dynamic>?;
        final info = itinerary?['flightItineraryInfo'] as Map<String, dynamic>?;

        // Check for errors
        if (info?['errorType'] == 'true' || data['errorType'] == 'true') {
          setState(() => _isSubmitting = false);
          final error = info?['error']?.toString() ?? data['error']?.toString() ?? 'Booking failed';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.error));
          return;
        }

        if (info != null) {
          pnr = info['itineraryRef']?.toString();
          reference = info['reference']?.toString() ?? pnr;
          echoToken = info['echoToken']?.toString() ?? pnr;
          jSessionIdResp = info['jSessionId']?.toString();
          vCarrierResp = (itinerary?['price'] as Map<String, dynamic>?)?['validatingCarrier']?.toString();
          orderData = itinerary;
        } else {
          // Fallback: flat response
          pnr = data['itineraryRef']?.toString() ?? data['reference']?.toString();
          reference = data['reference']?.toString() ?? pnr;
          echoToken = data['echoToken']?.toString() ?? pnr;
          vCarrierResp = data['vCarrier']?.toString();
          jSessionIdResp = data['jSessionId']?.toString();
        }
      }

      if (kDebugMode) print('=== PNR: $pnr, ref: $reference, echo: $echoToken');

      if (pnr == null || pnr!.isEmpty) {
        setState(() => _isSubmitting = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data is Map ? (data['message']?.toString() ?? 'Booking failed') : 'Booking failed - no PNR received'),
          backgroundColor: AppColors.error,
        ));
        return;
      }

      setState(() => _isSubmitting = false);

      // Extract price from order response
      final orderPrice = (orderData?['price'] as Map<String, dynamic>?);
      final totalFare = orderPrice?['totalFare'] ?? orderPrice?['totalAmount'] ?? flight['price'];

      if (mounted) {
        context.push(AppRoutes.payment, extra: {
          'pnr': pnr,
          'itineraryRef': pnr,
          'reference': reference ?? pnr,
          'echoToken': echoToken ?? pnr,
          'jSessionId': jSessionIdResp ?? flight['jSessionId'] ?? '',
          'airType': flight['provider'] ?? '',
          'vCarrier': vCarrierResp ?? priceData?['validatingCarrier'] ?? flight['airlineCode'] ?? '',
          'flightData': flight,
          'passengers': passengersForPayment,
          'totalPrice': totalFare,
          'email': _emailController.text.trim(),
          'phone': phoneNumber,
          'orderData': orderData,
        });
      }
    } catch (e) {
      if (kDebugMode) print('Booking error: $e');
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booking failed: $e'), backgroundColor: AppColors.error,
        action: SnackBarAction(label: 'Retry', textColor: Colors.white, onPressed: _submitBooking),
      ));
    }
  }

  // ═══════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════

  List<String> _getTitleOptions(String type) {
    if (type == 'child' || type == 'infant') return ['Master', 'Miss'];
    return ['Mr', 'Mrs', 'Ms'];
  }

  Future<void> _pickDate(TextEditingController controller, {String format = 'dd-MM-yyyy'}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().add(const Duration(days: 365 * 15)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: Colors.white)),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = DateFormat(format).format(picked);
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(children: [
        Icon(icon, size: AppIconSize.lg, color: AppColors.primary), AppGap.hSm,
        Text(title, style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _buildBottomBar(Map<String, dynamic> flight) {
    return Container(
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SafeArea(
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showBookingDetails(context, flight),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PKR ${_formatPrice(flight['price'] ?? 0)}', style: AppTextStyles.priceLg),
                Row(children: [
                  Text('View Details', style: AppTextStyles.hint.copyWith(color: AppColors.primary)),
                  const SizedBox(width: 2),
                  Icon(Icons.keyboard_arrow_up, size: AppIconSize.sm, color: AppColors.primary),
                ]),
              ]),
            ),
          ),
          AppGap.hLg,
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitBooking,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              child: _isSubmitting
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Continue'),
            ),
          ),
        ]),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> flight) {
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final allLegs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final totalPrice = (flight['price'] as num?)?.toDouble() ?? 0;
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;
    final baseFare = _parseDouble(priceData?['baseFare'] ?? priceData?['baseFarePerAdult']);
    final taxes = _parseDouble(priceData?['taxes'] ?? priceData?['taxesPerAdult']);
    final airlineCode = flight['airlineCode'] ?? '';

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75, maxChildSize: 0.92, minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
          child: Column(children: [
            AppGap.sm,
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: AppPadding.screenHLg.copyWith(top: AppSpacing.lg, bottom: AppSpacing.sm),
              child: Row(children: [
                Text('Flight Details', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ]),
            ),
            Expanded(
              child: ListView(controller: scrollController, padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
                // Airline Header
                Container(
                  padding: AppPadding.cardLg,
                  decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36, padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.sm), border: Border.all(color: AppColors.border)),
                      child: Image.network(
                        'https://www.rehmantravel.com/logos/${airlineCode.toUpperCase()}.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Center(child: Text(airlineCode, style: AppTextStyles.labelSm.copyWith(color: AppColors.primary))),
                      ),
                    ),
                    AppGap.hSm,
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(flight['airlineName'] ?? '', style: AppTextStyles.labelLg),
                      Text('${flight['flightNumber'] ?? ''} · ${flight['provider'] ?? ''}', style: AppTextStyles.hint),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (flight['isRefundable'] == true ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        flight['isRefundable'] == true ? 'Refundable' : 'Non-Refundable',
                        style: AppTextStyles.labelSm.copyWith(color: flight['isRefundable'] == true ? AppColors.success : AppColors.error),
                      ),
                    ),
                  ]),
                ),
                AppGap.md,

                // Flight Legs
                if (allLegs.length > 2) ...[
                  // Multi-city
                  for (int i = 0; i < allLegs.length; i++) ...[
                    _buildFlightLegCard('Flight ${i + 1}', allLegs[i], flight),
                    if (i < allLegs.length - 1) AppGap.sm,
                  ],
                ] else ...[
                  // Outbound
                  _buildFlightLegCard(
                    returnLeg != null ? 'Departure' : 'Flight',
                    {
                      'departureCode': flight['departureCode'], 'arrivalCode': flight['arrivalCode'],
                      'departureTime': flight['departureTime'], 'arrivalTime': flight['arrivalTime'],
                      'duration': flight['duration'], 'stops': flight['stops'], 'baggage': flight['baggage'],
                    },
                    flight,
                  ),
                  if (returnLeg != null) ...[
                    AppGap.sm,
                    _buildFlightLegCard('Return', returnLeg, flight),
                  ],
                ],
                AppGap.md,

                // Details Row
                Container(
                  padding: AppPadding.cardLg,
                  decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Column(children: [
                    _detailItem('Class', flight['cabin'] ?? 'Economy'),
                    _detailItem('Baggage', flight['baggage'] ?? '20kg'),
                    _detailItem('Stops', (flight['stops'] ?? 0) == 0 ? 'Direct' : '${flight['stops']} Stop'),
                  ]),
                ),
                AppGap.md,

                // Price Breakdown
                Container(
                  padding: AppPadding.cardLg,
                  decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Price Breakdown', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
                    AppGap.md,
                    if (baseFare > 0) _priceRow('Base Fare', baseFare),
                    if (taxes > 0) _priceRow('Taxes & Fees', taxes),
                    const Divider(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
                      Text('PKR ${_formatPrice(totalPrice)}', style: AppTextStyles.priceMd),
                    ]),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildFlightLegCard(String label, Map<String, dynamic> leg, Map<String, dynamic> flight) {
    final depCode = leg['departureCode'] ?? '';
    final arrCode = leg['arrivalCode'] ?? '';
    final depTime = leg['departureTime'] ?? '--:--';
    final arrTime = leg['arrivalTime'] ?? '--:--';
    final duration = leg['duration'] ?? '--';
    final stops = leg['stops'] ?? 0;
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    final baggage = leg['baggage'] ?? flight['baggage'] ?? '20kg';

    return Container(
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
        AppGap.sm,
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(depTime, style: AppTextStyles.titleLg),
            Text(depCode, style: AppTextStyles.caption),
          ])),
          Expanded(child: Column(children: [
            Text(duration, style: AppTextStyles.hint),
            AppGap.xs,
            Row(children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5))),
              Expanded(child: Container(height: 1, color: AppColors.border)),
              Icon(Icons.flight, size: AppIconSize.xs, color: AppColors.primary),
              Expanded(child: Container(height: 1, color: AppColors.border)),
              Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
            ]),
            AppGap.xs,
            Text(stopsInt == 0 ? 'Direct' : '$stopsInt Stop', style: AppTextStyles.hint.copyWith(fontSize: 9, color: stopsInt == 0 ? AppColors.success : AppColors.textHint)),
          ])),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(arrTime, style: AppTextStyles.titleLg),
            Text(arrCode, style: AppTextStyles.caption),
          ])),
        ]),
        AppGap.sm,
        Row(children: [
          Icon(Icons.luggage_outlined, size: 14, color: AppColors.textHint),
          const SizedBox(width: 4),
          Text(baggage, style: AppTextStyles.hint.copyWith(fontSize: 11)),
        ]),
      ]),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _priceRow(String label, double amount) {
    if (amount <= 0) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
      Text('PKR ${_formatPrice(amount)}', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
    ]));
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }

  String _formatPrice(dynamic price) {
    if (price is int) return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (price is double) return price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return price.toString();
  }
}

// ═══════════════════════════════════════════
//  PASSENGER DATA MODEL
// ═══════════════════════════════════════════
class _PassengerData {
  final String type; // adult, child, infant
  final int index;
  String title;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;

  _PassengerData({required this.type, required this.index})
      : title = (type == 'adult') ? 'Mr' : 'Master',
        firstNameController = TextEditingController(),
        lastNameController = TextEditingController(),
        dobController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
  }
}
