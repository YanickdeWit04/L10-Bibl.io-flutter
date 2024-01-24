import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          // Icon color in app bar
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
          // Selected item color in navigation bar
          unselectedItemColor: Colors.black
              .withOpacity(0.6), // Unselected item color in navigation bar
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle profile dropdown menu item selection
              // You can add your logic here
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                // Add more menu items as needed
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Content for selected tab $_currentIndex'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle tab navigation
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
