import 'package:flutter/material.dart';
import 'package:location_share/widgets/location_marker.dart';

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
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              ProfileWidget(),
              const SizedBox(
                height: 30,
              ),
              ProfileMenu(theme: theme,title: "Theme", icon: Icons.dark_mode),
              ProfileMenu(theme: theme,title: "Location Settings", icon: Icons.location_on)      
            ],
          ),
        ),
      ),
    );
  }

  Container ProfileMenu({
    required ThemeData theme,
    required String title,
    required IconData icon,
  }) {
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
      ),
    );
  }

  Column ProfileWidget() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, bottom: 12.0, top: 36.0),
          child: Center(
            child: Stack(
              children: [
                const SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomMarker(
                    initial: "D",
                    color: Colors.green,
                    fontSize: 48,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: buildEditIcon(Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        const Column(
          children: [
            Text(
              "Devesh Ukalkar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "devesh@xyz.com",
              style: TextStyle(color: Colors.grey),
            )
          ],
        )
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            size: 20,
          ),
        ),
      );

  Widget buildCircle(
          {required Widget child, required double all, required Color color}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
