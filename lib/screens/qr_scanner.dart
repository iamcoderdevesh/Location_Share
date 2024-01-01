import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String qrCodeResult = "Not Yet Scanned";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            textAlign: TextAlign.center,
            "QR Code Result",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onLongPress: () {},
            child: SelectableText(
              qrCodeResult,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Colors.red,
              showCursor: true,
              toolbarOptions: const ToolbarOptions(
                copy: true,
                cut: true,
                paste: true,
                selectAll: true,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            height: 68.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(
                    32.0,
                  ),
                ),
              ),
              onPressed: () async {
                ScanResult codeScanner = await BarcodeScanner.scan();
                setState(
                  () {
                    qrCodeResult = codeScanner.rawContent;
                  },
                ); //barcode scanner
              },
              child: const Text(
                "Scan your QR Code",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
