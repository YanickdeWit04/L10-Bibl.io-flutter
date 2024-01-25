import 'package:flutter/material.dart';
import 'classes/book.dart';

void main() {
  runApp(const MyApp());
  createAndPrintBook();
}
Book createAndPrintBook() {
  Book testbook = Book(
    title: "test",
    isbn: "123456789",
    author: "Hanssie",
    discription: "This is a test book",
    cover: "test",
    status: "available"
  );

  print('${testbook.title}, ${testbook.isbn}, ${testbook.author}, ${testbook.discription}, ${testbook.cover}, ${testbook.status}');

  return testbook;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BookDetails(book: createAndPrintBook()),
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book book;

  BookDetails({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${book.title}', style: TextStyle(fontSize: 20)),
            Text('ISBN: ${book.isbn}', style: TextStyle(fontSize: 20)),
            Text('Author: ${book.author}', style: TextStyle(fontSize: 20)),
            Text('Description: ${book.discription}', style: TextStyle(fontSize: 20)),
            Text('Cover: ${book.cover}', style: TextStyle(fontSize: 20)),
            Text('Status: ${book.status}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
