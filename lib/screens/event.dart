import 'package:flutter/material.dart';

class Event extends StatelessWidget {

  final search = TextFormField(
    decoration: InputDecoration(
      hintText: 'Search Event',
      prefixIcon: Icon(Icons.search),
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 10.0,left: 10.0),
            child: search,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: Row(
                      children: <Widget>[
                        Text('data'),
                        Text('data2'),
                        Icon(Icons.ac_unit)                      
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}