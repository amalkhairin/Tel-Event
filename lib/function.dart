import 'package:flutter/material.dart';

class GetFunction {
  String getMonth(String month){
    String _date;
    switch (month) {
      case '01': _date = "Januari"; break;
      case '02': _date = "Februari"; break;
      case '03': _date = "Maret"; break;
      case '04': _date = "April"; break;
      case '05': _date = "Mei"; break;
      case '06': _date = "Juni"; break;
      case '07': _date = "Juli"; break;
      case '08': _date = "Agustus"; break;
      case '09': _date = "September"; break;
      case '10': _date = "Oktober"; break;
      case '11': _date = "November"; break;
      case '12': _date = "Desember"; break;
      default: break;
    }
    return _date;
  }

  String getYear(String year){
    String _year = '';
    for (var i = 0; i < 4; i++) {
      _year = _year + year[i];
    }
    return _year;
  }

  Widget category(BuildContext context, String category){
    Color color;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double fontSize = 11.0;
    if ((height < 683 || width < 411)&&(height < 571 || width < 340)){
      fontSize = 9.0;
    }
    switch (category) {
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
        padding: const EdgeInsets.all(2.0),
        child: Text(category, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: fontSize),),
      ),
    );
  }

  Widget eventType(BuildContext context, String category){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double fontSize = 11.0;
    if ((height < 683 || width < 411)&&(height < 571 || width < 340)){
      fontSize = 9.0;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(category, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: fontSize),),
      ),
    );
  }
}