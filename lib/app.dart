import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tel_event/screens/event.dart';
import 'package:tel_event/screens/home.dart';
import 'package:tel_event/screens/myTicket.dart';
import 'package:tel_event/screens/profile.dart';

class MainApp extends StatefulWidget {
  MainApp({this.user});
  //init firebase
  final FirebaseUser user;

  //tag page
  static String tag = "main-app";

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {

  //navigation tab controller
  TabController controller;

  double fontSize = 20.0;

  //init tab
  @override
  void initState(){
    super.initState();
    controller = TabController(vsync: this,length: 4);
  }

  //main code
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double sizeFont = (height < 683 || width < 411)||(height < 571 || width < 340)? 10.0 : 16.0;

    return MaterialApp(
      //disable debug banner
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: Scaffold(
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            Home(),
            Event(user: widget.user,),
            MyTicket(user: widget.user,),
            Profile(user: widget.user,),
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: controller,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: sizeFont),
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
              icon: Icon(Icons.description),
              text: 'My Ticket',
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