import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehman_mobile_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:rehman_mobile_app/features/auth/presentation/screens/login_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/booking_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/flight_details_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/flight_results_screen.dart';
import 'package:rehman_mobile_app/app/main_shell.dart';
import 'package:rehman_mobile_app/features/visa/presentation/screens/visa_details_screen.dart';

// Route names
class AppRoutes {
  static const String home = '/';
  static const String flightResults = '/flights/results';
  static const String flightDetails = '/flights/details/:flightId';
  static const String booking = '/booking';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String visaDetails = '/visa/details';
}

// GoRouter provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isBooking = state.matchedLocation == AppRoutes.booking;

      // Redirect to login if trying to book without authentication
      if (isBooking && !isLoggedIn) {
        return '${AppRoutes.login}?redirect=${AppRoutes.booking}';
      }

      // Redirect to home if logged in and trying to access login
      if (isLoggingIn && isLoggedIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Main Shell with Bottom Navigation
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const MainShell(),
      ),

      // Flight Results
      GoRoute(
        path: AppRoutes.flightResults,
        name: 'flightResults',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FlightResultsScreen(searchParams: extra);
        },
      ),

      // Flight Details
      GoRoute(
        path: AppRoutes.flightDetails,
        name: 'flightDetails',
        builder: (context, state) {
          final flightId = state.pathParameters['flightId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return FlightDetailsScreen(
            flightId: flightId,
            flightData: extra,
          );
        },
      ),

      // Booking Screen (Protected)
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BookingScreen(flightData: extra);
        },
      ),

      // Login Screen
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectPath: redirect);
        },
      ),

      // Visa Details
      GoRoute(
        path: AppRoutes.visaDetails,
        name: 'visaDetails',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VisaDetailsScreen(visaData: extra ?? {});
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.matchedLocation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
