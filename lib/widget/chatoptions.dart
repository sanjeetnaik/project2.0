import '../views/PDFscreen.dart';
import '../widget/widget.dart';
import 'package:flutter/material.dart';
import '../views/chat.dart';


class Chatopt extends StatelessWidget {
  final String name, collegeName, userEmail, year, branch, url;

  Chatopt(
      {this.name,
      this.collegeName,
      this.branch,
      this.userEmail,
      this.year,
      this.url});



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xFF33A7AF)),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/userchat.jpg"),
                      radius: 30,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _showUserProfile(
                            context: context,
                            name: name,
                            collegeName: collegeName,
                            branch: branch,
                            userEmail: userEmail,
                            year: year,
                            url: url),
                      );
                    },
                    child: Text(
                      "View Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _showUserProfile(
      {BuildContext context,
      String name,
      String collegeName,
      String branch,
      String userEmail,
      String year,
      String url}) {
    TextEditingController discriptionEditingController =
        TextEditingController();

    return AlertDialog(
      title: Text('Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Name:  "),
              Text(
                name,
                textScaleFactor: 1.2,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Email:  "),
              Text(
                userEmail,
                textScaleFactor: 1.2,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("College Name:  "),
              Text(
                collegeName,
                textScaleFactor: 1.2,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Branch:  "), Text(branch, textScaleFactor: 1.2)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Year:  "),
              Text(
                year,
                textScaleFactor: 1.2,
              )
            ],
          ),
          SizedBox(height: 20,),
          TextButton(
            child: Text("View resume"),
            onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          PDFscreen(url)
                        ),
                      );},
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
