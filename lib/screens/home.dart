import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final newEvent = Card(
      color: Colors.grey,
      child: Image.asset('assets/img/1.jpg',width: screenWidth/4,height: screenHeight/7,),
    );

    Widget imageCarousel = new Container(
      height: screenHeight/3,
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          Carousel(
            boxFit: BoxFit.cover,
            images: [
              //change image assets in assets/img folder and rewrite path in pubspec.yaml
              AssetImage('assets/img/1.jpg'),
              AssetImage('assets/img/2.png'),
              AssetImage('assets/img/3.jpg'),
              AssetImage('assets/img/4.png'),
            ],
            autoplay: true,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 500),
            dotSize: 4.0,
            dotColor: Colors.white70,
          ),
          Center(
            child: Text('PREMIUM EVENT', style: TextStyle(color: Colors.white, fontSize: 30.0,backgroundColor: Colors.black26),)
          )
        ]
      ),
    );

    final registerEvent = FlatButton(
      onPressed: (){},
      child: Text('Click for more information'),
    );

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('TEL-', style: TextStyle(color: Colors.red, fontSize: 45.0),),
              Text('EVENT', style: TextStyle(color: Colors.black54, fontSize: 45.0),),
            ],
          ),
          SizedBox(height: screenHeight/50,),
          imageCarousel,
          SizedBox(height: screenHeight/50,),
          Text('NEW EVENTS'),
          SizedBox(height: screenHeight/50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              newEvent,
              newEvent,
              newEvent,
            ],
          ),
          SizedBox(height: screenHeight/50,),
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text('Ingin mendaftarkan event anda?'),
          ),
          registerEvent
        ],
      ),
    );
  }
}