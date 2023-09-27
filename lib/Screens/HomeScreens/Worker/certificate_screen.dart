import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class DisplayCertificates extends StatefulWidget {
  const DisplayCertificates({Key? key}) : super(key: key);

  @override
  State<DisplayCertificates> createState() => _DisplayCertificatesState();
}

class _DisplayCertificatesState extends State<DisplayCertificates> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    getUserCertificates();
  }

// function for getting imageurls in subcollection
// this returns the list of urls sulod sa 'certificates' na field
  void getUserCertificates() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('userDetails')
          .doc('step4')
          .get();
      if (documentSnapshot.exists) {
        List<dynamic> imageUrlArray = documentSnapshot['certificates'];
        setState(() {
          imageUrls = imageUrlArray.map((item) => item as String).toList();
        });
      } else {
        log('document not exist');
      }
    } catch (e) {
      log('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  'Certificates'.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.edit_note,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Expanded(
                child: ListView(
              children: imageUrls.map((url) {
                return Image.network(url);
              }).toList(),
            )),
          ],
        ),
      )),
    ));
  }
}