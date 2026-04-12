import 'package:flutter/foundation.dart';
import '../models/calculator_models.dart';
import '../models/price_models.dart';
import '../services/umrah_api_service.dart';

class CalculatorProvider with ChangeNotifier {
  final UmrahApiService _apiService = UmrahApiService();

  // State
  CalculatorInitData? initData;
  PriceBreakdown? priceBreakdown;

  bool isLoadingInit = false;
  bool isCalculating = false;
  bool isBooking = false;

  String? errorMessage;

  // User selections
  int adults = 2;
  int children = 0;
  int infants = 0;

  List<HotelBooking> selectedHotels = [];

  bool transportEnabled = false;
  int? selectedSectorId;
  int? selectedVehicleId;

  bool visaEnabled = false;
  String visaNationality = 'Pakistan';

  bool flightEnabled = false;
  String flightCurrency = 'USD';
  double adultFlightPrice = 0.0;
  double childFlightPrice = 0.0;
  double infantFlightPrice = 0.0;

  /// Initialize calculator - fetch all data
  Future<void> initialize() async {
    isLoadingInit = true;
    errorMessage = null;
    notifyListeners();

    try {
      initData = await _apiService.getCalculatorInit();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      print('Error initializing calculator: $e');
    } finally {
      isLoadingInit = false;
      notifyListeners();
    }
  }

  /// Add hotel booking
  void addHotel(HotelBooking hotel) {
    if (selectedHotels.length < 3) {
      selectedHotels.add(hotel);
      notifyListeners();
    }
  }

  /// Remove hotel by index
  void removeHotel(int index) {
    if (index >= 0 && index < selectedHotels.length) {
      selectedHotels.removeAt(index);
      notifyListeners();
    }
  }

  /// Update hotel in list
  void updateHotel(int index, HotelBooking hotel) {
    if (index >= 0 && index < selectedHotels.length) {
      selectedHotels[index] = hotel;
      notifyListeners();
    }
  }

  /// Update all selected hotels
  void updateHotels(List<HotelBooking> hotels) {
    selectedHotels = hotels;
    notifyListeners();
  }

  /// Update traveler counts
  void updateTravelers({int? adults, int? children, int? infants}) {
    if (adults != null) this.adults = adults;
    if (children != null) this.children = children;
    if (infants != null) this.infants = infants;
    notifyListeners();
  }

  /// Update transport settings
  void updateTransport({
    bool? enabled,
    int? sectorId,
    int? vehicleId,
  }) {
    if (enabled != null) transportEnabled = enabled;
    if (sectorId != null) selectedSectorId = sectorId;
    if (vehicleId != null) selectedVehicleId = vehicleId;
    notifyListeners();
  }

  /// Update visa settings
  void updateVisa({bool? enabled, String? nationality}) {
    if (enabled != null) visaEnabled = enabled;
    if (nationality != null) visaNationality = nationality;
    notifyListeners();
  }

  /// Update flight settings
  void updateFlight({
    bool? enabled,
    String? currency,
    double? adultPrice,
    double? childPrice,
    double? infantPrice,
  }) {
    if (enabled != null) flightEnabled = enabled;
    if (currency != null) flightCurrency = currency;
    if (adultPrice != null) adultFlightPrice = adultPrice;
    if (childPrice != null) childFlightPrice = childPrice;
    if (infantPrice != null) infantFlightPrice = infantPrice;
    notifyListeners();
  }

  /// Calculate price
  Future<bool> calculatePrice() async {
    if (!_validateCalculation()) {
      errorMessage = 'Please complete all required fields';
      notifyListeners();
      return false;
    }

    isCalculating = true;
    errorMessage = null;
    priceBreakdown = null;
    notifyListeners();

    try {
      final request = _buildBookingRequest();
      priceBreakdown = await _apiService.calculatePrice(request);
      errorMessage = null;
      isCalculating = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isCalculating = false;
      notifyListeners();
      return false;
    }
  }

  /// Create booking
  Future<BookingResponse?> createBooking({
    required String firstName,
    required String email,
    required String mobile,
    int? cityId,
  }) async {
    if (!_validateCalculation()) {
      errorMessage = 'Please complete all required fields';
      notifyListeners();
      return null;
    }

    isBooking = true;
    errorMessage = null;
    notifyListeners();

    try {
      final request = _buildBookingRequest(
        customer: Customer(
          firstName: firstName,
          email: email,
          mobile: mobile,
        ),
        cityId: cityId,
      );

      final response = await _apiService.createBooking(request);
      errorMessage = null;
      isBooking = false;
      notifyListeners();
      return response;
    } catch (e) {
      errorMessage = e.toString();
      isBooking = false;
      notifyListeners();
      return null;
    }
  }

  /// Build booking request from current state
  BookingRequest _buildBookingRequest({
    Customer? customer,
    int? cityId,
  }) {
    return BookingRequest(
      travelers: Travelers(
        adults: adults,
        children: children,
        infants: infants,
      ),
      hotels: selectedHotels,
      transport: Transport(
        enabled: transportEnabled,
        sectorId: selectedSectorId,
        vehicleId: selectedVehicleId,
      ),
      visa: Visa(
        enabled: visaEnabled,
        nationality: visaNationality,
      ),
      flight: flightEnabled
          ? Flight(
              enabled: true,
              currency: flightCurrency,
              adultPrice: adultFlightPrice,
              childPrice: childFlightPrice,
              infantPrice: infantFlightPrice,
            )
          : null,
      customer: customer,
      cityId: cityId,
    );
  }

  /// Validate calculation input
  bool _validateCalculation() {
    // Must have at least 1 traveler (adult or child)
    if (adults + children == 0) {
      return false;
    }

    // Must have at least 1 hotel
    if (selectedHotels.isEmpty) {
      return false;
    }

    // If transport enabled, must have sector and vehicle
    if (transportEnabled && (selectedSectorId == null || selectedVehicleId == null)) {
      return false;
    }

    return true;
  }

  /// Reset calculator
  void reset() {
    adults = 2;
    children = 0;
    infants = 0;
    selectedHotels = [];
    transportEnabled = false;
    selectedSectorId = null;
    selectedVehicleId = null;
    visaEnabled = false;
    visaNationality = 'Pakistan';
    flightEnabled = false;
    flightCurrency = 'USD';
    adultFlightPrice = 0.0;
    childFlightPrice = 0.0;
    infantFlightPrice = 0.0;
    priceBreakdown = null;
    errorMessage = null;
    notifyListeners();
  }

  /// Get selected sector name
  String? getSelectedSectorName() {
    if (selectedSectorId == null || initData == null) return null;
    try {
      return initData!.transport.sectors
          .firstWhere((s) => s.id == selectedSectorId)
          .name;
    } catch (e) {
      return null;
    }
  }

  /// Get selected vehicle name
  String? getSelectedVehicleName() {
    if (selectedVehicleId == null || initData == null) return null;
    try {
      return initData!.transport.vehicles
          .firstWhere((v) => v.id == selectedVehicleId)
          .name;
    } catch (e) {
      return null;
    }
  }

  /// Get hotel by ID
  Hotel? getHotelById(int hotelId) {
    if (initData == null) return null;
    try {
      return [...initData!.hotels.makkah, ...initData!.hotels.madinah]
          .firstWhere((h) => h.id == hotelId);
    } catch (e) {
      return null;
    }
  }
}
