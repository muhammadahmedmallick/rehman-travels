import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';

/// Hive box name for persisted recent flight searches.
const String kRecentSearchesBox = 'recent_searches';

/// Shared preferences key used to persist onboarding completion.
const String kOnboardingSeenKey = 'onboarding_seen';

/// Whether onboarding has been completed. Read once at startup.
final onboardingSeenProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage (Hive) — used for recent flight searches and any
  // future on-device persistence.
  await Hive.initFlutter();
  await Hive.openBox<String>(kRecentSearchesBox);
  //await Hive.openBox<String>(kDebugPnrsBox);

  final prefs = await SharedPreferences.getInstance();
  final onboardingSeen = prefs.getBool(kOnboardingSeenKey) ?? false;

  runApp(
    ProviderScope(
      overrides: [
        onboardingSeenProvider.overrideWith((ref) => onboardingSeen),
      ],
      child: const RehmanTravelsApp(),
    ),
  );
}
