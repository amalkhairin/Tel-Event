import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tel_event/screens/eventDetail.dart';
import 'package:tel_event/function.dart';


class Event extends StatelessWidget {
  Event({this.user});
  final FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventPage(user: this.user,),
    );
  }
}

class EventPage extends StatefulWidget {
  EventPage({this.user});
  final FirebaseUser user;
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {

  final db = Firestore.instance;

  String filter;


  @override
  Widget build(BuildContext context) {

    //search widget
    final search = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      
      child: TextField(
        onChanged: (value){
          if (value == ''){
            setState(() {
             filter = null; 
            });
          } else {
            setState(() {
             filter = value; 
            });
          }
        },
        decoration: InputDecoration(
          hintText: 'Search Event',
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
        ),
      )
    );

    return Container(
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.0,right: 10.0,left: 10.0),
            child: search,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
              child: EventList(uid: widget.user.uid, filter: filter,)
            ),
          )
        ],
      ),
    );
  }
}


class EventList extends StatelessWidget {
  EventList({this.uid, this.filter});
  final String uid;
  final String filter;

  @override
  Widget build(BuildContext context) {

    //init var
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double resizeHeight = 100.0;
    double resizeWidth = 100.0;
    double nameFontSize = 20.0;
    double orgFontSize = 10.0;
    double dateFontSize = 20.0;
    double priceFontSize = 20.0;
    double paddingLeft = 20.0;
    if ((height < 683 || width < 411)||(height < 571 || width < 340)){
      resizeHeight = 85.0;
      resizeWidth = 85.0;
      nameFontSize = 16.0;
      orgFontSize = 10.0;
      dateFontSize = 25.0;
      priceFontSize = 15.0;
      paddingLeft = 10.0;
    }
    //

    //debug
    print('height : $height');
    print('with : $width');
    //
    
    //main
    return StreamBuilder(
      stream: Firestore.instance.collection('temp(otomatis)').where('name', arrayContains: filter).orderBy('date',descending: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData) return Text('connecting...');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index){

            //init local var
            final DocumentSnapshot _data = snapshot.data.documents[index];

            final date = _data['date'];
            final String eventName = _data['name'];
            String name = '';
            if (eventName.length > 14){
              for (var i = 0; i < 13; i++) {
                name = name + eventName[i];
              }
            }
            name = name + '...';
            final price = _data['price'];
            final location = _data['location'];
            final organizer = _data['organizer'];
            final tak = _data['tak'];
            final access = _data['access'];
            final type = _data['type'];
            bool isEventAvailable = snapshot.data.documents.length != 0 ? true : false;
            //

            //make builder of list widget
            return isEventAvailable ? Padding(
              padding: const EdgeInsets.only(left: 2.0,right: 2.0,top: 8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1.0,
                color: Colors.white,
                onPressed: (){  
                  //move to other page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return DetailPage(
                          doc: _data,
                          uid: uid,
                        );
                      }
                    )
                  );
                  //
                },

                //make row view
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //first row-left
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.red, Colors.red[300]])
                      ),
                      height: resizeHeight,
                      width: resizeWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(date,textAlign: TextAlign.center, style: TextStyle(fontSize: dateFontSize,color: Colors.white),),
                        ],
                      ),
                    ),
                    //

                    //second row
                    Padding(
                      padding: EdgeInsets.only(left: paddingLeft),
                      //make column for vertical orientation of widget
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(name, style: TextStyle(color: Colors.black, fontSize: nameFontSize, fontWeight: FontWeight.w500),),
                          Text('by '+ organizer, style: TextStyle(color: Colors.grey[600], fontSize: orgFontSize)),
                          SizedBox(height:5.0,),
                          Row(
                            children: <Widget>[
                              GetFunction().category(context,access),
                              GetFunction().eventType(context, type),
                              Text('TAK: $tak'),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(price, style: TextStyle(color: Colors.green, fontSize: priceFontSize, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 50.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(price, style: TextStyle(color: Colors.green, fontSize: priceFontSize, fontWeight: FontWeight.w600)),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ) : Text('no event', textAlign: TextAlign.center,);
          },
        );
      },
    );
  }
}