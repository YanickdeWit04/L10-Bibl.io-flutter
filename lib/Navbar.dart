import 'package:flutter/material.dart';

void main() => runApp(const Navbar());

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavbarExample(),
    );
  }
}

class NavbarExample extends StatefulWidget {
  const NavbarExample({Key? key}) : super(key: key);

  @override
  State<NavbarExample> createState() => _NavbarExampleState();
}

class _NavbarExampleState extends State<NavbarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Catalog',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.barcode_reader),
            label: 'Barcode Scanner',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
