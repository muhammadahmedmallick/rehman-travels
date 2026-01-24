import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisaCountry {
  final String id;
  final String country;
  final String countryCode;
  final String flag;
  final String visaType;
  final String duration;
  final String processing;
  final String entry;
  final int price;
  final int colorValue;
  final bool isPopular;
  final List<String> requirements;

  const VisaCountry({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.flag,
    required this.visaType,
    required this.duration,
    required this.processing,
    required this.entry,
    required this.price,
    required this.colorValue,
    this.isPopular = false,
    this.requirements = const [],
  });

  Map<String, dynamic> toDetailMap() {
    return {
      'country': country,
      'countryCode': countryCode,
      'flag': flag,
      'visaType': visaType,
      'duration': duration,
      'processing': processing,
      'entry': entry,
      'price': price,
      'requirements': requirements,
    };
  }
}

class VisaState {
  final bool isLoading;
  final List<VisaCountry> countries;
  final String? error;
  final String searchQuery;
  final String selectedCategory;

  const VisaState({
    this.isLoading = false,
    this.countries = const [],
    this.error,
    this.searchQuery = '',
    this.selectedCategory = 'All',
  });

  List<VisaCountry> get filteredCountries {
    var filtered = countries;

    if (selectedCategory == 'Popular') {
      filtered = filtered.where((c) => c.isPopular).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((c) =>
              c.country.toLowerCase().contains(searchQuery.toLowerCase()) ||
              c.countryCode.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  List<VisaCountry> get popularCountries {
    return countries.where((c) => c.isPopular).toList();
  }

  VisaState copyWith({
    bool? isLoading,
    List<VisaCountry>? countries,
    String? error,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return VisaState(
      isLoading: isLoading ?? this.isLoading,
      countries: countries ?? this.countries,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class VisaNotifier extends StateNotifier<VisaState> {
  VisaNotifier() : super(const VisaState()) {
    loadVisaCountries();
  }

  Future<void> loadVisaCountries() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Comprehensive mock data
      final mockCountries = [
        // Popular Destinations
        const VisaCountry(
          id: '1',
          country: 'United Arab Emirates',
          countryCode: 'UAE',
          flag: '🇦🇪',
          visaType: 'Tourist Visa',
          duration: '30 Days',
          processing: '3-5 Working Days',
          entry: 'Single Entry',
          price: 15000,
          colorValue: 0xFF1E3A5F,
          isPopular: true,
          requirements: [
            'Valid passport (6 months validity)',
            'Passport size photographs',
            'Bank statement (last 3 months)',
            'Hotel booking confirmation',
            'Return flight ticket',
          ],
        ),
        const VisaCountry(
          id: '2',
          country: 'Saudi Arabia',
          countryCode: 'KSA',
          flag: '🇸🇦',
          visaType: 'Umrah Visa',
          duration: '14 Days',
          processing: '5-7 Working Days',
          entry: 'Single Entry',
          price: 25000,
          colorValue: 0xFF006C35,
          isPopular: true,
          requirements: [
            'Valid passport (6 months validity)',
            'Passport size photographs',
            'Vaccination certificate',
            'Confirmed Umrah package',
            'Mehram proof (for females)',
          ],
        ),
        const VisaCountry(
          id: '3',
          country: 'Turkey',
          countryCode: 'TUR',
          flag: '🇹🇷',
          visaType: 'E-Visa',
          duration: '30 Days',
          processing: '24-48 Hours',
          entry: 'Multiple Entry',
          price: 8000,
          colorValue: 0xFFE30A17,
          isPopular: true,
          requirements: [
            'Valid passport (6 months validity)',
            'Passport size photographs',
            'Hotel reservation',
            'Return ticket',
          ],
        ),
        const VisaCountry(
          id: '4',
          country: 'Malaysia',
          countryCode: 'MYS',
          flag: '🇲🇾',
          visaType: 'E-Visa',
          duration: '30 Days',
          processing: '3-5 Working Days',
          entry: 'Single Entry',
          price: 12000,
          colorValue: 0xFF010066,
          isPopular: true,
          requirements: [
            'Valid passport (6 months validity)',
            'Passport size photographs',
            'Bank statement',
            'Hotel booking',
            'Return ticket',
          ],
        ),
        const VisaCountry(
          id: '5',
          country: 'Thailand',
          countryCode: 'THA',
          flag: '🇹🇭',
          visaType: 'Tourist Visa',
          duration: '60 Days',
          processing: '5-7 Working Days',
          entry: 'Single Entry',
          price: 10000,
          colorValue: 0xFF00247D,
          isPopular: true,
          requirements: [
            'Valid passport (6 months validity)',
            'Passport size photographs',
            'Bank statement (last 6 months)',
            'Hotel booking confirmation',
            'Flight itinerary',
          ],
        ),
        const VisaCountry(
          id: '6',
          country: 'Azerbaijan',
          countryCode: 'AZE',
          flag: '🇦🇿',
          visaType: 'E-Visa',
          duration: '30 Days',
          processing: '3 Working Days',
          entry: 'Single Entry',
          price: 7000,
          colorValue: 0xFF0092BC,
          isPopular: true,
          requirements: [
            'Valid passport (3 months validity)',
            'Passport size photograph',
            'Hotel booking',
          ],
        ),

        // Other Countries
        const VisaCountry(
          id: '7',
          country: 'United Kingdom',
          countryCode: 'UK',
          flag: '🇬🇧',
          visaType: 'Visitor Visa',
          duration: '6 Months',
          processing: '15-20 Working Days',
          entry: 'Multiple Entry',
          price: 45000,
          colorValue: 0xFF00247D,
          requirements: [
            'Valid passport',
            'Passport size photographs',
            'Bank statements (6 months)',
            'Employment letter',
            'Property documents',
            'Travel history',
          ],
        ),
        const VisaCountry(
          id: '8',
          country: 'United States',
          countryCode: 'USA',
          flag: '🇺🇸',
          visaType: 'B1/B2 Visa',
          duration: '10 Years',
          processing: 'Interview Based',
          entry: 'Multiple Entry',
          price: 55000,
          colorValue: 0xFF3C3B6E,
          requirements: [
            'Valid passport',
            'DS-160 form',
            'Passport photographs',
            'Bank statements',
            'Employment documents',
            'Property documents',
          ],
        ),
        const VisaCountry(
          id: '9',
          country: 'Canada',
          countryCode: 'CAN',
          flag: '🇨🇦',
          visaType: 'Visitor Visa',
          duration: '10 Years',
          processing: '20-30 Working Days',
          entry: 'Multiple Entry',
          price: 50000,
          colorValue: 0xFFFF0000,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Bank statements',
            'Employment letter',
            'Travel history',
            'Purpose of visit',
          ],
        ),
        const VisaCountry(
          id: '10',
          country: 'Australia',
          countryCode: 'AUS',
          flag: '🇦🇺',
          visaType: 'Visitor Visa',
          duration: '1 Year',
          processing: '20-30 Working Days',
          entry: 'Multiple Entry',
          price: 48000,
          colorValue: 0xFF00008B,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Bank statements',
            'Employment letter',
            'Health insurance',
          ],
        ),
        const VisaCountry(
          id: '11',
          country: 'Schengen',
          countryCode: 'EUR',
          flag: '🇪🇺',
          visaType: 'Tourist Visa',
          duration: '90 Days',
          processing: '15-20 Working Days',
          entry: 'Multiple Entry',
          price: 35000,
          colorValue: 0xFF003399,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Travel insurance',
            'Bank statements',
            'Flight reservation',
            'Hotel booking',
          ],
        ),
        const VisaCountry(
          id: '12',
          country: 'China',
          countryCode: 'CHN',
          flag: '🇨🇳',
          visaType: 'Tourist Visa',
          duration: '30 Days',
          processing: '7-10 Working Days',
          entry: 'Single Entry',
          price: 22000,
          colorValue: 0xFFDE2910,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Invitation letter',
            'Bank statement',
            'Flight itinerary',
          ],
        ),
        const VisaCountry(
          id: '13',
          country: 'Egypt',
          countryCode: 'EGY',
          flag: '🇪🇬',
          visaType: 'E-Visa',
          duration: '30 Days',
          processing: '5-7 Working Days',
          entry: 'Single Entry',
          price: 9000,
          colorValue: 0xFFC8102E,
          requirements: [
            'Valid passport',
            'Passport photograph',
            'Hotel booking',
            'Return ticket',
          ],
        ),
        const VisaCountry(
          id: '14',
          country: 'Indonesia',
          countryCode: 'IDN',
          flag: '🇮🇩',
          visaType: 'Visa on Arrival',
          duration: '30 Days',
          processing: 'On Arrival',
          entry: 'Single Entry',
          price: 8500,
          colorValue: 0xFFCE1126,
          requirements: [
            'Valid passport (6 months)',
            'Return ticket',
            'Proof of accommodation',
          ],
        ),
        const VisaCountry(
          id: '15',
          country: 'Singapore',
          countryCode: 'SGP',
          flag: '🇸🇬',
          visaType: 'Tourist Visa',
          duration: '30 Days',
          processing: '5-7 Working Days',
          entry: 'Single Entry',
          price: 14000,
          colorValue: 0xFFED2939,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Bank statement',
            'Employment letter',
            'Hotel booking',
          ],
        ),
        const VisaCountry(
          id: '16',
          country: 'Vietnam',
          countryCode: 'VNM',
          flag: '🇻🇳',
          visaType: 'E-Visa',
          duration: '30 Days',
          processing: '3-5 Working Days',
          entry: 'Single Entry',
          price: 8000,
          colorValue: 0xFFDA251D,
          requirements: [
            'Valid passport',
            'Passport photograph',
            'Travel itinerary',
          ],
        ),
        const VisaCountry(
          id: '17',
          country: 'Oman',
          countryCode: 'OMN',
          flag: '🇴🇲',
          visaType: 'Tourist Visa',
          duration: '30 Days',
          processing: '3-5 Working Days',
          entry: 'Single Entry',
          price: 12000,
          colorValue: 0xFF008000,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Hotel booking',
            'Return ticket',
          ],
        ),
        const VisaCountry(
          id: '18',
          country: 'Qatar',
          countryCode: 'QAT',
          flag: '🇶🇦',
          visaType: 'Tourist Visa',
          duration: '30 Days',
          processing: '3-5 Working Days',
          entry: 'Single Entry',
          price: 18000,
          colorValue: 0xFF8A1538,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Hotel booking',
            'Return ticket',
            'Bank statement',
          ],
        ),
        const VisaCountry(
          id: '19',
          country: 'Bahrain',
          countryCode: 'BHR',
          flag: '🇧🇭',
          visaType: 'E-Visa',
          duration: '14 Days',
          processing: '2-3 Working Days',
          entry: 'Single Entry',
          price: 10000,
          colorValue: 0xFFCE1126,
          requirements: [
            'Valid passport',
            'Passport photograph',
            'Hotel booking',
          ],
        ),
        const VisaCountry(
          id: '20',
          country: 'Jordan',
          countryCode: 'JOR',
          flag: '🇯🇴',
          visaType: 'Visa on Arrival',
          duration: '30 Days',
          processing: 'On Arrival',
          entry: 'Single Entry',
          price: 7500,
          colorValue: 0xFF007A3D,
          requirements: [
            'Valid passport',
            'Return ticket',
            'Hotel booking',
          ],
        ),
        const VisaCountry(
          id: '21',
          country: 'Sri Lanka',
          countryCode: 'LKA',
          flag: '🇱🇰',
          visaType: 'ETA',
          duration: '30 Days',
          processing: '24-48 Hours',
          entry: 'Double Entry',
          price: 6500,
          colorValue: 0xFF8D153A,
          requirements: [
            'Valid passport',
            'Return ticket',
          ],
        ),
        const VisaCountry(
          id: '22',
          country: 'Maldives',
          countryCode: 'MDV',
          flag: '🇲🇻',
          visaType: 'Visa on Arrival',
          duration: '30 Days',
          processing: 'On Arrival',
          entry: 'Single Entry',
          price: 0,
          colorValue: 0xFF00747C,
          requirements: [
            'Valid passport',
            'Confirmed hotel booking',
            'Return ticket',
          ],
        ),
        const VisaCountry(
          id: '23',
          country: 'Nepal',
          countryCode: 'NPL',
          flag: '🇳🇵',
          visaType: 'Visa on Arrival',
          duration: '30 Days',
          processing: 'On Arrival',
          entry: 'Multiple Entry',
          price: 4500,
          colorValue: 0xFFDC143C,
          requirements: [
            'Valid passport',
            'Passport photograph',
          ],
        ),
        const VisaCountry(
          id: '24',
          country: 'Japan',
          countryCode: 'JPN',
          flag: '🇯🇵',
          visaType: 'Tourist Visa',
          duration: '15 Days',
          processing: '7-10 Working Days',
          entry: 'Single Entry',
          price: 25000,
          colorValue: 0xFFBC002D,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Bank statement',
            'Employment letter',
            'Detailed itinerary',
          ],
        ),
        const VisaCountry(
          id: '25',
          country: 'South Korea',
          countryCode: 'KOR',
          flag: '🇰🇷',
          visaType: 'Tourist Visa',
          duration: '30 Days',
          processing: '7-10 Working Days',
          entry: 'Single Entry',
          price: 20000,
          colorValue: 0xFF003478,
          requirements: [
            'Valid passport',
            'Passport photographs',
            'Bank statement',
            'Employment documents',
            'Travel plan',
          ],
        ),
      ];

      state = state.copyWith(
        isLoading: false,
        countries: mockCountries,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  Future<void> refresh() async {
    await loadVisaCountries();
  }
}

final visaProvider = StateNotifierProvider<VisaNotifier, VisaState>((ref) {
  return VisaNotifier();
});
