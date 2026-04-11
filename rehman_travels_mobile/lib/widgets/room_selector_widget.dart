import 'package:flutter/material.dart';

/// Widget for selecting room types and quantities
class RoomSelectorWidget extends StatefulWidget {
  final Map<String, int> initialRooms;
  final Function(Map<String, int> rooms) onChanged;

  const RoomSelectorWidget({
    Key? key,
    Map<String, int>? initialRooms,
    required this.onChanged,
  })  : initialRooms = initialRooms ??
            const {
              'Double': 0,
              'Triple': 0,
              'Quad': 0,
              'Quint': 0,
            },
        super(key: key);

  @override
  State<RoomSelectorWidget> createState() => _RoomSelectorWidgetState();
}

class _RoomSelectorWidgetState extends State<RoomSelectorWidget> {
  late Map<String, int> rooms;

  @override
  void initState() {
    super.initState();
    rooms = Map.from(widget.initialRooms);
  }

  void _updateRooms() {
    widget.onChanged(rooms);
  }

  void _incrementRoom(String roomType) {
    setState(() {
      rooms[roomType] = (rooms[roomType] ?? 0) + 1;
      _updateRooms();
    });
  }

  void _decrementRoom(String roomType) {
    if ((rooms[roomType] ?? 0) > 0) {
      setState(() {
        rooms[roomType] = (rooms[roomType] ?? 0) - 1;
        _updateRooms();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalRooms =
        rooms.values.fold<int>(0, (sum, val) => sum + val);

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
                  'Room Types',
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
                    'Total: $totalRooms',
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
            ...rooms.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RoomTypeRow(
                  label: entry.key,
                  count: entry.value,
                  onIncrement: () => _incrementRoom(entry.key),
                  onDecrement: () => _decrementRoom(entry.key),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _RoomTypeRow extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _RoomTypeRow({
    Key? key,
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
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
                    onTap: count > 0 ? onDecrement : null,
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: count > 0
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
