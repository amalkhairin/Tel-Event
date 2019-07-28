import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tel_event/login/login_page.dart';

class Dialogs {
  verificationAlert(BuildContext context, String email, bool back){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Email Verification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We have send verification link to $email. Please check your email'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                back = true;
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()
                ));
              },
              child: Text('Ok'),
            ),
          ],
        );
      }
    );
  }

  //alert
  emailAlert(BuildContext context, String email, FirebaseUser user){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Email Verification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please verify your email address first'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      }
    );
  }
}