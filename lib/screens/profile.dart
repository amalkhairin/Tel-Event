import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tel_event/login/login_page.dart';

class Profile extends StatelessWidget {
  Profile({this.user});
  final FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfilePage(user: user,),
    );
  }
}

// class Profile extends StatelessWidget {
//   Profile({this.user});
//   final FirebaseUser user;

//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   signOut(){
//     _googleSignIn.signOut();
//     _auth.signOut();
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     final googleSignOut = FlatButton(
//       color: Colors.red,
//       onPressed: (){
//         signOut();
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (BuildContext context) => LoginPage()
//           )
//         );
//       },
//       child: Text('LOG OUT', style: TextStyle(color: Colors.white),),
//     );

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Hello'),
//             Text(this.user.email),
//             googleSignOut,
//           ],
//         )
//       ),
//     );
//   }
// }

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user});
  final FirebaseUser user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final fontSize = 20.0;

  signOut(){
    _googleSignIn.signOut();
    _auth.signOut();
    
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

    final history = FlatButton(
      color: Colors.red,
      onPressed: (){},
      child: Text('Riwayat Pemesanan', style: TextStyle(color: Colors.white),),
    );

    return Container(
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
            child: Text('PROFILE', style: TextStyle(color: Colors.red, fontSize: 40.0),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Container(
              color: Colors.red,
              width: screenWidth,
              height: 5.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name: ', textAlign: TextAlign.left, style: TextStyle(fontSize: fontSize),),
              Text('Email : '+widget.user.email, textAlign: TextAlign.left, style: TextStyle(fontSize: fontSize),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
            child: history,
          ),
          googleSignOut,
        ],
      ),
    );
  }
}