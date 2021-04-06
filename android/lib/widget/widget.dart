import '../views/PDFscreen.dart';
import '../views/chat.dart';
import '../views/chatrooms.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 40,
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(fontSize: 17);
}

GestureDetector jobCards({String companyName, String jobDiscription,context}) {
  return GestureDetector(
    onTap: (){
      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatRoom(jobDiscription,companyName)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.tealAccent, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
        
            Text(
              companyName,
              textScaleFactor: 1.5,
            ),
            Text(
              "Job Discription: $jobDiscription",
              textScaleFactor: 1.2,
            )
          ],
        ),
      ),
    ),
  );
}

GestureDetector appliedJobCards({String companyName, String jobDiscription,String url,String myName,String email,context}) {
  return GestureDetector(
    onTap: (){
      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chat(companyName:companyName,discription:jobDiscription ,applicantName: myName,applicantEmail: email,)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.tealAccent, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              companyName,
              textScaleFactor: 1.5,
            ),
            Text(
              "Job Discription: $jobDiscription",
              textScaleFactor: 1.2,
            ),
             TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PDFscreen(url)),
                    );
                  },
                  child: Text("view Brochure")),
            
          ],
        ),
      ),
    ),
  );
}