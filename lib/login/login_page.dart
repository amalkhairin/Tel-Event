import 'package:flutter/material.dart';
import '../app.dart';
import '../login/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';  //tag page

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validation {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  signOut(){
    _googleSignIn.signOut();
    _auth.signOut();
  }

  final formKey = GlobalKey<FormState>();   //create validation key

  String email = '';
  String password = '';
  
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    final logo = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('TEL-', style: TextStyle(color: Colors.red, fontSize: 40.0),),
          Text('EVENT',style: TextStyle(color: Colors.black54, fontSize: 40.0)),
        ],
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: validateEmail,
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.email, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: validatePass,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(Icons.lock, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        splashColor: Colors.grey,
        color: Colors.red,
        child: Text("Log in", style: TextStyle(color: Colors.white,),),
        onPressed: (){
          if (formKey.currentState.validate()){
            formKey.currentState.save();
            Navigator.of(context).pushNamed(MainApp.tag);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final googleSignIn = InkWell(
      onTap: _handleSignIn,
      child: Image.asset('img/google-sign.png',width: 150.0,),
    );

    final googleSignOut = InkWell(
      onTap: signOut(),
      child: Image.asset('img/google-sign.png',width: 150.0,),
    );

    final forgetPass = FlatButton(
      child: Text("Forgotten password ?", style: TextStyle(color: Colors.black54)),
      onPressed: null,
    );

    final register = FlatButton(
      child: Text("dont have an account? sign up here", style: TextStyle(color: Colors.black54),),
      onPressed: null,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 50.0),
                child: logo,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0,right: 30.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height/100,),
                    Text("LOGIN", textAlign: TextAlign.center,style: TextStyle(color: Colors.red, fontSize: 20.0),),
                    SizedBox(height: height/50.0,),
                    email,
                    SizedBox(height: height/50.0,),
                    password,
                    forgetPass,
                    loginButton,
                    Text('or'),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: googleSignIn,
                    ),
                    googleSignOut,
                    //register,
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