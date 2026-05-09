import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehman_mobile_app/main.dart';
import 'package:rehman_mobile_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:rehman_mobile_app/features/auth/presentation/screens/login_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/booking_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/flight_details_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/flight_itinerary_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/flight_results_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/multi_city_review_screen.dart';
import 'package:rehman_mobile_app/app/main_shell.dart';
import 'package:rehman_mobile_app/features/visa/data/models/visa_models.dart';
import 'package:rehman_mobile_app/features/visa/presentation/screens/visa_contact_screen.dart';
import 'package:rehman_mobile_app/features/visa/presentation/screens/visa_details_screen.dart';
import 'package:rehman_mobile_app/features/pak_tour/presentation/screens/pak_tour_list_screen.dart';
import 'package:rehman_mobile_app/features/pak_tour/presentation/screens/pak_tour_detail_screen.dart';
import 'package:rehman_mobile_app/features/about/presentation/screens/about_us_screen.dart';
import 'package:rehman_mobile_app/features/auth/presentation/screens/register_screen.dart';
import 'package:rehman_mobile_app/features/bank/presentation/screens/bank_details_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/payment_screen.dart';
import 'package:rehman_mobile_app/features/flights/presentation/screens/ticket_screen.dart';
import 'package:rehman_mobile_app/features/esim/presentation/screens/esim_screen.dart';
import 'package:rehman_mobile_app/features/contact/presentation/screens/contact_screen.dart';
import 'package:rehman_mobile_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:rehman_mobile_app/features/umrah/presentation/screens/umrah_detail_screen.dart';
import 'package:rehman_mobile_app/features/umrah/presentation/screens/umrah_calculator_screen.dart';
import 'package:rehman_mobile_app/core/utils/app_lifecycle_refresh_mixin.dart';
import 'package:rehman_mobile_app/features/packages/presentation/screens/packages_screen.dart';
import 'package:rehman_mobile_app/features/packages/presentation/screens/package_detail_screen.dart';
import 'package:rehman_mobile_app/features/packages/presentation/providers/package_provider.dart';
import 'package:rehman_mobile_app/features/debug/presentation/screens/debug_pnrs_screen.dart';

// Route names
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String flightResults = '/flights/results';
  static const String flightDetails = '/flights/details/:flightId';
  static const String flightItinerary = '/flights/itinerary';
  static const String multiCityReview = '/flights/multi-city-review';
  static const String booking = '/booking';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String visaDetails = '/visa/details';
  static const String visaContact = '/visa/contact';
  static const String pakTourList = '/pak-tour';
  static const String pakTourDetails = '/pak-tour/details';
  static const String aboutUs = '/about-us';
  static const String bankDetails = '/bank-details';
  static const String payment = '/payment';
  static const String ticket = '/ticket';
  static const String esim = '/esim';
  static const String debugPnrs = '/debug/pnrs';
  static const String contact = '/contact';
  static const String umrahDetails = '/umrah/details';
  static const String umrahCalculator = '/umrah/calculator';
  static const String packages = '/packages';
  static const String packageDetails = '/packages/details';
}

// GoRouter provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  // Trigger session restoration on app startup
  ref.watch(sessionRestorationProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    // App-wide RouteObserver so `AppLifecycleRefreshMixin` can pause
    // its periodic timer when another screen is pushed on top of a
    // refresh-enabled route and fire immediately on pop back.
    observers: [appRouteObserver],
    redirect: (context, state) {
      final onboardingSeen = ref.read(onboardingSeenProvider);
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      // Show onboarding on first launch
      if (!onboardingSeen && !isOnboarding) {
        return AppRoutes.onboarding;
      }

      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      // Redirect to home if logged in and trying to access login
      if (isLoggingIn && isLoggedIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

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

      // Flight Itinerary (full-screen view of all legs)
      GoRoute(
        path: AppRoutes.flightItinerary,
        name: 'flightItinerary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return FlightItineraryScreen(flight: extra);
        },
      ),

      // Multi-city review (between leg-by-leg selection and booking)
      GoRoute(
        path: AppRoutes.multiCityReview,
        name: 'multiCityReview',
        builder: (context, state) => const MultiCityReviewScreen(),
      ),

      // Booking Screen (auth checked at submission time)
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

      // Register Screen
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Visa Details — takes a VisaType picked from the select sheet.
      GoRoute(
        path: AppRoutes.visaDetails,
        name: 'visaDetails',
        builder: (context, state) {
          final visa = state.extra as VisaType;
          return VisaDetailsScreen(visa: visa);
        },
      ),

      // Visa Contact Form
      GoRoute(
        path: AppRoutes.visaContact,
        name: 'visaContact',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map) {
            return VisaContactScreen(
              type: extra['type'] as VisaType?,
              variant: extra['variant'] as VisaVariant?,
            );
          }
          return const VisaContactScreen();
        },
      ),

      // Pak Tour List
      GoRoute(
        path: AppRoutes.pakTourList,
        name: 'pakTourList',
        builder: (context, state) => const PakTourListScreen(),
      ),

      // Pak Tour Details
      GoRoute(
        path: AppRoutes.pakTourDetails,
        name: 'pakTourDetails',
        builder: (context, state) {
          final urlLink = state.extra as String? ?? '';
          return PakTourDetailScreen(urlLink: urlLink);
        },
      ),

      // About Us
      GoRoute(
        path: AppRoutes.aboutUs,
        name: 'aboutUs',
        builder: (context, state) => const AboutUsScreen(),
      ),

      // Bank Details
      GoRoute(
        path: AppRoutes.bankDetails,
        name: 'bankDetails',
        builder: (context, state) => const BankDetailsScreen(),
      ),

      // Ticket Screen
      GoRoute(
        path: AppRoutes.ticket,
        name: 'ticket',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return TicketScreen(bookingData: extra);
        },
      ),

      // Payment Screen
      GoRoute(
        path: AppRoutes.payment,
        name: 'payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentScreen(bookingData: extra);
        },
      ),

      // eSIM Screen
      GoRoute(
        path: AppRoutes.esim,
        name: 'esim',
        builder: (context, state) => const EsimScreen(),
      ),

      // Contact Us Screen
      GoRoute(
        path: AppRoutes.contact,
        name: 'contact',
        builder: (context, state) => const ContactScreen(),
      ),

      // Umrah Package Details
      GoRoute(
        path: AppRoutes.umrahDetails,
        name: 'umrahDetails',
        builder: (context, state) {
          final urlLink = state.extra as String? ?? '';
          return UmrahDetailScreen(urlLink: urlLink);
        },
      ),

      // Umrah Calculator
      GoRoute(
        path: AppRoutes.umrahCalculator,
        name: 'umrahCalculator',
        builder: (context, state) => const UmrahCalculatorScreen(),
      ),

      // Packages
      GoRoute(
        path: AppRoutes.packages,
        name: 'packages',
        builder: (context, state) => const PackagesScreen(),
      ),

      // Package Details
      GoRoute(
        path: AppRoutes.packageDetails,
        name: 'packageDetails',
        builder: (context, state) {
          final package = state.extra as PackageModel;
          return PackageDetailScreen(package: package);
        },
      ),

      // Debug-only PNR tracker — listed in Profile under a debug
      // section. Lets developers cancel test PNRs via /orderCancel
      // without leaving stale bookings in the agent account.
      GoRoute(
        path: AppRoutes.debugPnrs,
        name: 'debugPnrs',
        builder: (context, state) => const DebugPnrsScreen(),
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
