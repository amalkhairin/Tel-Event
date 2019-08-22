import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:tel_event/login/login_page.dart';

class Dialogs {
  verificationAlert(BuildContext context, String email, bool back,){
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

  //email already taken
  errorEmailA(BuildContext context, String email){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(email+" has already taken. try another email or login to continue"),
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

  //user not found
  errorEmailB(BuildContext context, String error){
    String message = '';
    if (error.contains('ERROR_USER_NOT_FOUND')){
      message = 'Error user not found. Please register first';
    }
    if (error.contains('ERROR_WRONG_PASSWORD')){
      message = 'Wrong password. please check your password';
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ok'),
            ),
          ],
        );
      }
    );
  }

  resetPassAlert(BuildContext context, String email,){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Password Reset'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We have send password reset link to $email. Please check your email'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
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

  soldOutAlert(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Sold Out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Seat has reached the limit'),
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

  bookingConfirmation(BuildContext context,){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Sold Out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Seat has reached the limit'),
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

  bookingAlert(BuildContext context, String path, String name){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Ticket'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ticket file is saved in directory: $path'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: (){
                OpenFile.open('$path/$name-televent_ticket.pdf');
                Navigator.pop(context);
              },
              child: Text('Open file'),
            ),
          ],
        );
      }
    );
  }  
}