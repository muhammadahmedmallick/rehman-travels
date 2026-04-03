import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../visa/presentation/providers/visa_provider.dart';
import '../../../../app/widgets/date_range_picker.dart';
import '../../data/models/trip_type.dart';
import '../../data/models/flight_leg.dart';

class FlightSearchForm extends ConsumerStatefulWidget {
  const FlightSearchForm({super.key});

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
    _initMultiCityControllers();
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
    final result = await showFlightDatePicker(
      context: context,
      initialDeparture: _tripType == TripType.multiCity ? _legs[legIndex].date : _legs[0].date,
      initialReturn: _tripType == TripType.roundTrip && _legs.length > 1 ? _legs[1].date : null,
      allowOneWay: _tripType != TripType.roundTrip,
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Travelers', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            _buildCounterRow('Adults', '12+ years', adults, (v) { setModalState(() => adults = v); setState(() {}); }, minValue: 1),
            const Divider(),
            _buildCounterRow('Children', '2-11 years', children, (v) { setModalState(() => children = v); setState(() {}); }),
            const Divider(),
            _buildCounterRow('Infants', 'Under 2 years', infants, (v) { setModalState(() => infants = v); setState(() {}); }, maxValue: adults),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))),
          ]),
        ),
      ),
    );
  }

  Widget _buildCounterRow(String title, String subtitle, int value, Function(int) onChanged, {int minValue = 0, int maxValue = 9}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
        ])),
        Row(children: [
          IconButton(
            onPressed: value > minValue ? () => onChanged(value - 1) : null,
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: value > minValue ? AppColors.primary : AppColors.border)),
              child: Icon(Icons.remove, size: AppIconSize.lg, color: value > minValue ? AppColors.primary : AppColors.textHint),
            ),
          ),
          SizedBox(width: 40, child: Text('$value', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)),
          IconButton(
            onPressed: value < maxValue ? () => onChanged(value + 1) : null,
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: value < maxValue ? AppColors.primary : AppColors.border)),
              child: Icon(Icons.add, size: AppIconSize.lg, color: value < maxValue ? AppColors.primary : AppColors.textHint),
            ),
          ),
        ]),
      ]),
    );
  }

  void _showCabinClassSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cabin Class', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          _buildCabinOption('Y', 'Economy'),
          _buildCabinOption('S', 'Premium Economy'),
          _buildCabinOption('C', 'Business'),
          _buildCabinOption('F', 'First Class'),
        ]),
      ),
    );
  }

  Widget _buildCabinOption(String code, String name) {
    return ListTile(
      title: Text(name),
      leading: Radio<String>(value: code, groupValue: cabinClass, onChanged: (v) { setState(() => cabinClass = v!); Navigator.pop(context); }, activeColor: AppColors.primary),
      onTap: () { setState(() => cabinClass = code); Navigator.pop(context); },
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
      // Default departure = tomorrow if not selected
      if (_legs[0].date == null) {
        _legs[0] = _legs[0].copyWith(date: DateTime.now().add(const Duration(days: 1)));
      }
      // Default return = departure + 7 days if not selected
      if (_tripType == TripType.roundTrip && (_legs.length < 2 || _legs[1].date == null)) {
        if (_legs.length < 2) _legs.add(const FlightLeg());
        _legs[1] = _legs[1].copyWith(date: _legs[0].date!.add(const Duration(days: 7)));
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
      // Backward compat for results header
      'departureCode': _legs.first.fromCode,
      'arrivalCode': _tripType == TripType.multiCity ? _legs.last.toCode : _legs.first.toCode,
      'outboundDate': _legs.first.date != null ? DateFormat('dd-MM-yyyy').format(_legs.first.date!) : '',
      if (_tripType == TripType.roundTrip && _legs.length > 1 && _legs[1].date != null)
        'inboundDate': DateFormat('dd-MM-yyyy').format(_legs[1].date!),
    };

    context.push(AppRoutes.flightResults, extra: searchParams);
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
        const SizedBox(height: 6),

        // From + To in a row
        Row(children: [
          Expanded(child: _buildCompactAirportField(
            controller: _mcFromControllers[index],
            hint: 'From',
            icon: Icons.flight_takeoff,
            onSelected: (code, name) {
              setState(() {
                _legs[index] = _legs[index].copyWith(fromCode: code, fromName: name);
                _mcFromControllers[index].text = '$code - $name';
              });
            },
          )),
          const SizedBox(width: 6),
          Expanded(child: _buildCompactAirportField(
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
          )),
          const SizedBox(width: 6),
          // Date
          GestureDetector(
            onTap: () => _selectDate(context, index),
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.xs), border: Border.all(color: AppColors.border)),
              child: Text(
                _legs[index].date != null ? DateFormat('dd MMM yy').format(_legs[index].date!) : 'Date',
                style: _legs[index].date != null ? AppTextStyles.labelLg.copyWith(fontSize: 11) : AppTextStyles.hint.copyWith(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
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
            Text(date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select', style: AppTextStyles.labelLg),
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

  static const Map<String, Map<String, String>> _countryAirportMap = {
    'uae': {'code': 'DXB', 'airport': 'Dubai International Airport', 'city': 'Dubai', 'country': 'UAE'},
    'dubai': {'code': 'DXB', 'airport': 'Dubai International Airport', 'city': 'Dubai', 'country': 'UAE'},
    'saudi arabia': {'code': 'JED', 'airport': 'King Abdulaziz International Airport', 'city': 'Jeddah', 'country': 'Saudi Arabia'},
    'turkey': {'code': 'IST', 'airport': 'Istanbul Airport', 'city': 'Istanbul', 'country': 'Turkey'},
    'malaysia': {'code': 'KUL', 'airport': 'Kuala Lumpur International Airport', 'city': 'Kuala Lumpur', 'country': 'Malaysia'},
    'singapore': {'code': 'SIN', 'airport': 'Changi Airport', 'city': 'Singapore', 'country': 'Singapore'},
    'thailand': {'code': 'BKK', 'airport': 'Suvarnabhumi Airport', 'city': 'Bangkok', 'country': 'Thailand'},
    'azerbaijan': {'code': 'GYD', 'airport': 'Heydar Aliyev International Airport', 'city': 'Baku', 'country': 'Azerbaijan'},
    'bahrain': {'code': 'BAH', 'airport': 'Bahrain International Airport', 'city': 'Manama', 'country': 'Bahrain'},
    'oman': {'code': 'MCT', 'airport': 'Muscat International Airport', 'city': 'Muscat', 'country': 'Oman'},
    'qatar': {'code': 'DOH', 'airport': 'Hamad International Airport', 'city': 'Doha', 'country': 'Qatar'},
    'egypt': {'code': 'CAI', 'airport': 'Cairo International Airport', 'city': 'Cairo', 'country': 'Egypt'},
    'jordan': {'code': 'AMM', 'airport': 'Queen Alia International Airport', 'city': 'Amman', 'country': 'Jordan'},
    'china': {'code': 'PEK', 'airport': 'Beijing Capital International Airport', 'city': 'Beijing', 'country': 'China'},
    'iran': {'code': 'IKA', 'airport': 'Imam Khomeini International Airport', 'city': 'Tehran', 'country': 'Iran'},
    'iraq': {'code': 'NJF', 'airport': 'Al Najaf International Airport', 'city': 'Najaf', 'country': 'Iraq'},
    'kenya': {'code': 'NBO', 'airport': 'Jomo Kenyatta International Airport', 'city': 'Nairobi', 'country': 'Kenya'},
    'sri lanka': {'code': 'CMB', 'airport': 'Bandaranaike International Airport', 'city': 'Colombo', 'country': 'Sri Lanka'},
    'united kingdom': {'code': 'LHR', 'airport': 'Heathrow Airport', 'city': 'London', 'country': 'United Kingdom'},
    'uk': {'code': 'LHR', 'airport': 'Heathrow Airport', 'city': 'London', 'country': 'United Kingdom'},
    'indonesia': {'code': 'CGK', 'airport': 'Soekarno-Hatta International Airport', 'city': 'Jakarta', 'country': 'Indonesia'},
    'vietnam': {'code': 'SGN', 'airport': 'Tan Son Nhat International Airport', 'city': 'Ho Chi Minh City', 'country': 'Vietnam'},
    'cambodia': {'code': 'PNH', 'airport': 'Phnom Penh International Airport', 'city': 'Phnom Penh', 'country': 'Cambodia'},
    'ethiopia': {'code': 'ADD', 'airport': 'Addis Ababa Bole International Airport', 'city': 'Addis Ababa', 'country': 'Ethiopia'},
    'uzbekistan': {'code': 'TAS', 'airport': 'Tashkent International Airport', 'city': 'Tashkent', 'country': 'Uzbekistan'},
    'georgia': {'code': 'TBS', 'airport': 'Tbilisi International Airport', 'city': 'Tbilisi', 'country': 'Georgia'},
    'morocco': {'code': 'CMN', 'airport': 'Mohammed V International Airport', 'city': 'Casablanca', 'country': 'Morocco'},
    'south korea': {'code': 'ICN', 'airport': 'Incheon International Airport', 'city': 'Seoul', 'country': 'South Korea'},
    'japan': {'code': 'NRT', 'airport': 'Narita International Airport', 'city': 'Tokyo', 'country': 'Japan'},
    'maldives': {'code': 'MLE', 'airport': 'Velana International Airport', 'city': 'Male', 'country': 'Maldives'},
    'nepal': {'code': 'KTM', 'airport': 'Tribhuvan International Airport', 'city': 'Kathmandu', 'country': 'Nepal'},
  };

  List<Map<String, dynamic>> _popularAirports = [];

  @override
  void initState() {
    super.initState();
    _buildPopularAirports();
  }

  void _buildPopularAirports() {
    final visaState = ref.read(visaListProvider);
    final visaDestinations = <Map<String, dynamic>>[];
    final addedCodes = <String>{};

    for (final visa in visaState.visas) {
      final country = visa.countryName?.toLowerCase().trim() ?? '';
      if (country.isEmpty) continue;
      final airport = _countryAirportMap[country];
      if (airport != null && !addedCodes.contains(airport['code'])) {
        addedCodes.add(airport['code']!);
        visaDestinations.add(Map<String, dynamic>.from(airport));
      }
    }

    _popularAirports = [..._domesticAirports, ...visaDestinations];
    _airports = _popularAirports;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.length <= 2) {
      setState(() { _airports = _popularAirports; _isLoading = false; _error = null; });
      return;
    }
    setState(() => _isLoading = true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _searchAirports(query));
  }

  Future<void> _searchAirports(String query) async {
    try {
      final apiClient = ref.read(coreApiClientProvider);
      final response = await apiClient.get(ApiEndpoints.airportSearch, queryParameters: {'query': query});
      if (!mounted) return;
      final List<dynamic> data = response.data is List ? response.data : [];
      setState(() { _airports = data.map((item) => Map<String, dynamic>.from(item)).toList(); _isLoading = false; _error = null; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _isLoading = false; _error = 'Could not fetch airports'; });
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
