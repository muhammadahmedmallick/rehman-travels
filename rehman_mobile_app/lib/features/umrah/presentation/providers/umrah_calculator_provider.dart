import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// --- Init Data Models ---

class CalcHotel {
  final int id;
  final String name;
  final String location;
  final String? description;
  final String type;
  final String basisType;
  final String distance;
  final DateTime? latestPeriodEnd;
  final bool hasAnyRates;

  const CalcHotel({
    required this.id,
    required this.name,
    required this.location,
    this.description,
    this.type = '',
    this.basisType = '',
    this.distance = '',
    this.latestPeriodEnd,
    this.hasAnyRates = false,
  });

  String get typeLabel {
    final n = int.tryParse(type);
    if (n != null && n > 0) return '$n Star${n > 1 ? 's' : ''}';
    return type;
  }

  String get basisLabel {
    switch (basisType.toUpperCase()) {
      case 'BB':
        return 'Bed & Breakfast';
      case 'HB':
        return 'Half Board';
      case 'FB':
        return 'Full Board';
      case 'RO':
        return 'Room Only';
      case 'WBF':
      case 'WB':
        return 'Without Breakfast';
      default:
        return basisType;
    }
  }

  factory CalcHotel.fromJson(Map<String, dynamic> j) {
    DateTime? latest;
    bool hasNonZero = false;
    final periods = j['available_periods'];
    if (periods is List) {
      for (final p in periods) {
        if (p is Map) {
          final to = DateTime.tryParse(p['to']?.toString() ?? '');
          if (to != null && (latest == null || to.isAfter(latest))) {
            latest = to;
          }
          final rp = p['room_prices'];
          if (rp is Map) {
            for (final entry in rp.values) {
              if (entry is Map) {
                final wd = (entry['weekday'] as num?)?.toDouble() ?? 0;
                final we = (entry['weekend'] as num?)?.toDouble() ?? 0;
                if (wd > 0 || we > 0) {
                  hasNonZero = true;
                  break;
                }
              }
            }
          }
        }
      }
    }
    return CalcHotel(
      id: j['id'] ?? 0,
      name: (j['name']?.toString() ?? '').trim(),
      location: j['location']?.toString() ?? '',
      description: j['description']?.toString(),
      type: j['type']?.toString() ?? '',
      basisType: j['basis_type']?.toString() ?? '',
      distance: j['distance']?.toString() ?? '',
      latestPeriodEnd: latest,
      hasAnyRates: hasNonZero,
    );
  }

  bool get hasActiveRates {
    if (latestPeriodEnd == null) return false;
    return !latestPeriodEnd!.isBefore(DateTime.now());
  }
}

class CalcVehicle {
  final int id;
  final String name;
  final double price;
  final String? description;

  const CalcVehicle({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  factory CalcVehicle.fromJson(Map<String, dynamic> j) => CalcVehicle(
        id: j['id'] ?? 0,
        name: j['name']?.toString() ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        description: j['description']?.toString(),
      );
}

class CalcSector {
  final int id;
  final String name;

  const CalcSector({
    required this.id,
    required this.name,
  });

  factory CalcSector.fromJson(Map<String, dynamic> j) => CalcSector(
        id: j['id'] ?? 0,
        name: j['name']?.toString() ?? '',
      );
}

class CalcVisa {
  final int id;
  final String name;
  final String nationality;
  final double price;

  const CalcVisa({
    required this.id,
    required this.name,
    required this.nationality,
    required this.price,
  });

  factory CalcVisa.fromJson(Map<String, dynamic> j) => CalcVisa(
        id: j['id'] ?? 0,
        name: j['name']?.toString() ?? '',
        nationality: j['nationality']?.toString() ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
      );
}

class CalcCurrency {
  final String code;
  final String name;
  final String symbol;

  const CalcCurrency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory CalcCurrency.fromJson(Map<String, dynamic> j) => CalcCurrency(
        code: j['code']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        symbol: j['symbol']?.toString() ?? '',
      );
}

class CalcInitData {
  final List<CalcHotel> hotels;
  final List<CalcSector> sectors;
  final List<CalcVehicle> vehicles;
  final List<CalcVisa> visas;
  final List<CalcCurrency> currencies;

  const CalcInitData({
    this.hotels = const [],
    this.sectors = const [],
    this.vehicles = const [],
    this.visas = const [],
    this.currencies = const [],
  });

  factory CalcInitData.fromJson(Map<String, dynamic> j) {
    // hotels is a Map keyed by city ("makkah" / "madinah"); flatten into list.
    final hotelsRaw = j['hotels'];
    final hotels = <CalcHotel>[];
    if (hotelsRaw is Map) {
      for (final entry in hotelsRaw.values) {
        if (entry is List) {
          for (final h in entry) {
            if (h is Map) {
              hotels.add(CalcHotel.fromJson(Map<String, dynamic>.from(h)));
            }
          }
        }
      }
    } else if (hotelsRaw is List) {
      for (final h in hotelsRaw) {
        if (h is Map) {
          hotels.add(CalcHotel.fromJson(Map<String, dynamic>.from(h)));
        }
      }
    }

    final transport = j['transport'] is Map
        ? Map<String, dynamic>.from(j['transport'] as Map)
        : const <String, dynamic>{};

    List<T> parseList<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return CalcInitData(
      hotels: hotels,
      sectors: parseList(transport['sectors'], CalcSector.fromJson),
      vehicles: parseList(transport['vehicles'], CalcVehicle.fromJson),
      visas: parseList(j['visas'], CalcVisa.fromJson),
      currencies: parseList(j['currencies'], CalcCurrency.fromJson),
    );
  }
}

// --- Form Input Models ---

class HotelInput {
  int? hotelId;
  String? hotelName;
  String location;
  DateTime? checkIn;
  DateTime? checkOut;
  int doubleRooms;
  int tripleRooms;
  int quadRooms;
  int quintRooms;

  HotelInput({
    this.hotelId,
    this.hotelName,
    this.location = 'Makkah',
    this.checkIn,
    this.checkOut,
    this.doubleRooms = 1,
    this.tripleRooms = 0,
    this.quadRooms = 0,
    this.quintRooms = 0,
  });

  int get totalRooms => doubleRooms + tripleRooms + quadRooms + quintRooms;

  int get nights {
    if (checkIn == null || checkOut == null) return 0;
    return checkOut!.difference(checkIn!).inDays;
  }

  Map<String, dynamic> toJson() => {
        'hotel_id': hotelId,
        'check_in': checkIn != null ? _fmt(checkIn!) : null,
        'check_out': checkOut != null ? _fmt(checkOut!) : null,
        'rooms': {
          'Double': doubleRooms,
          'Triple': tripleRooms,
          'Quad': quadRooms,
          'Quint': quintRooms,
        },
      };

  static String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// --- Response Models ---

class CalcHotelBreakdown {
  final String hotel;
  final String location;
  final String checkIn;
  final String checkOut;
  final int nights;
  final double price;
  final int doubleRooms;
  final int tripleRooms;
  final int quadRooms;
  final int quintRooms;

  const CalcHotelBreakdown({
    required this.hotel,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.price,
    this.doubleRooms = 0,
    this.tripleRooms = 0,
    this.quadRooms = 0,
    this.quintRooms = 0,
  });

  factory CalcHotelBreakdown.fromJson(Map<String, dynamic> j) {
    final rooms = j['rooms'] is Map
        ? Map<String, dynamic>.from(j['rooms'] as Map)
        : const <String, dynamic>{};
    int r(String k) => (rooms[k] as num?)?.toInt() ?? 0;
    return CalcHotelBreakdown(
      hotel: (j['hotel']?.toString() ?? '').trim(),
      location: j['location']?.toString() ?? '',
      checkIn: j['check_in']?.toString() ?? '',
      checkOut: j['check_out']?.toString() ?? '',
      nights: j['nights'] ?? 0,
      price: (j['price'] as num?)?.toDouble() ?? 0,
      doubleRooms: r('Double'),
      tripleRooms: r('Triple'),
      quadRooms: r('Quad'),
      quintRooms: r('Quint'),
    );
  }
}

class CalcBreakdown {
  final double hotelsTotal;
  final List<CalcHotelBreakdown> hotelDetails;
  final double transportTotal;
  final double visaTotal;
  final double flightTotal;

  const CalcBreakdown({
    this.hotelsTotal = 0,
    this.hotelDetails = const [],
    this.transportTotal = 0,
    this.visaTotal = 0,
    this.flightTotal = 0,
  });

  factory CalcBreakdown.fromJson(Map<String, dynamic> j) {
    final hotels = j['hotels'] as Map<String, dynamic>? ?? const {};
    final transport = j['transport'] as Map<String, dynamic>? ?? const {};
    final visa = j['visa'] as Map<String, dynamic>? ?? const {};
    final flight = j['flight'] as Map<String, dynamic>? ?? const {};
    return CalcBreakdown(
      hotelsTotal: (hotels['total'] as num?)?.toDouble() ?? 0,
      hotelDetails: (hotels['details'] as List?)
              ?.map((e) =>
                  CalcHotelBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transportTotal: (transport['total'] as num?)?.toDouble() ?? 0,
      visaTotal: (visa['total'] as num?)?.toDouble() ?? 0,
      flightTotal: (flight['total'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CalcTotals {
  final double sar;
  final double usd;
  final double gbp;
  final double eur;
  final double aed;

  const CalcTotals({
    this.sar = 0,
    this.usd = 0,
    this.gbp = 0,
    this.eur = 0,
    this.aed = 0,
  });

  factory CalcTotals.fromJson(Map<String, dynamic> j) => CalcTotals(
        sar: (j['sar'] as num?)?.toDouble() ?? 0,
        usd: (j['usd'] as num?)?.toDouble() ?? 0,
        gbp: (j['gbp'] as num?)?.toDouble() ?? 0,
        eur: (j['eur'] as num?)?.toDouble() ?? 0,
        aed: (j['aed'] as num?)?.toDouble() ?? 0,
      );
}

class CalcResponse {
  final CalcBreakdown breakdown;
  final CalcTotals totals;
  final int totalNights;
  final int totalRooms;
  final int adults;
  final int children;
  final int infants;

  const CalcResponse({
    required this.breakdown,
    required this.totals,
    this.totalNights = 0,
    this.totalRooms = 0,
    this.adults = 0,
    this.children = 0,
    this.infants = 0,
  });

  factory CalcResponse.fromJson(Map<String, dynamic> j) {
    final summary = j['summary'] as Map<String, dynamic>? ?? const {};
    final travelers = summary['travelers'] as Map<String, dynamic>? ?? const {};
    return CalcResponse(
      breakdown: CalcBreakdown.fromJson(
          j['breakdown'] as Map<String, dynamic>? ?? const {}),
      totals:
          CalcTotals.fromJson(j['totals'] as Map<String, dynamic>? ?? const {}),
      totalNights: summary['total_nights'] ?? 0,
      totalRooms: summary['total_rooms'] ?? 0,
      adults: travelers['adults'] ?? 0,
      children: travelers['children'] ?? 0,
      infants: travelers['infants'] ?? 0,
    );
  }
}

// --- State ---

class UmrahCalculatorState {
  final bool initLoading;
  final String? initError;
  final CalcInitData init;

  final int adults;
  final int children;
  final int infants;

  final List<HotelInput> hotels;

  final bool transportEnabled;
  final int? sectorId;
  final int? vehicleId;

  final bool visaEnabled;
  final int? visaId;

  final bool flightEnabled;
  final String? flightCurrency;
  final double adultPrice;
  final double childPrice;
  final double infantPrice;

  final String customerFirstName;
  final String customerEmail;
  final String customerMobile;
  final String customerCity;

  final bool calculating;
  final String? calcError;
  final CalcResponse? result;

  const UmrahCalculatorState({
    this.initLoading = false,
    this.initError,
    this.init = const CalcInitData(),
    this.adults = 2,
    this.children = 0,
    this.infants = 0,
    this.hotels = const [],
    this.transportEnabled = false,
    this.sectorId,
    this.vehicleId,
    this.visaEnabled = false,
    this.visaId,
    this.flightEnabled = false,
    this.flightCurrency,
    this.adultPrice = 0,
    this.childPrice = 0,
    this.infantPrice = 0,
    this.customerFirstName = '',
    this.customerEmail = '',
    this.customerMobile = '',
    this.customerCity = '',
    this.calculating = false,
    this.calcError,
    this.result,
  });

  UmrahCalculatorState copyWith({
    bool? initLoading,
    String? initError,
    CalcInitData? init,
    int? adults,
    int? children,
    int? infants,
    List<HotelInput>? hotels,
    bool? transportEnabled,
    int? sectorId,
    int? vehicleId,
    bool? visaEnabled,
    int? visaId,
    bool? flightEnabled,
    String? flightCurrency,
    double? adultPrice,
    double? childPrice,
    double? infantPrice,
    String? customerFirstName,
    String? customerEmail,
    String? customerMobile,
    String? customerCity,
    bool? calculating,
    String? calcError,
    CalcResponse? result,
    bool clearResult = false,
    bool clearCalcError = false,
  }) {
    return UmrahCalculatorState(
      initLoading: initLoading ?? this.initLoading,
      initError: initError,
      init: init ?? this.init,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      hotels: hotels ?? this.hotels,
      transportEnabled: transportEnabled ?? this.transportEnabled,
      sectorId: sectorId ?? this.sectorId,
      vehicleId: vehicleId ?? this.vehicleId,
      visaEnabled: visaEnabled ?? this.visaEnabled,
      visaId: visaId ?? this.visaId,
      flightEnabled: flightEnabled ?? this.flightEnabled,
      flightCurrency: flightCurrency ?? this.flightCurrency,
      adultPrice: adultPrice ?? this.adultPrice,
      childPrice: childPrice ?? this.childPrice,
      infantPrice: infantPrice ?? this.infantPrice,
      customerFirstName: customerFirstName ?? this.customerFirstName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerMobile: customerMobile ?? this.customerMobile,
      customerCity: customerCity ?? this.customerCity,
      calculating: calculating ?? this.calculating,
      calcError: clearCalcError ? null : (calcError ?? this.calcError),
      result: clearResult ? null : (result ?? this.result),
    );
  }
}

// --- Notifier ---

class UmrahCalculatorNotifier extends StateNotifier<UmrahCalculatorState> {
  final CoreApiClient _api;

  UmrahCalculatorNotifier(this._api)
      : super(UmrahCalculatorState(
          hotels: [
            HotelInput(
              location: 'Makkah',
              checkIn: DateTime.now().add(const Duration(days: 3)),
              checkOut: DateTime.now().add(const Duration(days: 6)),
            ),
          ],
        )) {
    loadInit();
  }

  Future<void> loadInit() async {
    state = state.copyWith(initLoading: true, initError: null);
    try {
      final res = await _api.get(ApiEndpoints.umrahCalculatorInit);
      if (res.statusCode == 200 && res.data is Map) {
        final data = CalcInitData.fromJson(Map<String, dynamic>.from(res.data));
        state = state.copyWith(initLoading: false, init: data);
      } else {
        state =
            state.copyWith(initLoading: false, initError: 'Failed to load');
      }
    } catch (e) {
      if (kDebugMode) print('Umrah calc init error: $e');
      state = state.copyWith(initLoading: false, initError: e.toString());
    }
  }

  // Travelers
  void setAdults(int v) => state = state.copyWith(adults: v.clamp(1, 20));
  void setChildren(int v) => state = state.copyWith(children: v.clamp(0, 20));
  void setInfants(int v) => state = state.copyWith(infants: v.clamp(0, 20));

  // Hotels
  void addHotel() {
    if (state.hotels.length >= 3) return;
    final last = state.hotels.last;
    final nextLocation = last.location == 'Makkah' ? 'Madinah' : 'Makkah';
    final newHotels = [
      ...state.hotels,
      HotelInput(
        location: nextLocation,
        checkIn: last.checkOut,
        checkOut: last.checkOut?.add(const Duration(days: 4)),
      ),
    ];
    state = state.copyWith(hotels: newHotels);
  }

  void removeHotel(int index) {
    if (state.hotels.length <= 1) return;
    final newHotels = [...state.hotels]..removeAt(index);
    state = state.copyWith(hotels: newHotels);
  }

  void updateHotel(int index, HotelInput updated) {
    final newHotels = [...state.hotels];
    newHotels[index] = updated;
    state = state.copyWith(hotels: newHotels);
  }

  // Toggles
  void setTransportEnabled(bool v) =>
      state = state.copyWith(transportEnabled: v);
  void setSector(int? id) =>
      state = state.copyWith(sectorId: id, vehicleId: null);
  void setVehicle(int? id) => state = state.copyWith(vehicleId: id);

  void setVisaEnabled(bool v) => state = state.copyWith(visaEnabled: v);
  void setVisa(int? id) => state = state.copyWith(visaId: id);

  void setFlightEnabled(bool v) => state = state.copyWith(flightEnabled: v);
  void setFlightCurrency(String? c) => state = state.copyWith(flightCurrency: c);
  void setAdultPrice(double v) => state = state.copyWith(adultPrice: v);
  void setChildPrice(double v) => state = state.copyWith(childPrice: v);
  void setInfantPrice(double v) => state = state.copyWith(infantPrice: v);

  // Customer
  void setCustomerFirstName(String v) =>
      state = state.copyWith(customerFirstName: v);
  void setCustomerEmail(String v) => state = state.copyWith(customerEmail: v);
  void setCustomerMobile(String v) => state = state.copyWith(customerMobile: v);
  void setCustomerCity(String v) => state = state.copyWith(customerCity: v);

  // Validation — returns error message or null if valid
  String? validate() {
    if (state.customerFirstName.trim().isEmpty) return 'Please enter your name';
    if (state.customerMobile.trim().isEmpty) return 'Please enter your mobile number';
    if (state.customerEmail.trim().isEmpty) return 'Please enter your email';
    final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRe.hasMatch(state.customerEmail.trim())) {
      return 'Please enter a valid email';
    }
    if (state.hotels.isEmpty) return 'Add at least one hotel';
    for (var i = 0; i < state.hotels.length; i++) {
      final h = state.hotels[i];
      if (h.hotelId == null) return 'Hotel ${i + 1}: please select a hotel';
      if (h.checkIn == null || h.checkOut == null) {
        return 'Hotel ${i + 1}: please select check-in and check-out dates';
      }
      if (h.totalRooms == 0) {
        return 'Hotel ${i + 1}: please select at least one room';
      }
    }
    if (state.transportEnabled) {
      if (state.sectorId == null) return 'Transport: please select a sector';
      if (state.vehicleId == null) return 'Transport: please select a vehicle';
    }
    if (state.visaEnabled && state.visaId == null) {
      return 'Visa: please select a nationality';
    }
    if (state.flightEnabled) {
      if (state.flightCurrency == null) return 'Flight: please select a currency';
      if (state.adultPrice == 0 && state.adults > 0) {
        return 'Flight: please enter adult price';
      }
    }
    return null;
  }

  // Calculate
  Future<void> calculate() async {
    final validationError = validate();
    if (validationError != null) {
      state = state.copyWith(calculating: false, calcError: validationError);
      return;
    }
    state = state.copyWith(
        calculating: true, clearCalcError: true, clearResult: true);
    try {
      final body = {
        'travelers': {
          'adults': state.adults,
          'children': state.children,
          'infants': state.infants,
        },
        'hotels': state.hotels.map((h) => h.toJson()).toList(),
        'transport': {
          'enabled': state.transportEnabled,
          'sector_id': state.sectorId,
          'vehicle_id': state.vehicleId,
        },
        'visa': {
          'enabled': state.visaEnabled,
          'nationality': state.visaId,
        },
        'flight': {
          'enabled': state.flightEnabled,
          'currency': state.flightCurrency,
          'adult_price': state.adultPrice,
          'child_price': state.childPrice,
          'infant_price': state.infantPrice,
        },
      };
      final res = await _api.post(
        ApiEndpoints.umrahCalculatorCalculate,
        data: body,
      );
      if (res.statusCode == 200 && res.data is Map) {
        final result =
            CalcResponse.fromJson(Map<String, dynamic>.from(res.data));
        state = state.copyWith(calculating: false, result: result);
      } else {
        state = state.copyWith(
            calculating: false, calcError: 'Calculation failed');
      }
    } on DioException catch (e) {
      if (kDebugMode) print('Umrah calculate error: $e');
      state =
          state.copyWith(calculating: false, calcError: _parseDioError(e));
    } catch (e) {
      if (kDebugMode) print('Umrah calculate error: $e');
      state = state.copyWith(calculating: false, calcError: e.toString());
    }
  }

  String _parseDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        return errors.values.map((v) => v.toString()).join('\n');
      }
      if (data['detail'] != null) return data['detail'].toString();
      if (data['message'] != null) return data['message'].toString();
    }
    return e.message ?? 'Request failed';
  }
}

final umrahCalculatorProvider =
    StateNotifierProvider<UmrahCalculatorNotifier, UmrahCalculatorState>(
  (ref) => UmrahCalculatorNotifier(ref.watch(coreApiClientProvider)),
);
