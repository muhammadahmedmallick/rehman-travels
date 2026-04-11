import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

/// Whether onboarding has been completed. Read once at startup.
final onboardingSeenProvider = StateProvider<bool>((ref) => true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
