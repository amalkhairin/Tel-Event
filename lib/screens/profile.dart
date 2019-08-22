import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tel_event/login/login_page.dart';
import 'package:tel_event/screens/history.dart';

class Profile extends StatelessWidget {
  Profile({this.user});
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfilePage(user: this.user,),
    );
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user});
  final FirebaseUser user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String username;

  bool logOut = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final signOut = FlatButton(
      color: Colors.red,
      onPressed: (){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Confirmation'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure want to log out?')
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                FlatButton(
                  onPressed: (){
                    setState(() {
                      logOut = true;
                    _auth.signOut(); 
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()
                      )
                    );
                  },
                  child: Text('Logout'),
                )
              ],
            );
          }
        );
        // setState(() {
        //   logOut = true;
        //  _auth.signOut(); 
        // });
        // _save('0');
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => LoginPage()
        //   )
        // );
      },
      child: Text('LOG OUT', style: TextStyle(color: Colors.white),),
    );

    final history = FlatButton(
      color: Colors.red,
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => History(uid: widget.user.uid,user: widget.user,)
          )
        );
      },
      child: Text('Riwayat Pemesanan', style: TextStyle(color: Colors.white),),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('PROFILE', style: TextStyle(color: Colors.red, fontSize: 25.0),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.grey[100],
            child: ListView(
              shrinkWrap: true,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: GetData(user: widget.user,currentUid: widget.user.uid,child1: history,),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0,bottom: 40.0),
            child: Align(
              child: signOut,
              alignment: FractionalOffset.bottomRight,
            ),
          )
        ],
      ),
    );
  }
}
class GetData extends StatelessWidget {
  GetData({this.user, this.child1, this.currentUid});
  final Widget child1;
  final String currentUid;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    

    return StreamBuilder(
      stream: Firestore.instance.collection('user').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) return Text('loading');
        final int docLength = snapshot.data.documents.length;
        //print('$docLength');
        String username = '';
        String email = '';
        if (user != null){
          for (var i = 0; i < docLength; i++) {
            final DocumentSnapshot _data = snapshot.data.documents[i];
            if (user.uid == _data['uid']){
              username = _data['username'];
              email = _data['email'];
            } else {
              i++;
            }
          }
         } else if (currentUid != null) {
          for (var i = 0; i < docLength; i++) {
            final DocumentSnapshot _data = snapshot.data.documents[i];
            if (currentUid == _data['uid']){
              username = _data['username'];
              email = _data['email'];
            } else {
              i++;
            }
          }
        }
        print('aaa');
        return Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20.0,right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Name  : '+ username, textAlign: TextAlign.left, style: TextStyle(fontSize: 16.0),),
                  Text('Email   : '+ email, textAlign: TextAlign.left, style: TextStyle(fontSize: 16.0),),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                    child: child1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}