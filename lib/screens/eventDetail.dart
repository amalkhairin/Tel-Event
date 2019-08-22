import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tel_event/dialogs.dart';
import 'package:tel_event/screens/payment.dart';

class DetailPage extends StatefulWidget {
  DetailPage({this.doc,this.uid});
  final DocumentSnapshot doc;
  final String uid;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool isFullscreen = false;
  bool isSoldOut = false;
  bool start = true;
  String docId;
  bool isLoading = false;
  //var _data;

  void downloader(String url) async {
    try {
      var imageId = await ImageDownloader.downloadImage(
        url,
        destination: AndroidDestinationType.directoryDownloads
      );
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      print('$path right path');
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } catch (e) {
      Text('error: download failed', textAlign: TextAlign.center,);
    }
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    String image = widget.doc.data['image'];
    

    Widget showFullImg = isFullscreen ? new Stack(
      children: <Widget>[
        Container(
          color: Colors.black.withOpacity(0.8),
          height: height,
          width: width,
          child: CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                )
              ),
            ),
            placeholder: (context,url) => CircularProgressIndicator(),
            errorWidget: (context,url,error) => Center(child: Text('Error load image. Please check your connection', textAlign: TextAlign.center,)),
          )
        ),

        //close button
        Align(
          child: GestureDetector(
            onTap: (){
              setState(() {
               isFullscreen = false; 
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0,right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0)
                ),
                child: Icon(Icons.close, size: 35.0,color: Colors.grey,)
              ),
            ),
          ),
          alignment: FractionalOffset.topRight,
        ),
        //

        //download button
        Align(
          child: GestureDetector(
            onTap: (){
              downloader('https://firebasestorage.googleapis.com/v0/b/tel-event.appspot.com/o/kim.jpg?alt=media&token=c569b648-7aba-4acb-9969-ea8b6403c0e8');
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0)
                ),
                child: Icon(Icons.file_download, size: 40.0,color: Colors.grey[800],)
              ),
            ),
          ),
          alignment: FractionalOffset.bottomRight,
        )
        //
      ],
    ) : Container();

    Widget thumbnail = InkWell(
      onTap: (){
        setState(() {
          isFullscreen = true; 
        });
      },
      child: Container(
        height: 180,
        width: width,
        //color: Colors.white,
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitWidth,
              )
            ),
          ),
          placeholder: (context,url) => Center(child: Text('Loading image...', textAlign: TextAlign.center,)),
          errorWidget: (context,url,error) => Center(child: Text('Error load image. Please check your connection', textAlign: TextAlign.center,)),
        )
      ),
    );
    
    //get event description to field
    Widget field = Container(
      margin: EdgeInsets.only(right: 20.0, top: 20.0),
      width: width-20,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.doc['description']),
      ),
    );

    Widget orderButton(DocumentSnapshot data){
      return Center(
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.red,
          splashColor: Colors.greenAccent,
          onPressed: (){
            if (data.data['quota'] == 0){
              setState(() {
                isSoldOut = true;
              });
              Dialogs().soldOutAlert(context);
            } else {
              setState(() {
                isSoldOut = false;
                isLoading = true;
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentPage(data: data,uid: widget.uid,) 
                )
              );
            }
          },
          child: Container(
            height: height/20,
            width: width/3,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(data.data['price']+' | Booking', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            ),
          ),
        )
      );
    }

    Widget loadingIndicator = isLoading ? new Container(
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

    Widget body = StreamBuilder(
      stream: Firestore.instance.collection('temp(otomatis)').document(widget.doc.documentID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot,){
        if (!snapshot.hasData) return Text('connecting');
        final DocumentSnapshot _data = snapshot.data;

        final String name = _data.data['name'];
        final String date = _data.data['date'];
        final String time = _data.data['time'];
        Color isFullColor;
        String isSeatFull = _data.data['quota'] == 0 ? 'FULL' : '${_data.data['quota']}';
        if (_data.data['quota']==0){
          isFullColor = Colors.red;
        }
        double top = 0;
        bool isSpeaker = false;

        if (_data.data['speaker'] != '-' || _data.data['speaker'] == ''){
          top = 5.0;
          isSpeaker = false;
        } else {
          top = 20;
          isSpeaker = true;
        }
        print(name);
        return Card(
          margin: EdgeInsets.only(top: 10.0),
          child: Container(
            height: height*3/5,
            width: width-20,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0,top: 20.0),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(name, style: TextStyle(fontSize: 25.0),),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: <Widget>[
                        Helper().eventType(context, _data.data['type']),
                        Padding(padding: EdgeInsets.only(left: 5.0), child: Helper().eventAccess(context, _data.data['access']),),
                        Padding(padding: EdgeInsets.only(left: 5.0), child: Helper().organizer(context, _data.data['organizer']),),
                      ],
                    ),
                  ),

                  field,

                  isSpeaker? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.person, size: 26.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(_data.data['speaker'], style: TextStyle(fontSize: 16.0),),
                        ),
                      ],
                    ),
                  ) : new Container(),

                  Padding(
                    padding: EdgeInsets.only(top: top),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.event, size: 26.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(date, style: TextStyle(fontSize: 16.0),),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.access_time, size: 26.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(time, style: TextStyle(fontSize: 16.0),),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on, size: 26.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(_data.data['location'], style: TextStyle(fontSize: 16.0),),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.event_seat, size: 26.0, color: isFullColor,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(isSeatFull, style: TextStyle(fontSize: 16.0, color: isFullColor),),
                        ),
                      ],
                    ),
                  ),

                  orderButton(_data),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
    //

    //main code
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('Detail'),
            elevation: 5.0,
          ),
          body: Container(
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      thumbnail,
                      body,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Align(child: showFullImg, alignment: FractionalOffset.center,)
      ]
    );
  }
}


class Helper{
  Widget eventType(BuildContext context, String category){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double fontSize = 12.0;
    if ((height < 683 || width < 411)&&(height < 571 || width < 340)){
      fontSize = 9.0;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(category, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: fontSize),),
      ),
    );
  }

  Widget eventAccess(BuildContext context, String access){
    Color color;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double fontSize = 12.0;
    if ((height < 683 || width < 411)&&(height < 571 || width < 340)){
      fontSize = 9.0;
    }
    switch (access) {
      case 'public' :
        color = Colors.blueAccent;
        break;
      default: color = Colors.purple; break;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(access, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: fontSize),),
      ),
    );
  }

  Widget organizer(BuildContext context, String org){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double fontSize = 12.0;
    if ((height < 683 || width < 411)&&(height < 571 || width < 340)){
      fontSize = 9.0;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text('by '+org, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: fontSize),),
      ),
    );
  }
}