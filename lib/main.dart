import 'catalog.dart';
import 'package:flutter/material.dart';
import 'package:biblio/Navbar.dart';
import 'package:biblio/classes/book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Book Catalog'),
        ),
        body: BookListStream(),
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

  @override
  Widget build(BuildContext context) {
    return BooksList(books: _books);
  }
}
