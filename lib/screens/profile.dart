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
    final googleSignOut = InkWell(
      onTap: (){
        signOut();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage()
          )
        );
      },
      child: Image.asset('img/google-sign.png',width: 150.0,),
      
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(this.user.email),
            googleSignOut,
          ],
        )
      ),
    );
  }
}