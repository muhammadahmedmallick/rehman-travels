import 'package:flutter/material.dart';
import '../../core/utils/date_format.dart';
import '../theme.dart';

class DateRangePickerResult {
  final DateTime departure;
  final DateTime? returnDate;
  final bool isRoundTrip;

  const DateRangePickerResult({required this.departure, this.returnDate, this.isRoundTrip = false});
}

Future<DateRangePickerResult?> showFlightDatePicker({
  required BuildContext context,
  DateTime? initialDeparture,
  DateTime? initialReturn,
  bool allowOneWay = true,
  DateTime? minDate,
}) {
  return showModalBottomSheet<DateRangePickerResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FlightDatePicker(
      initialDeparture: initialDeparture,
      initialReturn: initialReturn,
      initialIsRoundTrip: !allowOneWay || initialReturn != null,
      minDate: minDate,
    ),
  );
}

class _FlightDatePicker extends StatefulWidget {
  final DateTime? initialDeparture;
  final DateTime? initialReturn;
  final bool initialIsRoundTrip;
  final DateTime? minDate;

  const _FlightDatePicker({
    this.initialDeparture,
    this.initialReturn,
    this.initialIsRoundTrip = false,
    this.minDate,
  });

  @override
  State<_FlightDatePicker> createState() => _FlightDatePickerState();
}

class _FlightDatePickerState extends State<_FlightDatePicker> {
  DateTime? _departure;
  DateTime? _return;
  bool _isRoundTrip = false;
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
    _isRoundTrip = widget.initialIsRoundTrip;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDateTap(DateTime date) {
    if (_isPast(date)) return;
    setState(() {
      if (!_isRoundTrip) {
        _departure = date;
        _return = null;
      } else if (_departure == null || (_departure != null && _return != null)) {
        _departure = date;
        _return = null;
      } else {
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
  bool _isPast(DateTime date) {
    final todayMidnight = DateTime(_today.year, _today.month, _today.day);
    final min = widget.minDate;
    if (min != null) {
      final minMidnight = DateTime(min.year, min.month, min.day);
      if (date.isBefore(minMidnight)) return true;
    }
    return date.isBefore(todayMidnight);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(children: [
        _buildHeader(),
        _buildTripToggle(),
        _buildDateChips(),
        const Divider(height: 1),
        _buildWeekdayLabels(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _monthCount,
            itemBuilder: (context, index) {
              final month = DateTime(_startMonth.year, _startMonth.month + index);
              return _buildMonth(month);
            },
          ),
        ),
        _buildBottom(),
      ]),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
        child: Row(children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 22)),
          const Spacer(),
          Text('Dates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const Spacer(),
          const SizedBox(width: 48),
        ]),
      ),
    );
  }

  Widget _buildTripToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() { _isRoundTrip = false; _return = null; }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: !_isRoundTrip ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text('One way', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: !_isRoundTrip ? Colors.white : AppColors.textSecondary))),
            ),
          )),
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _isRoundTrip = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isRoundTrip ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text('Roundtrip', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _isRoundTrip ? Colors.white : AppColors.textSecondary))),
            ),
          )),
        ]),
      ),
    );
  }

  Widget _buildDateChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(children: [
        Expanded(child: _dateChip(_departure, 'Departure', () => setState(() { _departure = null; _return = null; }))),
        if (_isRoundTrip) ...[
          const SizedBox(width: 10),
          Expanded(child: _dateChip(_return, 'Return', () => setState(() => _return = null), isReturn: true)),
        ],
      ]),
    );
  }

  Widget _dateChip(DateTime? date, String placeholder, VoidCallback onClear, {bool isReturn = false}) {
    final hasDate = date != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: hasDate && isReturn ? Border.all(color: AppColors.primary, width: 1.5) : null,
      ),
      child: Row(children: [
        Expanded(child: Text(
          hasDate ? AppDate.formatWithDay(date) : placeholder,
          style: TextStyle(fontSize: 13, fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400, color: hasDate ? AppColors.textPrimary : AppColors.textHint),
        )),
        if (hasDate)
          GestureDetector(
            onTap: onClear,
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: AppColors.textHint.withValues(alpha: 0.3), shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
      ]),
    );
  }

  Widget _buildWeekdayLabels() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: days.map((d) => Expanded(
        child: Center(child: Text(d, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHint))),
      )).toList()),
    );
  }

  Widget _buildMonth(DateTime month) {
    final monthName = AppDate.formatMonthYear(month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Sunday = 0 for grid (S M T W T F S)
    final firstWeekday = DateTime(month.year, month.month, 1).weekday % 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10, left: 4),
          child: Text(monthName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.1),
          itemCount: daysInMonth + firstWeekday,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox();

            final day = index - firstWeekday + 1;
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
                  color: isRange || (isDep && _return != null) || (isRet && _departure != null)
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : null,
                  borderRadius: isDep && _return != null
                      ? const BorderRadius.horizontal(left: Radius.circular(20))
                      : isRet
                          ? const BorderRadius.horizontal(right: Radius.circular(20))
                          : null,
                ),
                child: Center(
                  child: Container(
                    width: 38, height: 38,
                    decoration: isSelected ? BoxDecoration(color: AppColors.primary, shape: BoxShape.circle) : null,
                    child: Center(child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isPast
                            ? AppColors.textHint.withValues(alpha: 0.3)
                            : isSelected
                                ? Colors.white
                                : _isSameDay(date, _today)
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                      ),
                    )),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget _buildBottom() {
    final canContinue = _departure != null && (!_isRoundTrip || _return != null);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -3))]),
      child: SafeArea(
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_isRoundTrip ? 'Roundtrip' : 'One way', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            if (_departure != null)
              Text(
                _isRoundTrip && _return != null
                    ? AppDate.formatRange(_departure!, _return!)
                    : AppDate.format(_departure!),
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
          ])),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: canContinue
                  ? () => Navigator.pop(context, DateRangePickerResult(
                      departure: _departure!,
                      returnDate: _isRoundTrip ? _return : null,
                      isRoundTrip: _isRoundTrip,
                    ))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(horizontal: 28),
              ),
              child: Text('Continue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}
