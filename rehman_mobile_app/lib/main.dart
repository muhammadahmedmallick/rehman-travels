import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';

/// Whether onboarding has been completed. Read once at startup..
final onboardingSeenProvider = StateProvider<bool>((ref) => true);

/// Hive box name for persisted recent flight searches.
const String kRecentSearchesBox = 'recent_searches';

/// Hive box name for the debug-only PNR tracker — every PNR Exalted
/// hands back during a debug session lands here so the Settings →
/// Debug PNRs screen can list + manually cancel them.
const String kDebugPnrsBox = 'debug_pnrs';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage (Hive) — used for recent flight searches and any
  // future on-device persistence.
  await Hive.initFlutter();
  await Hive.openBox<String>(kRecentSearchesBox);
  await Hive.openBox<String>(kDebugPnrsBox);

  // TODO: Restore onboarding_seen check when finalized
  // final prefs = await SharedPreferences.getInstance();
  // final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
  const onboardingSeen = false;

  runApp(
    ProviderScope(
      overrides: [
        onboardingSeenProvider.overrideWith((ref) => onboardingSeen),
      ],
      child: const RehmanTravelsApp(),
    ),
  );
}
