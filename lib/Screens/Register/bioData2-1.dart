import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Register/requirements4.dart';
import 'package:flutter_auth/Screens/Register/service_screen3.dart';
import 'package:flutter_auth/Screens/Signup/components/sign_up_top_image.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class Address extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _ExpTextController = TextEditingController();
  TextEditingController _nbiTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileAddress(),
          desktop: Row(
            children: [
              SizedBox(
                width: 450,
                child: Column(
                  children: [
                    const Text("BIO DATA INFORMATION"),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                        "Full Name", Icons.person, false, _nameTextController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Address", Icons.location_city, false,
                        _emailTextController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Phone Number", Icons.phone, false,
                        _passwordTextController),
                    nextButton(context, () {}, "Next")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileAddress extends StatelessWidget {
  final items = ['item 1', 'item 2', 'item 3'];
  final gender = ['Male', 'Female', 'Non-binary'];
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _ExpTextController = TextEditingController();
  TextEditingController _nbiTextController = TextEditingController();
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  String? value;
  // File? fileToDisplay;

  MobileAddress({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Column(children: <Widget>[
                SizedBox(
                  width: 450,
                  child: Column(
                    children: <Widget>[
                      Text("City"),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: items.map(buildMenuItem).toList(),
                          onChanged: (value) => this.value = value,
                          isExpanded: true,
                          value: value,
                          iconSize: 36,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Text("Barangay"),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: items.map(buildMenuItem).toList(),
                          onChanged: (value) => this.value = value,
                          isExpanded: true,
                          value: value,
                          iconSize: 36,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      const Text("ADDRESS"),
                      textField("Street Address", Icons.location_city, false,
                          _emailTextController),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("Extended Address", Icons.location_city, false,
                          _emailTextController),
                      textField("ZIP Code", Icons.mail_outline, false,
                          _emailTextController),
                      nextButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ServiceScreen();
                        }));
                      }, "Next")
                    ],
                  ),
                )
              ]),
            ),
            const Spacer()
          ],
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}