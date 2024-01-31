import 'package:flutter/material.dart';
import 'DisplayScanResult.dart';
import 'classes/book.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

Future<List<Book>> fetchBooks() async {
  final response =
  await http.get(Uri.parse('https://api.landsteten.nl/products'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> jsonBooks = jsonResponse['products'];
    return jsonBooks.map((json) => Book.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

Future<void> updateLendingStatus(String ean) async {
  print('Updating lending status for EAN $ean to 1');
  final response = await http.put(
    Uri.parse('https://api.landsteten.nl/products/$ean'),
    body: {'status': '1'},
  );

  if (response.statusCode == 200) {
    print('Lending status updated successfully');
  } else if (response.statusCode == 404) {
    print('Product not found');
  } else {
    print(
        'Failed to update lending status. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to update lending status');
  }
}

Future<void> returnBook(String ean) async {
  print('Updating lending status for EAN $ean to 0');
  final response = await http.put(
    Uri.parse('https://api.landsteten.nl/products/$ean'),
    body: {'status': '0'},
  );

  if (response.statusCode == 200) {
    print('Successfully turned in');
  } else if (response.statusCode == 404) {
    print('Product not found');
  } else {
    print(
        'Failed to update lending status. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to update lending status');
  }
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
        onPressed: () async {
          String barcodeScanRes;
          try {
            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666',
              'Cancel',
              true,
              ScanMode.BARCODE,
            );
            print(barcodeScanRes);

            // Assuming you want to update the lending status to '1' (lent) when adding a new book
            await updateLendingStatus(barcodeScanRes);
          } on Exception {
            barcodeScanRes = 'Failed to get platform version.';
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayScanResult(result: barcodeScanRes),
            ),
          );
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

  const BookDetails({Key? key, required this.book}) : super(key: key);

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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Explicitly cast the status to a boolean before negating it
                await updateLendingStatus(book.ean);
                // Refresh the UI by rebuilding the widget tree
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: Text('Update Lending Status'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Use the new returnBook function for the second button
                await returnBook(book.ean);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: Text('Return Book'),
            ),
          ],
        ),
      ),
    );
  }
}
