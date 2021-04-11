import 'dart:io';
import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../services/database.dart';
import '../views/AppliedJobs.dart';
import '../widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String companyName;
  final String applicantName;
  final String discription;
  final String applicantEmail;

  Chat(
      {this.companyName,
      this.discription,
      this.applicantName,
      this.applicantEmail});
  @override
  _ChatState createState() =>
      _ChatState(companyName, discription, applicantName, this.applicantEmail);
}

class _ChatState extends State<Chat> {
  final companyName, discription, applicantName, applicantEmail;
  _ChatState(this.companyName, this.discription, this.applicantName,
      this.applicantEmail);
  Stream<QuerySnapshot> chats;
   ScrollController _sc = ScrollController();
  TextEditingController messageEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                
                controller: _sc,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    sendByMe:
                        name == snapshot.data.docs[index].data()["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": name,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods()
          .addMessage(companyName, discription, chatMessageMap, applicantEmail);

      setState(() {
        messageEditingController.text = "";
         _sc.jumpTo(_sc.position.maxScrollExtent);
      });
    }
  }

  bool isLoading = true;
  String name;
  String reciever;
  @override
  void initState() {
    setNameAndGetStream();

    super.initState();
  }
  // Container(
  //                   padding: EdgeInsets.all(5),
  //                   color: Colors.blue,
  //                   child: Text(
  //                     "Job discription:$discription",
  //                     textScaleFactor: 1.3,
  //                   ),
  //                 ),

  setNameAndGetStream() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    // name = await HelperFunctions.getCompanyNameSharedPreference();
    // if (name == null) {
    //   name = Constants.myName;
    //   reciever=companyName;
    // }
    // else
    // {
    //   reciever=applicantName;
    // }
    if (applicantName == Constants.myName) {
      name = applicantName;
      reciever = companyName;
    } else {
      name = companyName;
      reciever = applicantName;
    }

    DatabaseMethods()
        .getChats(companyName, discription, applicantEmail)
        .then((val) {
      setState(() {
        chats = val;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow, width: 2),
                        shape: BoxShape.circle,
                        color: Colors.black),
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    reciever,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              backgroundColor: Color(0xFF3B743B),
              elevation: 0.0,
            ),
            body: Container(
       
        
        child: Stack(
          children: [
            chatMessages(),
          ],
        ),
      ),
      bottomNavigationBar: 
       
         Container(
    

          width: MediaQuery.of(context).size.width,
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.black,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: new Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      
                      onTap: () {
                        setState(() {
                          _sc.jumpTo(_sc.position.maxScrollExtent);
                        });
                      },
                      maxLines: 3,
                      minLines: 1,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      controller: messageEditingController,
                      decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.white60,
                            fontSize: 20,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () {
                  addMessage();
                },
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight),
                        borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/images/send.png",
                      height: 25,
                      width: 25,
                    )),
              ),
            ],
          ),
        ),
          );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff808080),
                  const Color(0xff070707),
                ])),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
