import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';


class Event extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventPage(),
    );
  }
}

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  //get data here
  final String _getEventName = 'event 1';
  final String _getEventDate = '9/9/9999';
  final String _getEventLocation = 'mars';
  final int _getTak = 1100;
  final int _getPrice = 99990;

  List<Widget> _listEvent = [];

  //add item to list
  @override
  void initState() {
    // TODO: implement initState
    _listEvent.add(_buildCell(context,_getEventName,_getEventDate,_getEventLocation,_getPrice,_getTak));
    _listEvent.add(_buildCell(context,_getEventName,_getEventDate,_getEventLocation,_getPrice,_getTak));
    _listEvent.add(_buildCell(context,_getEventName,_getEventDate,_getEventLocation,_getPrice,_getTak));
    _listEvent.add(_buildCell(context,_getEventName,_getEventDate,_getEventLocation,_getPrice,_getTak));
    _listEvent.add(_buildCell(context,_getEventName,_getEventDate,_getEventLocation,_getPrice,_getTak));
    _listEvent.add(_buildCell(context,_getEventName,_getEventDate,_getEventLocation,_getPrice,_getTak));
    super.initState();
  }


  //search widget
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
              child: ListView.builder(
                itemCount: _listEvent.length,
                itemBuilder: (BuildContext context, int index){
                  return _listEvent[index];
                },
              )
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildCell(BuildContext context,String eventName, String eventDate, String eventLocation, int price, int tak){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5.0,
        color: Colors.red,
        onPressed: (){},
        child: Row(
          children: <Widget>[
            Container(
              color: Colors.blue,
              height: 100.0,
              width: 100.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Event   : '+eventName, style: TextStyle(color: Colors.white),),
                  Text('Date    : '+eventDate, style: TextStyle(color: Colors.white)),
                  Text('Location: '+eventLocation, style: TextStyle(color: Colors.white)),
                  Text('TAK     : '+'$tak', style: TextStyle(color: Colors.white)),
                  Text('Price   : Rp.'+'$price', style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}