import '../helper/authenticate.dart';
import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../views/appliedJobs.dart';
import 'package:flutter/material.dart';

import 'EditProfile.dart';
import 'PDFscreen.dart';
import 'search.dart';

class ApplyForJobs extends StatefulWidget {
  @override
  _ApplyForJobsState createState() => _ApplyForJobsState();
}

class _ApplyForJobsState extends State<ApplyForJobs> {
  Stream jobs;
  @override
  void initState() {
    getJobs();

    super.initState();
  }

  getJobs() async {
    Constants.email = await HelperFunctions.getUserEmailSharedPreference();
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getJobs().then((snapshots) {
      setState(() {
        jobs = snapshots;
      });
    });
  }

  applyForJob({String jobDiscription, String companyName, String url}) {
    DatabaseMethods().applyForJob(
        discription: jobDiscription,
        companyname: companyName,
        userEmail: Constants.email,
        userName: Constants.myName);
  }

  Widget getJobList() {
    return StreamBuilder(
      stream: jobs,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  List applied =
                      List.from(snapshot.data.docs[index].data()['applied']);

                  return applied.contains(Constants.email)
                      ? Container()
                      : applyingJobCards(
                          companyName: snapshot.data.docs[index]
                              .data()['companyName']
                              .toString(),
                          jobDiscription: snapshot.data.docs[index]
                              .data()["discription"]
                              .toString(),
                          url: snapshot.data.docs[index]
                              .data()["url"]
                              .toString());
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppliedJobs()));
              }),
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
                  MaterialPageRoute(builder: (context) => EditProfile(true)));
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
      body: getJobList(),
      floatingActionButton: FloatingActionButton(child:Icon(Icons.search,size: 40,) ,onPressed: (){Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Search()));},),
    );
    
  }

  GestureDetector applyingJobCards(
      {String companyName, String jobDiscription, String url}) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(10)),
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
              TextButton(
                  onPressed: () {
                    applyForJob(
                        companyName: companyName,
                        jobDiscription: jobDiscription,
                        url: url);
                  },
                  child: Text("Apply"))
            ],
          ),
        ),
      ),
    );
  }
}
