// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class SalonSummaryScreen extends StatefulWidget {
  const SalonSummaryScreen({Key? key}) : super(key: key);

  @override
  _SalonSummaryScreenState createState() => _SalonSummaryScreenState();
}

class _SalonSummaryScreenState extends State<SalonSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Thank You for Signing In!\nBefore Proceeding into the final step of signing up\nWe need to verify the validity of the documents that you have submitted\nThis will only take up to 3-5 business days.",
          textAlign: TextAlign.center,
          style: TextStyle(color: kPrimaryColor),
        ),
        const SizedBox(height: defaultPadding),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()));
            },
            child: const Text("Proceed to Home")),
      ],
    ));
  }
}
