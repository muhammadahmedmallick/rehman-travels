import 'package:json_annotation/json_annotation.dart';

part 'price_models.g.dart';

@JsonSerializable()
class PriceBreakdown {
  final PriceBreakdownDetail breakdown;
  final PriceTotals totals;
  final PriceSummary summary;

  PriceBreakdown({
    required this.breakdown,
    required this.totals,
    required this.summary,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PriceBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$PriceBreakdownToJson(this);
}

@JsonSerializable()
class PriceBreakdownDetail {
  final HotelsBreakdown hotels;
  final TransportBreakdown transport;
  final VisaBreakdown visa;
  final FlightBreakdown flight;

  PriceBreakdownDetail({
    required this.hotels,
    required this.transport,
    required this.visa,
    required this.flight,
  });

  factory PriceBreakdownDetail.fromJson(Map<String, dynamic> json) =>
      _$PriceBreakdownDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PriceBreakdownDetailToJson(this);
}

@JsonSerializable()
class HotelsBreakdown {
  final double total;
  final List<HotelDetail> details;

  HotelsBreakdown({
    required this.total,
    required this.details,
  });

  factory HotelsBreakdown.fromJson(Map<String, dynamic> json) =>
      _$HotelsBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$HotelsBreakdownToJson(this);
}

@JsonSerializable()
class HotelDetail {
  final String hotel;
  final String location;
  @JsonKey(name: 'check_in')
  final String checkIn;
  @JsonKey(name: 'check_out')
  final String checkOut;
  final int nights;
  @JsonKey(name: 'weekday_nights')
  final int weekdayNights;
  @JsonKey(name: 'weekend_nights')
  final int weekendNights;
  final Map<String, int> rooms;
  final double price;

  HotelDetail({
    required this.hotel,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.weekdayNights,
    required this.weekendNights,
    required this.rooms,
    required this.price,
  });

  factory HotelDetail.fromJson(Map<String, dynamic> json) =>
      _$HotelDetailFromJson(json);
  Map<String, dynamic> toJson() => _$HotelDetailToJson(this);
}

@JsonSerializable()
class TransportBreakdown {
  final double total;
  @JsonKey(name: 'vehicle_id')
  final int? vehicleId;
  @JsonKey(name: 'sector_id')
  final int? sectorId;
  @JsonKey(name: 'base_price')
  final double? basePrice;
  final double? markup;

  TransportBreakdown({
    required this.total,
    this.vehicleId,
    this.sectorId,
    this.basePrice,
    this.markup,
  });

  factory TransportBreakdown.fromJson(Map<String, dynamic> json) =>
      _$TransportBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$TransportBreakdownToJson(this);
}

@JsonSerializable()
class VisaBreakdown {
  final double total;
  final String nationality;
  @JsonKey(name: 'price_per_person')
  final double pricePerPerson;
  final int travelers;

  VisaBreakdown({
    required this.total,
    required this.nationality,
    required this.pricePerPerson,
    required this.travelers,
  });

  factory VisaBreakdown.fromJson(Map<String, dynamic> json) =>
      _$VisaBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$VisaBreakdownToJson(this);
}

@JsonSerializable()
class FlightBreakdown {
  final double total;
  final String currency;
  final FlightTravelerDetail adults;
  final FlightTravelerDetail children;
  final FlightTravelerDetail infants;

  FlightBreakdown({
    required this.total,
    required this.currency,
    required this.adults,
    required this.children,
    required this.infants,
  });

  factory FlightBreakdown.fromJson(Map<String, dynamic> json) =>
      _$FlightBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$FlightBreakdownToJson(this);
}

@JsonSerializable()
class FlightTravelerDetail {
  final int count;
  @JsonKey(name: 'price_original')
  final double priceOriginal;
  @JsonKey(name: 'price_sar')
  final double priceSar;
  final double total;

  FlightTravelerDetail({
    required this.count,
    required this.priceOriginal,
    required this.priceSar,
    required this.total,
  });

  factory FlightTravelerDetail.fromJson(Map<String, dynamic> json) =>
      _$FlightTravelerDetailFromJson(json);
  Map<String, dynamic> toJson() => _$FlightTravelerDetailToJson(this);
}

@JsonSerializable()
class PriceTotals {
  final double sar;
  final double usd;
  final double gbp;
  @JsonKey(name: 'without_flight')
  final WithoutFlightTotals withoutFlight;

  PriceTotals({
    required this.sar,
    required this.usd,
    required this.gbp,
    required this.withoutFlight,
  });

  factory PriceTotals.fromJson(Map<String, dynamic> json) =>
      _$PriceTotalsFromJson(json);
  Map<String, dynamic> toJson() => _$PriceTotalsToJson(this);
}

@JsonSerializable()
class WithoutFlightTotals {
  final double sar;
  final double usd;
  final double gbp;

  WithoutFlightTotals({
    required this.sar,
    required this.usd,
    required this.gbp,
  });

  factory WithoutFlightTotals.fromJson(Map<String, dynamic> json) =>
      _$WithoutFlightTotalsFromJson(json);
  Map<String, dynamic> toJson() => _$WithoutFlightTotalsToJson(this);
}

@JsonSerializable()
class PriceSummary {
  @JsonKey(name: 'total_nights')
  final int totalNights;
  @JsonKey(name: 'total_rooms')
  final int totalRooms;
  final SummaryTravelers travelers;

  PriceSummary({
    required this.totalNights,
    required this.totalRooms,
    required this.travelers,
  });

  factory PriceSummary.fromJson(Map<String, dynamic> json) =>
      _$PriceSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$PriceSummaryToJson(this);
}

@JsonSerializable()
class SummaryTravelers {
  final int adults;
  final int children;
  final int infants;
  final int total;

  SummaryTravelers({
    required this.adults,
    required this.children,
    required this.infants,
    required this.total,
  });

  factory SummaryTravelers.fromJson(Map<String, dynamic> json) =>
      _$SummaryTravelersFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryTravelersToJson(this);
}

// Booking Response Models

@JsonSerializable()
class BookingResponse {
  final bool success;
  @JsonKey(name: 'booking_id')
  final int bookingId;
  @JsonKey(name: 'customer_id')
  final int customerId;
  final PriceTotals totals;
  final Quotation quotation;

  BookingResponse({
    required this.success,
    required this.bookingId,
    required this.customerId,
    required this.totals,
    required this.quotation,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BookingResponseToJson(this);
}

@JsonSerializable()
class Quotation {
  final String html;
  final String text;
  @JsonKey(name: 'whatsapp_link')
  final String whatsappLink;
  @JsonKey(name: 'whatsapp_link_custom')
  final String whatsappLinkCustom;

  Quotation({
    required this.html,
    required this.text,
    required this.whatsappLink,
    required this.whatsappLinkCustom,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) =>
      _$QuotationFromJson(json);
  Map<String, dynamic> toJson() => _$QuotationToJson(this);
}

// Package Content Models

@JsonSerializable()
class PackageContent {
  final int id;
  final String title;
  final String url;
  final PackageMeta meta;
  final PackageImages images;
  final PackagePricing pricing;
  final PackageContentData content;

  PackageContent({
    required this.id,
    required this.title,
    required this.url,
    required this.meta,
    required this.images,
    required this.pricing,
    required this.content,
  });

  factory PackageContent.fromJson(Map<String, dynamic> json) =>
      _$PackageContentFromJson(json);
  Map<String, dynamic> toJson() => _$PackageContentToJson(this);
}

@JsonSerializable()
class PackageMeta {
  final String title;
  final String description;
  @JsonKey(name: 'canonical_url')
  final String? canonicalUrl;

  PackageMeta({
    required this.title,
    required this.description,
    this.canonicalUrl,
  });

  factory PackageMeta.fromJson(Map<String, dynamic> json) =>
      _$PackageMetaFromJson(json);
  Map<String, dynamic> toJson() => _$PackageMetaToJson(this);
}

@JsonSerializable()
class PackageImages {
  final String banner;
  final String card;

  PackageImages({
    required this.banner,
    required this.card,
  });

  factory PackageImages.fromJson(Map<String, dynamic> json) =>
      _$PackageImagesFromJson(json);
  Map<String, dynamic> toJson() => _$PackageImagesToJson(this);
}

@JsonSerializable()
class PackagePricing {
  final String currency;
  final String price;

  PackagePricing({
    required this.currency,
    required this.price,
  });

  factory PackagePricing.fromJson(Map<String, dynamic> json) =>
      _$PackagePricingFromJson(json);
  Map<String, dynamic> toJson() => _$PackagePricingToJson(this);
}

@JsonSerializable()
class PackageContentData {
  final ContentFormat html;
  final ContentFormat markdown;

  PackageContentData({
    required this.html,
    required this.markdown,
  });

  factory PackageContentData.fromJson(Map<String, dynamic> json) =>
      _$PackageContentDataFromJson(json);
  Map<String, dynamic> toJson() => _$PackageContentDataToJson(this);
}

@JsonSerializable()
class ContentFormat {
  @JsonKey(name: 'short_description')
  final String shortDescription;
  final String description;
  final String includes;
  final String excludes;

  ContentFormat({
    required this.shortDescription,
    required this.description,
    required this.includes,
    required this.excludes,
  });

  factory ContentFormat.fromJson(Map<String, dynamic> json) =>
      _$ContentFormatFromJson(json);
  Map<String, dynamic> toJson() => _$ContentFormatToJson(this);
}
