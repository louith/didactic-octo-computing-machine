// ignore_for_file: must_be_immutable, non_constant_identifier_names, camel_case_types, library_private_types_in_public_api, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step2.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step3.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step4.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step5.dart';
// import 'package:flutter_auth/Screens/WorkerRegister/forms/step5.dart';
import 'package:flutter_auth/Screens/WorkerRegister/verification.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class WorkerRegisterScreen extends StatefulWidget {
  const WorkerRegisterScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkerRegisterScreenState createState() => _WorkerRegisterScreenState();
}

class _WorkerRegisterScreenState extends State<WorkerRegisterScreen> {
  final addUser = fifthStep();
  late String fName;
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
                    if (currentStep >= 0 && currentStep <= 3)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text("NEXT"),
                      ),
                    if (currentStep == 4)
                      ElevatedButton(
                        onPressed: () {
                          _dialogBuilder(context);
                        },
                        child: const Text("NEXT"),
                      ),
                    if (currentStep != 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text(
                          "BACK",
                          style: TextStyle(color: kPrimaryColor),
                        ),
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
    currentStep < 4 ? setState(() => currentStep += 1) : null;
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(''),
          content: const firstStep(),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(''),
          content: const secondStep(),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text(''),
          content: const thirdStep(),
        ),
        Step(
          isActive: currentStep >= 3,
          title: const Text(''),
          content: const fourthStep(),
        ),
        Step(
          isActive: currentStep >= 4,
          title: const Text(''),
          content: const fifthStep(),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkerSummaryScreen()));
              },
            ),
          ],
        );
      },
    );
  }
}
