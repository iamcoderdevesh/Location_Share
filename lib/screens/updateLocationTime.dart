import 'package:flutter/material.dart';
import 'package:location_share/controllers/UserInfo.dart';
import 'package:provider/provider.dart';
import '../state/state.dart';

class UpdateLocationTime extends StatefulWidget {
  const UpdateLocationTime({super.key});

  @override
  State<UpdateLocationTime> createState() => _UpdateLocationTimeState();
}

enum UpdateTimeValues {
  realtime,
  min1,
  min5,
  min15,
  min30,
  hour1,
  hour4,
  hour24,
  off
}

class _UpdateLocationTimeState extends State<UpdateLocationTime> {
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  UpdateTimeValues? locationVal = UpdateTimeValues.off;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar(theme, context, "Update Location"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            RadioListTile<UpdateTimeValues>(
              title: const Text('Realtime'),
              value: UpdateTimeValues.realtime,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('1 minutes'),
              value: UpdateTimeValues.min1,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('5 minutes'),
              value: UpdateTimeValues.min5,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('15 minutes'),
              value: UpdateTimeValues.min15,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('30 minutes'),
              value: UpdateTimeValues.min30,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('1 hours'),
              value: UpdateTimeValues.hour1,
              groupValue: locationVal,
               onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('4 hours'),
              value: UpdateTimeValues.hour4,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('24 hours'),
              value: UpdateTimeValues.hour24,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
            RadioListTile<UpdateTimeValues>(
              title: const Text('off'),
              value: UpdateTimeValues.off,
              groupValue: locationVal,
              onChanged: (UpdateTimeValues? value) async {
                await setLocInterval(value: value);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(ThemeData theme, BuildContext context, String title) {
    return AppBar(
      backgroundColor: theme.canvasColor,
      foregroundColor: theme.colorScheme.secondary,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back)),
      centerTitle: true,
      title: Text(title),
    );
  }

  Future<void> setLocInterval({required UpdateTimeValues? value}) async {
    state.setUpdateInterval(updateInterval: value.toString());
    await UserInfoHandler(state).updateLocStatus();
    setState(() {
      locationVal = value;
    });
  }
}
