import 'package:flutter/material.dart';
import 'package:location_share/state/state.dart';
import 'package:provider/provider.dart';

class ShareManually extends StatefulWidget {
  const ShareManually({super.key});

  @override
  State<ShareManually> createState() => _ShareManuallyState();
}

class _ShareManuallyState extends State<ShareManually> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.location_pin,
                  size: 50.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Copy the location code below and send it to a friend. When your friend pastes the location code in the app and clicks on Share, you can obtain their location.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: SelectableText(
                    context.watch<LocationShareProvider>().shareCode,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('COPY'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
