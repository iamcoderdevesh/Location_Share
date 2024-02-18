import 'package:flutter/material.dart';
import 'package:location_share/screens/profile.dart';
import 'package:location_share/state/state.dart';
import 'package:provider/provider.dart';
import 'location_marker.dart';

class ProfileWidget extends StatelessWidget {
  final bool isEdit;

  const ProfileWidget({
    Key? key,
    this.isEdit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, bottom: 12.0, top: 36.0),
          child: Center(
            child: Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomMarker(
                    initial: context.watch<LocationShareProvider>().userName.toString().substring(0, 1),
                    color: Colors.green,
                    fontSize: 48,
                  ),
                ),
                isEdit ? Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    child: EditIcon(Colors.grey),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                    },
                  ),
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
         Column(
          children: [
            Text(
              context.watch<LocationShareProvider>().userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              context.watch<LocationShareProvider>().userEmail,
              style: const TextStyle(color: Colors.grey),
            )
          ],
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget EditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.edit : Icons.add_a_photo,
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
