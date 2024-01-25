import 'package:biblio/CatalogPage.dart';
import 'package:flutter/material.dart';
import 'package:biblio/Navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navbar(),
    );
  }
  }
