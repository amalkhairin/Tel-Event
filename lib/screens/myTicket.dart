import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTicket extends StatefulWidget {
  MyTicket({this.user});
  final FirebaseUser user;
  @override
  _MyTicketState createState() => _MyTicketState();
}

class _MyTicketState extends State<MyTicket> {

  open(String path){
    try {
      OpenFile.open(path);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "File not found",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  delete(DocumentSnapshot data)async{
    await Firestore.instance.collection('history').document(data.documentID).delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //read();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('My Ticket',style: TextStyle(color: Colors.red,fontSize: 25.0),),
        centerTitle: true,
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(opacity: 0.0),
      ),
      body: Container(
        color: Colors.grey[100],
        child: StreamBuilder(
          stream: Firestore.instance.collection('history').where('uid', isEqualTo: widget.user.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) return Text('Loading...');
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot _data = snapshot.data.documents[index];
                int string = 33;
                if ((height < 683 || width < 411)||(height < 571 || width < 340)){
                  string  = 25;
                }
                print('$string');
                final temp = _data['event'];
                String eventName = '';
                if (temp.length > 14){
                  for (var i = 0; i < string; i++) {
                    eventName = eventName + temp[i];
                  }
                }
                eventName = eventName + '...';
                final date = _data['date'];
                final price = _data['price'];
                final path = _data['path'];
                bool isEvent = snapshot.data.documents.length != 0 ? true : false;
                print('$isEvent');
                return isEvent?
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Container(
                          child: Card(
                            elevation: 5.0,
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
                                  padding: EdgeInsets.only(left: 20.0,right: 20.0),
                                  child: Text(date),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: (){
                                        delete(_data);
                                      },
                                      child: Text('delete', style: TextStyle(color: Colors.blue),),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        open(path);
                                      },
                                      child: Text('open file', style: TextStyle(color: Colors.blue),),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ), 
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Align(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45.0),
                              color: Colors.grey[100]
                            ),
                          ),
                          alignment: FractionalOffset.centerLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Align(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45.0),
                              color: Colors.grey[100]
                            ),
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                      )
                    ],
                  ),
                ) : Text('no ticket');
              },
            );
          },
        ),
      ),
    );
  }
}