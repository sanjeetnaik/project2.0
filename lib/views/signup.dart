import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../helper/helperfunctions.dart';

import '../services/auth.dart';
import '../services/database.dart';
import '../views/Home.dart';

import '../widget/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController companyNameEditingController =
      new TextEditingController();
  final List<String> collegeNames = ["KJSCE", "DJ Sanghvi"];
  final List<String> branches = ["CS", "IT", "EXTC", "ETRX", "MECH"];
  final List<String> years = ["First", "Second", "Third", "Fourth"];
  var userType = "Employee";
  String clgNameSelected;
  String branchSelected;
  String yearSelected;
  bool isEmployee = true;

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
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

  singUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = isEmployee
              ? {
                  "userName": usernameEditingController.text,
                  "userEmail": emailEditingController.text,
                  "userType": userType,
                  "collegeName": clgNameSelected,
                  "Branch": branchSelected,
                  "year": yearSelected
                }
              : {
                  "userName": usernameEditingController.text,
                  "userEmail": emailEditingController.text,
                  "userType": userType,
                  "companyName": companyNameEditingController.text
                };
          String path = isEmployee
              ? "cv/${emailEditingController.text}"
              : "brochure/${emailEditingController.text}";
          databaseMethods.addUserInfo(userDataMap, path, file);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);
          HelperFunctions.saveUserTypeSharedPreference(userType);
          HelperFunctions.saveCompanyNameSharedPreference(
              companyNameEditingController.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF35629E),
        title: Text(
          "Studentship!",
          style: TextStyle(letterSpacing: 2.5),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 50.0),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: simpleTextStyle(),
                              controller: usernameEditingController,
                              validator: (val) {
                                return val.isEmpty || val.length < 3
                                    ? "Enter Username 3+ characters"
                                    : null;
                              },
                              decoration: textFieldInputDecoration("username"),
                            ),
                            TextFormField(
                              controller: emailEditingController,
                              style: simpleTextStyle(),
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter correct email";
                              },
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("password"),
                              controller: passwordEditingController,
                              validator: (val) {
                                return val.length < 6
                                    ? "Enter Password 6+ characters"
                                    : null;
                              },
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 2, child: Text("User Type: ")),
                                Expanded(
                                  flex: 7,
                                  child: DropdownButton<String>(
                                    iconSize: 45,
                                    isExpanded: true,
                                    value: userType,
                                    items: <String>['Employee', 'Employeer']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (selected) {
                                      setState(() {
                                        userType = selected;
                                        if (selected == "Employee") {
                                          isEmployee = true;
                                        } else
                                          isEmployee = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            isEmployee
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Expanded(
                                          child: Text("College:"),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child:
                                              DropdownButtonFormField<String>(
                                            validator: (value) {
                                              return value == null
                                                  ? "Select college"
                                                  : null;
                                            },
                                            iconSize: 45,
                                            value: clgNameSelected,
                                            isExpanded: true,
                                            items: collegeNames
                                                .map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                clgNameSelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ])
                                : TextFormField(
                                    controller: companyNameEditingController,
                                    style: simpleTextStyle(),
                                    validator: (val) {
                                      return val.length > 0
                                          ? null
                                          : "Please enter company name";
                                    },
                                    decoration: textFieldInputDecoration(
                                        "Company Name"),
                                  ),
                            isEmployee
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Expanded(
                                          child: Text("Branch:"),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child:
                                              DropdownButtonFormField<String>(
                                            iconSize: 45,
                                            isExpanded: true,
                                            value: branchSelected,
                                            validator: (value) {
                                              return value == null
                                                  ? "Select Branch"
                                                  : null;
                                            },
                                            items: branches.map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newvalue) {
                                              setState(() {
                                                branchSelected = newvalue;
                                              });
                                            },
                                          ),
                                        ),
                                      ])
                                : SizedBox(height: 5),
                            isEmployee
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Expanded(
                                          child: Text("Year:"),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child:
                                              DropdownButtonFormField<String>(
                                            validator: (value) {
                                              return value == null
                                                  ? "Select Year"
                                                  : null;
                                            },
                                            iconSize: 45,
                                            value: yearSelected,
                                            isExpanded: true,
                                            items: years.map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
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
                                : SizedBox(height: 5),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: isEmployee
                                        ? Text("CV")
                                        : Text("Brochure"),
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: TextButton(
                                        child: isEmployee
                                            ? Text("Upload CV")
                                            : Text("upload brochure"),
                                        onPressed: () {
                                          _getFile();
                                        },
                                      ))
                                ])
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (file == null) {
                            final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                              content: isEmployee
                                  ? Text('Please upload CV')
                                  : Text('Please upload brochure'),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          singUp();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFF35629E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: simpleTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "SignIn now",
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
