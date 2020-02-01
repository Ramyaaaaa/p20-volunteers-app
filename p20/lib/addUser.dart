import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayatna',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        //accentColor: Colors.white,
      ),
      home: AddUserPage(title: 'Register'),
    );
  }
  
}

class AddUserPage extends StatefulWidget {
  AddUserPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class Student {
  
  String user,barcode, name, college, number, year;
  bool isRegistered = true;
  Student({this.user,this.barcode, this.name, this.college, this.number, this.year,this.isRegistered});

  factory Student.fromJson(Map<String, dynamic> json) {
    
    return Student(

      user: json['user'],
      barcode: json['barcode'],
      name: json['id'],
      college : json['name'],
      number : json ['score'],
      year : json['year'], 
      isRegistered: json['isRegistered']
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'user' : user,
      'barcode': barcode,
      // 'name': name,
      // 'college': college,
      // 'number': number,
      // 'year' : year,
      // 'isRegistered' : isRegistered,
      'id' : 918273
    };
}

Student studentFromJson(String str) {    
   final jsonData = json.decode(str);    
   return Student.fromJson(jsonData);
}

String studentToJson(Student student) {    
    
   Map<String, dynamic> studentMap = student.toJson();
   String jsonCon = json.encode(studentMap);
   return jsonCon;
}

Future<http.Response> createStudent(Student student) async {

  String url = 'https://prayatna.org.in/volunteersapp/addUser.php';
  final response = await http.post(url,
      headers: {
        "Accept": "application/json",
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: studentToJson(student)
  );
  print(response.body);
  return response;
}

class _AddUserPageState extends State<AddUserPage> {

  bool isSubmitDisabled;
  bool processingRequest;

  String userName;
  String clgName;
  String mobileNumber;
  String yearOfStudy;
  String barcode;
  String user;
  List<int> years = [1, 2,3,4];

  final uController = TextEditingController();
  final uNameController = TextEditingController();
  final cNameController = TextEditingController();
  final mobController = TextEditingController();
  var isRegistered = true;
  
  bool formInvalid = false;
  @override
  
  void initState()
  {
    super.initState();
    isSubmitDisabled = true;
    processingRequest = false;
  }

  @override
  void dispose() 
  {
    uNameController.dispose();
    cNameController.dispose();
    mobController.dispose();
    super.dispose();
  }


  Future search() async {
    user = uController.text;
    String url = 'https://www.prayatna.org.in/volunteersapp/register.php';
  final response = await http.post(Uri.encodeFull(url),
      headers: {
        "Accept": "application/json",
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: user);
  try {
    print("Response body : ");

    if(response.body == "" || response == null || response.body == null) {
      return returnAlert("No data");
   }
  //  print(response.body);
    
    print(json.decode(response.body));
    var body = json.decode(response.body);

    if(response.statusCode == 200) {
      if(body['status'] == '200') {

        uNameController.text = body['name'];
        mobController.text = body['phone'].toString();
        cNameController.text = body['college'];
        setState(() {
          yearOfStudy = body['year'].toString(); 
        });
        // yearOfStudy =
      }
      else {
        formInvalid = true;
        setState(() {
            isSubmitDisabled = true;
            cNameController.clear();
            mobController.clear();
            uNameController.clear();
            uController.clear();
          });
        returnAlert(body['message']);
          
      
      }
    }
    else {
      formInvalid = true;
              setState(() {
            isSubmitDisabled = true;
            cNameController.clear();
            mobController.clear();
            uNameController.clear();
            uController.clear();
          
          });

      returnAlert(response.body);
        
    }
  
  }
  catch(e)  {
    print("oops");
    print(e);
  }
  
  
  }
  Future returnAlert(String promptText) async {
    if(promptText == null)  {
      promptText = "Sorry,Error occured! Please try again!";
      

    }
    return showDialog (
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(promptText,
                          textAlign: TextAlign.center),
                actions: <Widget>[
                  new FlatButton(onPressed: () {
                    Navigator.pop(context);
                    if(promptText == "Error occured")
                    {
                      Navigator.pop(context);
                    }
                  }, child: new Text('Ok'))],
              );
            },
          );
  }

  Future showPrompt() {
    return returnAlert('Scan QR to submit!!');
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(
        () => this.barcode = barcode
      );

      isSubmitDisabled = false;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant Camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
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

    user = uController.text;
    userName = uNameController.text;
    clgName = cNameController.text;
    mobileNumber = mobController.text;
    String promptText;
    if(mobileNumber.length!=10) {
      promptText = 'Mobile number should have 10 digits!';
      formInvalid = true;
    }
    else if(userName.length==0) {
      promptText = 'Name should not be empty!';
      formInvalid = true;
    }
    else if(clgName.length==0) {
      promptText = 'College name should not be empty!';
      formInvalid = true;
    }
    else if(yearOfStudy==null) {
      promptText = 'Choose Year of Study!';
      formInvalid = true;
    }
    if(formInvalid) {
      print(promptText);
      return returnAlert(promptText);
    }
    else {
      // Student object created with the details entered
      Student student = Student(user : user,barcode: barcode, name: userName, college: clgName, number: mobileNumber,year: yearOfStudy,isRegistered: isRegistered);
      
      // post request to server
      setState(() {
       processingRequest = true; 
      });
      createStudent(student).then((response) {
        if(response.statusCode == 200 || response.statusCode==201) {
          setState(() {
            processingRequest = false;
            isSubmitDisabled = true;
            cNameController.clear();
            mobController.clear();
            uNameController.clear();
            uController.clear();
          });
          return returnAlert('Success!!\n\n'+userName+'\n'+clgName+'\n'+mobileNumber+'\n'+yearOfStudy+'\n'+barcode);
        }
        else {
          //print(response.body);
          setState(() {
            processingRequest = false;
          });
          promptText = response.body;
          return returnAlert(response.body);
        }
      });
    }
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
            // Image.asset(
            //   'assets/images/prayatna19_logo.png',
            //   fit: BoxFit.contain,
            //   height: 35,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Register",
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: !processingRequest ?
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
                  
                  new Text(
                    'Student Details',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  // Row(children: <Widget>[
                  //   new Padding(padding: new EdgeInsets.all(36.0)),
                  
                  // RichText(text: TextSpan(text :"Already Registered?",
                  // style: TextStyle(fontSize: 20))),
                  //   Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text("Yes"),
                  //       Checkbox(
                  //         value: isRegistered,
                  //         onChanged: (bool value) {
                  //           setState(() {
                  //             isRegistered = value;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                    // [Tuesday] checkbox
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text("No"),
                    //     Checkbox(
                    //       // activeColor: Color.fromRGBO(34, 34, 103, 20),
                    //       // checkColor: Color.fromRGBO(255, 255, 255, 4),
                    //       value: !isRegistered,
                    //       onChanged: (bool value) {
                    //         setState(() {
                    //           isRegistered = !value;
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),
                    
                  // ],),
                  isRegistered ? Row(children: <Widget>[
                   new Padding(padding: new EdgeInsets.all(38.0)),
                  new Container(
                    width: (MediaQuery.of(context).size.width)/2.4,
                    // height: 20,
                    child: new TextField(
                      controller: uController,
                      decoration: new InputDecoration(
                        hintText: "User ID or Email ID"
                      ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  
                  new MaterialButton(
                    minWidth: 50.0,
                    height: 3.0,
                    padding: const EdgeInsets.all(10.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: search,
                    child: new Text(
                      "Search",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        ),
                    ),
                  ),
                  // new Padding(padding: new EdgeInsets.all(7.0)),
                  
                  ],): new Container(),
                  new Container(
                    width: (MediaQuery.of(context).size.width)/1.5,
                    child: new TextField(
                      controller: uNameController,
                      decoration: new InputDecoration(
                        hintText: "Name"
                      ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new Container(
                    width: (MediaQuery.of(context).size.width)/1.5,
                    child: new TextField(
                      controller: cNameController,
                      decoration: new InputDecoration(
                        hintText: "College Name"
                      ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new Container(
                    width: (MediaQuery.of(context).size.width)/1.5,
                    child: new TextField(
                      controller: mobController,
                      decoration: new InputDecoration(
                        hintText: "Mobile Number"
                      ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new Container(
                    width: (MediaQuery.of(context).size.width)/1.5,
                    child: new DropdownButton<String>(
                    hint: new Text("Year of study"),
                    value: yearOfStudy,
                    onChanged: (String newValue) {
                      setState(() {
                        yearOfStudy = newValue;
                      });
                    },
                    items: years.map((int year) {
                      return new DropdownMenuItem<String>(
                        value: year.toString(),
                        child: new Text(year.toString()),
                      );
                    }).toList(),
                  ),
                  ),
                  new Padding(padding: new EdgeInsets.all(7.0)),
                  Row(children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(30.0)),
  
new MaterialButton(
                  
                   // minWidth: 100.0,
                    height: 5.0,
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: scan,
                    child: new Text(
                      "Scan QR",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        ),
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new MaterialButton(
                   // minWidth: 120.0,
                    height: 6.0,
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: isSubmitDisabled ? showPrompt : submitDetails,
                    child: new Text(
                      "Submit",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        ),
                    ),
                  ),
                  ],),
                  
                  new Padding(padding: new EdgeInsets.all(5.0)),
                ], 
        ) : const Center(child: const CircularProgressIndicator()), 
      ),
    );
  }
}
