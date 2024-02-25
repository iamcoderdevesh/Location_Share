import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/state.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

enum ThemeValues { lightTheme, darkTheme, systemDefault }

class _ThemeSettingsState extends State<ThemeSettings> {
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  ThemeValues? themeValue = ThemeValues.systemDefault;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar(theme, context, "Theme Settings"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: <Widget>[
              RadioListTile<ThemeValues>(
                title: const Text('Light'),
                value: ThemeValues.lightTheme,
                groupValue: themeValue,
                onChanged: (ThemeValues? value) {
                  setState(() {
                    themeValue = value;
                  });
                },
              ),
              RadioListTile<ThemeValues>(
                title: const Text('Dark'),
                value: ThemeValues.darkTheme,
                groupValue: themeValue,
                onChanged: (ThemeValues? value) {
                  setState(() {
                    themeValue = value;
                  });
                },
              ),
              RadioListTile<ThemeValues>(
                title: const Text('System Default'),
                value: ThemeValues.systemDefault,
                groupValue: themeValue,
                onChanged: (ThemeValues? value) {
                  setState(() {
                    themeValue = value;
                  });
                },
              ),
            ],
          ),
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
}
