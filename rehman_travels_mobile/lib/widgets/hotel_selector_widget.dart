import 'package:flutter/material.dart';
import '../models/calculator_models.dart';

/// Widget for selecting and managing hotels
class HotelSelectorWidget extends StatefulWidget {
  final List<Hotel> availableHotels;
  final List<HotelBooking> selectedHotels;
  final Function(List<HotelBooking> hotels) onChanged;

  const HotelSelectorWidget({
    Key? key,
    required this.availableHotels,
    required this.selectedHotels,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<HotelSelectorWidget> createState() => _HotelSelectorWidgetState();
}

class _HotelSelectorWidgetState extends State<HotelSelectorWidget> {
  late List<HotelBooking> hotels;

  @override
  void initState() {
    super.initState();
    hotels = List.from(widget.selectedHotels);
  }

  void _addHotel() {
    if (hotels.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 3 hotels allowed'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _AddHotelDialog(
        availableHotels: widget.availableHotels,
        onHotelSelected: (hotel) {
          setState(() {
            hotels.add(hotel);
            widget.onChanged(hotels);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _removeHotel(int index) {
    setState(() {
      hotels.removeAt(index);
      widget.onChanged(hotels);
    });
  }

  void _editHotel(int index) {
    final hotel = hotels[index];
    showDialog(
      context: context,
      builder: (context) => _HotelEditDialog(
        hotelBooking: hotel,
        onSave: (updatedHotel) {
          setState(() {
            hotels[index] = updatedHotel;
            widget.onChanged(hotels);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    int totalRooms = 0;
    int totalNights = 0;

    for (var hotel in hotels) {
      totalRooms += hotel.rooms.values.fold<int>(0, (sum, val) => sum + val);

      if (hotel.checkIn.isNotEmpty && hotel.checkOut.isNotEmpty) {
        try {
          final checkIn = DateTime.parse(hotel.checkIn);
          final checkOut = DateTime.parse(hotel.checkOut);
          totalNights += checkOut.difference(checkIn).inDays;
        } catch (e) {
          // Invalid date format
        }
      }
    }

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
                  'Hotels',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
                Text(
                  '${hotels.length}/3',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F6368),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hotels.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No hotels selected',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotelBooking = hotels[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HotelCard(
                      hotelBooking: hotelBooking,
                      onEdit: () => _editHotel(index),
                      onRemove: () => _removeHotel(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8EAED)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Rooms',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalRooms.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a73e8),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFDADCE0),
                    ),
                    Column(
                      children: [
                        Text(
                          'Total Nights',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalNights.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a73e8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hotels.length < 3 ? _addHotel : null,
                icon: const Icon(Icons.add),
                label: const Text('Add Hotel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1a73e8),
                  disabledBackgroundColor: const Color(0xFFDADCE0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final HotelBooking hotelBooking;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _HotelCard({
    Key? key,
    required this.hotelBooking,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomsText = hotelBooking.rooms.entries
        .where((e) => e.value > 0)
        .map((e) => '${e.value} ${e.key}')
        .join(', ');

    final datesConfigured =
        hotelBooking.checkIn.isNotEmpty && hotelBooking.checkOut.isNotEmpty;
    final roomsConfigured = roomsText.isNotEmpty;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: datesConfigured && roomsConfigured
                ? const Color(0xFF1B7D34)
                : const Color(0xFFFFA500),
          ),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF8F9FA),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hotelBooking.hotelName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF202124),
                              ),
                            ),
                          ),
                          if (datesConfigured && roomsConfigured)
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Color(0xFF1B7D34),
                            )
                          else
                            const Icon(
                              Icons.warning,
                              size: 16,
                              color: Color(0xFFFFA500),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hotelBooking.hotelLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5F6368),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onRemove();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Color(0xFFD32F2F)),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (datesConfigured)
              Text(
                '${hotelBooking.checkIn} to ${hotelBooking.checkOut}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5F6368),
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Text(
                'Tap to set check-in and check-out dates',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (roomsConfigured) ...[
              const SizedBox(height: 4),
              Text(
                'Rooms: $roomsText',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5F6368),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const SizedBox(height: 4),
              Text(
                'Tap to select room types',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HotelEditDialog extends StatefulWidget {
  final HotelBooking hotelBooking;
  final Function(HotelBooking) onSave;

  const _HotelEditDialog({
    Key? key,
    required this.hotelBooking,
    required this.onSave,
  }) : super(key: key);

  @override
  State<_HotelEditDialog> createState() => _HotelEditDialogState();
}

class _HotelEditDialogState extends State<_HotelEditDialog> {
  late DateTime? checkInDate;
  late DateTime? checkOutDate;
  late Map<String, int> rooms;

  @override
  void initState() {
    super.initState();
    if (widget.hotelBooking.checkIn.isNotEmpty) {
      checkInDate = DateTime.parse(widget.hotelBooking.checkIn);
    }
    if (widget.hotelBooking.checkOut.isNotEmpty) {
      checkOutDate = DateTime.parse(widget.hotelBooking.checkOut);
    }
    rooms = Map.from(widget.hotelBooking.rooms);
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
        if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
          checkOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in date first')),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Hotel: ${widget.hotelBooking.hotelName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202124),
                ),
              ),
              const SizedBox(height: 24),
              // Check-in and Check-out dates
              Text(
                'Dates',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: 'Check-in',
                      date: checkInDate,
                      onTap: _selectCheckInDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerField(
                      label: 'Check-out',
                      date: checkOutDate,
                      onTap: _selectCheckOutDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Room selection
              Text(
                'Select Rooms',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              ...rooms.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
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
                                  onTap: entry.value > 0
                                      ? () {
                                          setState(() {
                                            rooms[entry.key] =
                                                rooms[entry.key]! - 1;
                                          });
                                        }
                                      : null,
                                  child: Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: entry.value > 0
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
                                entry.value.toString(),
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
                                  onTap: () {
                                    setState(() {
                                      rooms[entry.key] = rooms[entry.key]! + 1;
                                    });
                                  },
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
                  ),
                );
              }).toList(),
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
                      onPressed: checkInDate != null && checkOutDate != null
                          ? () {
                              widget.onSave(HotelBooking(
                                hotelId: widget.hotelBooking.hotelId,
                                hotelName: widget.hotelBooking.hotelName,
                                hotelLocation:
                                    widget.hotelBooking.hotelLocation,
                                checkIn: checkInDate
                                    .toString()
                                    .split(' ')[0],
                                checkOut: checkOutDate
                                    .toString()
                                    .split(' ')[0],
                                rooms: rooms,
                              ));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a73e8),
                      ),
                      child: const Text('Save'),
                    ),
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

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerField({
    Key? key,
    required this.label,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  date == null ? 'Select' : '${date!.day}-${date!.month}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: date == null
                        ? const Color(0xFFBDC1C6)
                        : const Color(0xFF202124),
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
    );
  }
}

class _AddHotelDialog extends StatefulWidget {
  final List<Hotel> availableHotels;
  final Function(HotelBooking hotel) onHotelSelected;

  const _AddHotelDialog({
    Key? key,
    required this.availableHotels,
    required this.onHotelSelected,
  }) : super(key: key);

  @override
  State<_AddHotelDialog> createState() => _AddHotelDialogState();
}

class _AddHotelDialogState extends State<_AddHotelDialog> {
  Hotel? selectedHotel;

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
              'Select Hotel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDADCE0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<Hotel>(
                value: selectedHotel,
                hint: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Choose a hotel...'),
                ),
                isExpanded: true,
                underline: const SizedBox(),
                items: widget.availableHotels
                    .map((hotel) => DropdownMenuItem(
                          value: hotel,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(hotel.name),
                          ),
                        ))
                    .toList(),
                onChanged: (hotel) {
                  if (hotel != null) {
                    setState(() {
                      selectedHotel = hotel;
                    });
                  }
                },
              ),
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
                    onPressed: selectedHotel != null
                        ? () {
                            widget.onHotelSelected(
                              HotelBooking(
                                hotelId: selectedHotel!.id,
                                hotelName: selectedHotel!.name,
                                hotelLocation: selectedHotel!.location,
                                checkIn: '',
                                checkOut: '',
                                rooms: {
                                  'Double': 0,
                                  'Triple': 0,
                                  'Quad': 0,
                                  'Quint': 0,
                                },
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a73e8),
                    ),
                    child: const Text('Add'),
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
