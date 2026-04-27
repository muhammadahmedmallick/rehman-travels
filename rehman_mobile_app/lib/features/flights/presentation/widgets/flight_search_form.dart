import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../app/widgets/app_bottom_sheet.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/utils/date_format.dart';
import '../../../visa/presentation/providers/visa_provider.dart';
import '../../../../app/widgets/date_range_picker.dart';
import '../../data/models/trip_type.dart';
import '../../data/models/flight_leg.dart';
import '../../data/models/recent_search_item.dart';
import '../providers/recent_searches_provider.dart';

class FlightSearchForm extends ConsumerStatefulWidget {
  /// Optional initial search params to pre-fill the form (for modify search).
  final Map<String, dynamic>? initialParams;

  /// If provided, called instead of pushing a new route. Used for modify search.
  final void Function(Map<String, dynamic> searchParams)? onSearch;

  const FlightSearchForm({super.key, this.initialParams, this.onSearch});

  @override
  ConsumerState<FlightSearchForm> createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends ConsumerState<FlightSearchForm> {
  TripType _tripType = TripType.roundTrip;
  List<FlightLeg> _legs = [const FlightLeg(), const FlightLeg()];
  int adults = 1;
  int children = 0;
  int infants = 0;
  String cabinClass = 'Y';

  // Controllers for one-way/round-trip mode (reused from legs)
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  // Controllers for multi-city mode
  List<TextEditingController> _mcFromControllers = [];
  List<TextEditingController> _mcToControllers = [];

  @override
  void initState() {
    super.initState();
    _applyInitialParams();
    _seedDefaultDates();
    _initMultiCityControllers();
  }

  /// Pre-fills the date fields so they never read "Select" silently —
  /// the user can tap to change, but the value the field shows always
  /// matches what the search would actually send. Keeps the form and
  /// the eventual API call in lock-step (no more "Select" in the field
  /// while a default tomorrow date silently goes through).
  void _seedDefaultDates() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (_legs.isNotEmpty && _legs[0].date == null) {
      _legs[0] = _legs[0].copyWith(date: tomorrow);
    }
    if (_tripType == TripType.roundTrip &&
        _legs.length > 1 &&
        _legs[1].date == null) {
      _legs[1] =
          _legs[1].copyWith(date: tomorrow.add(const Duration(days: 7)));
    }
  }

  void _applyInitialParams() {
    final p = widget.initialParams;
    if (p == null) return;

    // Trip type
    final tripType = p['tripType']?.toString() ?? '';
    if (tripType == 'round-trip') _tripType = TripType.roundTrip;
    else if (tripType == 'one-way') _tripType = TripType.oneWay;
    else if (tripType == 'multi') _tripType = TripType.multiCity;

    // Passengers
    adults = _toInt(p['adultsCount']) ?? 1;
    children = _toInt(p['childrenCount']) ?? 0;
    infants = _toInt(p['infantsCount']) ?? 0;

    // Cabin
    cabinClass = p['cabin']?.toString() ?? 'Y';

    // Parse departure date
    DateTime? outDate;
    final outStr = p['outboundDate']?.toString() ?? '';
    if (outStr.isNotEmpty) {
      try {
        outDate = outStr.contains('-') && outStr.indexOf('-') == 2
            ? DateFormat('dd-MM-yyyy').parseStrict(outStr)
            : DateFormat('yyyy-MM-dd').parseStrict(outStr);
      } catch (_) {}
    }

    // Parse return date
    DateTime? inDate;
    final inStr = p['inboundDate']?.toString() ?? '';
    if (inStr.isNotEmpty) {
      try {
        inDate = inStr.contains('-') && inStr.indexOf('-') == 2
            ? DateFormat('dd-MM-yyyy').parseStrict(inStr)
            : DateFormat('yyyy-MM-dd').parseStrict(inStr);
      } catch (_) {}
    }

    final depCode = p['departureCode']?.toString() ?? '';
    final depName = p['departureName']?.toString() ?? depCode;
    final arrCode = p['arrivalCode']?.toString() ?? '';
    final arrName = p['arrivalName']?.toString() ?? arrCode;

    _legs = [
      FlightLeg(fromCode: depCode, fromName: depName, toCode: arrCode, toName: arrName, date: outDate),
      FlightLeg(date: inDate),
    ];

    _fromController.text = depCode.isNotEmpty ? '$depCode - $depName' : '';
    _toController.text = arrCode.isNotEmpty ? '$arrCode - $arrName' : '';
  }

  int? _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  void _initMultiCityControllers() {
    _disposeMultiCityControllers();
    _mcFromControllers = List.generate(_legs.length, (_) => TextEditingController());
    _mcToControllers = List.generate(_legs.length, (_) => TextEditingController());
    _syncMultiCityControllers();
  }

  void _syncMultiCityControllers() {
    for (int i = 0; i < _legs.length; i++) {
      if (i < _mcFromControllers.length) {
        _mcFromControllers[i].text = _legs[i].fromDisplay;
      }
      if (i < _mcToControllers.length) {
        _mcToControllers[i].text = _legs[i].toDisplay;
      }
    }
  }

  void _disposeMultiCityControllers() {
    for (final c in _mcFromControllers) { c.dispose(); }
    for (final c in _mcToControllers) { c.dispose(); }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _disposeMultiCityControllers();
    super.dispose();
  }

  void _setTripType(TripType type) {
    setState(() {
      _tripType = type;
      switch (type) {
        case TripType.oneWay:
          _legs = [const FlightLeg()];
        case TripType.roundTrip:
          _legs = [const FlightLeg(), const FlightLeg()];
        case TripType.multiCity:
          _legs = [const FlightLeg(), const FlightLeg()];
          _initMultiCityControllers();
      }
      _fromController.clear();
      _toController.clear();
      // Re-seed defaults so the date field doesn't fall back to
      // "Select" right after a trip-type swap.
      _seedDefaultDates();
    });
  }

  void _swapAirports() {
    setState(() {
      final leg = _legs[0];
      _legs[0] = leg.copyWith(
        fromCode: leg.toCode, fromName: leg.toName,
        toCode: leg.fromCode, toName: leg.fromName,
      );
      _fromController.text = _legs[0].fromDisplay;
      _toController.text = _legs[0].toDisplay;
    });
  }

  void _addLeg() {
    if (_legs.length >= 5) return;
    setState(() {
      final lastLeg = _legs.last;
      _legs.add(FlightLeg(fromCode: lastLeg.toCode, fromName: lastLeg.toName));
      _mcFromControllers.add(TextEditingController(text: _legs.last.fromDisplay));
      _mcToControllers.add(TextEditingController());
    });
  }

  void _removeLeg(int index) {
    if (_legs.length <= 2) return;
    setState(() {
      _legs.removeAt(index);
      _mcFromControllers[index].dispose();
      _mcToControllers[index].dispose();
      _mcFromControllers.removeAt(index);
      _mcToControllers.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, int legIndex) async {
    // For multi-city legs after the first, the date can never be earlier
    // than the previous leg's date — pass that as `minDate` so earlier
    // days are greyed out and untappable in the picker.
    DateTime? minDate;
    if (_tripType == TripType.multiCity && legIndex > 0) {
      for (int i = legIndex - 1; i >= 0; i--) {
        if (_legs[i].date != null) {
          minDate = _legs[i].date;
          break;
        }
      }
    }
    final result = await showFlightDatePicker(
      context: context,
      initialDeparture: _tripType == TripType.multiCity ? _legs[legIndex].date : _legs[0].date,
      initialReturn: _tripType == TripType.roundTrip && _legs.length > 1 ? _legs[1].date : null,
      allowOneWay: _tripType != TripType.roundTrip,
      minDate: minDate,
    );

    if (result != null) {
      setState(() {
        if (_tripType == TripType.multiCity) {
          _legs[legIndex] = _legs[legIndex].copyWith(date: result.departure);
          for (int i = legIndex + 1; i < _legs.length; i++) {
            if (_legs[i].date != null && _legs[i].date!.isBefore(result.departure)) {
              _legs[i] = _legs[i].copyWith(date: result.departure.add(Duration(days: i - legIndex)));
            }
          }
        } else {
          // Handle trip type change from inside calendar
          if (result.isRoundTrip && _tripType == TripType.oneWay) {
            _tripType = TripType.roundTrip;
            if (_legs.length < 2) _legs.add(const FlightLeg());
          } else if (!result.isRoundTrip && _tripType == TripType.roundTrip) {
            _tripType = TripType.oneWay;
            if (_legs.length > 1) _legs.removeRange(1, _legs.length);
          }

          _legs[0] = _legs[0].copyWith(date: result.departure);
          if (result.returnDate != null && _legs.length > 1) {
            _legs[1] = _legs[1].copyWith(date: result.returnDate);
          }
        }
      });
    }
  }

  void _showTravelersBottomSheet() {
    showAppBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Travelers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            _counterTile(Icons.person_outline, 'Adults', '12+ years', adults, (v) {
              setModalState(() {
                adults = v;
                if (infants > adults) infants = adults;
              });
              setState(() {});
            }, min: 1),
            const SizedBox(height: 12),
            _counterTile(Icons.child_care_outlined, 'Children', '2-11 years', children, (v) { setModalState(() => children = v); setState(() {}); }),
            const SizedBox(height: 12),
            _counterTile(Icons.baby_changing_station_outlined, 'Infants', 'Under 2 years', infants, (v) {
              setModalState(() => infants = v);
              setState(() {});
            }, max: adults),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _counterTile(IconData icon, String title, String sub, int value, Function(int) onChange, {int min = 0, int max = 50}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(sub, style: TextStyle(fontSize: 12, color: AppColors.textHint)),
        ])),
        // Minus
        GestureDetector(
          onTap: value > min ? () => onChange(value - 1) : null,
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: value > min ? AppColors.primary : const Color(0xFFE0E0E0), width: 1.5),
            ),
            child: Icon(Icons.remove, size: 16, color: value > min ? AppColors.primary : const Color(0xFFBBBBBB)),
          ),
        ),
        SizedBox(width: 36, child: Text('$value', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
        // Plus
        GestureDetector(
          onTap: value < max ? () => onChange(value + 1) : null,
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: value < max ? AppColors.primary : const Color(0xFFE0E0E0), width: 1.5),
            ),
            child: Icon(Icons.add, size: 16, color: value < max ? AppColors.primary : const Color(0xFFBBBBBB)),
          ),
        ),
      ]),
    );
  }

  void _showCabinClassSheet() {
    showAppBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Cabin Class', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          SheetOption(icon: Icons.airline_seat_recline_normal, title: 'Economy', subtitle: 'Standard seating', isSelected: cabinClass == 'Y', onTap: () { setState(() => cabinClass = 'Y'); Navigator.pop(ctx); }),
          SheetOption(icon: Icons.airline_seat_recline_extra, title: 'Premium Economy', subtitle: 'Extra legroom & comfort', isSelected: cabinClass == 'S', onTap: () { setState(() => cabinClass = 'S'); Navigator.pop(ctx); }),
          SheetOption(icon: Icons.airline_seat_flat_angled, title: 'Business', subtitle: 'Lie-flat seats & lounge access', isSelected: cabinClass == 'C', onTap: () { setState(() => cabinClass = 'C'); Navigator.pop(ctx); }),
          SheetOption(icon: Icons.airline_seat_individual_suite, title: 'First Class', subtitle: 'Private suites & premium dining', isSelected: cabinClass == 'F', onTap: () { setState(() => cabinClass = 'F'); Navigator.pop(ctx); }),
        ]),
      ),
    );
  }

  String _getCabinClassName() {
    switch (cabinClass) {
      case 'Y': return 'Economy';
      case 'S': return 'Premium Economy';
      case 'C': return 'Business';
      case 'F': return 'First Class';
      default: return 'Economy';
    }
  }

  void _search() {
    // Validate based on trip type
    if (_tripType == TripType.multiCity) {
      for (int i = 0; i < _legs.length; i++) {
        if (!_legs[i].isValid) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please complete Flight ${i + 1} details'),
            backgroundColor: AppColors.error,
          ));
          return;
        }
      }
    } else {
      // One-way / Round-trip
      if (_legs[0].fromCode.isEmpty || _legs[0].toCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select departure and arrival airports'), backgroundColor: AppColors.error));
        return;
      }
      if (_legs[0].fromCode == _legs[0].toCode) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('From and To cannot be the same'), backgroundColor: AppColors.error));
        return;
      }
      // Defensive fallback — defaults are also seeded on init / trip
      // type change. Wrap in setState so the field reflects what's
      // actually being sent if the user somehow reaches Search with a
      // null date (otherwise the API call goes through with tomorrow
      // while the field still reads "Select").
      if (_legs[0].date == null ||
          (_tripType == TripType.roundTrip &&
              (_legs.length < 2 || _legs[1].date == null))) {
        setState(() {
          if (_legs[0].date == null) {
            _legs[0] = _legs[0]
                .copyWith(date: DateTime.now().add(const Duration(days: 1)));
          }
          if (_tripType == TripType.roundTrip &&
              (_legs.length < 2 || _legs[1].date == null)) {
            if (_legs.length < 2) _legs.add(const FlightLeg());
            _legs[1] = _legs[1]
                .copyWith(date: _legs[0].date!.add(const Duration(days: 7)));
          }
        });
      }
    }

    // Multi-city: validate from != to per leg
    if (_tripType == TripType.multiCity) {
      for (int i = 0; i < _legs.length; i++) {
        if (_legs[i].fromCode == _legs[i].toCode && _legs[i].fromCode.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Flight ${i + 1}: From and To cannot be the same'), backgroundColor: AppColors.error));
          return;
        }
      }
    }

    // Build legs payload
    List<Map<String, dynamic>> legsPayload;

    if (_tripType == TripType.roundTrip) {
      legsPayload = [
        _legs[0].toApiPayload(),
        {
          'departureCode': _legs[0].toCode,
          'arrivalCode': _legs[0].fromCode,
          'departureName': _legs[0].toName,
          'arrivalName': _legs[0].fromName,
          'outboundDate': _legs[1].date != null ? DateFormat('yyyy-MM-dd').format(_legs[1].date!) : '',
        },
      ];
    } else if (_tripType == TripType.oneWay) {
      legsPayload = [_legs[0].toApiPayload()];
    } else {
      legsPayload = _legs.map((l) => l.toApiPayload()).toList();
    }

    final searchParams = {
      'legs': legsPayload,
      'tripType': _tripType.apiValue,
      'cabin': cabinClass,
      'adultsCount': adults,
      'childrenCount': children,
      'infantsCount': infants,
      'currencyCode': 'PKR',
      // Backward compat for results header + modify search
      'departureCode': _legs.first.fromCode,
      'departureName': _legs.first.fromName,
      'arrivalCode': _tripType == TripType.multiCity ? _legs.last.toCode : _legs.first.toCode,
      'arrivalName': _tripType == TripType.multiCity ? _legs.last.toName : _legs.first.toName,
      'outboundDate': _legs.first.date != null ? DateFormat('dd-MM-yyyy').format(_legs.first.date!) : '',
      if (_tripType == TripType.roundTrip && _legs.length > 1 && _legs[1].date != null)
        'inboundDate': DateFormat('dd-MM-yyyy').format(_legs[1].date!),
    };

    // Persist this search so the home screen can offer "Pick up where
    // you left off". Skip when this form is being used for in-results
    // modify (onSearch != null) — that's a refinement, not a fresh entry.
    if (widget.onSearch == null) {
      _saveRecentSearch(searchParams);
    }

    if (widget.onSearch != null) {
      widget.onSearch!(searchParams);
    } else {
      context.push(AppRoutes.flightResults, extra: searchParams);
    }
  }

  void _saveRecentSearch(Map<String, dynamic> p) {
    try {
      final tripType = p['tripType']?.toString() ?? 'one-way';
      // searchParams legs carry `outboundDate` in `yyyy-MM-dd` (the
      // shape the API wants). RecentSearchLeg stores dates in the
      // app's display shape `dd-MM-yyyy`, so flip them here.
      String toDisplayDate(String apiDate) {
        if (apiDate.isEmpty) return apiDate;
        final parts = apiDate.split('-');
        if (parts.length != 3) return apiDate;
        if (parts[0].length == 4) {
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
        return apiDate;
      }

      final legs = (p['legs'] as List?)
          ?.map((e) => RecentSearchLeg(
                fromCode: (e as Map)['departureCode']?.toString() ?? '',
                fromName: e['departureName']?.toString() ?? '',
                toCode: e['arrivalCode']?.toString() ?? '',
                toName: e['arrivalName']?.toString() ?? '',
                date: toDisplayDate(e['outboundDate']?.toString() ?? ''),
              ))
          .toList();
      final item = RecentSearchItem(
        tripType: tripType,
        departureCode: p['departureCode']?.toString() ?? '',
        departureName: p['departureName']?.toString() ?? '',
        arrivalCode: p['arrivalCode']?.toString() ?? '',
        arrivalName: p['arrivalName']?.toString() ?? '',
        outboundDate: p['outboundDate']?.toString() ?? '',
        inboundDate: p['inboundDate']?.toString(),
        adults: (p['adultsCount'] as int?) ?? 1,
        children: (p['childrenCount'] as int?) ?? 0,
        infants: (p['infantsCount'] as int?) ?? 0,
        cabin: p['cabin']?.toString() ?? 'Y',
        legs: tripType == 'multi' ? legs : null,
        savedAt: DateTime.now(),
      );
      ref.read(recentSearchesProvider.notifier).add(item);
    } catch (_) {
      // Saving recents must never break the search flow.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trip Type Toggle - 3 chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final type in TripType.values) ...[
              if (type != TripType.values.first) AppGap.hSm,
              _buildTripTypeChip(type.label, _tripType == type, () => _setTripType(type)),
            ],
          ]),
        ),
        AppGap.sm,

        // Different form based on trip type
        if (_tripType == TripType.multiCity)
          _buildMultiCityForm()
        else
          _buildStandardForm(),

        AppGap.sm,

        // Travelers & Class (shared)
        Row(children: [
          Expanded(child: _buildSelectionField(
            label: 'Travelers',
            value: '${adults + children + infants} Pax',
            icon: Icons.person_outline,
            onTap: _showTravelersBottomSheet,
          )),
          const SizedBox(width: 10),
          Expanded(child: _buildSelectionField(
            label: 'Class',
            value: _getCabinClassName(),
            icon: Icons.airline_seat_recline_normal,
            onTap: _showCabinClassSheet,
          )),
        ]),
        AppGap.md,

        // Search Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _search,
            icon: const Icon(Icons.search, size: AppIconSize.lg),
            label: const Text('Search Flights'),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  //  STANDARD FORM (One-Way / Round-Trip)
  // ═══════════════════════════════════════════
  Widget _buildStandardForm() {
    return Column(children: [
      // From Airport + Swap
      Stack(children: [
        _buildAirportField(
          controller: _fromController,
          label: 'From', hint: 'Select departure city', icon: Icons.flight_takeoff,
          code: _legs[0].fromCode.isNotEmpty ? _legs[0].fromCode : null,
          cityName: _legs[0].fromName,
          onAirportSelected: (code, name) {
            setState(() {
              _legs[0] = _legs[0].copyWith(fromCode: code, fromName: name);
              _fromController.text = '$code - $name';
            });
          },
        ),
        Positioned(
          right: AppSpacing.sm, top: 0, bottom: 0,
          child: Center(child: GestureDetector(
            onTap: _swapAirports,
            child: Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 16),
            ),
          )),
        ),
      ]),
      AppGap.sm,

      // To Airport
      _buildAirportField(
        controller: _toController,
        label: 'To', hint: 'Select arrival city', icon: Icons.flight_land,
        code: _legs[0].toCode.isNotEmpty ? _legs[0].toCode : null,
        cityName: _legs[0].toName,
        onAirportSelected: (code, name) {
          setState(() {
            _legs[0] = _legs[0].copyWith(toCode: code, toName: name);
            _toController.text = '$code - $name';
          });
        },
      ),
      AppGap.sm,

      // Date Selection
      Row(children: [
        Expanded(child: _buildDateField(
          label: 'Departure',
          date: _legs[0].date,
          onTap: () => _selectDate(context, 0),
        )),
        if (_tripType == TripType.roundTrip) ...[
          const SizedBox(width: 10),
          Expanded(child: _buildDateField(
            label: 'Return',
            date: _legs.length > 1 ? _legs[1].date : null,
            onTap: () => _selectDate(context, 1),
          )),
        ],
      ]),
    ]);
  }

  // ═══════════════════════════════════════════
  //  MULTI-CITY FORM
  // ═══════════════════════════════════════════
  Widget _buildMultiCityForm() {
    return Column(children: [
      for (int i = 0; i < _legs.length; i++) ...[
        if (i > 0) const SizedBox(height: 6),
        _buildLegRow(i),
      ],
      if (_legs.length < 5) ...[
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addLeg,
            icon: const Icon(Icons.add_circle_outline, size: 18),
            label: const Text('Add Flight'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
          ),
        ),
      ],
    ]);
  }

  Widget _buildLegRow(int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header: Flight N + Remove
        Row(children: [
          Icon(Icons.flight, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text('Flight ${index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const Spacer(),
          if (_legs.length > 2)
            GestureDetector(
              onTap: () => _removeLeg(index),
              child: const Icon(Icons.close, size: 18, color: AppColors.textHint),
            ),
        ]),
        const SizedBox(height: 8),

        // Vertical stack: From, To, Date — each full-width so long
        // airport names don't get truncated.
        _buildCompactAirportField(
          controller: _mcFromControllers[index],
          hint: 'From',
          icon: Icons.flight_takeoff,
          onSelected: (code, name) {
            setState(() {
              _legs[index] = _legs[index].copyWith(fromCode: code, fromName: name);
              _mcFromControllers[index].text = '$code - $name';
            });
          },
        ),
        const SizedBox(height: 8),
        _buildCompactAirportField(
          controller: _mcToControllers[index],
          hint: 'To',
          icon: Icons.flight_land,
          onSelected: (code, name) {
            setState(() {
              _legs[index] = _legs[index].copyWith(toCode: code, toName: name);
              _mcToControllers[index].text = '$code - $name';
              // Auto-fill next leg's "From"
              if (index + 1 < _legs.length) {
                _legs[index + 1] = _legs[index + 1].copyWith(fromCode: code, fromName: name);
                _mcFromControllers[index + 1].text = '$code - $name';
              }
            });
          },
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, index),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  _legs[index].date != null
                      ? AppDate.formatWithDay(_legs[index].date!)
                      : 'Select date',
                  style: _legs[index].date != null
                      ? AppTextStyles.labelLg.copyWith(fontSize: 12)
                      : AppTextStyles.hint.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildCompactAirportField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Function(String code, String name) onSelected,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: AppTextStyles.bodyMd.copyWith(fontSize: 11),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.hint.copyWith(fontSize: 11),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 14),
        prefixIconConstraints: const BoxConstraints(minWidth: 28),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.xs), borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.xs), borderSide: BorderSide(color: AppColors.border)),
        filled: true,
        fillColor: Colors.white,
      ),
      onTap: () => _showAirportSearch(onSelected),
    );
  }

  // ═══════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════

  Widget _buildTripTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: isSelected ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: AppTextStyles.bodyMd.copyWith(color: isSelected ? Colors.white : AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }

  Widget _buildAirportField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function(String code, String name) onAirportSelected,
    String? code,
    String? cityName,
  }) {
    final hasValue = code != null && code.isNotEmpty;
    return GestureDetector(
      onTap: () => _showAirportSearch(onAirportSelected),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label, labelStyle: AppTextStyles.bodyMd,
          prefixIcon: Icon(icon, color: AppColors.primary, size: AppIconSize.lg),
          isDense: true, contentPadding: AppPadding.sectionSm,
        ),
        child: hasValue
            ? Text.rich(
                TextSpan(children: [
                  TextSpan(text: _getCityForDisplay(code, cityName), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  TextSpan(text: ' ($code)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                ]),
                overflow: TextOverflow.ellipsis,
              )
            : Text(hint, style: AppTextStyles.bodyMd.copyWith(fontSize: 13, color: AppColors.textHint)),
      ),
    );
  }

  static const Map<String, String> _codeToCityMap = {
    'ISB': 'Islamabad', 'KHI': 'Karachi', 'LHE': 'Lahore', 'PEW': 'Peshawar',
    'MUX': 'Multan', 'SKT': 'Sialkot', 'DXB': 'Dubai', 'JED': 'Jeddah',
    'IST': 'Istanbul', 'KUL': 'Kuala Lumpur', 'SIN': 'Singapore', 'BKK': 'Bangkok',
    'GYD': 'Baku', 'BAH': 'Manama', 'MCT': 'Muscat', 'DOH': 'Doha',
    'CAI': 'Cairo', 'AMM': 'Amman', 'PEK': 'Beijing', 'IKA': 'Tehran',
    'NJF': 'Najaf', 'NBO': 'Nairobi', 'CMB': 'Colombo', 'LHR': 'London',
    'CGK': 'Jakarta', 'SGN': 'Ho Chi Minh', 'PNH': 'Phnom Penh',
    'ADD': 'Addis Ababa', 'TAS': 'Tashkent', 'TBS': 'Tbilisi',
    'CMN': 'Casablanca', 'ICN': 'Seoul', 'NRT': 'Tokyo', 'MLE': 'Male',
    'KTM': 'Kathmandu', 'MED': 'Madinah', 'RUH': 'Riyadh', 'AUH': 'Abu Dhabi',
    'SHJ': 'Sharjah', 'FSD': 'Faisalabad', 'UET': 'Quetta', 'RYK': 'Rahim Yar Khan',
  };

  String _getCityForDisplay(String? code, String? name) {
    if (name != null && name.isNotEmpty) {
      // If name doesn't look like an airport name, use it directly
      if (!name.toLowerCase().contains('airport')) return name;
    }
    // Fallback: look up city from code
    if (code != null && _codeToCityMap.containsKey(code)) {
      return _codeToCityMap[code]!;
    }
    // Last resort: return name as-is or code
    return name ?? code ?? '';
  }

  void _showAirportSearch(Function(String code, String name) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
        builder: (context, scrollController) => AirportSearchSheet(
          scrollController: scrollController,
          onSelected: (code, name) { onSelected(code, name); Navigator.pop(context); },
        ),
      ),
    );
  }

  Widget _buildDateField({required String label, required DateTime? date, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.sectionSm,
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.sm)),
        child: Row(children: [
          Icon(Icons.calendar_today_rounded, size: AppIconSize.lg - 2, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AppTextStyles.hint),
            const SizedBox(height: 2),
            Text(date != null ? AppDate.format(date) : 'Select', style: AppTextStyles.labelLg),
          ])),
        ]),
      ),
    );
  }

  Widget _buildSelectionField({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.sectionSm,
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppRadius.sm)),
        child: Row(children: [
          Icon(icon, size: AppIconSize.lg - 2, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AppTextStyles.hint),
            const SizedBox(height: 2),
            Text(value, style: AppTextStyles.labelMd.copyWith(color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
          ])),
          Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint, size: AppIconSize.md),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  AIRPORT SEARCH SHEET (unchanged)
// ═══════════════════════════════════════════
class AirportSearchSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function(String code, String name) onSelected;

  const AirportSearchSheet({super.key, required this.scrollController, required this.onSelected});

  @override
  ConsumerState<AirportSearchSheet> createState() => _AirportSearchSheetState();
}

class _AirportSearchSheetState extends ConsumerState<AirportSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _airports = [];
  bool _isLoading = false;
  String? _error;

  static const List<Map<String, dynamic>> _domesticAirports = [
    {'code': 'ISB', 'airport': 'Islamabad International Airport', 'city': 'Islamabad', 'country': 'Pakistan'},
    {'code': 'KHI', 'airport': 'Jinnah International Airport', 'city': 'Karachi', 'country': 'Pakistan'},
    {'code': 'LHE', 'airport': 'Allama Iqbal International Airport', 'city': 'Lahore', 'country': 'Pakistan'},
    {'code': 'PEW', 'airport': 'Bacha Khan International Airport', 'city': 'Peshawar', 'country': 'Pakistan'},
    {'code': 'MUX', 'airport': 'Multan International Airport', 'city': 'Multan', 'country': 'Pakistan'},
    {'code': 'SKT', 'airport': 'Sialkot International Airport', 'city': 'Sialkot', 'country': 'Pakistan'},
  ];

  List<Map<String, dynamic>> _popularAirports = [];

  @override
  void initState() {
    super.initState();
    _buildPopularAirports();
  }

  void _buildPopularAirports() {
    // Visa types now arrive with ISO-3 country codes (`country_code`)
    // instead of the legacy free-form country name. Map those to an
    // anchor airport so the popular-airports list still surfaces
    // destinations the user has shown intent for via the Visas tab.
    final visaState = ref.read(visaTypesProvider);
    final visaDestinations = <Map<String, dynamic>>[];
    final addedCodes = <String>{};

    for (final type in visaState.types) {
      final code = type.countryCode.toUpperCase();
      final airport = _iso3AirportMap[code];
      if (airport != null && !addedCodes.contains(airport['code'])) {
        addedCodes.add(airport['code']!);
        visaDestinations.add(Map<String, dynamic>.from(airport));
      }
    }

    _popularAirports = [..._domesticAirports, ...visaDestinations];
    _airports = _popularAirports;
  }

  /// Anchor airport per country (ISO-3) for visa-driven popular
  /// destinations. Intentionally small — the visa API only surfaces a
  /// handful of countries the operator sells visas for.
  static const Map<String, Map<String, String>> _iso3AirportMap = {
    'ARE': {'code': 'DXB', 'airport': 'Dubai International Airport', 'city': 'Dubai', 'country': 'UAE'},
    'SAU': {'code': 'JED', 'airport': 'King Abdulaziz International Airport', 'city': 'Jeddah', 'country': 'Saudi Arabia'},
    'TUR': {'code': 'IST', 'airport': 'Istanbul Airport', 'city': 'Istanbul', 'country': 'Turkey'},
    'THA': {'code': 'BKK', 'airport': 'Suvarnabhumi Airport', 'city': 'Bangkok', 'country': 'Thailand'},
    'MYS': {'code': 'KUL', 'airport': 'Kuala Lumpur International Airport', 'city': 'Kuala Lumpur', 'country': 'Malaysia'},
    'QAT': {'code': 'DOH', 'airport': 'Hamad International Airport', 'city': 'Doha', 'country': 'Qatar'},
    'GBR': {'code': 'LHR', 'airport': 'Heathrow Airport', 'city': 'London', 'country': 'UK'},
    'USA': {'code': 'JFK', 'airport': 'John F. Kennedy International Airport', 'city': 'New York', 'country': 'USA'},
    'CAN': {'code': 'YYZ', 'airport': 'Toronto Pearson International Airport', 'city': 'Toronto', 'country': 'Canada'},
    'AZE': {'code': 'GYD', 'airport': 'Heydar Aliyev International Airport', 'city': 'Baku', 'country': 'Azerbaijan'},
  };

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _airports = _popularAirports;
        _isLoading = false;
        _error = null;
      });
      return;
    }
    // Instant local filter — matches code ("khi"), city ("karac"),
    // airport name, OR country. Popular list + static Pak/GCC/EU
    // airports give an immediate result while the remote API is
    // still fetching.
    final localMatches = _localFilter(q);
    setState(() {
      _airports = localMatches;
      _isLoading = q.length > 1; // still spin for remote fetch
      _error = null;
    });
    if (q.length <= 1) return; // single char — local-only
    _debounce = Timer(const Duration(milliseconds: 400), () => _searchAirports(q, localMatches));
  }

  /// Filters the in-memory airport pool (popular list + static
  /// domestic / GCC / international map + IATA→city lookup) against
  /// a query. Matches when ANY of {code, city, airport, country}
  /// starts with OR contains the query. Code matches rank first,
  /// then city, then the rest.
  List<Map<String, dynamic>> _localFilter(String query) {
    final q = query.toLowerCase();
    final pool = <Map<String, dynamic>>[
      ..._popularAirports,
      ..._domesticAirports,
      ..._iso3AirportMap.values.map((e) => Map<String, dynamic>.from(e)),
    ];

    // Dedupe by code.
    final seen = <String>{};
    final unique = <Map<String, dynamic>>[];
    for (final a in pool) {
      final c = (a['code'] ?? '').toString().toUpperCase();
      if (c.isEmpty || seen.contains(c)) continue;
      seen.add(c);
      unique.add(a);
    }

    int rank(Map<String, dynamic> a) {
      final code = (a['code'] ?? '').toString().toLowerCase();
      final city = (a['city'] ?? '').toString().toLowerCase();
      final airport = (a['airport'] ?? '').toString().toLowerCase();
      final country = (a['country'] ?? '').toString().toLowerCase();
      if (code == q) return 0; // exact code match — top
      if (code.startsWith(q)) return 1;
      if (city.startsWith(q)) return 2;
      if (airport.startsWith(q)) return 3;
      if (country.startsWith(q)) return 4;
      if (city.contains(q)) return 5;
      if (airport.contains(q)) return 6;
      if (country.contains(q)) return 7;
      if (code.contains(q)) return 8;
      return 99;
    }

    final scored = unique
        .map((a) => MapEntry(rank(a), a))
        .where((e) => e.key < 99)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return scored.map((e) => e.value).toList();
  }

  Future<void> _searchAirports(
      String query, List<Map<String, dynamic>> localMatches) async {
    try {
      final apiClient = ref.read(coreApiClientProvider);
      final response = await apiClient.get(
        ApiEndpoints.airportSearch,
        queryParameters: {'query': query},
      );
      if (!mounted) return;
      final List<dynamic> data = response.data is List ? response.data : [];
      final remote =
          data.map((item) => Map<String, dynamic>.from(item)).toList();

      // Merge: local matches first (instant UX), then remote entries
      // the local pool doesn't already cover. Dedupe by code.
      final seen = <String>{
        for (final a in localMatches)
          (a['code'] ?? '').toString().toUpperCase(),
      };
      final merged = <Map<String, dynamic>>[...localMatches];
      for (final a in remote) {
        final c = (a['code'] ?? '').toString().toUpperCase();
        if (c.isEmpty || seen.contains(c)) continue;
        seen.add(c);
        merged.add(a);
      }

      setState(() {
        _airports = merged;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      // API failed — keep the local results visible instead of
      // flashing an error; only show error if nothing local matched.
      setState(() {
        _isLoading = false;
        _error = localMatches.isEmpty ? 'Could not fetch airports' : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _searchController, autofocus: true,
            decoration: const InputDecoration(hintText: 'Search airport or city', prefixIcon: Icon(Icons.search)),
            onChanged: _onSearchChanged,
          ),
        ]),
      ),
      if (_isLoading)
        const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: CircularProgressIndicator())
      else if (_error != null)
        Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Text(_error!, style: const TextStyle(color: AppColors.error)))
      else if (_airports.isEmpty)
        Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Text('No airports found', style: AppTextStyles.hint))
      else
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: _airports.length,
            itemBuilder: (context, index) {
              final airport = _airports[index];
              final code = airport['code'] ?? '';
              final airportName = airport['airport'] ?? airport['city'] ?? '';
              final country = airport['country'] ?? '';
              final city = airport['city'] ?? '';
              final subtitle = city.isNotEmpty && country.isNotEmpty ? '$city, $country' : country.isNotEmpty ? country : city;
              return InkWell(
                onTap: () => widget.onSelected(code, city.isNotEmpty ? city : airportName),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text(code, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(subtitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(airportName, style: TextStyle(fontSize: 12, color: AppColors.primary.withValues(alpha: 0.6))),
                    ])),
                    Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary.withValues(alpha: 0.4)),
                  ]),
                ),
              );
            },
          ),
        ),
    ]);
  }
}
