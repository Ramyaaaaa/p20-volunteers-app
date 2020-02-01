import 'package:flutter/material.dart';
import 'addUser.dart';
import 'createTeam.dart';
import 'uploadResults.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'qr.dart';
import 'viewResults.dart';

class Login extends StatelessWidget {
  String event;
  Login({this.event});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayatna',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: MyLoginPage(event: event),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.event}) : super(key: key);

  final String event;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  void dispose() 
  {
    super.dispose();
  }


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
                "Hello Volunteer",
              ),
            ),
          ],
        ),
      ),
      body: 
      Builder(builder : (context) => Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(5.0)),
            
            
            new MaterialButton(
              //minWidth: 100.0,
              //height: 25.0,
              padding: const EdgeInsets.all(20.0),
              textColor: Colors.white,
              color: Colors.grey,
              splashColor: Colors.black38, 
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => new CreateTeamPage(eventName: widget.event)));

              },
              child: new Text(
                "CREATE TEAM",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  ),
                ),
            ),
            new Padding(padding: new EdgeInsets.all(5.0)),
            new MaterialButton(
             // minWidth: 100.0,
              //height: 25.0,
              padding: const EdgeInsets.all(20.0),
              textColor: Colors.white,
              color: Colors.grey,
              onPressed: () {
                // Navigator.push(
                //       context, UploadResultsPage(eventName: widget.event));
                
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => new UploadResultsPage(eventName: widget.event)));
              },
              splashColor: Colors.black38,
              child: new Text(
                "UPLOAD OR PUBLISH RESULTS",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  ),
              ),
            ),
            new Padding(padding: new EdgeInsets.all(5.0)),
            new MaterialButton(
              minWidth: 100.0,
              //height: 25.0,
              padding: const EdgeInsets.all(20.0),
              textColor: Colors.white,
              color: Colors.grey,
              onPressed: () async {
                String value = await Navigator.push(
                    context,
                    ResultsPageRoute(
                      title: widget.event,
                      id: widget.event,
                    ),
                  );
                  if (value != null) {
                    final snackBar = SnackBar(content: Text(value,style : TextStyle(color: Colors.white)),backgroundColor: Colors.black,behavior: SnackBarBehavior.floating);
                    // Find the Scaffold in the Widget tree and use it to show a SnackBar
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                
              },
              splashColor: Colors.black38,
              child: new Text(
                "VIEW RESULTS",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  ),
              ),
            ),
            new Padding(padding: new EdgeInsets.all(5.0)),
            
            new MaterialButton(
              //minWidth: 100.0,
              // height:  500-(MediaQuery.of(context).size.height),
        
              padding: const EdgeInsets.all(20.0),
              textColor: Colors.white,
              color: Colors.grey,
              splashColor: Colors.black38, 
              onPressed: () {    
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => new QRPage(eventName: widget.event)));

              },
              child: new Text(
                "VIEW QR",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  ),
                ),
            ),
            
          ])
      )),
    );
  }
}