/// IATA airport code → city name lookup for common airports.
///
/// Used to display `Karachi` / `Dubai` on the flight list instead of
/// the bare code (`KHI` / `DXB`) when the flight payload doesn't carry
/// a city name. Covers the airports the app routinely serves (Pakistan,
/// GCC, South Asia) plus frequent long-haul connections.
const Map<String, String> _iataToCity = {
  // Pakistan
  'ISB': 'Islamabad',
  'KHI': 'Karachi',
  'LHE': 'Lahore',
  'PEW': 'Peshawar',
  'MUX': 'Multan',
  'UET': 'Quetta',
  'SKT': 'Sialkot',
  'LYP': 'Faisalabad',
  'GWD': 'Gwadar',

  // GCC
  'DXB': 'Dubai',
  'DWC': 'Dubai',
  'AUH': 'Abu Dhabi',
  'SHJ': 'Sharjah',
  'DOH': 'Doha',
  'KWI': 'Kuwait',
  'BAH': 'Bahrain',
  'MCT': 'Muscat',
  'RUH': 'Riyadh',
  'JED': 'Jeddah',
  'MED': 'Madinah',
  'DMM': 'Dammam',

  // Egypt / Levant / Turkey
  'CAI': 'Cairo',
  'AMM': 'Amman',
  'BEY': 'Beirut',
  'IST': 'Istanbul',
  'SAW': 'Istanbul',

  // South Asia
  'DEL': 'Delhi',
  'BOM': 'Mumbai',
  'CCU': 'Kolkata',
  'MAA': 'Chennai',
  'BLR': 'Bengaluru',
  'HYD': 'Hyderabad',
  'CMB': 'Colombo',
  'DAC': 'Dhaka',
  'KTM': 'Kathmandu',
  'KBL': 'Kabul',
  'MLE': 'Malé',

  // Europe
  'LHR': 'London',
  'LGW': 'London',
  'LCY': 'London',
  'STN': 'London',
  'MAN': 'Manchester',
  'BHX': 'Birmingham',
  'CDG': 'Paris',
  'ORY': 'Paris',
  'FRA': 'Frankfurt',
  'MUC': 'Munich',
  'AMS': 'Amsterdam',
  'BRU': 'Brussels',
  'MAD': 'Madrid',
  'BCN': 'Barcelona',
  'FCO': 'Rome',
  'MXP': 'Milan',
  'ZRH': 'Zurich',
  'VIE': 'Vienna',
  'CPH': 'Copenhagen',
  'ARN': 'Stockholm',
  'OSL': 'Oslo',
  'HEL': 'Helsinki',
  'DUB': 'Dublin',
  'LIS': 'Lisbon',
  'ATH': 'Athens',

  // North America
  'JFK': 'New York',
  'LGA': 'New York',
  'EWR': 'Newark',
  'ORD': 'Chicago',
  'LAX': 'Los Angeles',
  'SFO': 'San Francisco',
  'IAD': 'Washington',
  'DCA': 'Washington',
  'BOS': 'Boston',
  'MIA': 'Miami',
  'ATL': 'Atlanta',
  'DFW': 'Dallas',
  'IAH': 'Houston',
  'SEA': 'Seattle',
  'DEN': 'Denver',
  'PHX': 'Phoenix',
  'YYZ': 'Toronto',
  'YUL': 'Montreal',
  'YVR': 'Vancouver',
  'SDQ': 'Santo Domingo',

  // Southeast / East Asia
  'KUL': 'Kuala Lumpur',
  'SIN': 'Singapore',
  'BKK': 'Bangkok',
  'DMK': 'Bangkok',
  'HKT': 'Phuket',
  'HKG': 'Hong Kong',
  'TPE': 'Taipei',
  'ICN': 'Seoul',
  'GMP': 'Seoul',
  'NRT': 'Tokyo',
  'HND': 'Tokyo',
  'KIX': 'Osaka',
  'PEK': 'Beijing',
  'PKX': 'Beijing',
  'PVG': 'Shanghai',
  'SHA': 'Shanghai',
  'CAN': 'Guangzhou',
  'MNL': 'Manila',
  'CGK': 'Jakarta',
  'SGN': 'Ho Chi Minh City',
  'HAN': 'Hanoi',

  // Oceania
  'SYD': 'Sydney',
  'MEL': 'Melbourne',
  'BNE': 'Brisbane',
  'PER': 'Perth',
  'AKL': 'Auckland',

  // Africa
  'NBO': 'Nairobi',
  'JNB': 'Johannesburg',
  'CPT': 'Cape Town',
  'ADD': 'Addis Ababa',
  'LOS': 'Lagos',
};

/// Returns the city name for a given IATA code, or the code itself
/// when no mapping is found. Safe to call with any string.
String cityNameFromCode(String code) {
  if (code.isEmpty) return code;
  return _iataToCity[code.toUpperCase()] ?? code;
}

/// Like [cityNameFromCode] but returns an empty string when nothing
/// is known — useful when you want to decide between a code and a
/// city name at the call site.
String? tryCityNameFromCode(String code) {
  if (code.isEmpty) return null;
  return _iataToCity[code.toUpperCase()];
}
