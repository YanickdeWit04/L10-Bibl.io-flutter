import 'dart:convert';
import 'package:http/http.dart';
import 'catalog.dart';
import 'package:flutter/material.dart';
import 'package:biblio/Navbar.dart';
import 'package:biblio/classes/book.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FutureBuilder<List<Book>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("No books available.");
          } else {
            return BooksList(books: snapshot.data!);
          }
        },
      ),
    );
  }
}

class BookListStream extends StatefulWidget {
  @override
  _BookListStreamState createState() => _BookListStreamState();
}

class _BookListStreamState extends State<BookListStream> {
  late Stream<List<Book>> _bookStream;
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _books = [];
    _bookStream = Stream.periodic(Duration(seconds: 1), (count) async {
      return await fetchBooks();
    }).asyncMap((event) async => await event);

    _bookStream.listen((event) {
      setState(() {
        _books = event;
      });
    });
  }

  Future<List<Book>> fetchBooks() async {
    final response =
    await http.get(Uri.parse('https://api.landsteten.nl/books'));
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return [
      for (final map in (json['books'] as List).cast<Map<String, dynamic>>())
        Book.fromJson(map),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BooksList(books: _books);
  }
}
