import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'classes/book.dart';

//display the scan result with the book title, ISBN and EAN
Future<Book> findBookDataByIsbn(String result) async {
  print("result: $result");
  final response = await http.get(
      Uri.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:$result"));
  if (response.statusCode == 200) {
    Map<String, dynamic>? jsonResponse = jsonDecode(response.body);
    print(result);
    List<dynamic> jsonBooks = jsonResponse?['items'] ?? [];

    if (jsonBooks.isNotEmpty) {
      Map<String, dynamic> volumeInfo = jsonBooks[0]['volumeInfo'];
      String title = volumeInfo['title'];
      String author = volumeInfo['authors']?.isNotEmpty == true
          ? volumeInfo['authors'][0]
          : 'Unknown Author';
      return Book(
          title: title,
          status: 0,
          isbn: result,
          ean: result,
          id: Random.secure().nextInt(1000000));
    } else {
      throw Exception('Book not count');
    }
  } else {
    throw Exception('Failed to load books');
  }
}

//code for creating a new book
Future<void> createBook(Book book) async {
  final response = await http.post(
    Uri.parse('https://api.landsteten.nl/books'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'title': book.title,
      'status': 0,
      'isbn': book.isbn,
      'ean': book.ean,
    }),
  );
//console status code returns
  if (response.statusCode != 200) {
    print('Failed to create book. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to create book');
  }
}

class DisplayScanResult extends StatelessWidget {
  final String result;

  DisplayScanResult({required this.result});

//code for displaying the book status for lent out
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Book>(
      future: findBookDataByIsbn(result),
      builder: (BuildContext context, AsyncSnapshot<Book> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          createBook(snapshot.data!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book Title: ${snapshot.data!.title}'),
              Text('ISBN: ${snapshot.data!.isbn}'),
              Text('EAN: ${snapshot.data!.ean}'),
            ],
          );
        } else {
          return Text('Book not found');
        }
      },
    );
  }
}
