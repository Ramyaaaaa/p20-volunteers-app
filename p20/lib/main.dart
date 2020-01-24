import 'package:flutter/material.dart';
import 'addUser.dart';
import 'createTeam.dart';
import 'uploadResults.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'qr.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayatna',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> events = ['OSPC', 'DB Dwellers', 'Street Coding','Data Structure','Blind Coding','Hexathlon','Web Hub','Paper Presentation','Coffee With Java', 'Parsel Tongue',];
  String event, password;

  
  var passwordMap = {'OSPC':'ospc@123','DB Dwellers':'db@123','Street Coding':'sc@123',
                      'Data Structure':'ds@123','Blind Coding':'bc@123','Hexathlon':'hex@123',
                      'Web Hub':'web@123','Paper Presentation':'pp@123','Coffee With Java':'java@123',  
                      'Parsel Tongue':'py@123'};

  final passwordController = TextEditingController();

  @override
  void dispose() 
  {
    passwordController.dispose();
    super.dispose();
  }

  Future checkPassword(String nextPage)
  {
    String dialogText = 'Empty';
    password = passwordController.text;
    if(event==null) {
      dialogText = 'Choose an event!';
    }
    else if(password.length==0) {
      dialogText = 'Enter Password!';
    } 
    else if(password!=passwordMap[event]) {
      dialogText = 'Wrong password! Try Again!';
    }
    else {
      if(nextPage == "teamPage")  {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new CreateTeamPage(eventName: event)));
      }
      else if(nextPage == "resultPage") {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new UploadResultsPage(eventName: event)));
      }
      else if(nextPage == "qrPage") {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new QRPage(eventName: event)));
      
                              
      }
    }
    if(dialogText!='Empty') {
      return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog (
                  content: Text(dialogText, textAlign: TextAlign.center),
                  actions: <Widget>[
                    new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('Ok'))],
                );
              },
      );
    }
    setState(() {
     passwordController.clear(); 
    });
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
                "Home",
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
                  new Container(
                    width: (MediaQuery.of(context).size.width)/1.25,
                    child: new DropdownButton<String>(
                    hint: new Text("Choose Event"),
                    value: event,
                    onChanged: (String newValue) {
                      setState(() {
                        event = newValue;
                      });
                    },
                    items: events.map((String e) {
                      return new DropdownMenuItem<String>(
                        value: e,
                        child: new Text(e),
                      );
                    }).toList(),
                  ),
                  ),
                  new Container(
                    width: (MediaQuery.of(context).size.width)/1.25,
                    child: new TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: "Enter password"
                      ),
                    ),
                  ),
                  new Container(
                    width: 300.0,
                    child: new Column(
                      children : [
                        new MaterialButton(
                          minWidth: 100.0,
                          height: 25.0,
                          padding: const EdgeInsets.all(25.0),
                          textColor: Colors.white,
                          color: Colors.grey,
                          splashColor: Colors.black38, 
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddUser()),
                            );
                          },
                          child: new Text(
                            "REGISTER",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              ),
                            ),
                        ),
                        new Padding(padding: new EdgeInsets.all(25.0)),
                        
                        new MaterialButton(
                          minWidth: 100.0,
                          height: 25.0,
                          padding: const EdgeInsets.all(25.0),
                          textColor: Colors.white,
                          color: Colors.grey,
                          splashColor: Colors.black38, 
                          onPressed: () {
                            checkPassword("teamPage");
                          },
                          child: new Text(
                            "CREATE TEAM",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              ),
                            ),
                        ),
                        new Padding(padding: new EdgeInsets.all(25.0)),
                        new MaterialButton(
                          minWidth: 100.0,
                          height: 25.0,
                          padding: const EdgeInsets.all(25.0),
                          textColor: Colors.white,
                          color: Colors.grey,
                          onPressed: () {
                            checkPassword("resultPage");
                          },
                          splashColor: Colors.black38,
                          child: new Text(
                            "UPLOAD RESULTS",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              ),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.all(25.0)),
                        
                        new MaterialButton(
                          minWidth: 100.0,
                          height: 25.0,
                          padding: const EdgeInsets.all(25.0),
                          textColor: Colors.white,
                          color: Colors.grey,
                          splashColor: Colors.black38, 
                          onPressed: () {
                            checkPassword("qrPage");
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
                  ),
                ],
        ),
      ),
    );
  }
}