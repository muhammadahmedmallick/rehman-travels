import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'providers/calculator_provider.dart';
import 'screens/home_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/package_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
      ],
      child: MaterialApp(
        title: 'Rehman Travels',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/calculator': (context) => const CalculatorScreen(),
          '/package-detail': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            return PackageDetailScreen(
              slug: args?['slug'] ?? 'economy',
            );
          },
        },
      ),
    );
  }
}
