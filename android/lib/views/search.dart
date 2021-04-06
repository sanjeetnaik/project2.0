import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';
import 'PDFscreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch(String val) async {
    if (val.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(val).then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            padding: EdgeInsets.all(9),
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchResultSnapshot.docs[index].data()["userType"] ==
                      "Employee"
                  ? employeeProfile(
                      name: searchResultSnapshot.docs[index].data()["userName"],
                      email:
                          searchResultSnapshot.docs[index].data()["userEmail"],
                      collegeName: searchResultSnapshot.docs[index]
                          .data()["collegeName"],
                      branch: searchResultSnapshot.docs[index].data()["Branch"],
                      year: searchResultSnapshot.docs[index].data()["year"],
                      url: searchResultSnapshot.docs[index].data()["url"],
                      context: context)
                  : employeerProfile(
                      companyName: searchResultSnapshot.docs[index]
                          .data()["companyName"],
                      userName:
                          searchResultSnapshot.docs[index].data()["userName"],
                      url: searchResultSnapshot.docs[index].data()["url"],
                      context: context);
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
        automaticallyImplyLeading: false,
        title: TextField(
          cursorColor: Colors.white,
          onChanged: (value) {
            initiateSearch(value);
          },
          controller: searchEditingController,
          style: TextStyle(color: Colors.white, fontSize: 20),
          decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none),
        ),
        backgroundColor: Color(0xFF33A7AF),
        elevation: 0.0,
      ),
      body: (isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Container(
                child: userList(),
              ),
            )),
    );
  }
}

Container employeerProfile(
    {String companyName, String userName, String url, context}) {
  return Container(
    color: Colors.deepPurple[50],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Text(
            "Employeer",
            textScaleFactor: 1.5,
          )),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Company Name: "), Text(companyName)]),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("User Name: "), Text(userName)]),
          TextButton(
            child: Text("View Brochure"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFscreen(url)),
              );
            },
          )
        ],
      ),
    ),
  );
}

Container employeeProfile(
    {String name,
    String email,
    String collegeName,
    String branch,
    String year,
    String url,
    context}) {
  return Container(
    color: Colors.deepPurple[50],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Text(
            "Employee",
            textScaleFactor: 1.5,
          )),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Name: "), Text(name)]),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Email: "), Text(email)]),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("College: "), Text(collegeName)]),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Branch: "), Text(branch)]),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Year: "), Text(year)]),
          TextButton(
            child: Text("View resume"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFscreen(url)),
              );
            },
          )
        ],
      ),
    ),
  );
}
