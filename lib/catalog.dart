import 'package:flutter/material.dart';
import 'classes/book.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

Future<List<Book>> fetchBooks() async {
  final response =
      await http.get(Uri.parse('https://api.landsteten.nl/products'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> jsonBooks =
        jsonResponse['products']; // replace 'books' with the actual key
    return jsonBooks.map((json) => Book.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load books');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FutureBuilder<List<Book>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BooksList(books: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
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
        title: const Text('Book List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add book');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
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
            Text('Id: ${book.id}', style: TextStyle(fontSize: 20)),
            Text('Title: ${book.title}', style: TextStyle(fontSize: 20)),
            Text('Status: ${book.status}', style: TextStyle(fontSize: 20)),
            Text('ISBN: ${book.isbn}', style: TextStyle(fontSize: 20)),
            Text('EAN: ${book.ean}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
