import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget for selecting date range (check-in and check-out)
class DateRangePickerWidget extends StatefulWidget {
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final Function(DateTime checkIn, DateTime checkOut) onChanged;

  const DateRangePickerWidget({
    Key? key,
    this.initialCheckIn,
    this.initialCheckOut,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  late DateTime? checkInDate;
  late DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    checkInDate = widget.initialCheckIn;
    checkOutDate = widget.initialCheckOut;
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
        // Reset check-out if it's before check-in
        if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
          checkOutDate = null;
        }
      });

      if (checkInDate != null && checkOutDate != null) {
        widget.onChanged(checkInDate!, checkOutDate!);
      }
    }
  }

  Future<void> _selectCheckOutDate() async {
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in date first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate ?? checkInDate!.add(const Duration(days: 1)),
      firstDate: checkInDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
      });

      if (checkInDate != null && checkOutDate != null) {
        widget.onChanged(checkInDate!, checkOutDate!);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  int _getDaysDifference() {
    if (checkInDate != null && checkOutDate != null) {
      return checkOutDate!.difference(checkInDate!).inDays;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final daysDifference = _getDaysDifference();

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
            const Text(
              'Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DatePickerButton(
                    label: 'Check-in',
                    date: checkInDate,
                    onTap: _selectCheckInDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePickerButton(
                    label: 'Check-out',
                    date: checkOutDate,
                    onTap: _selectCheckOutDate,
                  ),
                ),
              ],
            ),
            if (daysDifference > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a73e8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$daysDifference nights',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a73e8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DatePickerButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerButton({
    Key? key,
    required this.label,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select';
    return DateFormat('MMM dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDADCE0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: date != null
                          ? const Color(0xFF202124)
                          : const Color(0xFFBDC1C6),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Color(0xFF1a73e8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
