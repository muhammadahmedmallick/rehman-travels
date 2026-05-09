import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/date_format.dart';
import 'package:printing/printing.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../../app/widgets/date_range_picker.dart';
import '../providers/umrah_calculator_provider.dart';
import 'umrah_quotation_pdf.dart';

class UmrahCalculatorScreen extends ConsumerWidget {
  const UmrahCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(umrahCalculatorProvider);
    final notifier = ref.read(umrahCalculatorProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: const AppBackButton(),
        title: const Text('Umrah Calculator',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: state.initLoading
          ? const Center(child: CircularProgressIndicator())
          : state.initError != null
              ? _errorView(state.initError!, notifier.loadInit)
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _travelersCard(state, notifier),
                    const SizedBox(height: 12),
                    ..._buildHotelCards(context, state, notifier),
                    if (state.hotels.length < 3)
                      TextButton.icon(
                        onPressed: notifier.addHotel,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add another hotel'),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary),
                      ),
                    const SizedBox(height: 12),
                    _transportCard(state, notifier),
                    const SizedBox(height: 12),
                    _visaCard(state, notifier),
                    const SizedBox(height: 12),
                    _flightCard(state, notifier),
                    const SizedBox(height: 12),
                    _customerCard(state, notifier),
                    const SizedBox(height: 20),
                    _calculateButton(state, notifier),
                    if (state.calcError != null) ...[
                      const SizedBox(height: 12),
                      _errorBanner(state.calcError!),
                    ],
                    if (state.result != null) ...[
                      const SizedBox(height: 20),
                      _resultsCard(context, state, state.result!),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
    );
  }

  // ---------- Sections ----------

  Widget _travelersCard(
      UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    return _card(
      title: 'Travelers',
      icon: Icons.people_alt_outlined,
      child: Column(
        children: [
          _counterRow('Adults', s.adults, () => n.setAdults(s.adults - 1),
              () => n.setAdults(s.adults + 1),
              min: 1),
          _counterRow('Children', s.children,
              () => n.setChildren(s.children - 1),
              () => n.setChildren(s.children + 1)),
          _counterRow('Infants', s.infants,
              () => n.setInfants(s.infants - 1),
              () => n.setInfants(s.infants + 1)),
        ],
      ),
    );
  }

  List<Widget> _buildHotelCards(BuildContext context,
      UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    final widgets = <Widget>[];
    for (var i = 0; i < s.hotels.length; i++) {
      widgets.add(_HotelCard(
        index: i,
        hotel: s.hotels[i],
        availableHotels: s.init.hotels
            .where((h) =>
                h.location.toLowerCase() ==
                    s.hotels[i].location.toLowerCase() &&
                h.hasAnyRates)
            .toList(),
        onChanged: (updated) => n.updateHotel(i, updated),
        onRemove: s.hotels.length > 1 ? () => n.removeHotel(i) : null,
      ));
      widgets.add(const SizedBox(height: 12));
    }
    return widgets;
  }

  Widget _transportCard(
      UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    return _card(
      title: 'Transport',
      icon: Icons.directions_bus_outlined,
      trailing: Switch(
        value: s.transportEnabled,
        activeThumbColor: AppColors.primary,
        onChanged: n.setTransportEnabled,
      ),
      child: !s.transportEnabled
          ? const SizedBox.shrink()
          : Column(
              children: [
                _dropdown<int>(
                  label: 'Sector',
                  value: s.sectorId,
                  items: s.init.sectors
                      .map((e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name,
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: n.setSector,
                ),
                const SizedBox(height: 12),
                _dropdown<int>(
                  label: 'Vehicle',
                  value: s.vehicleId,
                  items: s.init.vehicles
                      .map((v) => DropdownMenuItem(
                            value: v.id,
                            child: Text(v.name,
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: n.setVehicle,
                ),
              ],
            ),
    );
  }

  Widget _visaCard(UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    return _card(
      title: 'Umrah Visa',
      icon: Icons.credit_card_outlined,
      trailing: Switch(
        value: s.visaEnabled,
        activeThumbColor: AppColors.primary,
        onChanged: n.setVisaEnabled,
      ),
      child: !s.visaEnabled
          ? const SizedBox.shrink()
          : _dropdown<int>(
              label: 'Nationality',
              value: s.visaId,
              items: s.init.visas
                  .map((v) => DropdownMenuItem(
                      value: v.id,
                      child: Text(
                          '${v.nationality} — ${v.name}  •  ${v.price.toStringAsFixed(0)} SAR',
                          overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: n.setVisa,
            ),
    );
  }

  Widget _flightCard(UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    return _card(
      title: 'Flight Fares',
      icon: Icons.flight_takeoff_outlined,
      trailing: Switch(
        value: s.flightEnabled,
        activeThumbColor: AppColors.primary,
        onChanged: n.setFlightEnabled,
      ),
      child: !s.flightEnabled
          ? const SizedBox.shrink()
          : Column(
              children: [
                _dropdown<String>(
                  label: 'Currency',
                  value: s.flightCurrency,
                  items: s.init.currencies
                      .map((c) => DropdownMenuItem(
                          value: c.code,
                          child: Text('${c.code} — ${c.name}')))
                      .toList(),
                  onChanged: n.setFlightCurrency,
                ),
                const SizedBox(height: 12),
                _priceField('Adult price', s.adultPrice, n.setAdultPrice),
                const SizedBox(height: 12),
                _priceField('Child price', s.childPrice, n.setChildPrice),
                const SizedBox(height: 12),
                _priceField('Infant price', s.infantPrice, n.setInfantPrice),
              ],
            ),
    );
  }

  Widget _customerCard(
      UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    return _card(
      title: 'Customer Details',
      icon: Icons.person_outline,
      child: Column(
        children: [
          TextFormField(
            initialValue: s.customerFirstName,
            decoration: _inputDecoration('First Name'),
            onChanged: n.setCustomerFirstName,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: s.customerEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Email'),
            onChanged: n.setCustomerEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: s.customerMobile,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('Mobile No'),
            onChanged: n.setCustomerMobile,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: s.customerCity,
            decoration: _inputDecoration('City'),
            onChanged: n.setCustomerCity,
          ),
        ],
      ),
    );
  }

  Widget _calculateButton(
      UmrahCalculatorState s, UmrahCalculatorNotifier n) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: s.calculating ? null : n.calculate,
        icon: s.calculating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.calculate_outlined),
        label: Text(s.calculating ? 'Calculating...' : 'Calculate UBC'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _resultsCard(
      BuildContext context, UmrahCalculatorState s, CalcResponse r) {
    final totals = r.totals;
    Widget line(String c, double v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text(_money(v),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        );
    return _card(
      title: 'Quotation',
      icon: Icons.receipt_long_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (r.breakdown.hotelDetails.isNotEmpty) ...[
            const Text('Hotels',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 6),
            ...r.breakdown.hotelDetails.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                              '${h.hotel} (${h.location}) • ${h.nights}n',
                              style: const TextStyle(fontSize: 12))),
                      Text('${_money(h.price)} SAR',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
            const Divider(),
          ],
          if (r.breakdown.transportTotal > 0)
            _breakdownRow('Transport', r.breakdown.transportTotal),
          if (r.breakdown.visaTotal > 0)
            _breakdownRow('Visa', r.breakdown.visaTotal),
          if (r.breakdown.flightTotal > 0)
            _breakdownRow('Flight', r.breakdown.flightTotal),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.secondary, width: 1),
            ),
            child: Column(children: [
              const Text('GRAND TOTAL',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.5)),
              const SizedBox(height: 6),
              line('SAR', totals.sar),
              line('USD', totals.usd),
              line('GBP', totals.gbp),
              line('EUR', totals.eur),
              line('AED', totals.aed),
            ]),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _downloadPdf(context, s, r),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Helpers ----------

  Future<void> _downloadPdf(
      BuildContext context, UmrahCalculatorState s, CalcResponse r) async {
    try {
      final doc = await UmrahQuotationPdf.build(state: s, result: r);
      await Printing.layoutPdf(onLayout: (format) async => doc.save());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF error: $e')),
        );
      }
    }
  }

  Widget _breakdownRow(String label, double value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('${_money(value)} SAR',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _counterRow(String label, int value, VoidCallback onMinus,
      VoidCallback onPlus,
      {int min = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14))),
          _roundBtn(Icons.remove, value > min ? onMinus : null),
          SizedBox(
            width: 36,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          _roundBtn(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? AppColors.primaryLight : AppColors.divider,
        ),
        child: Icon(icon,
            size: 18,
            color: enabled ? AppColors.primary : AppColors.textHint),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      decoration: _inputDecoration(label),
    );
  }

  Widget _priceField(
      String label, double value, ValueChanged<double> onChanged) {
    return TextFormField(
      initialValue: value > 0 ? value.toStringAsFixed(0) : '',
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(label),
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      );

  Widget _errorView(String error, VoidCallback retry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: retry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _errorBanner(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(error,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 12))),
        ],
      ),
    );
  }

  String _money(double v) => NumberFormat('#,##0.00').format(v);
}

// ---------- Hotel Card (stateful for local edits) ----------

class _HotelCard extends StatelessWidget {
  final int index;
  final HotelInput hotel;
  final List<CalcHotel> availableHotels;
  final ValueChanged<HotelInput> onChanged;
  final VoidCallback? onRemove;

  const _HotelCard({
    required this.index,
    required this.hotel,
    required this.availableHotels,
    required this.onChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.hotel_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Hotel ${index + 1}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.error, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: _dec('Location'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: hotel.location,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Makkah', child: Text('Makkah')),
                  DropdownMenuItem(value: 'Madinah', child: Text('Madinah')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  hotel.location = v;
                  hotel.hotelId = null;
                  hotel.hotelName = null;
                  onChanged(hotel);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: _dec('Hotel'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: availableHotels.any((h) => h.id == hotel.hotelId)
                    ? hotel.hotelId
                    : null,
                isExpanded: true,
                hint: const Text('Select hotel',
                    style: TextStyle(fontSize: 13)),
                items: availableHotels
                    .map((h) => DropdownMenuItem(
                          value: h.id,
                          child: Text(h.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (v) {
                  hotel.hotelId = v;
                  final match = availableHotels.where((h) => h.id == v);
                  hotel.hotelName = match.isNotEmpty ? match.first.name : null;
                  onChanged(hotel);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _dateField(context, 'Check-in', hotel.checkIn),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dateField(context, 'Check-out', hotel.checkOut),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${hotel.nights} nights',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          const Text('Rooms',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          const SizedBox(height: 6),
          _roomRow('Double', hotel.doubleRooms, (v) {
            hotel.doubleRooms = v;
            onChanged(hotel);
          }),
          _roomRow('Triple', hotel.tripleRooms, (v) {
            hotel.tripleRooms = v;
            onChanged(hotel);
          }),
          _roomRow('Quad', hotel.quadRooms, (v) {
            hotel.quadRooms = v;
            onChanged(hotel);
          }),
          _roomRow('Quint', hotel.quintRooms, (v) {
            hotel.quintRooms = v;
            onChanged(hotel);
          }),
        ],
      ),
    );
  }

  Widget _dateField(BuildContext context, String label, DateTime? value) {
    final formatted =
        value == null ? '' : AppDate.format(value);
    return InkWell(
      onTap: () => _pickHotelRange(context),
      child: InputDecorator(
        decoration: _dec(label).copyWith(
          suffixIcon: const Icon(Icons.calendar_today, size: 16),
        ),
        child: Text(formatted.isEmpty ? '—' : formatted,
            style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Future<void> _pickHotelRange(BuildContext context) async {
    final result = await showFlightDatePicker(
      context: context,
      initialDeparture:
          hotel.checkIn ?? DateTime.now().add(const Duration(days: 3)),
      initialReturn: hotel.checkOut,
      allowOneWay: false,
    );
    if (result == null) return;
    hotel.checkIn = result.departure;
    hotel.checkOut = result.returnDate ??
        result.departure.add(const Duration(days: 3));
    onChanged(hotel);
  }

  Widget _roomRow(String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          InkWell(
            onTap: value > 0 ? () => onChanged(value - 1) : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value > 0
                    ? AppColors.primaryLight
                    : AppColors.divider,
              ),
              child: Icon(Icons.remove,
                  size: 16,
                  color: value > 0
                      ? AppColors.primary
                      : AppColors.textHint),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700)),
          ),
          InkWell(
            onTap: () => onChanged(value + 1),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
              ),
              child: const Icon(Icons.add,
                  size: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      );
}
