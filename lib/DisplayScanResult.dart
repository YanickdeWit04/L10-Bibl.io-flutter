import 'dart:convert';
import 'package:http/http.dart' as http;
import 'qrcode.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';

Future<String> bookExists(String result) async {
  print(result);
  final response =
  await http.get(Uri.parse('https://api.landsteten.nl/books/$result'));
  print(response.body);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse.toString(); // Convert jsonResponse to String
  } else {
    // Handle the case when the status code is not 200.
    // You can return false, throw an exception, or handle it in some other way.
    return 'false';
  }
}


class DisplayScanResult extends StatelessWidget {
  final String result;

  DisplayScanResult({required this.result});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: bookExists(result),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('Book exists: ${snapshot.data}');
        }
      },
    );
  }
}
