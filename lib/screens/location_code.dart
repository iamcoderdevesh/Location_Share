import 'package:flutter/material.dart';
import 'package:location_share/controllers/Share.dart';
import 'package:location_share/main.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/widgets/snackbar.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class LocationCode extends StatefulWidget {
  const LocationCode({Key? key}) : super(key: key);

  @override
  State<LocationCode> createState() => _LocationCodeState();
}

class _LocationCodeState extends State<LocationCode> {
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/img1.png',
              //   width: 150,
              //   height: 150,
              // ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Enter Location Code",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Ask your friend to send you the location code. Then paste your friend's location code below and click the submit button to get the location.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Code",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.paste,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
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
                    String code = controller.text.toString().trim();
                    if (code != "") {
                      String result =
                          await ShareInfo(state).saveShareInfo(code: code);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                          // ignore: use_build_context_synchronously
                          .showSnackBar(ShowSnack(result, context).snackBar);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
