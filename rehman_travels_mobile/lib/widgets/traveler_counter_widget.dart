import 'package:flutter/material.dart';

/// Widget for selecting number of travelers (adults, children, infants)
class TravelerCounterWidget extends StatefulWidget {
  final int initialAdults;
  final int initialChildren;
  final int initialInfants;
  final Function(int adults, int children, int infants) onChanged;

  const TravelerCounterWidget({
    Key? key,
    this.initialAdults = 2,
    this.initialChildren = 0,
    this.initialInfants = 0,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TravelerCounterWidget> createState() => _TravelerCounterWidgetState();
}

class _TravelerCounterWidgetState extends State<TravelerCounterWidget> {
  late int adults;
  late int children;
  late int infants;

  @override
  void initState() {
    super.initState();
    adults = widget.initialAdults;
    children = widget.initialChildren;
    infants = widget.initialInfants;
  }

  void _updateTravelers() {
    widget.onChanged(adults, children, infants);
  }

  void _incrementAdults() {
    setState(() {
      adults++;
      _updateTravelers();
    });
  }

  void _decrementAdults() {
    if (adults > 1) {
      setState(() {
        adults--;
        _updateTravelers();
      });
    }
  }

  void _incrementChildren() {
    setState(() {
      children++;
      _updateTravelers();
    });
  }

  void _decrementChildren() {
    if (children > 0) {
      setState(() {
        children--;
        _updateTravelers();
      });
    }
  }

  void _incrementInfants() {
    setState(() {
      infants++;
      _updateTravelers();
    });
  }

  void _decrementInfants() {
    if (infants > 0) {
      setState(() {
        infants--;
        _updateTravelers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTravelers = adults + children + infants;

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
                  'Travelers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a73e8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Total: $totalTravelers',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a73e8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TravelerRow(
              label: 'Adults',
              count: adults,
              onIncrement: _incrementAdults,
              onDecrement: _decrementAdults,
              minCount: 1,
            ),
            const SizedBox(height: 12),
            _TravelerRow(
              label: 'Children',
              count: children,
              onIncrement: _incrementChildren,
              onDecrement: _decrementChildren,
              minCount: 0,
            ),
            const SizedBox(height: 12),
            _TravelerRow(
              label: 'Infants',
              count: infants,
              onIncrement: _incrementInfants,
              onDecrement: _decrementInfants,
              minCount: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelerRow extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minCount;

  const _TravelerRow({
    Key? key,
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.minCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6368),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDADCE0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: count > minCount ? onDecrement : null,
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: count > minCount
                          ? const Color(0xFF1a73e8)
                          : const Color(0xFFDADCE0),
                    ),
                  ),
                ),
              ),
              Container(
                width: 44,
                alignment: Alignment.center,
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrement,
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xFF1a73e8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
