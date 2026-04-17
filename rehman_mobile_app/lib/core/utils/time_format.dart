// App-wide flight time helpers.
//
// Backend providers return times in a few different shapes —
// `10:15`, `05:25:00`, `05:25:00+05:00`, `08:30:00Z`. These helpers
// normalize that into a single 12-hour `5:25 AM` / `8:05 PM` display
// format and, when needed, into minutes-since-midnight for math.
//
// Change the format in one place here and the whole app updates.

/// Strips seconds and timezone offsets from a raw time string and
/// returns minutes-since-midnight, or `null` if it can't be parsed.
int? timeToMinutes(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  var s = raw.trim();
  // Drop trailing timezone like "+05:00" / "-04:00" / "+0500".
  final tzMatch = RegExp(r'[+\-]\d{2}:?\d{2}$').firstMatch(s);
  if (tzMatch != null) s = s.substring(0, tzMatch.start);
  if (s.toUpperCase().endsWith('Z')) s = s.substring(0, s.length - 1);
  // Take the first two HH:MM groups.
  final parts = s.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return h * 60 + m;
}

/// Returns a clean `5:25 AM` / `8:05 PM` string for any of the raw
/// shapes the API may produce. Falls back to the original input if
/// it can't be parsed (so unknown formats are at least still visible).
String formatFlightTime(String? raw) {
  if (raw == null || raw.isEmpty) return '--:--';
  final mins = timeToMinutes(raw);
  if (mins == null) return raw;
  final h24 = (mins ~/ 60) % 24;
  final m = mins % 60;
  final period = h24 >= 12 ? 'PM' : 'AM';
  var h12 = h24 % 12;
  if (h12 == 0) h12 = 12;
  final mm = m.toString().padLeft(2, '0');
  return '$h12:$mm $period';
}

/// Convenience shortcut for "10:15 - 20:05" → "10:15 AM - 8:05 PM".
String formatFlightTimeRange(String? from, String? to) {
  return '${formatFlightTime(from)} - ${formatFlightTime(to)}';
}
