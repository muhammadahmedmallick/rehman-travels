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

class FlightSearchForm extends ConsumerStatefulWidget {
  const FlightSearchForm({super.key});

  @override
  ConsumerState<FlightSearchForm> createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends ConsumerState<FlightSearchForm> {
  bool isRoundTrip = true;
  DateTime? departureDate;
  DateTime? returnDate;
  int adults = 1;
  int children = 0;
  int infants = 0;
  String cabinClass = 'Y'; // Y = Economy

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  String? _fromCode;
  String? _toCode;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swapAirports() {
    setState(() {
      final tempText = _fromController.text;
      final tempCode = _fromCode;

      _fromController.text = _toController.text;
      _fromCode = _toCode;

      _toController.text = tempText;
      _toCode = tempCode;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final initialDate = isDeparture
        ? (departureDate ?? DateTime.now().add(const Duration(days: 1)))
        : (returnDate ??
            departureDate?.add(const Duration(days: 7)) ??
            DateTime.now().add(const Duration(days: 8)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isDeparture
          ? DateTime.now()
          : (departureDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
          if (returnDate != null && returnDate!.isBefore(picked)) {
            returnDate = picked.add(const Duration(days: 1));
          }
        } else {
          returnDate = picked;
        }
      });
    }
  }

  void _showTravelersBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Travelers',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildCounterRow(
                'Adults',
                '12+ years',
                adults,
                (value) {
                  setModalState(() => adults = value);
                  setState(() {});
                },
                minValue: 1,
              ),
              const Divider(),
              _buildCounterRow(
                'Children',
                '2-11 years',
                children,
                (value) {
                  setModalState(() => children = value);
                  setState(() {});
                },
              ),
              const Divider(),
              _buildCounterRow(
                'Infants',
                'Under 2 years',
                infants,
                (value) {
                  setModalState(() => infants = value);
                  setState(() {});
                },
                maxValue: adults,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterRow(
    String title,
    String subtitle,
    int value,
    Function(int) onChanged, {
    int minValue = 0,
    int maxValue = 9,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: value > minValue ? () => onChanged(value - 1) : null,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: value > minValue
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 20,
                    color: value > minValue
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: value < maxValue ? () => onChanged(value + 1) : null,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: value < maxValue
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: value < maxValue
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCabinClassSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cabin Class',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCabinOption('Y', 'Economy'),
            _buildCabinOption('W', 'Premium Economy'),
            _buildCabinOption('J', 'Business'),
            _buildCabinOption('F', 'First Class'),
          ],
        ),
      ),
    );
  }

  Widget _buildCabinOption(String code, String name) {
    return ListTile(
      title: Text(name),
      leading: Radio<String>(
        value: code,
        groupValue: cabinClass,
        onChanged: (value) {
          setState(() => cabinClass = value!);
          Navigator.pop(context);
        },
        activeColor: AppColors.primary,
      ),
      onTap: () {
        setState(() => cabinClass = code);
        Navigator.pop(context);
      },
    );
  }

  String _getCabinClassName() {
    switch (cabinClass) {
      case 'Y':
        return 'Economy';
      case 'W':
        return 'Premium Economy';
      case 'J':
        return 'Business';
      case 'F':
        return 'First Class';
      default:
        return 'Economy';
    }
  }

  void _search() {
    if (_fromCode == null || _toCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select departure and arrival airports'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select departure date'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (isRoundTrip && returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select return date'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final searchParams = {
      'departureCode': _fromCode,
      'arrivalCode': _toCode,
      'outboundDate': DateFormat('dd-MM-yyyy').format(departureDate!),
      'inboundDate': isRoundTrip && returnDate != null
          ? DateFormat('dd-MM-yyyy').format(returnDate!)
          : null,
      'cabin': cabinClass,
      'adultsCount': adults,
      'childrenCount': children,
      'infantsCount': infants,
      'tripType': isRoundTrip ? 'round-trip' : 'one-way',
      'currencyCode': 'PKR',
    };

    context.push(AppRoutes.flightResults, extra: searchParams);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trip Type Toggle
        Row(
          children: [
            _buildTripTypeChip('Round Trip', isRoundTrip, () {
              setState(() => isRoundTrip = true);
            }),
            const SizedBox(width: 8),
            _buildTripTypeChip('One Way', !isRoundTrip, () {
              setState(() => isRoundTrip = false);
            }),
          ],
        ),
        const SizedBox(height: 12),

        // From Airport
        _buildAirportField(
          controller: _fromController,
          label: 'From',
          hint: 'Select departure city',
          icon: Icons.flight_takeoff,
          onAirportSelected: (code, name) {
            setState(() {
              _fromCode = code;
              _fromController.text = '$code - $name';
            });
          },
        ),

        // Swap Button
        Center(
          child: GestureDetector(
            onTap: _swapAirports,
            child: Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.swap_vert_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),

        // To Airport
        _buildAirportField(
          controller: _toController,
          label: 'To',
          hint: 'Select arrival city',
          icon: Icons.flight_land,
          onAirportSelected: (code, name) {
            setState(() {
              _toCode = code;
              _toController.text = '$code - $name';
            });
          },
        ),
        const SizedBox(height: 12),

        // Date Selection
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Departure',
                date: departureDate,
                onTap: () => _selectDate(context, true),
              ),
            ),
            if (isRoundTrip) ...[
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateField(
                  label: 'Return',
                  date: returnDate,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Travelers & Class
        Row(
          children: [
            Expanded(
              child: _buildSelectionField(
                label: 'Travelers',
                value: '${adults + children + infants} Passenger${adults + children + infants > 1 ? 's' : ''}',
                icon: Icons.person_outline,
                onTap: _showTravelersBottomSheet,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSelectionField(
                label: 'Class',
                value: _getCabinClassName(),
                icon: Icons.airline_seat_recline_normal,
                onTap: _showCabinClassSheet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Search Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _search,
            icon: const Icon(Icons.search, size: 20),
            label: const Text('Search Flights'),
          ),
        ),
      ],
    );
  }

  Widget _buildTripTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAirportField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function(String code, String name) onAirportSelected,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
      onTap: () => _showAirportSearch(onAirportSelected),
    );
  }

  void _showAirportSearch(Function(String code, String name) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => AirportSearchSheet(
          scrollController: scrollController,
          onSelected: (code, name) {
            onSelected(code, name);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date != null
                        ? DateFormat('dd MMM').format(date)
                        : 'Select',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textHint,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Airport Search Sheet
class AirportSearchSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function(String code, String name) onSelected;

  const AirportSearchSheet({
    super.key,
    required this.scrollController,
    required this.onSelected,
  });

  @override
  ConsumerState<AirportSearchSheet> createState() => _AirportSearchSheetState();
}

class _AirportSearchSheetState extends ConsumerState<AirportSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _airports = [];
  bool _isLoading = false;
  String? _error;

  // Pakistan domestic airports (always shown first)
  static const List<Map<String, dynamic>> _domesticAirports = [
    {'code': 'ISB', 'airport': 'Islamabad International Airport', 'city': 'Islamabad', 'country': 'Pakistan'},
    {'code': 'KHI', 'airport': 'Jinnah International Airport', 'city': 'Karachi', 'country': 'Pakistan'},
    {'code': 'LHE', 'airport': 'Allama Iqbal International Airport', 'city': 'Lahore', 'country': 'Pakistan'},
    {'code': 'PEW', 'airport': 'Bacha Khan International Airport', 'city': 'Peshawar', 'country': 'Pakistan'},
    {'code': 'MUX', 'airport': 'Multan International Airport', 'city': 'Multan', 'country': 'Pakistan'},
    {'code': 'SKT', 'airport': 'Sialkot International Airport', 'city': 'Sialkot', 'country': 'Pakistan'},
  ];

  // Country name to main airport mapping for visa destinations
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

    // Add visa destinations mapped to airports
    for (final visa in visaState.visas) {
      final country = visa.countryName?.toLowerCase().trim() ?? '';
      if (country.isEmpty) continue;

      final airport = _countryAirportMap[country];
      if (airport != null && !addedCodes.contains(airport['code'])) {
        addedCodes.add(airport['code']!);
        visaDestinations.add(Map<String, dynamic>.from(airport));
      }
    }

    // Domestic first, then visa destinations
    _popularAirports = [
      ..._domesticAirports,
      ...visaDestinations,
    ];
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
      setState(() {
        _airports = _popularAirports;
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() => _isLoading = true);

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchAirports(query);
    });
  }

  Future<void> _searchAirports(String query) async {
    try {
      final apiClient = ref.read(coreApiClientProvider);
      final response = await apiClient.get(
        ApiEndpoints.airportSearch,
        queryParameters: {'query': query},
      );

      if (!mounted) return;

      final List<dynamic> data = response.data is List ? response.data : [];
      setState(() {
        _airports = data.map((item) => Map<String, dynamic>.from(item)).toList();
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Could not fetch airports';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search airport or city',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _onSearchChanged,
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: CircularProgressIndicator(),
          )
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.error),
            ),
          )
        else if (_airports.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'No airports found',
              style: TextStyle(color: AppColors.textHint),
            ),
          )
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
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.flight,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '$code - $airportName',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    country,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  onTap: () => widget.onSelected(code, airportName),
                );
              },
            ),
          ),
      ],
    );
  }
}
