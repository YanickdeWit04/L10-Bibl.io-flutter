import 'package:flutter/material.dart';

class DisplayScanResult extends StatelessWidget {
  final String result;

  DisplayScanResult({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Result'),
      ),
      body: Center(
        child: Text(result),
      ),
    );
  }
}
