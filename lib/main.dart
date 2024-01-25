import 'package:flutter/material.dart';
import 'classes/book.dart';

void main() {
  runApp(const MyApp());
}

List<Book> createAndPrintBooks() {
  List<Book> books = [
    Book(
      title: "Test 1",
      isbn: "123456789",
      author: "Hanssie",
      description: "This is a test book 1",
      cover: "test",
      copies: 2,
    ),
    Book(
      title: "Test 2",
      isbn: "987654321",
      author: "John Doe",
      description: "This is a test book 2",
      cover: "test",
      copies: 1,
    ),
      Book(
      title: "Test 3",
      isbn: "987654321",
      author: "John Doe",
      description: "This is a test book 2",
      cover: "test",
      copies: 3,
    ),
    // Add more books as needed
  ];

  return books;
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

class BooksList extends StatelessWidget {
  final List<Book> books;

  BooksList({required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetails(book: books[index]),
                ),
              );
            },
          );
        },
      ),
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
            Text('Description: ${book.description}', style: TextStyle(fontSize: 20)),
            Text('Cover: ${book.cover}', style: TextStyle(fontSize: 20)),
            Text('Copies: ${book.copies}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
