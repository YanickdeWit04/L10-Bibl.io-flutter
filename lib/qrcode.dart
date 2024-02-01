import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'DisplayScanResult.dart';

class QrCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      // Delay the barcode scanning by 500 milliseconds
      await Future.delayed(Duration(milliseconds: 500));

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);

      if (barcodeScanRes != null && barcodeScanRes.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayScanResult(result: barcodeScanRes),
          ),
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Barcode scan')),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Text('Start barcode scan'),
                ),
                Text('Scan result : $_scanBarcode\n',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
