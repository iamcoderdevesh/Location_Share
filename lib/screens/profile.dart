import 'package:flutter/material.dart';
import 'package:location_share/widgets/ProfileWidget.dart';
import 'package:location_share/widgets/location_marker.dart';
import 'package:location_share/widgets/TextField.dart';
import 'package:provider/provider.dart';
import '../controllers/UserInfo.dart';
import '../state/state.dart';
import '../widgets/snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  String name = "", email = "";

  @override
  void initState() {
    super.initState();
    name = state.userName;
    email = state.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    var mode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.colorScheme.secondary,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const ProfileWidget(isEdit: false),
              CustomTextField(
                  label: 'Name',
                  text: name,
                  onChanged: (String value) {
                    name = value;
                  }),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Email',
                text: email,
                onChanged: (String value) {
                  email = value;
                },
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(
                        32.0,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    state.setUserInfo(
                        userName: name,
                        user_id: state.user_id,
                        userEmail: email,
                        status: state.status,
                        shareCode: state.shareCode);
                    if (await UserInfoHandler(state).setUserInfo()) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          ShowSnack("Profile Updated Successfully!!!", context)
                              .snackBar);
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
}
