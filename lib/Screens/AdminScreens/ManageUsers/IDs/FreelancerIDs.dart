import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class Freelancer {
  final String nbi;
  final String govtID;
  final String vaxCard;
  final String tinID;

  Freelancer(
      {required this.nbi,
      required this.govtID,
      required this.vaxCard,
      required this.tinID});

  factory Freelancer.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Freelancer(
        tinID: data['tinID'] as String,
        nbi: data['nbiClearance'] as String,
        govtID: data['governmentID'] as String,
        vaxCard: data['vaccinationCard'] as String);
  }
}

class FreelancerDocs extends StatefulWidget {
  final String currentID;
  const FreelancerDocs({super.key, required this.currentID});

  @override
  State<FreelancerDocs> createState() => _FreelancerDocsState();
}

class _FreelancerDocsState extends State<FreelancerDocs> {
  Future<Freelancer> getFreeelancerDocsWithDownloadUrls() async {
    final docRef = db
        .collection('users')
        .doc(widget.currentID)
        .collection('portfolio')
        .doc('requirements');
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final List<String> downloadUrls = [];
      final nbi = docSnapshot.get('nbiClearance') as String;
      final govtID = docSnapshot.get('governmentID') as String;
      final vaxCard = docSnapshot.get('vaccinationCard') as String;
      final tinID = docSnapshot.get('tinID') as String;

      final futures = [nbi, govtID, vaxCard, tinID];
      downloadUrls.addAll(futures);
      print(downloadUrls);
      return Freelancer(
          nbi: downloadUrls[0],
          govtID: downloadUrls[1],
          vaxCard: downloadUrls[2],
          tinID: downloadUrls[3]);
    } else {
      return Freelancer(
          nbi: 'no outsideSalonUrl',
          govtID: 'no insideSalonUrl',
          vaxCard: 'no businessPermitUrl',
          tinID: 'no tinID provided');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Freelancer>(
        future: getFreeelancerDocsWithDownloadUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final freelancerDocs = snapshot.data!;
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
                    adminHeading('NBI Clearance'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.network(
                          freelancerDocs.nbi,
                          fit: BoxFit.cover,
                          height: 400,
                          width: 550,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    adminHeading('Government ID'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.network(
                          freelancerDocs.govtID,
                          fit: BoxFit.cover,
                          height: 400,
                          width: 550,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text('TIN ID: ${freelancerDocs.tinID}')
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    adminHeading('Vaccination Card'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.network(
                          freelancerDocs.vaxCard,
                          fit: BoxFit.cover,
                          height: 400,
                          width: 550,
                        ),
                        SizedBox(
                          width: 25,
                        ),
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
