import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class Portfolio {
  final String cert0;
  final String cert1;
  Portfolio({
    required this.cert0,
    required this.cert1,
  });

  factory Portfolio.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Portfolio(
      cert0: data['certificates0'] as String,
      cert1: data['certificates1'] as String,
    );
  }
}

class FreelancerPortfolio extends StatefulWidget {
  final String currentID;
  const FreelancerPortfolio({super.key, required this.currentID});

  @override
  State<FreelancerPortfolio> createState() => _FreelancerPortfolioState();
}

class _FreelancerPortfolioState extends State<FreelancerPortfolio> {
  Future<Portfolio> getFreelancerPortfolio() async {
    final docRef = db
        .collection('users')
        .doc(widget.currentID)
        .collection('portfolio')
        .doc('requirements');
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final List<String> downloadUrls = [];
      final cert0 = docSnapshot.get('nbiClearance') as String;
      final cert1 = docSnapshot.get('tinID') as String;

      final futures = [cert0, cert1];
      downloadUrls.addAll(futures);
      print(downloadUrls);
      return Portfolio(
        cert0: downloadUrls[0],
        cert1: downloadUrls[1],
      );
    } else {
      return Portfolio(
          cert0: 'no certificate provided', cert1: 'no certificate provided');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Portfolio>(
        future: getFreelancerPortfolio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final portfolio = snapshot.data!;
            return SingleChildScrollView(
              child: Expanded(
                  child: Container(
                padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    adminHeading('Certificates'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.network(
                          portfolio.cert0,
                          fit: BoxFit.cover,
                          height: 400,
                          width: 550,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        portfolio.cert1.isNotEmpty
                            ? Image.network(
                                portfolio.cert1,
                                fit: BoxFit.cover,
                                height: 400,
                                width: 550,
                              )
                            : Container(
                                width: 550,
                                height: 400,
                                child: Text('Image does not exist'),
                              )
                      ],
                    ),
                  ],
                ),
              )),
            );
          }
        });
  }
}
