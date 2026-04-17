import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../flights/presentation/widgets/flight_route_header.dart';
import '../../data/models/visa_models.dart';

/// "Enter Contact Details" form — the final step of the visa apply
/// flow. The API to submit this payload isn't wired yet (the user
/// will plug it in later), so for now the "Talk to our Visa Expert"
/// button runs local validation and shows a success snackbar.
class VisaContactScreen extends StatefulWidget {
  final VisaType? type;
  final VisaVariant? variant;

  const VisaContactScreen({super.key, this.type, this.variant});

  @override
  State<VisaContactScreen> createState() => _VisaContactScreenState();
}

class _VisaContactScreenState extends State<VisaContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          // Shared dark-gradient sliver header — keeps the visa
          // apply flow visually aligned with the booking / payment
          // screens across the app.
          FlightRouteHeader(
            title: 'Contact Details',
            subtitle: widget.type?.title,
            params: null,
          ),
        ],
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter Contact Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kindly fill in the form, and our representative '
                        'will contact you soon.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _buildFieldLabel('Full Name'),
                      _buildField(
                        controller: _nameCtrl,
                        hint: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return 'Please enter your name';
                          if (t.length < 3) return 'Name is too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFieldLabel('Email Address'),
                      _buildField(
                        controller: _emailCtrl,
                        hint: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return 'Please enter your email';
                          final ok =
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(t);
                          if (!ok) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFieldLabel('Mobile Number'),
                      _buildPhoneField(),
                      if (widget.type != null) ...[
                        const SizedBox(height: 22),
                        _buildSummaryCard(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            _buildSubmitBar(),
          ],
        ),
      ),
      ),
    );
  }

  // ─── Field widgets ────────────────────────────────────

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: _fieldDecoration(hint),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneCtrl,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      validator: (v) {
        final t = (v ?? '').trim();
        if (t.isEmpty) return 'Please enter your mobile number';
        if (t.length < 10) return 'Mobile number is too short';
        return null;
      },
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: _fieldDecoration('3001234567').copyWith(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF01411C),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '☪',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '+92',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 1,
                height: 20,
                color: AppColors.border,
              ),
            ],
          ),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 92, minHeight: 40),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textHint,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.error, width: 1.2),
      ),
    );
  }

  // ─── Summary card (picked visa) ───────────────────────

  Widget _buildSummaryCard() {
    final t = widget.type!;
    final v = widget.variant;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.badge_outlined,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (v != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    v.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Submit bar ───────────────────────────────────────

  /// Bottom submit bar — same container treatment (white surface +
  /// top shadow + SafeArea) the visa details "Apply now" footer and
  /// the flight booking "Continue" footer use, so the apply flow
  /// keeps a consistent CTA affordance from start to finish.
  Widget _buildSubmitBar() {
    return Container(
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          // Inherits the app-wide golden CTA style from
          // `theme.dart`'s elevatedButtonTheme — matches the "Apply
          // now" button on the visa details screen and every other
          // booking-flow CTA.
          onPressed: _submitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          child: _submitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Talk to our Visa Expert'),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    // Placeholder — real submit API will be wired in a follow-up.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Thanks! Our visa expert will reach out shortly.',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    context.pop();
  }
}
