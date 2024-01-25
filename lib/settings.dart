import 'package:biblio/main.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Add Products'),
          ),
          body: Center(
            child: Text('Add products'),
          ),
        )
    );
  }
}
