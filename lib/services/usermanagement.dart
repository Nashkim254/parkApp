import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmap/screens/adminpage.dart';
import 'package:gmap/screens/login.dart';
import 'package:gmap/screens/search.dart';

class Usermanagement {
  FirebaseAuth auth = FirebaseAuth.instance;
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Search();
        } else {
          return Login();
        }
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Not autherized! You are not an admin!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  authorizeAccess(BuildContext context) {
    var user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('User')
        .where('UserId', isEqualTo: user.uid)
        .get()
        .then((mydocs) {
      if (mydocs.docs[0].exists) {
        if (mydocs.docs[0].data()['UserRole'] == 'admin') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AdminPage()));
        } else {
          showAlertDialog(context);
        }
      }
    });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
