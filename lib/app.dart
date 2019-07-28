import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tel_event/screens/event.dart';
import 'package:tel_event/screens/home.dart';
import 'package:tel_event/screens/profile.dart';

class MainApp extends StatefulWidget {
  MainApp({this.user, this.googleSignIn});
  //init firebase
  final FirebaseUser user;
  final FirebaseAuth googleSignIn;

  //tag page
  static String tag = "main-app";

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {

  //navigation tab controller
  TabController controller;

  //init tab
  @override
  void initState(){
    super.initState();
    controller = TabController(vsync: this,length: 3);
  }

  //main code
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //disable debug banner
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: Scaffold(
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            Home(),
            Event(),
            Profile(user: widget.user,),
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: controller,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: 'Home',
            ),
            Tab(
              icon: Icon(Icons.event_available),
              text: 'Event',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: 'Profile',
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}