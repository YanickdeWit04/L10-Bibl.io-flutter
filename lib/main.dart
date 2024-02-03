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
      title: 'Book Catalog',
      home: FutureBuilder<List<Book>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
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
      return await fetchFreshBooks();
    }).asyncMap((event) async => await event);

    _bookStream.listen((event) {
      setState(() {
        _books = event;
      });
    });
  }

  Future<List<Book>> fetchFreshBooks() async {
    return await fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    return await fetchFreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    return BooksList(books: _books);
  }
}