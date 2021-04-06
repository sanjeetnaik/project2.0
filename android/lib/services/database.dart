import 'package:firebase_storage/firebase_storage.dart';

import '../helper/helperfunctions.dart';
import '../views/AddJobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  addUserInfo(userData, path, file) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(path).putFile(file);
    String location = await (await uploadTask).ref.getDownloadURL();

    userData["url"] = location;
    HelperFunctions.saveURLSharedPreference(location);

    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateUserInfo(email, String path, file, {year, companyName}) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(path).putFile(file);
    String location = await (await uploadTask).ref.getDownloadURL();
    HelperFunctions.saveURLSharedPreference(location);

    FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((element) {
                element.reference.update({"url": location});
                if (year != null) {
                  element.reference.update({"year": year});
                  FirebaseFirestore.instance
                      .collection("jobs")
                      .where("companyName", isEqualTo: companyName)
                      .get()
                      .then((value) => value.docs.forEach((element) {
                            element.reference.update({"url": location});
                          }));
                }
              })
            });
  }

  Future<void> addjob(job) async {
    return FirebaseFirestore.instance
        .collection("jobs")
        .add(job)
        .catchError((e) {
      print(e.toString());
    });
  }

  getAppliedJobs(String email) async {
    return FirebaseFirestore.instance
        .collection("jobs")
        .where("applied", arrayContains: email)
        .snapshots();
  }

  applyForJob({companyname, discription, userEmail, userName}) {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": userName,
      "message": "hi, I would like to apply for this Job",
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    List userEmail1 = [userEmail];
    FirebaseFirestore.instance
        .collection("jobs")
        .where("companyName", isEqualTo: companyname)
        .where("discription", isEqualTo: discription)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              var inst = FirebaseFirestore.instance
                  .collection("jobs")
                  .doc(f.reference.id);

              inst.update({"applied": FieldValue.arrayUnion(userEmail1)});
              inst.collection(userEmail).add(chatMessageMap);
            }),
          },
        );
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  getChats(String companyname, discription, applicantEmail) async {
    var fi = FirebaseFirestore.instance.collection("jobs");
    var id;

    await fi
        .where("companyName", isEqualTo: companyname)
        .where("discription", isEqualTo: discription)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              id = f.reference.id;
            }),
          },
        );

    return fi.doc(id).collection(applicantEmail).orderBy('time').snapshots();
  }

  getAddedJobs(String companyName) async {
    return FirebaseFirestore.instance
        .collection("jobs")
        .where('companyName', isEqualTo: companyName)
        .snapshots();
  }

  getJobs() async {
    return FirebaseFirestore.instance.collection("jobs").snapshots();
  }

  addMessage(String companyname, discription, chatMessageData, applicantEmail) {
    FirebaseFirestore.instance
        .collection("jobs")
        .where("companyName", isEqualTo: companyname)
        .where("discription", isEqualTo: discription)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              FirebaseFirestore.instance
                  .collection("jobs")
                  .doc(f.reference.id)
                  .collection(applicantEmail)
                  .add(chatMessageData)
                  .catchError((e) {
                print(e.toString());
              });
            }),
          },
        );
  }

  getAppliedUsers(String companyName, String discription) async {
    List users;
    await FirebaseFirestore.instance
        .collection("jobs")
        .where("companyName", isEqualTo: companyName)
        .where("discription", isEqualTo: discription)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              users = List.from(f.data()["applied"]);
            }),
          },
        );
    if (users.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", whereIn: users)
          .snapshots();
    }
  }

  deleteJob({String companyName, String discription}) async {
    List users;
    FirebaseFirestore.instance
        .collection("jobs")
        .where("companyName", isEqualTo: companyName)
        .where("discription", isEqualTo: discription)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              users = List.from(f.data()["applied"]);
              f.reference.delete();
              for (var item in users) {
                f.reference.collection(item).get().then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });
              }
            }),
          },
        );
  }
}
