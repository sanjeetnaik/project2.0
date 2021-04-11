import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../services/database.dart';

class EditProfile extends StatefulWidget {
  EditProfile(this.isEmployee);
  final isEmployee;
  @override
  _EditProfileState createState() => _EditProfileState(isEmployee);
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState(this.isEmployee);
  final isEmployee;

  final List<String> years = ["First", "Second", "Third", "Fourth"];
  String yearSelected;
  final formKey = GlobalKey<FormState>();

  File file;

  _getFile() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (result != null) {
      file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  updateProfile() async {
    if (formKey.currentState.validate() && isEmployee) {
      Constants.email = await HelperFunctions.getUserEmailSharedPreference();
      
      String path = "cv/${Constants.email}";
      DatabaseMethods()
          .updateUserInfo(Constants.email, path, file, year: yearSelected);
      Navigator.of(context).pop();
    } else if (!isEmployee) {
      String companyName=await HelperFunctions.getCompanyNameSharedPreference();
      Constants.email = await HelperFunctions.getUserEmailSharedPreference();
      String path = "brochure/${Constants.email}";
      DatabaseMethods().updateUserInfo(Constants.email, path, file,companyName:companyName );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  isEmployee
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Expanded(
                                child: Text(
                                  "Year:",
                                  textScaleFactor: 1.5,
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 7,
                                child: DropdownButtonFormField<String>(
                                  validator: (value) {
                                    return value == null ? "Select Year" : null;
                                  },
                                  iconSize: 45,
                                  value: yearSelected,
                                  isExpanded: true,
                                  items: years.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String value) {
                                    setState(() {
                                      yearSelected = value;
                                    });
                                  },
                                ),
                              ),
                            ])
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Expanded(
                        flex: 2,
                        child: Text(isEmployee ? "CV:" : "Brochure:",
                            textScaleFactor: 1.6)),
                    Expanded(
                        flex: 5,
                        child: TextButton(
                          child: Text(
                              isEmployee ? "Upload CV" : "Upload Brochure",
                              textScaleFactor: 1.3),
                          onPressed: () {
                            _getFile();
                          },
                        ))
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (file == null) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          content: Text(isEmployee
                              ? 'Please upload CV'
                              : "Please upload brochure"),
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      // singUp();
                      updateProfile();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF35629E),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
