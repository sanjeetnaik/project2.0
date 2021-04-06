import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../views/ApplyForJobs.dart';
import 'package:flutter/material.dart';

import 'AddJobs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
@override
  void initState() {
    HelperFunctions.getUserTypeSharedPreference().then((value){setState(() {
      Constants.type=value;
      
    });});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text("Home"),
    //           IconButton(
    //             icon:Icon(Icons.chat),
    //             onPressed: () {
                  
    //               Navigator.pushReplacement(context,
    //                   MaterialPageRoute(builder: (context) => ChatRoom()));
    //             },
    //           )
    //         ],
    //       ),
    //     ),
    //     body: SafeArea(
    //       child: Center(
    //       child: Text(Constants.type),
    //       ),
    //     ));

    return Constants.type=="Employee"?ApplyForJobs():AddJobs();
  }
}
