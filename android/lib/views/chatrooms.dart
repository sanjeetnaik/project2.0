import '../helper/authenticate.dart';
import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../views/AddJobs.dart';
import '../views/chat.dart';
import '../views/search.dart';
import 'package:flutter/material.dart';
import '../widget/chatoptions.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(this.discription, this.companyName);
  final discription, companyName;
  @override
  _ChatRoomState createState() => _ChatRoomState(discription, companyName);
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  _ChatRoomState(this.discription, this.companyName);
  String discription, companyName;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String name = snapshot.data.docs[index].data()['userName']
                      .toString();
                  String email = snapshot
                      .data.docs[index].data()['userEmail']
                      .toString();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                              companyName: companyName,
                              discription: discription,
                              applicantEmail: email.toString(),
                              applicantName: name),
                        ),
                      );
                    },
                    child: Chatopt(
                      name: name,
                      collegeName: snapshot
                          .data.docs[index].data()['collegeName']
                          .toString(),
                      year: snapshot.data.docs[index].data()['year']
                          .toString(),
                      userEmail: email,
                      branch: snapshot.data.docs[index].data()['Branch']
                          .toString(),
                      url: snapshot.data.docs[index].data()['url'],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    String companyName = await HelperFunctions.getCompanyNameSharedPreference();
    DatabaseMethods()
        .getAppliedUsers(companyName, discription)
        .then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Applied Candidates"),
        backgroundColor: Color(0xFF33A7AF),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Delete",style: TextStyle(color: Colors.red[400]),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                              "Are you sure you want to delete job for $discription?"),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          DatabaseMethods().deleteJob(companyName:companyName,discription:discription);
                           Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AddJobs()));
                        },
                       
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
      body: SafeArea(
        child: Container(
          child: chatRoomsList(),
        ),
      ),
    );
  }
}
