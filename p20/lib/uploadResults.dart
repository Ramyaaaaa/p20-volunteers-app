import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UploadResultsPage extends StatefulWidget {
  final String title, eventName;

  UploadResultsPage({Key key, this.eventName, this.title}) : super(key: key);

  @override
  _UploadResultsPageState createState() => new _UploadResultsPageState();
}

class Result {
  String teamID, event, marks;

  Result({this.teamID, this.event, this.marks, id});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        teamID: json['teamID'],
        event: json['event'],
        marks: json['marks'],
        id: '425364');
  }

  Map<String, dynamic> toJson() =>
      {'teamID': teamID, 'event': event, 'marks': marks, 'id': '425364'};
}

Result resultFromJson(String str) {
  final jsonData = json.decode(str);
  return Result.fromJson(jsonData);
}

String resultToJson(Result result) {
  Map<String, dynamic> studentMap = result.toJson();
  String jsonCon = json.encode(studentMap);
  return jsonCon;
}

Future<http.Response> createResult(Result result) async {
  print("Result");
  print(resultToJson(result));
  String url = 'https://www.prayatna.org.in/volunteersapp/uploadResults.php';
  final response = await http.post(Uri.encodeFull(url),
      headers: {
        "Accept": "application/json",
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: resultToJson(result));

  try {
    print("Response body : ");
    print(json.decode(response.body));
  
  }
  catch(e)  {
    print(e);
  }
  
  return response;
}

class _UploadResultsPageState extends State<UploadResultsPage> {
  bool isSubmitDisabled;
  bool processingRequest;

  String teamID, barcode;
  String event;
  String marks;

  var eventMap = {
    'OSPC': 'ospc',
    'JAVA': 'java',
    'DB Dwellers': 'dbd',
    'Python': 'python',
    'CnC': 'cnc',
    'CTCI': 'ctci'
  };

  final marksController = TextEditingController();
  final teamIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isSubmitDisabled = true;
    processingRequest = false;
    teamID = '';
  }

  @override
  void dispose() {
    marksController.dispose();
    teamIDController.dispose();
    super.dispose();
  }

  Future returnAlert(String promptText) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(promptText, textAlign: TextAlign.center),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.pop(context), child: new Text('Ok'))
          ],
        );
      },
    );
  }

  Future showPrompt() {
    String promptText;
    promptText = 'Scan steam ID!';
    return returnAlert(promptText);
  }
  bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
  }
  Future submitConfirm() async {
    marks = marksController.text;
    if (marks.length == 0) {
      return returnAlert('Enter marks scored!');
    }
    if(!isNumeric(marks)) {
      return returnAlert('Marks contain alphabets or negative numbers');
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
              "Team ID : " +
                  teamID +
                  '\n' +
                  "Event : " +
                  event +
                  '\n' +
                  "Marks : " +
                  marks.toString(),
              textAlign: TextAlign.center),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  submitDetails();
                },
                child: new Text('Yes')),
            new FlatButton(
                onPressed: () => Navigator.pop(context), child: new Text('No'))
          ],
        );
      },
    );
  }

  Future submitDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      return returnAlert('Connect to Internet and try again!');
    }

    // Student object created with the details entered
    Result result = Result(teamID: teamID, event: event, marks: marks);

    setState(() {
      processingRequest = true;
      teamID = '';
      marks = '';
    });

    // post request sent to server
    createResult(result).then((response) {
      //print(response.statusCode);

      final body = json.decode(response.body);
      print(body["status"]);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['status'] == '200') {
          setState(() {
            processingRequest = false;
            isSubmitDisabled = true;
            marksController.clear();
          });
          return returnAlert('Success!!\n' + event + '\n' + marks);
        } else {
          setState(() {
            processingRequest = false;
            isSubmitDisabled = true;
            
          });
          return returnAlert(body["message"]);
        }
      } else {
        setState(() {
          processingRequest = false;
          isSubmitDisabled = true;
        });
        return returnAlert(response.body);
      }
    });
  }

  Future confirmAction() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Do you want to publish the results?',
              textAlign: TextAlign.center),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  publishResult();
                },
                child: new Text('Yes')),
            new FlatButton(
                onPressed: () => Navigator.pop(context), child: new Text('No'))
          ],
        );
      },
    );
  }

  Future publishResult() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      return returnAlert('Connect to Internet and try again!');
    }
    String url = 'http://34.73.200.44/publishResult';
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(event));
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Text(response.body, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text('Ok')),
            ]);
      },
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.teamID += barcode;
        this.barcode = barcode;
      });
      isSubmitDisabled = false;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    this.event = eventMap[widget.eventName];
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
                "Upload Results",
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: !processingRequest
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  new Text(
                    widget.eventName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(3.0)),
       
                  new Container(
                    width: (MediaQuery.of(context).size.width) / 1.5,
                    child: new TextField(
                      controller: marksController,
                      decoration:
                          new InputDecoration(hintText: "Marks obtained"),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new MaterialButton(
                    minWidth: 90,
                    height: 7.0,
                    padding: const EdgeInsets.all(22.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: scan,
                    child: new Text(
                      "Scan Team ID",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new MaterialButton(
                    minWidth: 100.0,
                    height: 6.0,
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: isSubmitDisabled ? showPrompt : submitConfirm,
                    child: new Text(
                      "Submit",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new MaterialButton(
                    minWidth: 120.0,
                    height: 10.0,
                    padding: const EdgeInsets.all(25.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: confirmAction,
                    child: new Text(
                      "Publish Result",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: const CircularProgressIndicator(),
              ),
      ),
    );
  }
}
