import 'catalog.dart';
import 'package:flutter/material.dart';
import 'classes/book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BooksList(books: createAndPrintBooks()),
    );
  }
}