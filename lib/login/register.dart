import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String id = '';
  String _email = '';
  String _password = '';
  String _username = '';
  bool valid = false;
  bool resend = false;
  bool back = false;
  bool _isLoading = false;
  bool _isSecure = true;
  bool _secure2 = true;
  int idx = 1;
  
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
        DocumentReference ref = await Firestore.instance.collection('user').add({'username': _username, 'uid': newUser.uid, 'email':_email});
        
        //send verification link to email
        await newUser.sendEmailVerification();
        Dialogs().verificationAlert(context,_email,back);
      } catch (e) {
        setState(() {
         _isLoading = false; 
        });
        Dialogs().errorEmailA(context, _email);
      }
    }
  }

  void _togglePassVisibility(){
    setState(() {
     _isSecure = !_isSecure; 
    });
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

    final username = TextFormField(
      textCapitalization: TextCapitalization.none,
      validator: Validation().validateUsername,
      onSaved: (value) => _username = value,
      decoration: InputDecoration(
        hintText: 'Username',
        prefixIcon: Icon(Icons.person, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
      
      obscureText: _isSecure,
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
        suffixIcon: GestureDetector(
          onTap: (){
            _togglePassVisibility();
          },
          child: Icon(
            _isSecure ? Icons.visibility_off : Icons.visibility,
            color: _isSecure ? Colors.grey: Colors.red,
          ),
        ),
      ),
    );

    final reEnterPassword = TextFormField(
      obscureText: _secure2,
      validator: (value) => value != _password ? "password doesn\'t match" : null,
      decoration: InputDecoration(
        hintText: 'Re-enter password',
        prefixIcon: Icon(Icons.lock, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        suffixIcon: GestureDetector(
          onTap: (){
            _togglePassVisibility();
          },
          child: Icon(
            _isSecure ? Icons.visibility_off : Icons.visibility,
            color: _isSecure ? Colors.grey: Colors.red,
          ),
        ),
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
          setState(() {
           if (validateAndSave()){
             _isLoading = true;
           } 
          });
          validateAndSubmit();
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
    print('$_username'+' 0000');
    print('$_email'+' aaa');
    print('$_password'+' bbbb');
    
    Widget loadingIndicator = _isLoading ? new Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(5.0),
        child: new Center(
          child: new CircularProgressIndicator(
            //backgroundColor: Colors.white,
          )
        )
      ),
    ) : new Container();

    //main code
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
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
                        username,
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
          new Align(child: loadingIndicator,alignment: FractionalOffset.center,)
        ],
      ),
    );
  }
}