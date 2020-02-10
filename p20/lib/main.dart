import 'package:flutter/material.dart';
import 'addUser.dart';
import 'login.dart';
import 'dart:async';
import 'package:flutter/services.dart';

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
  List<String> events = [
    'OSPC',
    'DB Dwellers',
    'C Noobies',
    'Think-a-Thon',
    'Hexathlon',
    'Web Hub',
    'Coffee With Java',
    'Parsel Tongue'
  ];
  String event, password;

  var passwordMap = {
    'OSPC': 'ospc#137',
    'DB Dwellers': 'db@135',
    'C Noobies': 'cnob#109',
    'Hexathlon': 'hex*987',
    'Web Hub': 'web/123',
    'Think-a-Thon': 'think-765',
    'Coffee With Java': 'java+654',
    'Parsel Tongue': 'py=012'
  };

  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future checkPassword(event) {
    print(event);

    String dialogText = 'Empty';
    password = passwordController.text;
    if (event == null) {
      dialogText = 'Choose an event!';
    } else if (password.length == 0) {
      dialogText = 'Enter Password!';
    } else if (password != passwordMap[event]) {
      dialogText = 'Wrong password! Try Again!';
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login(event: event)),
      );
    }
    if (dialogText != 'Empty') {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(dialogText, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text('Ok'))
            ],
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
              width: (MediaQuery.of(context).size.width) / 1.25,
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
              width: (MediaQuery.of(context).size.width) / 1.25,
              child: new TextField(
                controller: passwordController,
                obscureText: true,
                decoration: new InputDecoration(hintText: "Enter password"),
              ),
            ),
            new Container(
                width: 300.0,
                //height: (MediaQuery.of(context).size.height)/1.25,
                child: new Column(children: [
                  new Padding(padding: new EdgeInsets.all(15.0)),
                  new MaterialButton(
                    //minWidth: 100.0,
                    //height: 25.0,
                    padding: const EdgeInsets.all(20.0),
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
                  new Padding(padding: new EdgeInsets.all(15.0)),
                  new MaterialButton(
                    //minWidth: 100.0,
                    //height: 25.0,
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    splashColor: Colors.black38,
                    onPressed: () {
                      checkPassword(event);
                    },
                    child: new Text(
                      "LOGIN",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
