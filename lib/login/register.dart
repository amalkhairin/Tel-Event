import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tel_event/login/login_page.dart';
import '../dialogs.dart';
import 'validation.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //init form key
  final formKey = GlobalKey<FormState>();

  //validate form
  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }
  
  String _email = '';
  String _password = '';
  bool valid = false;
  bool resend = false;
  bool back = false;
  
  //account verified checked
  bool verified(FirebaseUser user){
    if (user.isEmailVerified){
      valid = true;
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()){
      try {
        FirebaseUser newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        //send verification link to email
        await newUser.sendEmailVerification();
        Dialogs().verificationAlert(context,_email,back);
      } catch (e) {
        print('$e');
      }
    }
  }

  //validate email
  String _validateEmail(String value){
    if (value.isNotEmpty){
      //RegEx pattern email verification
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(value)){
        return null;
      }
      return 'email isn\'t valid';
    } else {
      return 'email can\'t be empty';
    }
  }

  //main code
  @override
  Widget build(BuildContext context) {

    //get device size
    double height = MediaQuery.of(context).size.height;

    final label = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Register New Account', style: TextStyle(color: Colors.red, fontSize: 20.0),),
        ],
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => _email = value,
      validator: Validation().validateEmail,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(Icons.email, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      
      obscureText: true,
      validator: (value) {
        if (value.isEmpty){
          return 'password can\'t be empty';
        } else {
          if (value.length < 6){
            return 'password should be at least 6 characters';
          }
        }
        formKey.currentState.save();
        _password = value;
        return null;
      },
      onSaved: (value) => _password = value,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(Icons.lock, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final reEnterPassword = TextFormField(
      obscureText: true,
      validator: (value) => value != _password ? "password doesn\'t match" : null,
      decoration: InputDecoration(
        hintText: 'Re-enter password',
        prefixIcon: Icon(Icons.lock, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );
     
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        splashColor: Colors.grey,
        color: Colors.red,
        child: Text("Register", style: TextStyle(color: Colors.white,),),
        onPressed: () async {
          formKey.currentState.save();
          validateAndSubmit();
          //Dialogs().verificationAlert(context,_email,back);
          print('$_email');
          print(valid);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final signIn = FlatButton(
      child: Text("already have an account? sign in here", style: TextStyle(color: Colors.black54),),
      onPressed: (){
        //move to login page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage()
          )
        );
      },
    );

    //debug test
    print('$_email'+'aaa');
    print('$_password'+'bbbb');

    //main code
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          autovalidate: true,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 50.0),
                child: label,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0,right: 30.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height/50.0,),
                    email,
                    SizedBox(height: height/50.0,),
                    password,
                    SizedBox(height: height/50.0,),
                    reEnterPassword,
                    registerButton,
                    signIn,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}