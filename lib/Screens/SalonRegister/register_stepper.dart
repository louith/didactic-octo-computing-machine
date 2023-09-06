// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step2.dart';
import 'package:flutter_auth/Screens/SalonRegister/verification.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class SalonRegisterScreen extends StatefulWidget {
  const SalonRegisterScreen({Key? key}) : super(key: key);

  @override
  _SalonRegisterScreenState createState() => _SalonRegisterScreenState();
}

class _SalonRegisterScreenState extends State<SalonRegisterScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Theme(
        data: ThemeData(
            canvasColor: Colors.transparent,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  background: Colors.white70,
                  secondary: kPrimaryLightColor,
                )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    if (currentStep != 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text(
                          "BACK",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    if (currentStep <= 0)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text("NEXT"),
                      ),
                    if (currentStep == 1)
                      ElevatedButton(
                        onPressed: () {
                          _dialogBuilder(context);
                        },
                        child: const Text("NEXT"),
                      ),
                  ],
                ),
              );
            },
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => currentStep = step);
  }

  continued() {
    currentStep < 1 ? setState(() => currentStep += 1) : null;
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(''),
          content: const step1(),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(''),
          content: const step2(),
        ),
      ];

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm?'),
          content: const Text('Pwede paka mag review sa imo deets'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                addRoleToFireStore();
              },
            ),
          ],
        );
      },
    );
  }

  addRoleToFireStore() {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    try {
      ref.doc(user!.uid).update({'role': 'salon'});
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SalonSummaryScreen();
      }));
      print("added salon role to firestore");
    } catch (e) {
      print("$user $ref");
      print(e);
    }
  }
}