import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'team.dart';

abstract class HttpRequestContract {
  String getEventId();
  void onLoadResultsComplete(List<Team> teams, int selected);
  void onLoadResultsError(String errorMessage);
}

class HttpRequest {
  final HttpRequestContract view;
  HttpRequest(this.view);

  void loadResults() async {
    try {
      await InternetAddress.lookup('google.com');
    } on SocketException catch (_) {
      this.view.onLoadResultsError('Connect to Internet and try again!');
      return;
    }

    String url = 'https://www.prayatna.org.in/volunteersapp/results.php';
    
    // String body = '{"event": "${this.view.getEventId()}"}';

    Map<String,dynamic> res = {'event': '${this.view.getEventId()}', 'id': '425364','view':1};
    print(json.encode(res));
    String body = json.encode(res);

    print('Sending request to server');
    http
        .post(Uri.encodeFull(url),
            headers: {
              "Accept": "application/json",
              HttpHeaders.contentTypeHeader: 'application/json'
            },
            body: body)
        .then((response) {
      // print('Request Body: ' + body);
      print('Response: ' + response.body.toString());
      final body = json.decode(response.body);
            print(body["status"]);
            
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("response code is 200");
        if(body["published"] != null && body["published"] == false) {
          this.view.onLoadResultsError(
              'Results are not published yet. Please try again later');
        
          print("results are not published");

        }
        else {


          print(body['1003']);

          List<Team> teams = [];
           body.forEach((team,data) {
           print(team);
            print(data);
            List<dynamic> memberList ;
            memberList = data['user'];
            
            // data['user'].forEach((member) {
              
            //   print("memberrrrrr");
            //   print(member['name']);
            //   memberList.add<String>(member['name'].toString());
            // });

            memberList.forEach((a) {
              print(a);
              
              print("for loop");
            });

              teams.add(Team(
              teamID : team.toString(),
              // rank: team['rank'].toString(),
              members: memberList,
              marks: data['mark'].toString(),
              isSelected: (data['selected'] == 1) ? true : false,
              
            ));
            
          });
          
          this.view.onLoadResultsComplete(teams, 1);
        }
          // body.forEach((teamID,data) {
          //   List<String> namesList;
          //   List<String> phoneNumbers;
          //   print('${teamID}: ${data}');
          //   data.forEach((user,userData) {
          //     namesList.add(userData['name']);
          //     phoneNumbers.add(userData['phone']);
          //   });

          // 
          // }); 
       

        // List responseList = null;
        // var params = responseList;
        // List<Team> teams = responseList.map((team) {
        //     return Team(
        //       rank: team['rank'].toString(),
        //       members: List<String>.from(team['names']),
        //       marks: team['marks'].toString(),
        //       isSelected: (team['selected'] == 'true') ? true : false,
        //     );
        //   }).toList();
          
        

      //  }
        // String resultsAvailable = params['published'];
        // if (resultsAvailable == 'true') {
        //   int selected = params['selected'];
        //   List<Team> teams = responseList.map((team) {
        //     return Team(
        //       rank: team['rank'].toString(),
        //       members: List<String>.from(team['names']),
        //       marks: team['marks'].toString(),
        //       isSelected: (team['rank'] <= selected) ? true : false,
        //     );
        //   }).toList();
        //  else {
          // }
      } else {
        this.view.onLoadResultsError(response.body.toString());
      }
    }).catchError((error) {
      print(error);
      this.view.onLoadResultsError('Unexpected error occured');
    });
  }
}