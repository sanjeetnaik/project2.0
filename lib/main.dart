import 'package:firebase_core/firebase_core.dart';

import 'helper/authenticate.dart';
import 'helper/helperfunctions.dart';
import 'views/Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  bool isLoading = true;
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : MaterialApp(
            title: 'Chat',
            debugShowCheckedModeBanner: false,
            home: userIsLoggedIn != null
                ? userIsLoggedIn
                    ? Home()
                    : Authenticate()
                : Container(
                    child: Center(
                      child: Authenticate(),
                    ),
                  ),
          );
  }
}
