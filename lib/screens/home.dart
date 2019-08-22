import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tel_event/screens/eventDetail.dart';
import 'package:tel_event/function.dart';

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
  
  double _elevation = 0.0;

  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    Widget imageCarousel = new Container(
      height: screenHeight/3,
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          Carousel(
            borderRadius: true,
            radius: Radius.circular(20.0),
            boxFit: BoxFit.cover,
            images: [
              //change image assets in assets/img folder and rewrite path in pubspec.yaml
              // AssetImage('assets/img/1.jpg'),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey),child: Text('This Feature is Not Available Now', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0),),),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey),child: Text('This Feature is Not Available Now', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0),),),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey),child: Text('This Feature is Not Available Now', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0),),),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey),child: Text('This Feature is Not Available Now', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0),),),
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

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double fontSize = 45.0;
    double paddingTop = 60.0;
    
    if ((height < 683 || width < 411)&&(height < 571 || width < 340)){
      fontSize = 35.0;
      paddingTop = 30.0;
    }

    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: paddingTop),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('TEL-', style: TextStyle(color: Colors.red, fontSize: fontSize),),
                Text('EVENT', style: TextStyle(color: Colors.black54, fontSize: fontSize),),
              ],
            ),
          ),
          SizedBox(height: screenHeight/50,),
          imageCarousel,
          SizedBox(height: screenHeight/50,),
          Text('NEW EVENTS'),
          SizedBox(height: screenHeight/50,),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance.collection('temp(otomatis)').limit(3).orderBy("date", descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (!snapshot.hasData) return Text('connecting...');
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index){

                    final DocumentSnapshot _data = snapshot.data.documents[index];
                    final date = _data['date'];
                    print('ini home');
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 10.0),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _elevation = 5.0; 
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context){
                                return DetailPage(
                                  doc: _data,
                                );
                              }
                            )
                          );
                        },
                        child: Card(
                          elevation: _elevation,
                          color: Colors.red,
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Center(child: Text(date,textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0,color: Colors.white),)),
                          )
                        )
                      )
                    );
                  }
                );
              },
            )
          ),
          SizedBox(height: screenHeight/50,),
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text("Ingin mendaftarkan event anda?"),
          ),
          registerEvent
        ],
      ),
    );
  }
}