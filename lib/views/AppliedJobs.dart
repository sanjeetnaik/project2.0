import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import '../services/database.dart';
import '../widget/widget.dart';
import 'package:flutter/material.dart';

class AppliedJobs extends StatefulWidget {
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  Stream stream;

  @override
  void initState() {
    
    getAppliedJobs();
    super.initState();
  }

  getAppliedJobs() async {
    Constants.email = await HelperFunctions.getUserEmailSharedPreference();
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getAppliedJobs(Constants.email).then((snapshot) {
      setState(() {
        stream = snapshot;
      });
    });
  }

  Widget getAppliedJobList()
  {
     return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return appliedJobCards(
                    companyName: snapshot
                        .data.docs[index].data()['companyName']
                        .toString(),
                    jobDiscription: snapshot
                        .data.docs[index].data()["discription"]
                        .toString(),
                    url: snapshot.data.docs[index].data()['url'],
                    myName: Constants.myName,
                    email:Constants.email,
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
      appBar: AppBar(title: Text("Applied Jobs"),),
      body: SafeArea(child: getAppliedJobList(),),
    );
  }
}
