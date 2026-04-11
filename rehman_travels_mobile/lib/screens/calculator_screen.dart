import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_models.dart';
import '../providers/calculator_provider.dart';
import '../widgets/traveler_counter_widget.dart';
import '../widgets/hotel_selector_widget.dart';
import '../widgets/date_range_picker_widget.dart';
import '../widgets/room_selector_widget.dart';
import '../widgets/price_breakdown_card.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/error_dialog.dart';

/// Main calculator screen for booking Umrah packages
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late CalculatorProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<CalculatorProvider>(context, listen: false);
      _initializeCalculator();
    });
  }

  Future<void> _initializeCalculator() async {
    LoadingDialog.show(context, message: 'Loading calculator data...');
    await provider.initialize();
    if (mounted) {
      LoadingDialog.hide(context);
      if (provider.errorMessage != null) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: provider.errorMessage ?? 'Failed to load calculator data',
          onRetry: _initializeCalculator,
        );
      }
    }
  }

  Future<void> _calculatePrice() async {
    // Validate all hotels have dates and rooms selected
    for (int i = 0; i < provider.selectedHotels.length; i++) {
      final hotel = provider.selectedHotels[i];

      if (hotel.checkIn.isEmpty || hotel.checkOut.isEmpty) {
        ErrorDialog.show(
          context,
          title: 'Missing Dates',
          message: 'Please set check-in and check-out dates for all hotels',
        );
        return;
      }

      final totalRooms = hotel.rooms.values.fold<int>(0, (sum, val) => sum + val);
      if (totalRooms == 0) {
        ErrorDialog.show(
          context,
          title: 'No Rooms Selected',
          message: 'Please select at least one room for ${hotel.hotelName}',
        );
        return;
      }
    }

    final success = await provider.calculatePrice();
    if (!mounted) return;

    if (!success) {
      ErrorDialog.show(
        context,
        title: 'Calculation Error',
        message: provider.errorMessage ?? 'Failed to calculate price',
        onRetry: _calculatePrice,
      );
    }
  }

  Future<void> _createBooking() async {
    // Show customer input dialog
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _CustomerInfoDialog(),
    );

    if (result == null) return;

    LoadingDialog.show(context, message: 'Creating booking...');
    final bookingResponse = await provider.createBooking(
      firstName: result['firstName'] ?? '',
      email: result['email'] ?? '',
      mobile: result['mobile'] ?? '',
    );

    if (!mounted) {
      LoadingDialog.hide(context);
      return;
    }

    LoadingDialog.hide(context);

    if (bookingResponse != null && bookingResponse.success) {
      _showBookingSuccess(bookingResponse);
    } else {
      ErrorDialog.show(
        context,
        title: 'Booking Error',
        message: provider.errorMessage ?? 'Failed to create booking',
        onRetry: _createBooking,
      );
    }
  }

  void _showBookingSuccess(BookingResponse response) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF1B7D34),
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Created!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202124),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: ${response.bookingId}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5F6368),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a73e8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umrah Package Calculator'),
        elevation: 0,
        backgroundColor: const Color(0xFF1a73e8),
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, provider, _) {
          if (provider.initData == null && provider.isLoadingInit) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.initData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Color(0xFFD32F2F),
                  ),
                  const SizedBox(height: 16),
                  const Text('Failed to load calculator'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeCalculator,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Travelers
                TravelerCounterWidget(
                  initialAdults: provider.adults,
                  initialChildren: provider.children,
                  initialInfants: provider.infants,
                  onChanged: (adults, children, infants) {
                    provider.updateTravelers(
                      adults: adults,
                      children: children,
                      infants: infants,
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Hotels
                HotelSelectorWidget(
                  availableHotels: [
                    ...provider.initData!.hotels.makkah,
                    ...provider.initData!.hotels.madinah,
                  ],
                  selectedHotels: provider.selectedHotels,
                  onChanged: (hotels) {
                    // Update provider with modified hotels
                    provider.updateHotels(hotels);
                  },
                ),
                const SizedBox(height: 16),
                // Transport section
                _TransportSection(provider: provider),
                const SizedBox(height: 16),
                // Visa section
                _VisaSection(provider: provider),
                const SizedBox(height: 16),
                // Flight section
                _FlightSection(provider: provider),
                const SizedBox(height: 16),
                // Calculate button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isCalculating ? null : _calculatePrice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a73e8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: provider.isCalculating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Calculate Price',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Price breakdown
                if (provider.priceBreakdown != null)
                  PriceBreakdownCard(breakdown: provider.priceBreakdown!),
                const SizedBox(height: 16),
                // Book button
                if (provider.priceBreakdown != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isBooking ? null : _createBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B7D34),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: provider.isBooking
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Create Booking',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TransportSection extends StatelessWidget {
  final CalculatorProvider provider;

  const _TransportSection({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDADCE0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transport',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
                Switch(
                  value: provider.transportEnabled,
                  onChanged: (value) {
                    provider.updateTransport(enabled: value);
                  },
                  activeColor: const Color(0xFF1a73e8),
                ),
              ],
            ),
            if (provider.transportEnabled) ...[
              const SizedBox(height: 16),
              _DropdownField(
                label: 'Sector',
                items: provider.initData?.transport.sectors ?? [],
                selectedId: provider.selectedSectorId,
                onChanged: (id) {
                  provider.updateTransport(sectorId: id as int?);
                },
              ),
              const SizedBox(height: 12),
              _DropdownField(
                label: 'Vehicle',
                items: provider.initData?.transport.vehicles ?? [],
                selectedId: provider.selectedVehicleId,
                onChanged: (id) {
                  provider.updateTransport(vehicleId: id as int?);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VisaSection extends StatelessWidget {
  final CalculatorProvider provider;

  const _VisaSection({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDADCE0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
                Switch(
                  value: provider.visaEnabled,
                  onChanged: (value) {
                    provider.updateVisa(enabled: value);
                  },
                  activeColor: const Color(0xFF1a73e8),
                ),
              ],
            ),
            if (provider.visaEnabled) ...[
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDADCE0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: provider.visaNationality,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'Pakistan',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Pakistan'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Other'),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateVisa(nationality: value);
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlightSection extends StatefulWidget {
  final CalculatorProvider provider;

  const _FlightSection({Key? key, required this.provider}) : super(key: key);

  @override
  State<_FlightSection> createState() => _FlightSectionState();
}

class _FlightSectionState extends State<_FlightSection> {
  late TextEditingController adultController;
  late TextEditingController childController;
  late TextEditingController infantController;

  @override
  void initState() {
    super.initState();
    adultController =
        TextEditingController(text: widget.provider.adultFlightPrice.toString());
    childController =
        TextEditingController(text: widget.provider.childFlightPrice.toString());
    infantController =
        TextEditingController(text: widget.provider.infantFlightPrice.toString());
  }

  @override
  void dispose() {
    adultController.dispose();
    childController.dispose();
    infantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDADCE0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Flight',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
                Switch(
                  value: widget.provider.flightEnabled,
                  onChanged: (value) {
                    widget.provider.updateFlight(enabled: value);
                  },
                  activeColor: const Color(0xFF1a73e8),
                ),
              ],
            ),
            if (widget.provider.flightEnabled) ...[
              const SizedBox(height: 16),
              Text(
                'Currency: ${widget.provider.flightCurrency}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5F6368),
                ),
              ),
              const SizedBox(height: 12),
              _PriceInputField(
                label: 'Adult Price',
                controller: adultController,
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0;
                  widget.provider.updateFlight(adultPrice: price);
                },
              ),
              const SizedBox(height: 12),
              _PriceInputField(
                label: 'Child Price',
                controller: childController,
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0;
                  widget.provider.updateFlight(childPrice: price);
                },
              ),
              const SizedBox(height: 12),
              _PriceInputField(
                label: 'Infant Price',
                controller: infantController,
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0;
                  widget.provider.updateFlight(infantPrice: price);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final List<dynamic> items;
  final int? selectedId;
  final Function(dynamic) onChanged;

  const _DropdownField({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6368),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDADCE0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            value: selectedId,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Select $label'),
            ),
            items: items
                .map((item) => DropdownMenuItem<int>(
                      value: item.id,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(item.name),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _PriceInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;

  const _PriceInputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6368),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '0.00',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDADCE0)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomerInfoDialog extends StatefulWidget {
  const _CustomerInfoDialog({Key? key}) : super(key: key);

  @override
  State<_CustomerInfoDialog> createState() => _CustomerInfoDialogState();
}

class _CustomerInfoDialogState extends State<_CustomerInfoDialog> {
  late TextEditingController firstNameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 24),
            _TextInputField(
              label: 'First Name',
              controller: firstNameController,
              hintText: 'Enter your name',
            ),
            const SizedBox(height: 12),
            _TextInputField(
              label: 'Email',
              controller: emailController,
              hintText: 'your@email.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _TextInputField(
              label: 'Mobile',
              controller: mobileController,
              hintText: '+923001234567',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateInputs()) {
                        Navigator.pop(context, {
                          'firstName': firstNameController.text,
                          'email': emailController.text,
                          'mobile': mobileController.text,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a73e8),
                    ),
                    child: const Text('Proceed'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TextInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const _TextInputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6368),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDADCE0)),
            ),
          ),
        ),
      ],
    );
  }
}
