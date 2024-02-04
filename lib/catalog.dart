import 'package:biblio/qrcode.dart';
import 'package:flutter/material.dart';
import 'classes/book.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Book>> fetchBooks() async {
  final response = await http.get(Uri.parse('https://api.landsteten.nl/books'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> jsonBooks = jsonResponse['books'];
    return jsonBooks.map((book) => Book.fromJson(book)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

//code for displaying the book status for lent out
Future<void> updateLendingStatus(String ean) async {
  print('Updating lending status for EAN $ean to 1');
  final response = await http.put(
    Uri.parse('https://api.landsteten.nl/books/$ean'),
    body: {'status': '1'}, //status 1 means lent out
  );

  //console status code returns
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

//code for displaying the book status for not lent out
Future<void> returnBook(String ean) async {
  print('Updating lending status for EAN $ean to 0');
  final response = await http.put(
    Uri.parse('https://api.landsteten.nl/books/$ean'),
    body: {'status': '0'}, // status 0 means not lent out
  );

  //console status code returns
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

class BooksList extends StatefulWidget {
  final List<Book> books;

  BooksList({required this.books});

  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  late List<Book> filteredBooks;

  @override
  void initState() {
    super.initState();
    filteredBooks = widget.books;
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks = widget.books
          .where(
              (book) => book.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //layout for the book list and qr code scanner
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[700],
      ),
      //qr code scanner button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrCode(),
            ),
          );
        },
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ),
      ),
      //search bar
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterBooks,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredBooks[index].title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetails(book: filteredBooks[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book book;

  const BookDetails({Key? key, required this.book}) : super(key: key);

//layout for selected book details
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book details',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[700],
      ),
      //book details inside of the book tab
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Id: ${book.id}', style: TextStyle(fontSize: 20)),
            Text('Title: ${book.title}', style: TextStyle(fontSize: 20)),
            Text('Lent Status: ${book.status}', style: TextStyle(fontSize: 20)),
            Text('ISBN: ${book.isbn}', style: TextStyle(fontSize: 20)),
            Text('EAN: ${book.ean}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            //row styled buttons for lent and return book
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await updateLendingStatus(book.ean);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  },
                  child: Text('Lent'), //button text
                ),
                SizedBox(width: 8), // Add some space between buttons
                ElevatedButton(
                  onPressed: () async {
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
          ],
        ),
      ),
    );
  }
}
