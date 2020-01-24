import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(QRPage());

class QRPage extends StatefulWidget {
  String eventName ;
   QRPage({Key key, this.eventName}) : super(key: key);

  @override
  _QRPageState createState() => new _QRPageState(eventName: eventName);
}
class _QRPageState extends State<QRPage> {
    String eventName ;

    _QRPageState({this.eventName});

  var qrMap = {'OSPC':'ospc@123','DB Dwellers':'db@123','Street Coding':'sc@123',
                      'Data Structure':'ds@123','Blind Coding':'bc@123','Hexathlon':'hex@123',
                      'Web Hub':'web@123','Paper Presentation':'pp@123','Coffee With Java':'java@123',  
                      'Parsel Tongue':'py@123'};

 
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "SECRET QR CODE",
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: QrImage(
        data: qrMap[eventName],)
        ),
      );
  }
}