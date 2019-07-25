import 'package:flutter/material.dart';
import 'package:tel_event/screens/event.dart';
import 'package:tel_event/screens/home.dart';
import 'package:tel_event/screens/profile.dart';

class MainApp extends StatefulWidget {
  static String tag = 'main-app';
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState(){
    super.initState();
    controller = TabController(vsync: this,length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: Scaffold(
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            Home(),
            Event(),
            Profile(),
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