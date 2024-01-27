import 'package:flutter/material.dart';
import 'package:location_share/state/state.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareWithQrCode extends StatefulWidget {
  const ShareWithQrCode({Key? key}) : super(key: key);

  @override
  State<ShareWithQrCode> createState() => _ShareWithQrCodeState();
}

class _ShareWithQrCodeState extends State<ShareWithQrCode> {
  final qrText = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String qrData = context.watch<LocationShareProvider>().shareCode;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("QR Code",
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 250,
                    child: QrImageView(
                      data: qrData,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Divider(
                  height: 20.0,
                  thickness: 1.0,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  endIndent: 42.0,
                  indent: 42.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Text(
                    "Scan the above QR Code to share the location.",
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
