import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/HomeScreens/editservices_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/servicenames.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String addText = 'ADD';
  List<String> serviceNames = [
    'Hair',
    'Makeup',
    'Spa',
    'Nails',
    'Lashes',
    'Wax',
  ];
  String serviceType = '';
  String serviceName = '';
  String type = hrMin.first;
  String timeOftype = '1';
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  File? serviceImage;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> timeList = type == 'hr'
        ? hrs.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()
        : mins.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList();
    return Scaffold(
      body: SafeArea(
          child: Background(
              child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Column(
          children: [
            Text(
              "Add Service".toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Select Service Type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(50)),
              child: DropdownButton<String>(
                isExpanded: true,
                value: serviceType.isEmpty ? null : serviceType,
                items: serviceNames.isNotEmpty
                    ? serviceNames.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ));
                      }).toList()
                    : <DropdownMenuItem<String>>[],
                onChanged: (value) {
                  setState(() {
                    serviceName = '';
                    serviceType = value!;
                  });
                },
              ),
            ),
            if (serviceType.toLowerCase() == 'hair')
              serviceDropdown(ServiceNames().hair),
            if (serviceType.toLowerCase() == 'makeup')
              serviceDropdown(ServiceNames().makeup),
            if (serviceType.toLowerCase() == 'spa')
              serviceDropdown(ServiceNames().spa),
            if (serviceType.toLowerCase() == 'nails')
              serviceDropdown(ServiceNames().nails),
            if (serviceType.toLowerCase() == 'lashes')
              serviceDropdown(ServiceNames().lashes),
            if (serviceType.toLowerCase() == 'wax')
              serviceDropdown(ServiceNames().wax),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            flatTextField('Serivce Description', _serviceDescription),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            flatTextField('Serivce Price', _servicePrice, istext: false),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Duration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            durationDropdowns(timeList),
            const SizedBox(height: defaultPadding),
            // const Row(
            //   children: [
            //     Text(
            //       'Image',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
            // TextButton(
            //     onPressed: () {
            //       getImage();
            //     },
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Add Photo',
            //           style: TextStyle(
            //             fontSize: 13,
            //             fontFamily: 'Inter',
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //         Icon(Icons.open_in_new)
            //       ],
            //     )),
            // const SizedBox(height: defaultPadding),
            // InkWell(
            //   onTap: serviceImage == null ? null : viewImage,
            //   child: Text(
            //     serviceImage == null ? 'Empty' : 'View',
            //     style: const TextStyle(
            //         color: kPrimaryColor, decoration: TextDecoration.underline),
            //   ),
            // ),
            // const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('BACK')),
                TextButton(onPressed: servicesToFirestore, child: Text(addText))
              ],
            )
          ],
        ),
      ))),
    );
  }

  viewImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.file(serviceImage!),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    serviceImage = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      },
    );
  }

  Future<void> addServicesToFirestore(String serviceName, String serviceType,
      String? serivcePrice, serviceDuration, serviceDescription) async {
    try {} catch (e) {
      log(e.toString());
    }
  }

  Future<bool> isServiceTypeExisting(String serviceName) async {
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceName);
      DocumentSnapshot docSnapshot = await docRef.get();
      return docSnapshot.exists;
    } catch (e) {
      log('Error getting service type: $e');
      return false;
    }
  }

  Future<bool> isServiceNameExisting(
      String serviceName, String serviceType) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceName)
          .collection('${currentUser!.uid}services');
      DocumentSnapshot documentSnapshot =
          await collectionReference.doc(serviceType).get();
      return (
          // querySnapshot.docs.isNotEmpty &&
          documentSnapshot.exists); // True if service already exists
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('An Error Occured'),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        ));
      }
      log(e.toString());
      return false;
    }
  }

  Container durationDropdowns(List<DropdownMenuItem<String>> timeList) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton(
                value: timeOftype,
                items: timeList,
                onChanged: (String? newVale) {
                  setState(() {
                    timeOftype = newVale!;
                  });
                },
              ),
              const SizedBox(width: defaultPadding),
              DropdownButton<String>(
                value: type,
                onChanged: ((String? newValue) {
                  setState(() {
                    type = newValue!;
                  });
                }),
                items: hrMin.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget serviceDropdown(List<String> services) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Row(
          children: [
            Text(
              'Select Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(50)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: serviceName.isEmpty ? null : serviceName,
              items: services.isNotEmpty
                  ? services.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 14),
                          ));
                    }).toList()
                  : <DropdownMenuItem<String>>[],
              onChanged: (value) => setState(() {
                try {
                  serviceName = value!;
                } catch (e) {
                  log(e.toString());
                }
              }),
            )),
      ],
    );
  }

  Future getImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        File? image = File(img.path);
        image = await cropImage(image);
        setState(() {
          serviceImage = image;
        });
        return serviceImage;
      } else {
        return;
      }
    } catch (e) {
      log("error picking image $e");
    }
  }

  Future cropImage(File imgFile) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );
      if (croppedImage == null) {
        return;
      } else {
        return File(croppedImage.path);
      }
    } catch (e) {
      log('error cropping image $e');
    }
  }

  Future<void> servicesToFirestore() async {
    if (await isServiceTypeExisting(serviceType)) {
      log('servicetype existing');
      if (await isServiceNameExisting(serviceType, serviceName)) {
        log('servicename existing');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Service Already Existing'),
            action: SnackBarAction(label: 'Close', onPressed: () {}),
          ));
        }
      } else {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('salonImage')
            .child(currentUser!.uid)
            .child('serviceImages')
            .child(serviceName);
        if (serviceImage != null) {
          UploadTask uploadTask = reference.putFile(File(serviceImage!.path));
          final storageSnapshot = uploadTask.snapshot;
          final serviceImageUrl = await storageSnapshot.ref.getDownloadURL();
          log('servicename not existing');
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc(serviceType)
              .update({serviceName: ""});
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('services')
              .doc(serviceType)
              .collection('${currentUser!.uid}services')
              .doc(serviceName)
              .set({
            'description': _serviceDescription.text,
            'duration': "$timeOftype $type",
            'price': _servicePrice.text,
            'image': serviceImageUrl,
          }).then((value) {
            log('added $serviceName');
            Navigator.of(context).pop();
          });
        } else {
          log('servicename not existing');
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc(serviceType)
              .update({serviceName: ""});
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('services')
              .doc(serviceType)
              .collection('${currentUser!.uid}services')
              .doc(serviceName)
              .set({
            'description': _serviceDescription.text,
            'duration': "$timeOftype $type",
            'price': _servicePrice.text,
            'image': '',
          }).then((value) {
            log('added $serviceName');
            Navigator.of(context).pop();
          });
        }
      }
    } else {
      log('servicetype not existing');
      //add "doc" fields to make document readable
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('categories')
          .doc(serviceType)
          .set({serviceName: ""});
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .set({'doc': ''}).then((value) {
        log('added $serviceType');
        Navigator.of(context).pop();
      });
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .collection('${currentUser!.uid}services')
          .doc(serviceName)
          .set({
        'description': _serviceDescription.text,
        'duration': "$timeOftype $type",
        'price': _servicePrice.text,
      }).then((value) {
        log('added $serviceType with $serviceName');
        Navigator.of(context).pop();
      });
    }
  }
}
