import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../providers/flight_search_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? flightData;

  const BookingScreen({super.key, this.flightData});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _termsAccepted = false;
  bool _isSubmitting = false;

  // Resolved flight data (from extra or pending provider)
  late Map<String, dynamic> _resolvedFlightData;

  // Dynamic passenger data
  late int _adultsCount;
  late int _childrenCount;
  late int _infantsCount;
  late List<_PassengerData> _passengers;

  @override
  void initState() {
    super.initState();

    // If flightData came via route extra, use it.
    // Otherwise check pending data (user returning from login redirect).
    if (widget.flightData != null) {
      _resolvedFlightData = widget.flightData!;
    } else {
      final pendingData = ref.read(pendingBookingDataProvider);
      _resolvedFlightData = pendingData ?? {};
    }

    // Clear booking journey flag now that we're on booking screen
    ref.read(isBookingJourneyProvider.notifier).state = false;

    final searchParams = ref.read(flightSearchProvider).searchParams;
    _adultsCount = (searchParams?['adultsCount'] as int?) ?? 1;
    _childrenCount = (searchParams?['childrenCount'] as int?) ?? 0;
    _infantsCount = (searchParams?['infantsCount'] as int?) ?? 0;

    _passengers = [];
    for (int i = 0; i < _adultsCount; i++) {
      _passengers.add(_PassengerData(type: 'Adult', index: i + 1));
    }
    for (int i = 0; i < _childrenCount; i++) {
      _passengers.add(_PassengerData(type: 'Child', index: i + 1));
    }
    for (int i = 0; i < _infantsCount; i++) {
      _passengers.add(_PassengerData(type: 'Infant', index: i + 1));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    for (final p in _passengers) {
      p.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flight = _resolvedFlightData;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Passenger Details'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Summary
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flight, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${flight['departureCode'] ?? 'ISB'} → ${flight['arrivalCode'] ?? 'KHI'}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            flight['airlineName'] ?? 'Airline',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'PKR ${_formatPrice(flight['price'] ?? 0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Passenger Forms
              ...List.generate(_passengers.length, (index) {
                final passenger = _passengers[index];
                final paxNumber = index + 1;
                return _buildPassengerForm(passenger, paxNumber);
              }),

              // Contact Details Section
              Text(
                'Contact Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'your@email.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+92 300 1234567',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Terms
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() => _termsAccepted = value ?? false);
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _termsAccepted = !_termsAccepted);
                      },
                      child: Text(
                        'I agree to the terms and conditions and fare rules',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: (_termsAccepted && !_isSubmitting) ? _submitBooking : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Continue to Payment'),
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerForm(_PassengerData passenger, int paxNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passenger $paxNumber (${passenger.type})',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),

        // Title
        Text(
          'Title',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: _getTitleOptions(passenger.type).map((title) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _buildTitleChip(title, passenger),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        // First Name
        TextFormField(
          controller: passenger.firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
            hintText: 'As per passport/CNIC',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter first name';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // Last Name
        TextFormField(
          controller: passenger.lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            hintText: 'As per passport/CNIC',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter last name';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  List<String> _getTitleOptions(String type) {
    if (type == 'Child') return ['Mstr', 'Miss'];
    if (type == 'Infant') return ['Mstr', 'Miss'];
    return ['Mr', 'Mrs', 'Ms'];
  }

  Widget _buildTitleChip(String title, _PassengerData passenger) {
    final isSelected = passenger.title == title;
    return GestureDetector(
      onTap: () => setState(() => passenger.title = title),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) return;

    setState(() => _isSubmitting = true);

    final flight = _resolvedFlightData;
    final searchState = ref.read(flightSearchProvider);

    // Build passengers payload
    final passengersPayload = _passengers.map((p) {
      return {
        'title': p.title,
        'firstName': p.firstNameController.text.trim(),
        'lastName': p.lastNameController.text.trim(),
        'type': p.type.toLowerCase(),
      };
    }).toList();

    final payload = {
      'passengers': passengersPayload,
      'contactEmail': _emailController.text.trim(),
      'contactPhone': _phoneController.text.trim(),
      'bookingInfo': flight['bookingInfo'],
      'jSessionId': flight['jSessionId'],
      'provider': flight['provider'],
      'departureCode': flight['departureCode'],
      'arrivalCode': flight['arrivalCode'],
      'outboundDate': searchState.searchParams?['outboundDate'],
      'inboundDate': searchState.searchParams?['inboundDate'],
      'cabin': searchState.searchParams?['cabin'] ?? 'Y',
      'tripType': searchState.searchParams?['tripType'] ?? 'one-way',
      'currencyCode': searchState.searchParams?['currencyCode'] ?? 'PKR',
    };

    if (kDebugMode) {
      print('=== BOOKING SUBMISSION ===');
      print('Payload: $payload');
    }

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.postWithHeader(
        ApiEndpoints.orderCreate,
        data: payload,
        extraHeaders: {'Action-Type': 'Create'},
      );

      if (kDebugMode) {
        print('Booking response: ${response.statusCode}');
        print('Booking data: ${response.data}');
      }

      if (!mounted) return;

      final data = response.data;
      String? pnr;
      if (data is Map<String, dynamic>) {
        pnr = data['pnr']?.toString() ?? data['bookingReference']?.toString() ?? data['orderId']?.toString();
      }

      setState(() => _isSubmitting = false);

      _showSuccessDialog(pnr);
    } catch (e) {
      if (kDebugMode) {
        print('Booking error: $e');
      }

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _submitBooking,
          ),
        ),
      );
    }
  }

  void _showSuccessDialog(String? pnr) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Booking Submitted!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (pnr != null) ...[
              Text(
                'PNR: $pnr',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              'Your booking request has been submitted. You will receive a confirmation email shortly.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/');
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price is int) {
      return price.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } else if (price is double) {
      return price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return price.toString();
  }
}

class _PassengerData {
  final String type;
  final int index;
  String title;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  _PassengerData({
    required this.type,
    required this.index,
  })  : title = (type == 'Adult') ? 'Mr' : 'Mstr',
        firstNameController = TextEditingController(),
        lastNameController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
  }
}
