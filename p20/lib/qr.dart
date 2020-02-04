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

  var qrMap = {'OSPC':"@#'6<&sW5UFT)~pW",'DB Dwellers':">ny]djSv\$yt#2C&]",
                'C Noobies': 'R9UswyX6>9)nN}R\$','Think-a-Thon':'S6Kp[F+/Dh~\$vRj>',
                'Hexathlon':'[k,me6g3MGbUM-As','Web Hub':'6kv%4CUdT,PEwE&Z',
                'Coffee With Java':'ww9@#mCdWc`n[=-H','Parsel Tongue':"7Ws5k2B]'C-r^6=y"};

 
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: new IconButton(
               icon: new Icon(Icons.arrow_back, color: Colors.white),
               onPressed: () => Navigator.of(context).pop(),
              ),
        
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
      body: 
      Container(
        color: Colors.white,
        child : Center(
        child: QrImage(
        data: qrMap[eventName],)
        ),
      )
    );
  }
}