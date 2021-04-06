import '../helper/authenticate.dart';
import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widget/widget.dart';
import 'package:flutter/material.dart';

import 'EditProfile.dart';

class AddJobs extends StatefulWidget {
  @override
  _AddJobsState createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  String companyName;
  Stream jobs;
  String url;
  @override
  void initState() {
    getAddedJobs();

    super.initState();
  }

  getAddedJobs() async {
    companyName = await HelperFunctions.getCompanyNameSharedPreference();
    url=await HelperFunctions.getURLSharedPreference();
    DatabaseMethods().getAddedJobs(companyName).then((snapshots) {
      setState(() {
        jobs = snapshots;
      });
    });
  }

  Widget getAddedJobList() {
    return StreamBuilder(
      stream: jobs,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return jobCards(
                    companyName: snapshot
                        .data.docs[index].data()['companyName']
                        .toString(),
                    jobDiscription: snapshot
                        .data.docs[index].data()["discription"]
                        .toString(),
                        context: context
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Jobs"),
        actions: [
        
            PopupMenuButton<String>(
            onSelected: (value){
              if(value=="Logout")
              {
                 AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
              }
              else if(value=="Edit profile")
              {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile(false)));
              }
            },
            itemBuilder: (BuildContext context) {
              return {"Edit profile",'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: getAddedJobList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, companyName),
          );
        },
        child: Text(
          "Add Job",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String companyName) {
    TextEditingController discriptionEditingController =
        TextEditingController();
List<String> applied=[];
    return AlertDialog(
      title: Text('Add Job'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: discriptionEditingController,
            style: simpleTextStyle(),
            decoration: textFieldInputDecoration("Job Discription"),
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
        IconButton(
            icon: Icon(Icons.done),
            color: Colors.green,
            onPressed: () {
              Map<String, dynamic> job = {
                "companyName": companyName,
                "discription": discriptionEditingController.text,
                "url":url,
                "applied":applied
              };
              DatabaseMethods().addjob(job);
              Navigator.of(context).pop();
            })
      ],
    );
  }
}


