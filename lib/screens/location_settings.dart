import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_share/controllers/UserInfo.dart';
import 'package:location_share/screens/updateLocationTime.dart';
import 'package:location_share/services/locationService.dart';
import 'package:location_share/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import '../state/state.dart';
import 'package:location_share/services/backgroundLocation.dart';

class LocationSettings extends StatefulWidget {
  const LocationSettings({super.key});

  @override
  State<LocationSettings> createState() => _LocationSettingsState();
}

class _LocationSettingsState extends State<LocationSettings> {
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  late bool _locationSwitch = state.locationStatus;
  late bool _backgroundSwitch = state.backgroundStatus;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar(theme, context, "Location Settings"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            listMenu(
              theme: theme,
              title: "Location Sharing",
              subtitle: "Enable/Disable Live Location Sharing",
              widget: CupertinoSwitch(
                value: _locationSwitch,
                onChanged: (value) async {
                  await setLocStatus();
                },
              ),
              onTap: () async {
                await setLocStatus();
              },
            ),
            if (_locationSwitch) backgroundLocationWidget(theme),
            // listMenu(
            //   theme: theme,
            //   title: "Real Time Location",
            //   subtitle: "Share my location in every 5 minutes",
            //   widget: const Padding(
            //     padding: EdgeInsets.only(right: 10),
            //     child: Text("5 min", textAlign: TextAlign.start),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const UpdateLocationTime(),
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }

  Container backgroundLocationWidget(ThemeData theme) {
    return listMenu(
      theme: theme,
      title: "Background Location Sharing",
      subtitle: "Enable/Disable Background Location Sharing",
      widget: CupertinoSwitch(
        value: _backgroundSwitch,
        onChanged: (value) async {
          await setBackgroundStatus();
        },
      ),
      onTap: () async {
        await setBackgroundStatus();
      },
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

  Container listMenu(
      {required ThemeData theme,
      required String title,
      required String subtitle,
      required Widget widget,
      Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: Text(title),
        ),
        subtitle: Text(subtitle),
        trailing: widget,
        onTap: onTap,
      ),
    );
  }

  Future<void> setLocStatus() async {
    _locationSwitch = _locationSwitch ? false : true;
    state.setLocationStatus(status: _locationSwitch);
    await UserInfoHandler(state).updateLocStatus();
    setState(() {
      _locationSwitch = state.locationStatus;
    });
    if (!_locationSwitch) {
      UpdateLocation(state).onStop();
      BackgroundLocation().onStop();
    }
  }

  Future<void> setBackgroundStatus() async {
    _backgroundSwitch = _backgroundSwitch ? false : true;
    state.setBackgroundStatus(status: _backgroundSwitch);
    await UserInfoHandler(state).updateLocStatus();
    setState(() {
      _backgroundSwitch = state.backgroundStatus;
    });
    _backgroundSwitch
        ? BackgroundLocation().onStart()
        : BackgroundLocation().onStop();
  }
}
