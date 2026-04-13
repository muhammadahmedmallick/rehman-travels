/// A single saved flight search the user has performed.
///
/// Stored as a JSON string in a Hive `Box<String>` so we don't need a
/// TypeAdapter and can evolve the schema (or add multi-city legs)
/// without a migration.
class RecentSearchItem {
  final String tripType; // 'one-way' / 'round-trip' / 'multi-city'
  final String departureCode;
  final String departureName;
  final String arrivalCode;
  final String arrivalName;
  final String outboundDate; // dd-MM-yyyy
  final String? inboundDate; // dd-MM-yyyy or null for one-way
  final int adults;
  final int children;
  final int infants;
  final String cabin; // 'Y' / 'C' / 'F' / 'W'
  final List<RecentSearchLeg>? legs; // populated for multi-city
  final DateTime savedAt;

  const RecentSearchItem({
    required this.tripType,
    required this.departureCode,
    required this.departureName,
    required this.arrivalCode,
    required this.arrivalName,
    required this.outboundDate,
    this.inboundDate,
    required this.adults,
    required this.children,
    required this.infants,
    required this.cabin,
    this.legs,
    required this.savedAt,
  });

  /// Stable key for dedup — same route + dates + cabin folds into one entry.
  String get dedupKey {
    final legPart = (legs == null || legs!.isEmpty)
        ? '$departureCode>$arrivalCode|$outboundDate|${inboundDate ?? ''}'
        : legs!.map((l) => '${l.fromCode}>${l.toCode}|${l.date}').join('::');
    return '$tripType|$legPart|$cabin|$adults-$children-$infants';
  }

  Map<String, dynamic> toJson() => {
        'tripType': tripType,
        'departureCode': departureCode,
        'departureName': departureName,
        'arrivalCode': arrivalCode,
        'arrivalName': arrivalName,
        'outboundDate': outboundDate,
        'inboundDate': inboundDate,
        'adults': adults,
        'children': children,
        'infants': infants,
        'cabin': cabin,
        'legs': legs?.map((l) => l.toJson()).toList(),
        'savedAt': savedAt.toIso8601String(),
      };

  factory RecentSearchItem.fromJson(Map<String, dynamic> j) => RecentSearchItem(
        tripType: j['tripType']?.toString() ?? 'one-way',
        departureCode: j['departureCode']?.toString() ?? '',
        departureName: j['departureName']?.toString() ?? '',
        arrivalCode: j['arrivalCode']?.toString() ?? '',
        arrivalName: j['arrivalName']?.toString() ?? '',
        outboundDate: j['outboundDate']?.toString() ?? '',
        inboundDate: j['inboundDate']?.toString(),
        adults: (j['adults'] as num?)?.toInt() ?? 1,
        children: (j['children'] as num?)?.toInt() ?? 0,
        infants: (j['infants'] as num?)?.toInt() ?? 0,
        cabin: j['cabin']?.toString() ?? 'Y',
        legs: (j['legs'] as List?)
            ?.map((e) => RecentSearchLeg.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        savedAt: DateTime.tryParse(j['savedAt']?.toString() ?? '') ??
            DateTime.now(),
      );

  /// Rebuild the searchParams Map that flight_search_form.dart produces,
  /// so we can pass it straight to the results screen on tap. The search
  /// API requires each leg to carry `outboundDate` in `yyyy-MM-dd` format
  /// (matches `FlightLeg.toApiPayload`).
  Map<String, dynamic> toSearchParams() {
    final legsPayload = legs
        ?.map((l) => {
              'departureCode': l.fromCode,
              'arrivalCode': l.toCode,
              'outboundDate': _toApiDate(l.date),
            })
        .toList();
    return {
      'legs': legsPayload ??
          [
            {
              'departureCode': departureCode,
              'arrivalCode': arrivalCode,
              'outboundDate': _toApiDate(outboundDate),
            },
            if (inboundDate != null)
              {
                'departureCode': arrivalCode,
                'arrivalCode': departureCode,
                'outboundDate': _toApiDate(inboundDate!),
              },
          ],
      'tripType': tripType,
      'cabin': cabin,
      'adultsCount': adults,
      'childrenCount': children,
      'infantsCount': infants,
      'currencyCode': 'PKR',
      'departureCode': departureCode,
      'departureName': departureName,
      'arrivalCode': arrivalCode,
      'arrivalName': arrivalName,
      'outboundDate': outboundDate,
      if (inboundDate != null) 'inboundDate': inboundDate,
    };
  }

  /// Converts a stored `dd-MM-yyyy` date to the `yyyy-MM-dd` shape the
  /// flight search API expects. Returns the input unchanged if it can't
  /// be parsed (so anything already in the right shape passes through).
  static String _toApiDate(String input) {
    if (input.isEmpty) return input;
    final parts = input.split('-');
    if (parts.length != 3) return input;
    // Already yyyy-MM-dd?
    if (parts[0].length == 4) return input;
    final dd = parts[0].padLeft(2, '0');
    final mm = parts[1].padLeft(2, '0');
    final yyyy = parts[2];
    return '$yyyy-$mm-$dd';
  }

  String get tripTypeLabel {
    switch (tripType) {
      case 'round-trip':
        return 'Return';
      case 'multi-city':
        return 'Multi-city';
      default:
        return 'One way';
    }
  }
}

class RecentSearchLeg {
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String date; // dd-MM-yyyy

  const RecentSearchLeg({
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'fromCode': fromCode,
        'fromName': fromName,
        'toCode': toCode,
        'toName': toName,
        'date': date,
      };

  factory RecentSearchLeg.fromJson(Map<String, dynamic> j) => RecentSearchLeg(
        fromCode: j['fromCode']?.toString() ?? '',
        fromName: j['fromName']?.toString() ?? '',
        toCode: j['toCode']?.toString() ?? '',
        toName: j['toName']?.toString() ?? '',
        date: j['date']?.toString() ?? '',
      );
}
