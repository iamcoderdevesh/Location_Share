import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class ShareManually extends StatefulWidget {
  const ShareManually({super.key});

  @override
  State<ShareManually> createState() => _ShareManuallyState();
}

class _ShareManuallyState extends State<ShareManually> {
  late String code = context.watch<LocationShareProvider>().shareCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_pin,
                  size: 50.0,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Copy the location code below and send it to a friend. When your friend pastes the location code in the app and clicks on Share, you can obtain their location.',
                  style: TextStyle(color: theme.colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.inverseSurface),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: SelectableText(
                    code,
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code)).then((value) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                        // ignore: use_build_context_synchronously
                        .showSnackBar(ShowSnack("Location Code Copied", context).snackBar);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary),
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
