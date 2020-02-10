
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

          List<Team> teams = [];
           body.forEach((team,data) {
           print(team);
            print(data);
            List<dynamic> memberList ;
            memberList = data['user'];
            
              teams.add(Team(
              teamID : team.toString(),
              members: memberList,
              marks: data['mark'].toString(),
              isSelected: (data['selected'] == 1) ? true : false,
              
            ));
            
          });
          
          this.view.onLoadResultsComplete(teams, 1);
        }
        
      } else {
        this.view.onLoadResultsError(response.body.toString());
      }
    }).catchError((error) {
      print(error);
      this.view.onLoadResultsError('Unexpected error occured');
    });
  }
}