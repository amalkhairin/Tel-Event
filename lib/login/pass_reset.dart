import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tel_event/dialogs.dart';
import '../login/validation.dart';

class PassReset extends StatefulWidget {
  @override
  _PassResetState createState() => _PassResetState();
}

class _PassResetState extends State<PassReset> {

  final _key = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = false;

  bool validate(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      return true;
    }else {
      return false;
    }
  }

  void sendResetPass() async {
    if (validate()){
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        Dialogs().resetPassAlert(context, _email);
      } catch (e) {
        setState(() {
         _isLoading = false; 
        });
        final String error = e.toString();
        Dialogs().errorEmailB(context,error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final height = MediaQuery.of(context).size.height;

    final inputEmail = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 10.0,
      child: TextFormField(
        enableInteractiveSelection: false,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        onSaved: (value) => _email = value,
        validator: Validation().validateEmail,
        decoration: InputDecoration(
          hintText: "Type Your Email",
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))
        )
        ,
      )
    );

    final submit = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () async {
          _key.currentState.save();
          if (validate()){
            setState(() {
             _isLoading = true; 
            });
          }
          sendResetPass();
        },
        elevation: 0.0,
        splashColor: Colors.white,
        color: Colors.orange[300],
        child: Text('Send', style: TextStyle(color: Colors.white,),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('FORGOT PASSWORD', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
      ),
      body: Container(
        height: height,
        color: Colors.red[700],
        child: Stack(
          children: <Widget>[
            Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: height/8.0,),
                    Text('Forgot Your Password?', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                    SizedBox(height: height/12.0,),
                    Text('We will send password reset link to your email', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15.0),),
                    SizedBox(height: height/20.0,),
                    inputEmail,
                    SizedBox(height: height/6.0,),
                    Padding(
                      padding: EdgeInsets.only(left: 200.0, right: 10.0),
                      child: submit,
                    )
                  ],
                ),
              ),
            ),
            new Align(child: loadingIndicator,alignment: FractionalOffset.center,)
          ],
        ),
      )
    );
  }
}