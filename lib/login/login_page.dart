import 'package:flutter/material.dart';
import 'package:tel_event/dialogs.dart';
import 'package:tel_event/login/register.dart';
import '../app.dart';
import '../login/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tel_event/app.dart';

class LoginPage extends StatefulWidget {
  //tag page
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validation {
  
  //init key
  final formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  //init loading
  bool _isLoading = false;


  //form validate
  bool validateAndSave(){
    final form =formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()){
      try {
        FirebaseUser newUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        if (newUser.isEmailVerified){
          //move to main app page (home,profile,event)
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MainApp(user: newUser,)
          ));
        } else {
          Dialogs().emailAlert(context, _email, newUser,);
        }
      } catch (e) {
        setState(() {
         _isLoading = false; 
        });
        Dialogs().errorEmailB(context);
      }
    }
  }

  //main code
  @override
  Widget build(BuildContext context) {
    //get device size
    double height = MediaQuery.of(context).size.height;

    //logo widget
    final logo = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('TEL-', style: TextStyle(color: Colors.red, fontSize: 40.0),),
          Text('EVENT',style: TextStyle(color: Colors.black54, fontSize: 40.0)),
        ],
      ),
    );

    //email form
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (value) => _email = value,
      validator: validateEmail,
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.email, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    //password form
    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      onSaved: (value) => _password = value,
      validator: validatePass,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(Icons.lock, color: Colors.red,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    //login button widget
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        splashColor: Colors.grey,
        color: Colors.red,
        child: Text("Log in", style: TextStyle(color: Colors.white,),),
        onPressed: (){
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

    final forgetPass = FlatButton(
      child: Text("Forgotten password ?", style: TextStyle(color: Colors.black54)),
      onPressed: null,
    );

    final register = FlatButton(
      child: Text("don\'t have an account? sign up here", style: TextStyle(color: Colors.black54),),
      onPressed: (){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            //move to register page
            builder: (BuildContext context) => Register()
          )
        );
      },
    );

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
                        register,
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          new Align(child: loadingIndicator,alignment: FractionalOffset.center,)
        ]
      ),
    );
  }
}