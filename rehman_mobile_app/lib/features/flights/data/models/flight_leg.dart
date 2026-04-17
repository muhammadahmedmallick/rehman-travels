import 'package:intl/intl.dart';

class FlightLeg {
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final DateTime? date;

  const FlightLeg({
    this.fromCode = '',
    this.fromName = '',
    this.toCode = '',
    this.toName = '',
    this.date,
  });

  FlightLeg copyWith({
    String? fromCode,
    String? fromName,
    String? toCode,
    String? toName,
    DateTime? date,
  }) {
    return FlightLeg(
      fromCode: fromCode ?? this.fromCode,
      fromName: fromName ?? this.fromName,
      toCode: toCode ?? this.toCode,
      toName: toName ?? this.toName,
      date: date ?? this.date,
    );
  }

  bool get isValid => fromCode.isNotEmpty && toCode.isNotEmpty && date != null;

  String get fromDisplay => fromCode.isNotEmpty ? '$fromCode - $fromName' : '';
  String get toDisplay => toCode.isNotEmpty ? '$toCode - $toName' : '';

  /// Full payload including display names. The search provider
  /// strips the name fields before posting to the backend (they're
  /// kept in state so UI code can resolve per-leg city names for
  /// headers / cards without a separate lookup).
  Map<String, dynamic> toApiPayload() => {
    'departureCode': fromCode,
    'arrivalCode': toCode,
    'departureName': fromName,
    'arrivalName': toName,
    'outboundDate': date != null ? DateFormat('yyyy-MM-dd').format(date!) : '',
  };
}
