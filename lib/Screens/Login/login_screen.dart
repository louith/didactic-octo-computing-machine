// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/admin_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/Salon/salon_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/worker_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/firebase/firebase_services.dart';
import '../../components/background.dart';
import 'components/login_screen_top_image.dart';
import 'package:flutter_auth/components/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseService _authService = FirebaseService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const LoginScreenTopImage(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                  flex: 8,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        textField(
                          "Email Address",
                          Icons.person,
                          false,
                          _email,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField(
                          "Password",
                          Icons.lock,
                          true,
                          _password,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        SizedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90)),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  print("email and password clear");
                                  _login();
                                }
                              },
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))
                                  : const Text(
                                      'LOG IN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        AlreadyHaveAnAccountCheck(
                          login: true,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SignupScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

//route constructor to salon or worker when logged in
// throws error when login na walay role sa database
  void route() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == 'freelancer') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WorkerScreen();
          }));
        } else if (documentSnapshot.get('role') == 'salon') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SalonScreen();
          }));
        } else if (documentSnapshot.get('role') == 'admin') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AdminScreen();
          }));
        } else {
          print(e);
        }
      } else {
        print("document does not exist in the database");
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return const Verification();
        // }));
      }
    });
  }

  void _login() async {
    String email = _email.text;
    String password = _password.text;
    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      route();
      if (user != null) {
        print("user logged in");
      } else {
        print(e);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('no user found');
      } else if (e.code == 'wrong-password') {
        print('wrong password');
      }
    }
  }
}
