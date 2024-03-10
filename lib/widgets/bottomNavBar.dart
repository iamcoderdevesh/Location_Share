import 'package:flutter/material.dart';

import 'package:location_share/screens/home.dart';
import 'package:location_share/screens/request.dart';
import 'package:location_share/screens/settings.dart';
import 'package:location_share/screens/share.dart';

import 'bottomSheetModal.dart';

class BottoNavBar extends StatefulWidget {
  const BottoNavBar({super.key});

  @override
  State<BottoNavBar> createState() => _BottoNavBarState();
}

class _BottoNavBarState extends State<BottoNavBar> {
  int _currentIndex = 0;
  final _pageOptions = [const HomePage(), const SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          bottomSheetModal(context, customModalContent(context));
        },
        child: Icon(Icons.add,
            color: Theme.of(context).colorScheme.onInverseSurface),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 26,
          selectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (index) => {
            setState(() {
              _currentIndex = index;
            })
          },
        ),
      ),
    );
  }

  Popover customModalContent(BuildContext context) {
    return Popover(
      height: 200,
      margin: const EdgeInsets.only(
        top: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Share Location'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShareLocation()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.call_received),
            title: const Text('Request Location'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RequestLocation()));
            },
          ),
        ],
      ),
    );
  }
}
