import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;


void main() => runApp(CreateTeamPage());

class CreateTeamPage extends StatefulWidget {
  
  final String eventName;
  final String title;

  CreateTeamPage({Key key, this.eventName, this.title}) : super(key: key);

  @override
  _CreateTeamPageState createState() => new _CreateTeamPageState();

}
class Result {
  
  String userIDs, event, teamID;

  Result({this.userIDs, this.event,this.teamID });

  factory Result.fromJson(Map<String, dynamic> json) {
    
    return Result(
      userIDs: json['user'],
      event : json['event'],
      teamID: json['teamID'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'barcodes': userIDs,
      'event': event,
      'teamID' : teamID,
      'id' : 314253
    };
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

  print("result " );
  print( resultToJson(result));
  
  String url = 'https://www.prayatna.org.in/volunteersapp/createTeam.php';
  final response = await http.post(Uri.encodeFull(url),
      headers: {
        "Accept": "application/json",
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: resultToJson(result)
  );
   print("response");
   print("status.code" + response.statusCode.toString());
   print("bodyyyy"+ response.body);
  
  return response;
}


class _CreateTeamPageState extends State<CreateTeamPage>
{
  
  bool isSubmitDisabled;
  bool processingRequest;
  String teamID;
  String event;
  String marks;
  String barcode;
  String teamStrengthS;
  int teamStrength, barcodeScanned;

  List<String> members = ['1', '2', '3'];

  var eventMap = {'OSPC':'ospc', 'Coffee With Java':'java', 'DB Dwellers':'dbd',
                  'C Noobies':'cnob','Think-a-Thon' : 'think',
                  'Hexathlon' : 'hex','Web Hub' : 'web',
                    'Parsel Tongue':'python'};


  @override
  void initState()
  {
    super.initState();
    isSubmitDisabled = true;
    processingRequest = false;
    teamStrength = -1;
    barcodeScanned = 0;
    teamID = "";
  }

  @override
  void dispose() 
  {
    super.dispose();
  }

  Future returnAlert(String promptText) async {
    return showDialog (
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(promptText,
                          textAlign: TextAlign.center),
                actions: <Widget>[
                  new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('Ok'))],
              );
            },
          );
  }

  Future showPrompt()
  {
    String promptText = "";


    if(teamStrength.toString()==null || teamStrength.toString()=='-1') {
      promptText = 'Choose team strength!';
    }
    else {

      if(teamID == "")  {
        promptText = 'Scan Team ID! ';
      }

      if(teamStrength > 0)
        promptText += 'Scan '+teamStrength.toString()+' QR to submit!!';
      
    }
    return returnAlert(promptText);
  }

  Future scan(id) async {

    if(id == "userid")  {
      if(teamStrength.toString()==null || teamStrength.toString()=='-1') {
        return returnAlert('Choose team strength!');
      }
      if(barcodeScanned == int.parse(teamStrengthS) ) {
        return returnAlert('Already scanned '+teamStrengthS+' QR!');
      }
    }
    else if(id == "teamid") {
      if(teamID.toString() != "") {
        return returnAlert('Already scanned team QR!');
      }
    }
    try {
      String barcode = await BarcodeScanner.scan();

      if(id == "userid")  {
        setState(
          () => this.barcode += barcode + '&'
        );
        if(teamStrength!= 0)  {
          teamStrength = teamStrength-1;
          barcodeScanned = barcodeScanned+1;
        }
      }
      else if(id == "teamid") {
        setState(
          () => this.teamID = barcode
        );
      }
      
      if(teamStrength==0 && teamID != "") {
        
          isSubmitDisabled = false;
          teamStrength = int.parse(teamStrengthS);
        
      }
      // else {
      //   teamStrength = teamStrength-1;
      // }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future submitConfirm() async
  {
    return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(barcode+'\n'+event+'\n', textAlign: TextAlign.center),
                actions: <Widget>[
                  new FlatButton(onPressed: () { Navigator.pop(context); submitDetails(); }, child: new Text('Confirm')),
                  new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('Cancel'))
                  ],
              );
            },
          );
  }

  Future submitDetails() async
  {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        
      }
    } on SocketException catch (_) {
      return returnAlert('Connect to Internet and try again!');
    }

      // Student object created with the details entered
      Result result = Result(userIDs: barcode, event: event,teamID : teamID);
      
      setState(() {
       processingRequest = true;
       barcode = '';
       barcodeScanned = 0;
       teamID = "";
      });

      // post request sent to server
      createResult(result).then((response) {
         
        //print(response.statusCode);
        if(response.statusCode==200 || response.statusCode==201) {
//  try {
      
          print("yesssss!!!");

            // var body = response.body;
            final body = json.decode(response.body);
            print(body["status"]);
            setState(() {
            processingRequest = false;
            isSubmitDisabled = true;
          });
          
        if (body["status"] == "200") {

            // var jsonBody = json.decode(body);
              // returnAlert('Success!!\n'+"Here's your team ID" +body);
          return returnAlert("Here's your team ID : " + body['team_id']);
        
        }
        else {
          return returnAlert(body['message']);
        }
        }
        // catch(exception) {
                // print(exception.toString());

        // }
          // return returnAlert('Success!!\n'+event+'\n'+marks);
        // }
        else {
          setState(() {
            processingRequest = false;
            isSubmitDisabled = true;
          });
          return returnAlert(response.body);
        }
      });
  }

  
  @override
  Widget build(BuildContext context) {

    this.event = eventMap[widget.eventName];

    
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
            // Image.asset(
            //   // 'assets/images/prayatna19_logo.png',
            //   fit: BoxFit.contain,
            //   height: 35,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Create Team",
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: !processingRequest ? Column(
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
                    width: (MediaQuery.of(context).size.width)/1.5,
                    child: new DropdownButton<String>(
                    hint: new Text("Choose team strength"),
                    value: teamStrengthS,
                    onChanged: (String newValue) {
                      setState(() {
                        teamStrengthS = newValue;
                        teamStrength = int.parse(teamStrengthS);
                        barcode = '';
                        barcodeScanned = 0;
                        isSubmitDisabled = true;
                      });
                    },
                    items: members.map((String e) {
                      return new DropdownMenuItem<String>(
                        value: e,
                        child: new Text(e),
                      );
                    }).toList(),
                  ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new MaterialButton(
                    minWidth: 90,
                    height: 7.0,
                    padding: const EdgeInsets.all(22.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed : () => {
                       scan("userid")
                    },
                    child: new Text(
                      "Scan user QR",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new MaterialButton(
                    minWidth: 90,
                    height: 7.0,
                    padding: const EdgeInsets.all(22.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed : () => {
                       scan("teamid")
                    },
                    child: new Text(
                      "Scan team QR",
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
                      "Create Team",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        ),
                    ),
                  ),
                  // new Padding(padding: new EdgeInsets.all(5.0)),
                  // new MaterialButton(
                  //   minWidth: 120.0,
                  //   height: 10.0,
                  //   padding: const EdgeInsets.all(25.0),
                  //   textColor: Colors.white,
                  //   color: Colors.grey,
                  //   onPressed: confirmAction,
                  //   child: new Text(
                  //     "Create Team",
                  //     style: new TextStyle(
                  //       fontSize: 15.0,
                  //       color: Colors.white,
                  //       ),
                  //   ),
                  // ),
                ], 
        ) : const Center(child: const CircularProgressIndicator(),
                  ),
      ),
    );
  }
}