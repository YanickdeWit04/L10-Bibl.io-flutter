import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'classes/book.dart';

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

class DisplayScanResult extends StatelessWidget {
  final String result;

  DisplayScanResult({required this.result});

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book Title: ${snapshot.data!.title}'),
              Text('Author: ${snapshot.data!.author}'),
            ],
          );
        } else {
          return Text('Book not found');
        }
      },
    );
  }
}
