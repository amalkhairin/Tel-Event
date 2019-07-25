import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tel_event/app.dart';
import 'package:tel_event/login/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{     //navigation routes of page
    LoginPage.tag: (context) => LoginPage(),
    MainApp.tag: (context) => MainApp(),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tel-Event",
      home: LoginPage(),
      routes: routes,
    );
  }
}