import 'package:flutter/material.dart';
import 'package:location_share/screens/location_settings.dart';
import 'package:location_share/screens/themeSettings.dart';
import 'package:location_share/widgets/location_marker.dart';
import 'package:location_share/widgets/ProfileWidget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var mode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.colorScheme.secondary,
        title: const Text("Settings",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const ProfileWidget(),
            const SizedBox(
              height: 30,
            ),
            ProfileMenu(
              theme: theme,
              title: "Theme",
              icon: Icons.dark_mode,
              route: (BuildContext) {
                return const ThemeSettings();
              },
            ),
            ProfileMenu(
              theme: theme,
              title: "Location Settings",
              icon: Icons.location_on,
              route: (BuildContext) {
                return const LocationSettings();
              },
            )
          ],
        ),
      ),
    );
  }

  Container ProfileMenu(
      {required ThemeData theme,
      required String title,
      required IconData icon,
      required Widget Function(BuildContext) route}) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(
            icon,
          ),
        ),
        title: Text(title),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(Icons.chevron_right, size: 18),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: route));
        },
      ),
    );
  }
}
