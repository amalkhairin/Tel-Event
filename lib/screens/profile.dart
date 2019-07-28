import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tel_event/login/login_page.dart';

class Profile extends StatelessWidget {
  Profile({this.user});
  final FirebaseUser user;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signOut(){
    _googleSignIn.signOut();
    _auth.signOut();
    
  }

  @override
  Widget build(BuildContext context) {
    final googleSignOut = FlatButton(
      color: Colors.red,
      onPressed: (){
        signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage()
          )
        );
      },
      child: Text('LOG OUT', style: TextStyle(color: Colors.white),),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello'),
            Text(this.user.email),
            googleSignOut,
          ],
        )
      ),
    );
  }
}