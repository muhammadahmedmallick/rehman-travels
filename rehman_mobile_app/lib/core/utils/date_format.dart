import 'package:intl/intl.dart';

/// Single source of truth for how dates are displayed across the app.
///
/// Rule: every user-facing date renders as **day month year** —
/// `25 Apr 2026` (with optional weekday prefix `Sat, 25 Apr 2026`).
///
/// Storage / API formats (`yyyy-MM-dd`, `dd-MM-yyyy`) are deliberately
/// kept out of this helper — those are wire contracts and must not
/// change just because the display style does.
class AppDate {
  AppDate._();

  // ── Display formatters (DateTime → String) ──────────────────────────

  /// `25 Apr 2026` — the canonical app-wide date label.
  static String format(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  /// `Sat, 25 Apr 2026` — same as [format] with the weekday prefix.
  static String formatWithDay(DateTime date) =>
      DateFormat('EEE, dd MMM yyyy').format(date);

  /// `Saturday, 25 April 2026` — long form for itinerary headers.
  static String formatLong(DateTime date) =>
      DateFormat('EEEE, dd MMMM yyyy').format(date);

  /// `April 2026` — month + year for calendar headers.
  static String formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  /// Smart range:
  ///   • same month/year → `25–27 Apr 2026`
  ///   • same year       → `25 Apr – 5 May 2026`
  ///   • different year  → `25 Dec 2026 – 5 Jan 2027`
  static String formatRange(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      return '${start.day}–${end.day} ${DateFormat('MMM yyyy').format(end)}';
    }
    if (start.year == end.year) {
      return '${DateFormat('dd MMM').format(start)} – ${format(end)}';
    }
    return '${format(start)} – ${format(end)}';
  }

  // ── Parsers (String → DateTime) ─────────────────────────────────────

  /// Best-effort parser for the date strings the app passes around.
  /// Tries the formats we actually use, in order: `yyyy-MM-dd`,
  /// `dd-MM-yyyy`, `yyyy/MM/dd`, `dd/MM/yyyy`, ISO-8601.
  /// Returns `null` if nothing matched.
  static DateTime? tryParse(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    // Heuristic: position of the first dash tells us yyyy-MM-dd vs dd-MM-yyyy.
    try {
      if (s.contains('-') && s.indexOf('-') == 2) {
        return DateFormat('dd-MM-yyyy').parseStrict(s);
      }
      if (s.contains('-')) {
        return DateFormat('yyyy-MM-dd').parseStrict(s.split('T').first);
      }
      if (s.contains('/') && s.indexOf('/') == 2) {
        return DateFormat('dd/MM/yyyy').parseStrict(s);
      }
      if (s.contains('/')) {
        return DateFormat('yyyy/MM/dd').parseStrict(s);
      }
    } catch (_) {}
    return DateTime.tryParse(s);
  }

  /// Parse a raw API/storage string and return our canonical
  /// `25 Apr 2026` label. Returns `fallback` (default empty) on
  /// failure so callers can skip rendering when the input is bad.
  static String tryFromString(String raw, {String fallback = ''}) {
    final parsed = tryParse(raw);
    if (parsed == null) return fallback;
    return format(parsed);
  }

  /// Same as [tryFromString] but with the weekday prefix.
  static String tryFromStringWithDay(String raw, {String fallback = ''}) {
    final parsed = tryParse(raw);
    if (parsed == null) return fallback;
    return formatWithDay(parsed);
  }
}
