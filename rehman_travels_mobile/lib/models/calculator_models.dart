import 'package:json_annotation/json_annotation.dart';

part 'calculator_models.g.dart';

@JsonSerializable()
class CalculatorInitData {
  final CalculatorHotels hotels;
  final TransportData transport;
  final List<VisaOption> visas;
  final List<CurrencyData> currencies;

  CalculatorInitData({
    required this.hotels,
    required this.transport,
    required this.visas,
    required this.currencies,
  });

  factory CalculatorInitData.fromJson(Map<String, dynamic> json) =>
      _$CalculatorInitDataFromJson(json);
  Map<String, dynamic> toJson() => _$CalculatorInitDataToJson(this);
}

@JsonSerializable()
class CalculatorHotels {
  final List<Hotel> makkah;
  final List<Hotel> madinah;

  CalculatorHotels({
    required this.makkah,
    required this.madinah,
  });

  factory CalculatorHotels.fromJson(Map<String, dynamic> json) =>
      _$CalculatorHotelsFromJson(json);
  Map<String, dynamic> toJson() => _$CalculatorHotelsToJson(this);
}

@JsonSerializable()
class Hotel {
  final int id;
  final String name;
  final String location;
  final String distance;
  final String type;
  @JsonKey(name: 'basis_type')
  final String basisType;
  final String description;
  @JsonKey(name: 'available_periods')
  final List<HotelPeriod> availablePeriods;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.type,
    required this.basisType,
    required this.description,
    required this.availablePeriods,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => _$HotelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelToJson(this);
}

@JsonSerializable()
class HotelPeriod {
  final int id;
  final String from;
  final String to;
  @JsonKey(name: 'is_ramadan')
  final bool isRamadan;
  @JsonKey(name: 'room_prices')
  final Map<String, RoomPrice> roomPrices;

  HotelPeriod({
    required this.id,
    required this.from,
    required this.to,
    required this.isRamadan,
    required this.roomPrices,
  });

  factory HotelPeriod.fromJson(Map<String, dynamic> json) =>
      _$HotelPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$HotelPeriodToJson(this);
}

@JsonSerializable()
class RoomPrice {
  final double weekday;
  final double weekend;
  final double markup;

  RoomPrice({
    required this.weekday,
    required this.weekend,
    required this.markup,
  });

  factory RoomPrice.fromJson(Map<String, dynamic> json) =>
      _$RoomPriceFromJson(json);
  Map<String, dynamic> toJson() => _$RoomPriceToJson(this);
}

@JsonSerializable()
class TransportData {
  final List<Sector> sectors;
  final List<Vehicle> vehicles;
  final List<VehiclePrice> prices;

  TransportData({
    required this.sectors,
    required this.vehicles,
    required this.prices,
  });

  factory TransportData.fromJson(Map<String, dynamic> json) =>
      _$TransportDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransportDataToJson(this);
}

@JsonSerializable()
class Sector {
  final int id;
  final String name;
  final String markup;

  Sector({
    required this.id,
    required this.name,
    required this.markup,
  });

  factory Sector.fromJson(Map<String, dynamic> json) => _$SectorFromJson(json);
  Map<String, dynamic> toJson() => _$SectorToJson(this);
}

@JsonSerializable()
class Vehicle {
  final int id;
  final String name;
  final String markup;

  Vehicle({
    required this.id,
    required this.name,
    required this.markup,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}

@JsonSerializable()
class VehiclePrice {
  @JsonKey(name: 'vehicle_id')
  final int vehicleId;
  @JsonKey(name: 'sector_id')
  final int sectorId;
  final double price;
  @JsonKey(name: 'markup_price')
  final double markupPrice;

  VehiclePrice({
    required this.vehicleId,
    required this.sectorId,
    required this.price,
    required this.markupPrice,
  });

  factory VehiclePrice.fromJson(Map<String, dynamic> json) =>
      _$VehiclePriceFromJson(json);
  Map<String, dynamic> toJson() => _$VehiclePriceToJson(this);
}

@JsonSerializable()
class VisaOption {
  final int id;
  final String name;
  final String nationality;
  final double price;
  final String from;
  final String to;

  VisaOption({
    required this.id,
    required this.name,
    required this.nationality,
    required this.price,
    required this.from,
    required this.to,
  });

  factory VisaOption.fromJson(Map<String, dynamic> json) =>
      _$VisaOptionFromJson(json);
  Map<String, dynamic> toJson() => _$VisaOptionToJson(this);
}

@JsonSerializable()
class CurrencyData {
  final String code;
  final String name;
  final String symbol;
  final double rate;
  final String flag;

  CurrencyData({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
    required this.flag,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDataFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyDataToJson(this);
}

// Booking Request Models

@JsonSerializable()
class BookingRequest {
  final Travelers travelers;
  final List<HotelBooking> hotels;
  final Transport transport;
  final Visa visa;
  final Flight? flight;
  final Customer? customer;
  @JsonKey(name: 'city_id')
  final int? cityId;

  BookingRequest({
    required this.travelers,
    required this.hotels,
    required this.transport,
    required this.visa,
    this.flight,
    this.customer,
    this.cityId,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BookingRequestToJson(this);
}

@JsonSerializable()
class Travelers {
  final int adults;
  final int children;
  final int infants;

  Travelers({
    required this.adults,
    required this.children,
    required this.infants,
  });

  factory Travelers.fromJson(Map<String, dynamic> json) =>
      _$TravelersFromJson(json);
  Map<String, dynamic> toJson() => _$TravelersToJson(this);
}

@JsonSerializable()
class HotelBooking {
  final String location;
  @JsonKey(name: 'hotel_id')
  final int hotelId;
  @JsonKey(name: 'check_in')
  final String checkIn;
  @JsonKey(name: 'check_out')
  final String checkOut;
  final Map<String, int> rooms;

  HotelBooking({
    required this.location,
    required this.hotelId,
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
  });

  factory HotelBooking.fromJson(Map<String, dynamic> json) =>
      _$HotelBookingFromJson(json);
  Map<String, dynamic> toJson() => _$HotelBookingToJson(this);
}

@JsonSerializable()
class Transport {
  final bool enabled;
  @JsonKey(name: 'sector_id')
  final int? sectorId;
  @JsonKey(name: 'vehicle_id')
  final int? vehicleId;

  Transport({
    required this.enabled,
    this.sectorId,
    this.vehicleId,
  });

  factory Transport.fromJson(Map<String, dynamic> json) =>
      _$TransportFromJson(json);
  Map<String, dynamic> toJson() => _$TransportToJson(this);
}

@JsonSerializable()
class Visa {
  final bool enabled;
  final String nationality;

  Visa({
    required this.enabled,
    required this.nationality,
  });

  factory Visa.fromJson(Map<String, dynamic> json) => _$VisaFromJson(json);
  Map<String, dynamic> toJson() => _$VisaToJson(this);
}

@JsonSerializable()
class Flight {
  final bool enabled;
  final String currency;
  @JsonKey(name: 'adult_price')
  final double adultPrice;
  @JsonKey(name: 'child_price')
  final double childPrice;
  @JsonKey(name: 'infant_price')
  final double infantPrice;
  final String? sector;
  final String? departure;
  final String? arrival;

  Flight({
    required this.enabled,
    required this.currency,
    required this.adultPrice,
    required this.childPrice,
    required this.infantPrice,
    this.sector,
    this.departure,
    this.arrival,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => _$FlightFromJson(json);
  Map<String, dynamic> toJson() => _$FlightToJson(this);
}

@JsonSerializable()
class Customer {
  @JsonKey(name: 'first_name')
  final String firstName;
  final String email;
  final String mobile;

  Customer({
    required this.firstName,
    required this.email,
    required this.mobile,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
