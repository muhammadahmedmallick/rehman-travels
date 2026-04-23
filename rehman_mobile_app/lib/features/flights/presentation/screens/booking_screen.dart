import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_bottom_sheet.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../../app/widgets/full_screen_loader.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../data/utils/fare_calculation.dart';
import '../../../../core/utils/app_lifecycle_refresh_mixin.dart';
import '../../../../core/utils/time_format.dart';
import '../providers/fare_refresh_clock.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/collapsible_itinerary_card.dart';
import '../widgets/flight_gone_dialog.dart';
import '../widgets/booking_journey_header.dart';
import '../widgets/refresh_countdown_pill.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? flightData;
  const BookingScreen({super.key, this.flightData});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen>
    with AppLifecycleRefreshMixin<BookingScreen> {
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
        p.title = 'Mr';
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
  Future<void> onLifecycleRefresh() async {
    final searchParams = ref.read(flightSearchProvider).searchParams;
    final flightId = _resolvedFlightData['id'];
    if (searchParams == null || flightId == null) return;
    await ref.read(flightSearchProvider.notifier).searchFlights(searchParams);
    if (!mounted) return;
    final newFlights = ref.read(flightSearchProvider).flights;
    // IDs are regenerated on every search so id-only match falsely
    // flags still-available flights as sold. Fall back to a composite
    // key (airline + flight number + times) before declaring it gone.
    final match = _findMatchingFlight(newFlights, _resolvedFlightData);
    if (match == null) {
      await showFlightGoneDialog(context);
      return;
    }
    // Silent update — price/segment changes reflect on next frame.
    setState(() => _resolvedFlightData = match);
  }

  Map<String, dynamic>? _findMatchingFlight(
    List<dynamic> flights,
    Map<String, dynamic> target,
  ) {
    final id = target['id'];
    for (final f in flights) {
      if (f is Map && f['id'] == id) return Map<String, dynamic>.from(f);
    }
    final airline = (target['airlineCode'] ?? '').toString();
    final flightNo = (target['flightNumber'] ?? '').toString();
    final depTime = (target['departureTime'] ?? '').toString();
    final arrTime = (target['arrivalTime'] ?? '').toString();
    if (airline.isEmpty || flightNo.isEmpty) return null;
    for (final f in flights) {
      if (f is! Map) continue;
      if ((f['airlineCode'] ?? '').toString() == airline &&
          (f['flightNumber'] ?? '').toString() == flightNo &&
          (f['departureTime'] ?? '').toString() == depTime &&
          (f['arrivalTime'] ?? '').toString() == arrTime) {
        return Map<String, dynamic>.from(f);
      }
    }
    return null;
  }

  /// Keep the fare fresh while the passenger form is being filled —
  /// booking hasn't been created yet, so prices can still drift.
  @override
  Duration? get periodicRefreshInterval => kFlightFareRefreshInterval;

  // Share the fare-refresh countdown with the itinerary screen so
  // the 3-minute timer continues across the booking flow instead of
  // resetting every time the user steps forward.
  @override
  DateTime? readSharedLastTickAt() => FareRefreshClock.lastTickAt;

  @override
  void writeSharedLastTickAt(DateTime at) =>
      FareRefreshClock.lastTickAt = at;

  @override
  Widget build(BuildContext context) {
    final flight = _resolvedFlightData;
    final selectedCurrency = ref.watch(currencyProvider).selected;

    return FullScreenLoader(
      isLoading: _isSubmitting,
      message: 'Creating your booking...',
      child: Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // Booking-flow header — dedicated design with step
            // indicator; route is meta, screen title is the hero.
            BookingJourneyHeader(
              title: 'Passenger Details',
              params: ref.read(flightSearchProvider).searchParams,
              currentStep: 1,
            ),

            // Countdown pill — pinned under the header so it stays
            // visible while the user scrolls the passenger forms.
            SliverPersistentHeader(
              pinned: true,
              delegate: PinnedRefreshCountdownHeader(
                nextRefreshIn: nextRefreshIn,
                isPaused: () => isRefreshPaused,
                isRefreshing: () => isRefreshing,
              ),
            ),

            // Content
            SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Flight itinerary — same collapsible card used on the
              // payment screen. Reads from the shared ItineraryView so
              // the rendering matches the view-details page exactly.
              CollapsibleItineraryCard(
                flight: flight,
                searchParams: ref.read(flightSearchProvider).searchParams,
              ),

              // Contact Information Card
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(Icons.phone_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Contact Information', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ]),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 30,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: AppTextStyles.bodyLg,
                    decoration: InputDecoration(labelText: 'Email Address *', labelStyle: AppTextStyles.caption, hintText: 'your@email.com', prefixIcon: const Icon(Icons.email_outlined, size: AppIconSize.lg)),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email (e.g. name@example.com)';
                      return null;
                    },
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
                        maxLength: 20,
                        style: AppTextStyles.bodyLg,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(labelText: 'Mobile Number *', labelStyle: AppTextStyles.caption, hintText: '3XX XXXXXXX'),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Phone is required';
                          if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'Only numbers allowed';
                          if (v.length < 10) return 'Enter valid number';
                          return null;
                        },
                      ),
                    ),
                  ]),
                ]),
              ),

              // Passenger Forms
              for (int i = 0; i < _passengers.length; i++)
                KeyedSubtree(
                  key: ObjectKey(_passengers[i]),
                  child: _buildPassengerForm(_passengers[i], i + 1),
                ),

              const SizedBox(height: 100),
            ])),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(flight, selectedCurrency),
    ),
    );
  }

  Widget _routeRow(String dep, String arr, String depTime, String arrTime, String dur, dynamic stops, bool isReturn) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(dep, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(depTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
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
        Text(arrTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
      ]),
    ]);
  }

  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '')) ?? 0;
    return 0;
  }

  Widget _buildFlightSummaryCard(Map<String, dynamic> flight, Map<String, dynamic>? returnLeg, Currency? selectedCurrency) {
    final airlineCode = (flight['airlineCode'] ?? '').toString().toUpperCase();
    final isRefundable = flight['isRefundable'] ?? false;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
            // Departure route
            _cardRouteSection(
              label: returnLeg != null ? 'Departure' : 'Flight Info',
              depCode: flight['departureCode'] ?? '',
              arrCode: flight['arrivalCode'] ?? '',
              depTime: formatFlightTime(flight['departureTime']?.toString()),
              arrTime: formatFlightTime(flight['arrivalTime']?.toString()),
              duration: flight['duration'] ?? '--',
              stops: flight['stops'] ?? 0,
              isReturn: false,
            ),

            // Return route
            if (returnLeg != null) ...[
              const Divider(height: 16),
              _cardRouteSection(
                label: 'Return',
                depCode: returnLeg['departureCode'] ?? '',
                arrCode: returnLeg['arrivalCode'] ?? '',
                depTime: formatFlightTime(returnLeg['departureTime']?.toString()),
                arrTime: formatFlightTime(returnLeg['arrivalTime']?.toString()),
                duration: returnLeg['duration'] ?? '--',
                stops: returnLeg['stops'] ?? 0,
                isReturn: true,
              ),
            ],

            // Flight Info
            const Divider(height: 16),
            Text('Flight Info', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 8),
            _summaryRow(
                Icons.airline_seat_recline_normal,
                'Class',
                _getCabinLabel((flight['cabin']?.toString().isNotEmpty ?? false)
                    ? flight['cabin'].toString()
                    : (ref.read(flightSearchProvider).searchParams?['cabin']
                            ?.toString() ??
                        ''))),
            _summaryRow(Icons.luggage_outlined, 'Baggage', flight['baggage'] ?? '20kg'),
            if (returnLeg != null)
              _summaryRow(Icons.luggage_outlined, 'Return Baggage', returnLeg['baggage'] ?? flight['baggage'] ?? '20kg'),
            _summaryRow(Icons.business, 'Provider', flight['provider'] ?? ''),

            // Fare
            const Divider(height: 16),
            Text('Fare', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 8),
            _summaryRow(Icons.attach_money, 'Total', formatCurrencyPrice(_toDouble(flight['price'] ?? 0), selectedCurrency)),
            _summaryRow(Icons.swap_vert, 'Refundable', (flight['isRefundable'] ?? false) ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _cardRouteSection({
    required String label, required String depCode, required String arrCode,
    required String depTime, required String arrTime, required String duration,
    required dynamic stops, required bool isReturn,
  }) {
    final stopsInt = stops is int ? stops : int.tryParse(stops.toString()) ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(depCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
          const SizedBox(height: 2),
          Text(depTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ])),
        Expanded(flex: 3, child: Column(children: [
          Text(duration, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 4),
          Row(children: [
            Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5))),
            Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
            Transform.rotate(angle: isReturn ? -1.5708 : 1.5708, child: Icon(Icons.flight, size: 14, color: AppColors.primary)),
            Expanded(child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3))),
            Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
          ]),
          const SizedBox(height: 3),
          Text(stopsInt == 0 ? 'Non-stop' : '$stopsInt Stop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: stopsInt == 0 ? AppColors.success : AppColors.primary)),
        ])),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(arrCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
          const SizedBox(height: 2),
          Text(arrTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ])),
      ]),
    ]);
  }

  Widget _summaryRow(IconData icon, String label, String value) {
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

  // ═══════════════════════════════════════════
  //  PASSENGER FORM
  // ═══════════════════════════════════════════
  Widget _buildPassengerForm(_PassengerData pax, int paxNumber) {
    final typeLabel = pax.type == 'adult' ? 'Adult' : pax.type == 'child' ? 'Child' : 'Infant';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.soft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header inside card
        Row(children: [
          Icon(Icons.person_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Passenger $paxNumber ($typeLabel)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
          if (_canRemovePassenger(pax))
            IconButton(
              onPressed: () => _removePassenger(pax),
              icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
              tooltip: 'Remove passenger',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ]),
        const SizedBox(height: 12),

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
          keyboardType: TextInputType.name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
          decoration: InputDecoration(labelText: 'First Name *', labelStyle: AppTextStyles.caption, hintText: 'As per passport/CNIC'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'First name is required';
            if (v.trim().length < 2) return 'At least 2 characters';
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v.trim())) return 'Only letters allowed';
            return null;
          },
        ),
        AppGap.md,
        TextFormField(
          controller: pax.lastNameController, textCapitalization: TextCapitalization.words, style: AppTextStyles.bodyLg,
          keyboardType: TextInputType.name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
          decoration: InputDecoration(labelText: 'Last Name *', labelStyle: AppTextStyles.caption, hintText: 'As per passport/CNIC'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Last name is required';
            if (v.trim().length < 2) return 'At least 2 characters';
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v.trim())) return 'Only letters allowed';
            return null;
          },
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
    );
  }

  // ═══════════════════════════════════════════
  //  OUTBOUND DATE RESOLVER
  // ═══════════════════════════════════════════
  /// Returns the outbound date for the orderCreate payload as
  /// `yyyy-MM-dd`. Walks every place the date might be parked —
  /// search params, parsed flight map, parsed first segment, raw
  /// API leg/segment data — and falls back to tomorrow as an
  /// absolute last resort so the API never receives an empty date.
  ///
  /// Search params arrive in `dd-MM-yyyy` (the form's display
  /// format); the API expects ISO `yyyy-MM-dd`, so the parts are
  /// flipped when needed.
  String _resolveOutboundDate(
      Map<String, dynamic> flight, FlightSearchState searchState) {
    String pick(dynamic v) {
      if (v == null) return '';
      final s = v.toString().trim();
      return s == 'null' ? '' : s;
    }

    // Collect (label, value) pairs so debug output tells us exactly
    // WHICH source fed the final answer — invaluable when a specific
    // flow starts dropping the date again.
    final candidates = <MapEntry<String, String>>[];
    void add(String label, dynamic v) =>
        candidates.add(MapEntry(label, pick(v)));

    add('sp.outboundDate', searchState.searchParams?['outboundDate']);
    final spLegs =
        (searchState.searchParams?['legs'] as List?)?.whereType<Map>();
    if (spLegs != null && spLegs.isNotEmpty) {
      add('sp.legs[0].outboundDate', spLegs.first['outboundDate']);
      add('sp.legs[0].departureDate', spLegs.first['departureDate']);
    }
    add('flight.departureDate', flight['departureDate']);
    add('flight.outboundDate', flight['outboundDate']);

    final allLegs = (flight['allLegs'] as List?)?.whereType<Map>();
    if (allLegs != null && allLegs.isNotEmpty) {
      final firstLeg = allLegs.first;
      add('flight.allLegs[0].departureDate', firstLeg['departureDate']);
      final segs = (firstLeg['segments'] as List?)?.whereType<Map>();
      if (segs != null && segs.isNotEmpty) {
        add('flight.allLegs[0].segs[0].departureDate',
            segs.first['departureDate']);
        add('flight.allLegs[0].segs[0].departureDateTime',
            segs.first['departureDateTime']);
      }
    }

    final rawData = flight['rawData'] as Map<String, dynamic>?;
    final rawLegs = rawData?['legs'] as Map<String, dynamic>?;
    if (rawLegs != null) {
      final leg1 = rawLegs['leg1'] as Map<String, dynamic>?;
      if (leg1 != null) {
        add('raw.leg1.departureDate', leg1['departureDate']);
        final rawSegs = (leg1['segments'] as List?)?.whereType<Map>();
        if (rawSegs != null && rawSegs.isNotEmpty) {
          add('raw.leg1.segs[0].departureDate',
              rawSegs.first['departureDate']);
          add('raw.leg1.segs[0].departureDateTime',
              rawSegs.first['departureDateTime']);
        }
      }
    }

    // Try each candidate through a tolerant parser; first one that
    // yields a valid DateTime wins. This way no matter what format
    // the upstream gave us (yyyy-MM-dd, dd-MM-yyyy, ISO 8601 with T,
    // "2026-04-29 00:00:00" etc.) we normalise cleanly.
    DateTime? parsed;
    String source = 'none';
    for (final entry in candidates) {
      if (entry.value.isEmpty) continue;
      parsed = _tryParseFlexible(entry.value);
      if (parsed != null) {
        source = entry.key;
        break;
      }
    }

    // Absolute last resort — default to tomorrow so orderCreate never
    // goes out with an empty / malformed date.
    parsed ??= DateTime.now().add(const Duration(days: 1));
    if (source == 'none') source = 'fallback(tomorrow)';

    final iso = DateFormat('yyyy-MM-dd').format(parsed);

    if (kDebugMode) {
      print('═══════════════════════════════════════════════════════');
      print('║ OUTBOUND DATE resolved: $iso (from $source)');
      for (final entry in candidates) {
        if (entry.value.isNotEmpty) {
          print('║   • ${entry.key} = ${entry.value}');
        }
      }
      print('═══════════════════════════════════════════════════════');
    }

    return iso;
  }

  /// Parses a date string across the formats our data sources use.
  /// Accepts dart `DateTime.parse` output (ISO 8601 with or without
  /// time), `yyyy-MM-dd`, `dd-MM-yyyy`, and space-separated variants.
  /// Returns null only when no known format matches.
  DateTime? _tryParseFlexible(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    // 1. Strip anything after the first space OR 'T' — we only
    //    care about the date portion.
    final dateOnly =
        trimmed.split(RegExp(r'[T\s]')).first;

    // 2. ISO 8601 yyyy-MM-dd (API format).
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(dateOnly);
    } catch (_) {}

    // 3. Form display dd-MM-yyyy.
    try {
      return DateFormat('dd-MM-yyyy').parseStrict(dateOnly);
    } catch (_) {}

    // 4. Slash variants.
    try {
      return DateFormat('yyyy/MM/dd').parseStrict(dateOnly);
    } catch (_) {}
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(dateOnly);
    } catch (_) {}

    // 5. Dart's built-in lenient parser as a last pass.
    return DateTime.tryParse(trimmed);
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
        'gender': (p.title == 'Mr' || p.title == 'Mstr' || p.title == 'Master') ? 'M' : 'F',
        'document': {
          'type': 'P',
          'number': '4220112120011',
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
        'dateOfBirth': p.dobController.text.trim(),
        'gender': (p.title == 'Mr' || p.title == 'Mstr' || p.title == 'Master') ? 'Male' : 'Female',
      });
    }

    final outboundDate = _resolveOutboundDate(flight, searchState);

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
      'currencyRate': () {
        final c = ref.read(currencyProvider).selected;
        return (c != null && c.currencyRate > 0) ? c.currencyRate.toString() : '1';
      }(),
      'currencyCode': ref.read(currencyProvider).selected?.currencyCode ?? 'PKR',
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

  /// Whether the [pax] card is allowed to show its remove button.
  /// Rules: at least one adult must remain, and an infant can only
  /// exist if there's still an adult to chaperone it.
  bool _canRemovePassenger(_PassengerData pax) {
    if (_passengers.length <= 1) return false;
    if (pax.type == 'adult' && _adultsCount <= 1) return false;
    if (pax.type == 'adult' && _infantsCount >= _adultsCount) {
      // Removing this adult would leave more infants than adults.
      return false;
    }
    return true;
  }

  void _removePassenger(_PassengerData pax) {
    if (!_canRemovePassenger(pax)) return;
    setState(() {
      final removed = _passengers.remove(pax);
      if (!removed) return;
      switch (pax.type) {
        case 'adult':
          _adultsCount--;
          break;
        case 'child':
          _childrenCount--;
          break;
        case 'infant':
          _infantsCount--;
          break;
      }
      // Re-index remaining passengers of each type so labels stay
      // sequential (Passenger 1, 2, 3 ...).
      final counters = {'adult': 0, 'child': 0, 'infant': 0};
      for (final p in _passengers) {
        counters[p.type] = (counters[p.type] ?? 0) + 1;
        p.index = counters[p.type]!;
      }
    });
    // Dispose after the frame so any in-flight TextFormField callbacks
    // don't hit a disposed controller.
    WidgetsBinding.instance.addPostFrameCallback((_) => pax.dispose());
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Passenger removed'),
        duration: Duration(seconds: 2),
      ));
  }

  String _labelWithFlightNo(String label, String? flightNo) {
    final fn = (flightNo ?? '').trim();
    return fn.isEmpty ? label : '$label · $fn';
  }

  String _getCabinLabel(String cabin) {
    final lower = cabin.toLowerCase().trim();
    if (lower.isEmpty || lower == 'y' || lower == 'economy' || lower == 'm') return 'Economy';
    if (lower == 'c' || lower == 'business' || lower == 'j') return 'Business';
    if (lower == 'f' || lower == 'first') return 'First';
    if (lower == 's' || lower == 'w' || lower == 'premium economy' || lower == 'premium') return 'Premium Economy';
    return cabin;
  }

  List<String> _getTitleOptions(String type) {
    // QA: upstream API rejects "Master" for child/infant types, so use
    // Mr/Miss for all passenger categories.
    if (type == 'child' || type == 'infant') return ['Mr', 'Ms'];
    return ['Mr', 'Mrs', 'Ms'];
  }

  Future<void> _pickDate(TextEditingController controller, {String format = 'dd-MM-yyyy'}) async {
    // Show a custom bottom sheet with year, month, day dropdowns
    int selectedYear = 2000;
    int selectedMonth = 1;
    int selectedDay = 1;

    // Parse existing value if any
    if (controller.text.isNotEmpty) {
      try {
        final existing = DateFormat(format).parseStrict(controller.text);
        selectedYear = existing.year;
        selectedMonth = existing.month;
        selectedDay = existing.day;
      } catch (_) {}
    }

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final years = List.generate(now.year - 1940 + 1, (i) => now.year - i); // current year down to 1940
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    final picked = await showAppBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
          if (selectedDay > daysInMonth) selectedDay = daysInMonth;
          final days = List.generate(daysInMonth, (i) => i + 1);

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Date of Birth', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),

              // Year
              Text('Year', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedYear,
                    isExpanded: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                    items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                    onChanged: (v) => setModalState(() => selectedYear = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Month + Day
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Month', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedMonth, isExpanded: true,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(months[i]))),
                        onChanged: (v) => setModalState(() => selectedMonth = v!),
                      ),
                    ),
                  ),
                ])),
                const SizedBox(width: 12),
                SizedBox(width: 100, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Day', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedDay, isExpanded: true,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        items: days.map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
                        onChanged: (v) => setModalState(() => selectedDay = v!),
                      ),
                    ),
                  ),
                ])),
              ]),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final picked = DateTime(selectedYear, selectedMonth, selectedDay);
                    if (picked.isAfter(yesterday)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Date of birth cannot be today or in the future'), backgroundColor: AppColors.error));
                      return;
                    }
                    Navigator.pop(ctx, picked);
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ]),
          );
        },
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

  Widget _buildBottomBar(Map<String, dynamic> flight, Currency? selectedCurrency) {
    return Container(
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SafeArea(
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showBookingDetails(context, flight),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(formatCurrencyPrice(_toDouble(flight['price'] ?? 0), selectedCurrency), style: AppTextStyles.priceLg),
                
              ]),
            ),
          ),
          AppGap.hLg,
          Expanded(
            child: ElevatedButton(
              onPressed: (_isSubmitting || isRefreshing) ? null : _submitBooking,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              child: _isSubmitting
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isRefreshing ? 'Refreshing...' : 'Continue'),
            ),
          ),
        ]),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> flight) {
    final returnLeg = flight['returnLeg'] as Map<String, dynamic>?;
    final allLegs = (flight['allLegs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    // Shared fare math — every screen reconciles against the same
    // headline total via fare_calculation.dart.
    final fare = computeFareBreakdown(
      flight: flight,
      adults: _adultsCount,
      children: _childrenCount,
      infants: _infantsCount,
    );
    final totalPrice = fare.total;
    final baseFare = fare.baseFare;
    final taxes = fare.taxes;
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
              child: ListView(controller: scrollController, padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).padding.bottom + 16), children: [
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
                    _labelWithFlightNo(
                      returnLeg != null ? 'Departure' : 'Flight',
                      flight['flightNumber']?.toString(),
                    ),
                    {
                      'departureCode': flight['departureCode'], 'arrivalCode': flight['arrivalCode'],
                      'departureTime': flight['departureTime'], 'arrivalTime': flight['arrivalTime'],
                      'duration': flight['duration'], 'stops': flight['stops'], 'baggage': flight['baggage'],
                      'flightNumber': flight['flightNumber'],
                    },
                    flight,
                  ),
                  if (returnLeg != null) ...[
                    AppGap.sm,
                    _buildFlightLegCard(
                      _labelWithFlightNo('Return', returnLeg['flightNumber']?.toString()),
                      returnLeg,
                      flight,
                    ),
                  ],
                ],
                AppGap.md,

                // Details Row
                Container(
                  padding: AppPadding.cardLg,
                  decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Column(children: [
                    _detailItem('Class', _getCabinLabel(
                      (flight['cabin'] ??
                              ref.read(flightSearchProvider).searchParams?['cabin'] ??
                              '')
                          .toString(),
                    )),
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
                      Text('Total Balance', style: AppTextStyles.titleSm.copyWith(fontWeight: FontWeight.w700)),
                      Text(formatCurrencyPrice(totalPrice, ref.read(currencyProvider).selected), style: AppTextStyles.priceMd),
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
    final depTime = formatFlightTime(leg['departureTime']?.toString());
    final arrTime = formatFlightTime(leg['arrivalTime']?.toString());
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
      Text(formatCurrencyPrice(amount, ref.read(currencyProvider).selected), style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
    ]));
  }

}

// ═══════════════════════════════════════════
//  PASSENGER DATA MODEL
// ═══════════════════════════════════════════
class _PassengerData {
  final String type; // adult, child, infant
  int index;
  String title;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;

  _PassengerData({required this.type, required this.index})
      : title = 'Mr',
        firstNameController = TextEditingController(),
        lastNameController = TextEditingController(),
        dobController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
  }
}
