import 'package:flutter/material.dart';
import 'package:location_share/widgets/location_marker.dart';
import '../widgets/bottomSheetModal.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Popover(
        child: Column(
          children: [
            _buildListItem(
              context,
              name: "Devesh Ukalkar",
              address: "22 A, Karade kh., Maharashtra 410220, India",
              status: "Can't see your location",
              logo: const CustomMarker(
                initial: "D",
                color: Colors.brown,
              ),
              icon: const Icon(Icons.chevron_right),
            ),
            _buildListItem(context,
                name: "Ganesh Ukalkar",
                address: "22 A, Karade kh., Maharashtra 410220, India",
                status: "Can see your location",
                logo: const CustomMarker(initial: "G"),
                icon: const Icon(Icons.chevron_right)),
            _buildListItem(
              context,
              name: "Harsh Ukalkar",
              address: "22 A, Karade kh., Maharashtra 410220, India",
              status: "Can see your location",
              logo: const CustomMarker(
                initial: "H",
                color: Colors.lightBlueAccent,
              ),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required String name,
    required String address,
    required String status,
    required Widget logo,
    required Widget icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
                width: 40.0,
                child: logo,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200.0,
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          icon,
        ],
      ),
    );
  }
}
