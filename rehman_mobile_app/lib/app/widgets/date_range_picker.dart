import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme.dart';

class DateRangePickerResult {
  final DateTime departure;
  final DateTime? returnDate;

  const DateRangePickerResult({required this.departure, this.returnDate});
}

Future<DateRangePickerResult?> showFlightDatePicker({
  required BuildContext context,
  DateTime? initialDeparture,
  DateTime? initialReturn,
  bool allowOneWay = true,
}) {
  return showModalBottomSheet<DateRangePickerResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FlightDatePicker(
      initialDeparture: initialDeparture,
      initialReturn: initialReturn,
      allowOneWay: allowOneWay,
    ),
  );
}

class _FlightDatePicker extends StatefulWidget {
  final DateTime? initialDeparture;
  final DateTime? initialReturn;
  final bool allowOneWay;

  const _FlightDatePicker({this.initialDeparture, this.initialReturn, this.allowOneWay = true});

  @override
  State<_FlightDatePicker> createState() => _FlightDatePickerState();
}

class _FlightDatePickerState extends State<_FlightDatePicker> {
  DateTime? _departure;
  DateTime? _return;
  late ScrollController _scrollController;
  late DateTime _today;
  late DateTime _startMonth;
  static const int _monthCount = 12;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _startMonth = DateTime(_today.year, _today.month);
    _departure = widget.initialDeparture;
    _return = widget.initialReturn;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (widget.allowOneWay) {
        // Single selection mode
        _departure = date;
        _return = null;
      } else if (_departure == null || (_departure != null && _return != null)) {
        // First tap or reset: set departure
        _departure = date;
        _return = null;
      } else {
        // Second tap: set return
        if (date.isBefore(_departure!)) {
          _return = _departure;
          _departure = date;
        } else if (date.isAtSameMomentAs(_departure!)) {
          return;
        } else {
          _return = date;
        }
      }
    });
  }

  bool _isInRange(DateTime date) {
    if (_departure == null || _return == null) return false;
    return date.isAfter(_departure!) && date.isBefore(_return!);
  }

  bool _isDeparture(DateTime date) => _departure != null && _isSameDay(date, _departure!);
  bool _isReturn(DateTime date) => _return != null && _isSameDay(date, _return!);
  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
  bool _isPast(DateTime date) => date.isBefore(DateTime(_today.year, _today.month, _today.day));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        // Header
        _buildHeader(),
        // Date summary
        _buildDateSummary(),
        const Divider(height: 1),
        // Weekday labels
        _buildWeekdayLabels(),
        // Calendar months
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: _monthCount,
            itemBuilder: (context, index) {
              final month = DateTime(_startMonth.year, _startMonth.month + index);
              return _buildMonth(month);
            },
          ),
        ),
        // Bottom buttons
        _buildBottomButtons(),
      ]),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
        child: Row(children: [
          Text('Select Dates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const Spacer(),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 24)),
        ]),
      ),
    );
  }

  Widget _buildDateSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: widget.allowOneWay
          // Single mode - only departure
          ? _buildDateChip('Select Date', _departure, AppColors.primary)
          // Range mode - departure + return
          : Row(children: [
              Expanded(child: _buildDateChip('Departure', _departure, AppColors.primary)),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward, size: 16, color: AppColors.textHint),
              const SizedBox(width: 12),
              Expanded(child: _buildDateChip('Return', _return, AppColors.secondary)),
            ]),
    );
  }

  Widget _buildDateChip(String label, DateTime? date, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: date != null ? color.withValues(alpha: 0.08) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: date != null ? color.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(
          date != null ? DateFormat('EEE, dd MMM').format(date) : 'Select',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: date != null ? color : AppColors.textHint),
        ),
      ]),
    );
  }

  Widget _buildWeekdayLabels() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surfaceLight,
      child: Row(
        children: days.map((d) => Expanded(
          child: Center(child: Text(d, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint))),
        )).toList(),
      ),
    );
  }

  Widget _buildMonth(DateTime month) {
    final monthName = DateFormat('MMMM yyyy').format(month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday; // 1=Mon, 7=Sun

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10, left: 4),
          child: Text(monthName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ),
        // Day grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemCount: daysInMonth + firstWeekday - 1,
          itemBuilder: (context, index) {
            if (index < firstWeekday - 1) return const SizedBox();

            final day = index - firstWeekday + 2;
            final date = DateTime(month.year, month.month, day);
            final isPast = _isPast(date);
            final isDep = _isDeparture(date);
            final isRet = _isReturn(date);
            final isRange = _isInRange(date);
            final isSelected = isDep || isRet;

            return GestureDetector(
              onTap: isPast ? null : () => _onDateTap(date),
              child: Container(
                decoration: BoxDecoration(
                  // Range fill
                  color: isRange ? AppColors.primary.withValues(alpha: 0.08) : null,
                  // Range edges
                  borderRadius: isDep
                      ? const BorderRadius.horizontal(left: Radius.circular(20))
                      : isRet
                          ? const BorderRadius.horizontal(right: Radius.circular(20))
                          : null,
                ),
                child: Center(
                  child: Container(
                    width: 36, height: 36,
                    decoration: isSelected
                        ? BoxDecoration(
                            color: isDep ? AppColors.primary : AppColors.secondary,
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isPast
                              ? AppColors.textHint.withValues(alpha: 0.4)
                              : isSelected
                                  ? Colors.white
                                  : _isSameDay(date, _today)
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        child: widget.allowOneWay
            // Single selection mode (one-way / multi-city)
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _departure != null
                      ? () => Navigator.pop(context, DateRangePickerResult(departure: _departure!))
                      : null,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                  child: Text(_departure != null ? 'Select Date' : 'Tap a date'),
                ),
              )
            // Range selection mode (round-trip)
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_departure != null && _return != null)
                      ? () => Navigator.pop(context, DateRangePickerResult(departure: _departure!, returnDate: _return))
                      : null,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                  child: Text(_departure != null && _return != null ? 'Done' : _departure != null ? 'Select return date' : 'Select dates'),
                ),
              ),
      ),
    );
  }
}
