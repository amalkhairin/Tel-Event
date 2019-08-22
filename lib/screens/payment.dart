import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tel_event/dialogs.dart';
import 'package:tel_event/function.dart';
import 'package:tel_event/login/validation.dart';
import 'package:tel_event/screens/tester.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({this.data, this.uid});
  final DocumentSnapshot data;
  final String uid;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  
  String _email='';
  String userEmail = '';
  String _name ='';
  String _phone = '';
  int _nominal=0;
  String docId ='';
  String id ='';
  String loadedUid ='';
  bool _isLoading = false;

  final newPath = '/storage/emulated/0/Download';
  
  final formKey = GlobalKey<FormState>();

  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }


  updateData(DocumentSnapshot data, int sum) async {
    await Firestore.instance.collection('temp(otomatis)').document(widget.data.documentID).updateData({'quota' : sum});
  }

  createHistory(String name, String event, String price, String path, String email, String phone, String uid, String date) async {
    DocumentReference ref = await Firestore.instance.collection('history').add({'name': name, 'event':event, 'price':price, 'path':'$path/$name-televent_ticket.pdf', 'email':email, 'phone':phone, 'uid':uid ,'date':date});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int seat = widget.data.data['quota'];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color color = Colors.grey[600];

    final date = widget.data['date'];

    // Widget generateQr = QrImage(
    //   size: height/3.5,
    //   data: _name+widget.data.documentID,
    //   gapless: false,
    //   version: 3,
    //   foregroundColor: Colors.red,
    //   onError: (dynamic ex) {
    //     print('[QR] ERROR - $ex');
    //   },
    // );

    final name = TextFormField(
      autofocus: false,
      onSaved: (value) => _name = value,
      validator: (value) => value == '' ? 'name can\'t be empty':null,
      decoration: InputDecoration(
        hintText: "Name",
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final email = TextFormField(
      autofocus: false,
      onSaved: (value) => _email = value,
      validator: Validation().validateEmail,
      decoration: InputDecoration(
        hintText: "Email address",
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final phone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      onSaved: (value) => _phone = value,
      validator: (value) => value == '' ? 'phone number can\'t be empty' : null,
      decoration: InputDecoration(
        hintText: "Phone number",
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    Widget payMethod = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(0.0),
          child: InkWell(
            onTap: (){
               Fluttertoast.showToast(
                 msg: "This feature is disable",
                 toastLength: Toast.LENGTH_SHORT,
                 gravity: ToastGravity.BOTTOM,

               );
            },
            child: Card(
              color: color,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('ATM 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: InkWell(
            onTap: (){
              Fluttertoast.showToast(
                 msg: "This feature is disable",
                 toastLength: Toast.LENGTH_SHORT,
                 gravity: ToastGravity.BOTTOM,

               );
            },
            child: Card(
              color: color,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('ATM 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: InkWell(
            onTap: (){
              Fluttertoast.showToast(
                 msg: "This feature is disable",
                 toastLength: Toast.LENGTH_SHORT,
                 gravity: ToastGravity.BOTTOM,

               );
            },
            child: Card(
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('ATM 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
              ),
            ),
          ),
        )
      ],
    );

    final confirmButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: RaisedButton(
        elevation: 5.0,
        splashColor: Colors.grey,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0,right: 20.0),
          child: Text("Confirm", style: TextStyle(color: Colors.white),),
        ),
        onPressed: () async {
         formKey.currentState.save();
          if(validateAndSave()) {
            setState(() {
              _isLoading = true;
              seat--;
            });
            Tester().generate(widget.data, _name, _email);
            updateData(widget.data, seat);
            createHistory(_name, widget.data.data['name'], widget.data.data['price'], newPath, _email, _phone,widget.uid, date);
            Dialogs().bookingAlert(context, newPath, _name);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    Widget loadingIndicator = _isLoading ? new Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(5.0),
        child: new Center(
          child: new CircularProgressIndicator(
            //backgroundColor: Colors.white,
          )
        )
      ),
    ) : new Container();

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          Container(
          color: Colors.grey[100],
            child: Center(
              child: Form(
                key: formKey,
                autovalidate: true,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0,bottom: 40.0),
                      child: Text('Payment Detail',textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w400),)
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 10.0,right: 10.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0, left: 30.0,right: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: height*1/100,),
                              Text(widget.data.data['name'], style: TextStyle(fontSize: 20.0),),
                              SizedBox(height: height*2/100,),
                              Text(widget.data.data['price'], style: TextStyle(fontSize: 30.0,color: Colors.green),),
                              SizedBox(height: height*5/100,),
                              name,
                              SizedBox(height: height*2/100,),
                              email,
                              SizedBox(height: height*2/100,),
                              phone,
                              SizedBox(height: height*2/100,),
                              Padding(padding: EdgeInsets.only(bottom: 10.0),child: Text('Payment Method'),),
                              payMethod,
                              SizedBox(height: height*1/100,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  confirmButton,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(child: loadingIndicator, alignment: FractionalOffset.center,),
        ],
      ),
    );
  }
}