import 'package:flutter/material.dart';
import '../models/menu_models.dart';

/// Hardcoded navigation menu widget with 8 Umrah items
class UmrahDropdownWidget extends StatefulWidget {
  final Function(MenuItem) onItemSelected;

  const UmrahDropdownWidget({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<UmrahDropdownWidget> createState() => _UmrahDropdownWidgetState();
}

class _UmrahDropdownWidgetState extends State<UmrahDropdownWidget> {
  // Hardcoded menu items (8 items as per specification)
  static final List<MenuItem> menuItems = [
    MenuItem(
      id: 0,
      title: 'Umrah Package Calculator',
      url: '/calculator',
      type: 'calculator',
    ),
    MenuItem(
      id: 1,
      title: 'Customized Umrah packages From Pakistan',
      url: '/package/customized-umrah-packages-from-pakistan',
      type: 'content',
    ),
    MenuItem(
      id: 2,
      title: 'Economy Umrah Packages',
      url: '/package/economy',
      type: 'content',
    ),
    MenuItem(
      id: 3,
      title: 'Executive Umrah Packages',
      url: '/package/executive',
      type: 'content',
    ),
    MenuItem(
      id: 4,
      title: 'Umrah e Visa From Pakistan',
      url: '/package/umrah-e-visa',
      type: 'content',
    ),
    MenuItem(
      id: 5,
      title: 'Best Umrah Packages',
      url: '/package/best-umrah-packages',
      type: 'content',
    ),
    MenuItem(
      id: 6,
      title: 'Ramzan Umrah Packages',
      url: '/package/ramzan-umrah-packages',
      type: 'content',
    ),
    MenuItem(
      id: 7,
      title: '15 Days Umrah Packages From Pakistan',
      url: '/package/15-days-umrah-packages-from-pakistan',
      type: 'content',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      onSelected: widget.onItemSelected,
      itemBuilder: (BuildContext context) {
        return menuItems
            .map((MenuItem item) => PopupMenuItem<MenuItem>(
                  value: item,
                  child: _MenuItemTile(item: item),
                ))
            .toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDADCE0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu, color: Color(0xFF1a73e8)),
            SizedBox(width: 8),
            Text(
              'Umrah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a73e8),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, color: Color(0xFF1a73e8)),
          ],
        ),
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final MenuItem item;

  const _MenuItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          item.type == 'calculator' ? Icons.calculate : Icons.description,
          size: 20,
          color: const Color(0xFF1a73e8),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF202124),
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple dropdown button variant (alternative to PopupMenuButton)
class UmrahDropdownButtonWidget extends StatefulWidget {
  final Function(MenuItem) onItemSelected;
  final MenuItem? selectedItem;

  const UmrahDropdownButtonWidget({
    Key? key,
    required this.onItemSelected,
    this.selectedItem,
  }) : super(key: key);

  @override
  State<UmrahDropdownButtonWidget> createState() =>
      _UmrahDropdownButtonWidgetState();
}

class _UmrahDropdownButtonWidgetState extends State<UmrahDropdownButtonWidget> {
  static final List<MenuItem> menuItems = [
    MenuItem(
      id: 0,
      title: 'Umrah Package Calculator',
      url: '/calculator',
      type: 'calculator',
    ),
    MenuItem(
      id: 1,
      title: 'Customized Umrah packages From Pakistan',
      url: '/package/customized-umrah-packages-from-pakistan',
      type: 'content',
    ),
    MenuItem(
      id: 2,
      title: 'Economy Umrah Packages',
      url: '/package/economy',
      type: 'content',
    ),
    MenuItem(
      id: 3,
      title: 'Executive Umrah Packages',
      url: '/package/executive',
      type: 'content',
    ),
    MenuItem(
      id: 4,
      title: 'Umrah e Visa From Pakistan',
      url: '/package/umrah-e-visa',
      type: 'content',
    ),
    MenuItem(
      id: 5,
      title: 'Best Umrah Packages',
      url: '/package/best-umrah-packages',
      type: 'content',
    ),
    MenuItem(
      id: 6,
      title: 'Ramzan Umrah Packages',
      url: '/package/ramzan-umrah-packages',
      type: 'content',
    ),
    MenuItem(
      id: 7,
      title: '15 Days Umrah Packages From Pakistan',
      url: '/package/15-days-umrah-packages-from-pakistan',
      type: 'content',
    ),
  ];

  late MenuItem? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem ?? menuItems[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDADCE0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<MenuItem>(
        value: selectedItem,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.arrow_drop_down, color: Color(0xFF1a73e8)),
        ),
        items: menuItems
            .map((item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _MenuItemTile(item: item),
                  ),
                ))
            .toList(),
        onChanged: (MenuItem? item) {
          if (item != null) {
            setState(() {
              selectedItem = item;
            });
            widget.onItemSelected(item);
          }
        },
      ),
    );
  }
}
