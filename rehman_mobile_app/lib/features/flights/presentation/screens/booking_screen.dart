import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../core/constants/api_endpoints.dart';
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
      _passengers.add(_PassengerData(type: 'Adult', index: i + 1));
    }
    for (int i = 0; i < _childrenCount; i++) {
      _passengers.add(_PassengerData(type: 'Child', index: i + 1));
    }
    for (int i = 0; i < _infantsCount; i++) {
      _passengers.add(_PassengerData(type: 'Infant', index: i + 1));
    }

    // Pre-fill for debug testing
    if (kDebugMode) {
      _emailController.text = 'rao.noman082@gmail.com';
      _phoneController.text = '3001234567';
      for (final p in _passengers) {
        p.firstNameController.text = 'Rao';
        p.lastNameController.text = 'Noman';
        p.title = 'Mr';
        p.dobDay = '22';
        p.dobMonth = '04';
        p.dobYearController.text = '1993';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Traveler Information', style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
        actions: [
          TextButton.icon(
            onPressed: () => _showBookingDetails(context, flight),
            icon: const Icon(Icons.info, size: AppIconSize.sm, color: Colors.white),
            label: Text('', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGap.md,

              // Contact Details
              _buildSectionHeader('Contact Information', Icons.phone_outlined),
              Padding(
                padding: AppPadding.screenH,
                child: Container(
                  padding: AppPadding.cardLg,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyLg,
                        decoration: InputDecoration(
                          labelText: 'Email Address *',
                          labelStyle: AppTextStyles.caption,
                          hintText: 'your@email.com',
                          prefixIcon: const Icon(Icons.email_outlined, size: AppIconSize.lg),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Email is required';
                          if (!value.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      AppGap.md,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 90,
                            child: DropdownButtonFormField<String>(
                              value: _areaCode,
                              style: AppTextStyles.bodyMd,
                              decoration: InputDecoration(
                                labelText: 'Code *',
                                labelStyle: AppTextStyles.caption,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                              ),
                              items: const [
                                DropdownMenuItem(value: '+92', child: Text('+92')),
                                DropdownMenuItem(value: '+971', child: Text('+971')),
                                DropdownMenuItem(value: '+966', child: Text('+966')),
                                DropdownMenuItem(value: '+44', child: Text('+44')),
                                DropdownMenuItem(value: '+1', child: Text('+1')),
                              ],
                              onChanged: (v) => setState(() => _areaCode = v ?? '+92'),
                              validator: (v) => v == null ? 'Required' : null,
                            ),
                          ),
                          AppGap.hSm,
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: AppTextStyles.bodyLg,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number *',
                                labelStyle: AppTextStyles.caption,
                                hintText: '3XX XXXXXXX',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Phone is required';
                                if (value.length < 10) return 'Enter valid number';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              AppGap.lg,

              // Passenger Forms
              ...List.generate(_passengers.length, (index) {
                return _buildPassengerForm(_passengers[index], index + 1);
              }),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showBookingDetails(context, flight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PKR ${_formatPrice(flight['price'] ?? 0)}', style: AppTextStyles.priceLg),
                      Row(
                        children: [
                          Text('View Details', style: AppTextStyles.hint.copyWith(color: AppColors.primary)),
                          const SizedBox(width: 2),
                          Icon(Icons.keyboard_arrow_up, size: AppIconSize.sm, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> flight) {
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final totalPrice = (flight['price'] as num?)?.toDouble() ?? 0;
    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;
    final baseFare = _parseDouble(priceData?['baseFare'] ?? priceData?['baseFarePerAdult']);
    final taxes = _parseDouble(priceData?['taxes'] ?? priceData?['taxesPerAdult']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            children: [
              AppGap.sm,
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: AppPadding.screenHLg.copyWith(top: AppSpacing.lg, bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Text('Booking Details', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    // Flight Route
                    Container(
                      padding: AppPadding.cardLg,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32, height: 32, padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.xs + 2)),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  'https://www.rehmantravel.com/logos/${(flight['airlineCode'] ?? 'PK').toString().toUpperCase()}.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Center(child: Text(flight['airlineCode'] ?? '', style: AppTextStyles.labelSm)),
                                ),
                              ),
                              AppGap.hSm,
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(flight['airlineName'] ?? '', style: AppTextStyles.labelLg),
                                Text(flight['flightNumber'] ?? '', style: AppTextStyles.hint),
                              ])),
                            ],
                          ),
                          AppGap.md,
                          _buildRouteSummary(
                            label: returnLeg != null ? 'Departure' : null,
                            departureCode: flight['departureCode'] ?? '',
                            arrivalCode: flight['arrivalCode'] ?? '',
                            departureTime: flight['departureTime'] ?? '--:--',
                            arrivalTime: flight['arrivalTime'] ?? '--:--',
                            duration: flight['duration'] ?? '--',
                          ),
                          if (returnLeg != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(children: [
                                Expanded(child: Container(height: 1, color: AppColors.border)),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('Return', style: AppTextStyles.hint.copyWith(fontSize: 9))),
                                Expanded(child: Container(height: 1, color: AppColors.border)),
                              ]),
                            ),
                            _buildRouteSummary(
                              departureCode: returnLeg['departureCode'] ?? '',
                              arrivalCode: returnLeg['arrivalCode'] ?? '',
                              departureTime: returnLeg['departureTime'] ?? '--:--',
                              arrivalTime: returnLeg['arrivalTime'] ?? '--:--',
                              duration: returnLeg['duration'] ?? '--',
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppGap.md,
                    _detailItem(Icons.luggage_outlined, 'Baggage', flight['baggage'] ?? '20kg'),
                    _detailItem(Icons.airline_seat_recline_normal, 'Class', flight['cabin'] ?? 'Economy'),
                    _detailItem(
                      flight['isRefundable'] == true ? Icons.check_circle_outline : Icons.cancel_outlined,
                      'Refundable', (flight['isRefundable'] ?? false) ? 'Yes' : 'No',
                      valueColor: (flight['isRefundable'] ?? false) ? AppColors.success : AppColors.error,
                    ),
                    _detailItem(Icons.business, 'Provider', flight['provider'] ?? ''),
                    AppGap.md,
                    Container(
                      padding: AppPadding.cardLg,
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.md)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Price Breakdown', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
                        AppGap.md,
                        if (_adultsCount > 0) _priceRow('Adult x $_adultsCount', baseFare > 0 ? baseFare * _adultsCount : totalPrice),
                        if (_childrenCount > 0) _priceRow('Child x $_childrenCount', _parseDouble(priceData?['baseFarePerChild']) * _childrenCount),
                        if (_infantsCount > 0) _priceRow('Infant x $_infantsCount', _parseDouble(priceData?['baseFarePerInfant']) * _infantsCount),
                        if (taxes > 0) _priceRow('Taxes & Fees', taxes),
                        const Divider(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Total', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
                          Text('PKR ${_formatPrice(totalPrice)}', style: AppTextStyles.priceMd),
                        ]),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteSummary({String? label, required String departureCode, required String arrivalCode, required String departureTime, required String arrivalTime, required String duration}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label != null) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(label, style: AppTextStyles.labelMd.copyWith(color: AppColors.primary))),
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(departureTime, style: AppTextStyles.titleLg), Text(departureCode, style: AppTextStyles.caption),
        ])),
        Expanded(child: Column(children: [
          Text(duration, style: AppTextStyles.hint), AppGap.xs,
          Row(children: [
            Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5))),
            Expanded(child: Container(height: 1, color: AppColors.border)),
            Icon(Icons.flight, size: AppIconSize.xs, color: AppColors.primary),
            Expanded(child: Container(height: 1, color: AppColors.border)),
            Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
          ]),
        ])),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(arrivalTime, style: AppTextStyles.titleLg), Text(arrivalCode, style: AppTextStyles.caption),
        ])),
      ]),
    ]);
  }

  Widget _detailItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      Icon(icon, size: AppIconSize.lg, color: AppColors.textSecondary), AppGap.hMd,
      Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: valueColor)),
    ]));
  }

  Widget _priceRow(String label, double amount) {
    if (amount <= 0) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
      Text('PKR ${_formatPrice(amount)}', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
    ]));
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 10), child: Row(children: [
      Icon(icon, size: AppIconSize.lg, color: AppColors.primary), AppGap.hSm,
      Text(title, style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
    ]));
  }

  Widget _buildPassengerForm(_PassengerData passenger, int paxNumber) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionHeader('Passenger $paxNumber (${passenger.type})', Icons.person_outline),
      Padding(
        padding: AppPadding.screenH,
        child: Container(
          padding: AppPadding.cardLg,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Title *', style: AppTextStyles.labelLg),
            AppGap.sm,
            Wrap(spacing: 8, children: _getTitleOptions(passenger.type).map((title) {
              final isSelected = passenger.title == title;
              return GestureDetector(
                onTap: () => setState(() => passenger.title = title),
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
            TextFormField(
              controller: passenger.firstNameController, textCapitalization: TextCapitalization.words, style: AppTextStyles.bodyLg,
              decoration: InputDecoration(labelText: 'First Name *', labelStyle: AppTextStyles.caption, hintText: 'As per passport/CNIC'),
              validator: (v) => (v == null || v.isEmpty) ? 'First name is required' : null,
            ),
            AppGap.md,
            TextFormField(
              controller: passenger.lastNameController, textCapitalization: TextCapitalization.words, style: AppTextStyles.bodyLg,
              decoration: InputDecoration(labelText: 'Last Name *', labelStyle: AppTextStyles.caption, hintText: 'As per passport/CNIC'),
              validator: (v) => (v == null || v.isEmpty) ? 'Last name is required' : null,
            ),
            AppGap.md,
            Text('Date of Birth *', style: AppTextStyles.labelLg),
            AppGap.sm,
            Row(children: [
              Expanded(flex: 2, child: DropdownButtonFormField<String>(
                value: passenger.dobDay, style: AppTextStyles.bodyMd,
                decoration: InputDecoration(labelText: 'Day', labelStyle: AppTextStyles.caption, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14)),
                items: List.generate(31, (i) { final d = (i + 1).toString().padLeft(2, '0'); return DropdownMenuItem(value: d, child: Text(d)); }),
                onChanged: (v) => setState(() => passenger.dobDay = v),
                validator: (v) => v == null ? 'Required' : null,
              )),
              AppGap.hSm,
              Expanded(flex: 3, child: DropdownButtonFormField<String>(
                value: passenger.dobMonth, style: AppTextStyles.bodyMd,
                decoration: InputDecoration(labelText: 'Month', labelStyle: AppTextStyles.caption, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14)),
                items: const [
                  DropdownMenuItem(value: '01', child: Text('Jan')), DropdownMenuItem(value: '02', child: Text('Feb')),
                  DropdownMenuItem(value: '03', child: Text('Mar')), DropdownMenuItem(value: '04', child: Text('Apr')),
                  DropdownMenuItem(value: '05', child: Text('May')), DropdownMenuItem(value: '06', child: Text('Jun')),
                  DropdownMenuItem(value: '07', child: Text('Jul')), DropdownMenuItem(value: '08', child: Text('Aug')),
                  DropdownMenuItem(value: '09', child: Text('Sep')), DropdownMenuItem(value: '10', child: Text('Oct')),
                  DropdownMenuItem(value: '11', child: Text('Nov')), DropdownMenuItem(value: '12', child: Text('Dec')),
                ],
                onChanged: (v) => setState(() => passenger.dobMonth = v),
                validator: (v) => v == null ? 'Required' : null,
              )),
              AppGap.hSm,
              Expanded(flex: 3, child: TextFormField(
                controller: passenger.dobYearController, keyboardType: TextInputType.number, maxLength: 4, style: AppTextStyles.bodyMd,
                decoration: InputDecoration(labelText: 'Year', labelStyle: AppTextStyles.caption, hintText: 'YYYY', counterText: '', contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14)),
                validator: (v) { if (v == null || v.isEmpty) return 'Required'; if (v.length != 4) return 'YYYY'; return null; },
              )),
            ]),
          ]),
        ),
      ),
      AppGap.lg,
    ]);
  }

  List<String> _getTitleOptions(String type) {
    if (type == 'Child') return ['Mstr', 'Miss'];
    if (type == 'Infant') return ['Mstr', 'Miss'];
    return ['Mr', 'Mrs', 'Ms'];
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final flight = _resolvedFlightData;
    final searchState = ref.read(flightSearchProvider);

    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final priceData = rawData?['price'] as Map<String, dynamic>?;
    final phoneNumber = '$_areaCode-${_phoneController.text.trim()}';
    if (kDebugMode) print('=== PHONE: $phoneNumber');

    // Build persons as indexed arrays (matching website's Laravel format)
    // Website sends: persons[type][0], persons[nameTitle][0], etc.
    final personsTypes = <String>[];
    final personsNameTitle = <String>[];
    final personsFirstName = <String>[];
    final personsLastName = <String>[];
    final personsDobDate = <String>[];
    final personsDobMonth = <String>[];
    final personsDobYear = <String>[];
    final personsNationality = <String>[];
    final personsIdnNmber = <String>[];
    final personsExpDate = <String>[];
    final personsExpMonth = <String>[];
    final personsExpYear = <String>[];
    final personsIssDate = <String>[];
    final personsIssMonth = <String>[];
    final personsIssYear = <String>[];
    final personsIssueCountry = <String>[];

    // Also build display list for payment page
    final passengersForPayment = <Map<String, dynamic>>[];

    for (final p in _passengers) {
      personsTypes.add(p.type.toLowerCase());
      personsNameTitle.add(p.title);
      personsFirstName.add(p.firstNameController.text.trim());
      personsLastName.add(p.lastNameController.text.trim());
      personsDobDate.add(p.dobDay ?? '01');
      personsDobMonth.add(p.dobMonth ?? '01');
      personsDobYear.add(p.dobYearController.text.trim());
      personsNationality.add('PK');
      personsIdnNmber.add('');
      personsExpDate.add('');
      personsExpMonth.add('');
      personsExpYear.add('');
      personsIssDate.add('');
      personsIssMonth.add('');
      personsIssYear.add('');
      personsIssueCountry.add('');

      passengersForPayment.add({
        'nameTitle': p.title,
        'firstName': p.firstNameController.text.trim(),
        'lastName': p.lastNameController.text.trim(),
        'type': p.type.toLowerCase(),
      });
    }

    final tripType = searchState.searchParams?['tripType'] ?? 'one-way';
    final outboundDate = searchState.searchParams?['outboundDate'] ?? '';
    final inboundDate = searchState.searchParams?['inboundDate'] ?? '';
    final cabin = searchState.searchParams?['cabin'] ?? 'Y';

    // Build payload matching website's exact format
    final payload = {
      'jSessionId': flight['jSessionId'] ?? '',
      'adultsCount': _adultsCount.toString(),
      'childrenCount': _childrenCount.toString(),
      'infantsCount': _infantsCount.toString(),
      'phoneNumber': phoneNumber,
      'email': _emailController.text.trim(),
      'airType': flight['provider'] ?? '',
      'vCarrier': priceData?['validatingCarrier'] ?? '',
      'currencyRate': searchState.searchParams?['currencyRate']?.toString() ?? '1',
      'currencyCode': searchState.searchParams?['currencyCode'] ?? 'PKR',
      'departureDate': outboundDate,
      'bookingInfo': flight['bookingInfo'] ?? '',
      // params matching website URL query params format
      'params': {
        'ft': tripType,
        'ol': flight['departureCode'] ?? '',
        'dl': flight['arrivalCode'] ?? '',
        'obd': outboundDate,
        'ibd': inboundDate,
        'ac': _adultsCount.toString(),
        'cc': _childrenCount.toString(),
        'ic': _infantsCount.toString(),
        'cbn': cabin,
        'stp': '',
        'cr': '1',
        'ct': 'PKR',
        'pn': '',
        'st': 'b2c',
        'dt': 'W',
      },
      'persons': {
        'type': personsTypes,
        'nameTitle': personsNameTitle,
        'firstName': personsFirstName,
        'lastName': personsLastName,
        'dobDate': personsDobDate,
        'dobMonth': personsDobMonth,
        'dobYear': personsDobYear,
        'nationality': personsNationality,
        'idnNmber': personsIdnNmber,
        'expDate': personsExpDate,
        'expMonth': personsExpMonth,
        'expYear': personsExpYear,
        'issDate': personsIssDate,
        'issMonth': personsIssMonth,
        'issYear': personsIssYear,
        'issueCountry': personsIssueCountry,
      },
      'bookingKeys': rawData?['bookingInfo'] != null
          ? [{'bookingRefKey': rawData!['bookingInfo']}]
          : [],
    };

    if (kDebugMode) print('=== BOOKING: $payload');

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.postWithHeader(
        ApiEndpoints.orderCreate,
        data: payload,
        extraHeaders: {'Action-Type': flight['provider'] ?? 'Sabre'},
      );
      if (!mounted) return;

      final data = response.data;
      if (kDebugMode) print('=== BOOKING RESPONSE: $data');
      if (kDebugMode) print('=== RESPONSE TYPE: ${data.runtimeType}');

      String? pnr;
      String? vCarrierResp;
      String? payUrl;

      if (data is Map<String, dynamic>) {
        // Response format: {statusCode, errorType, airType, itineraryRef, reference, echoToken, vCarrier, payUrl}
        if (data['errorType'] == 'true') {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['error']?.toString() ?? 'Booking failed'),
            backgroundColor: AppColors.error,
          ));
          return;
        }

        pnr = data['itineraryRef']?.toString() ??
            data['reference']?.toString() ??
            data['pnr']?.toString();
        vCarrierResp = data['vCarrier']?.toString();
        payUrl = data['payUrl']?.toString();
      } else if (data is String && data.isEmpty) {
        // API returned empty string (controller disabled)
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Booking service temporarily unavailable. Please try again later.'),
          backgroundColor: AppColors.error,
        ));
        return;
      }

      if (kDebugMode) print('=== PARSED PNR: $pnr, vCarrier: $vCarrierResp, payUrl: $payUrl');
      setState(() => _isSubmitting = false);

      // Navigate to payment page
      if (mounted) {
        context.push(AppRoutes.payment, extra: {
          'pnr': pnr ?? '',
          'itineraryRef': pnr ?? '',
          'airType': flight['provider'] ?? '',
          'vCarrier': vCarrierResp ?? priceData?['validatingCarrier'] ?? '',
          'flightData': flight,
          'passengers': passengersForPayment,
          'totalPrice': flight['price'],
        });
      }
    } catch (e) {
      if (kDebugMode) print('Booking error: $e');
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booking failed: ${e.toString()}'), backgroundColor: AppColors.error,
        action: SnackBarAction(label: 'Retry', textColor: Colors.white, onPressed: _submitBooking),
      ));
    }
  }

  String _formatPrice(dynamic price) {
    if (price is int) return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (price is double) return price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return price.toString();
  }
}

class _PassengerData {
  final String type;
  final int index;
  String title;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobYearController;
  String? dobDay;
  String? dobMonth;

  _PassengerData({required this.type, required this.index})
      : title = (type == 'Adult') ? 'Mr' : 'Mstr',
        firstNameController = TextEditingController(),
        lastNameController = TextEditingController(),
        dobYearController = TextEditingController();

  void dispose() { firstNameController.dispose(); lastNameController.dispose(); dobYearController.dispose(); }
}
