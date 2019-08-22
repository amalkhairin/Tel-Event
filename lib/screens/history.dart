import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  History({this.uid,this.user});
  final String uid;
  final FirebaseUser user;
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  String newUid;
  
  read()async{
    final pref = await SharedPreferences.getInstance();
    String value = pref.getString('load');
    if (value != '0'){
        newUid = value;
        setState(() { });
        //print(uid+' is here');
    } else {
      // setState(() {
      //  newUid= value; 
      // });
    }
  }

  DateTime now = DateTime.now();
  DateFormat dateFormat;

  initialize() async {
    await initializeDateFormatting();
  }

  @override
  void initState() {
    super.initState();
    //read();
    initialize();
    now = DateTime.now();
    dateFormat = DateFormat.yMMMMEEEEd('id');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('History',style: TextStyle(color: Colors.red,fontSize: 25.0),),
        centerTitle: true,
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(opacity: 0.0),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
          color: Colors.grey[100],
          child: StreamBuilder(
            stream: Firestore.instance.collection('history').where('uid', isEqualTo: widget.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) return Text('Loading...');
              print('$newUid');
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  DocumentSnapshot _data = snapshot.data.documents[index];
                  final temp = _data['event'];
                  String eventName = '';
                  int string = 34;
                  if ((height < 683 || width < 411)||(height < 571 || width < 340)){
                    string  = 25;
                  }
                  if (temp.length > 14){
                    for (var i = 0; i < string; i++) {
                      eventName = eventName + temp[i];
                    }
                  }
                  eventName = eventName + '...';
                  final date = _data['date'];
                  final price = _data['price'];
                  bool isEvent = snapshot.data.documents.length != 0 ? true : false;
                  print('$isEvent');
                  return isEvent ?
                    Container(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 10.0,bottom: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(eventName, style: TextStyle(fontSize: 20.0),),
                                  
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0,bottom: 5.0),
                              child: Text(price, style: TextStyle(fontSize: 20.0, color: Colors.green)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(date),
                                  Text('booking time'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ), 
                    ) : Text('no ticket');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}