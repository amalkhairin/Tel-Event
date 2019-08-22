import 'dart:io';
import 'dart:math';
import 'package:random_string/random_string.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tel_event/function.dart';

class Tester {
  getPath()async{
    final path = await _localPath;
    return path;
  }

  String _randomString(int length) {
      var rand = new Random();
      var codeUnits = new List.generate(
          length, 
          (index){
            return rand.nextInt(33)+89;
          }
      );
      
      return new String.fromCharCodes(codeUnits);
    }

    String token = '';

    String generateToken(){
      token = randomAlpha(6);
    }

    String getToken(String token){
      return token;
    }

  void generate(DocumentSnapshot data, String name, String email) async {
    
    final Document pdf = Document();

    String date = data.data['date'];
    String time = data.data['time'];

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget> [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('E-ticket', style: TextStyle(fontSize: 30.0),),
            Text('TEL-EVENT', style: TextStyle(fontSize: 25.0, color: PDFColor.fromInt(10)),),
          ]
        ),
        SizedBox(height: 40.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data.data['name'], style: TextStyle(fontSize: 20.0)),
            Text('by ${data.data['organizer']}'),
            Paragraph(text: ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(date),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(time),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(data.data['location']),
                  ],
                ),
              ],
            ),
          ]
        ),
        Header(text: ''),
        SizedBox(height: 20.0),
        Text('Tujukkan E-ticket ini pada saat ingin masuk ke event'),
        Text('Datang 1 jam sebelum event dimulai'),
        SizedBox(height: 20.0),
        Header(text: ''),
        Container(
          color: PDFColor.grey,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Name'),
                Padding(
                  padding: EdgeInsets.only(right: 50.0),
                  child: Text('Email'),
                ),
              ],
            ),
          ),
        ),
        Paragraph(text: ''),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(name),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(email),
            ),
          ],
        ),
        Paragraph(text: ''),
        SizedBox(height: 70.0),
        Center(
          child: Column(
            children: <Widget>[
              Text('your ticket id:'),
              Text(randomAlpha(6), style: TextStyle(fontSize: 30.0))
            ]
          ),
        ),
        SizedBox(height: 100.0),
        Paragraph(text: ''),
        Header(text: ''),
        Text('CUSTOMER SERVICES', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('services.televent@gmail.com'),
        Paragraph(text: ''),
        Text('PERHATIAN: tiket ini tidak untuk di print'),
      ]));
    
    //final output = await getTemporaryDirectory();
    final path = await _localPath;
    final local = '/storage/emulated/0/Download';
    
    print('$local');
    try {
      final File file = File('$local/$name-televent_ticket.pdf');
      await file.writeAsBytesSync(pdf.save());
      Fluttertoast.showToast(
        msg: "$local/$name-televent_ticket.pdf",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print(e);
    }
    
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}
