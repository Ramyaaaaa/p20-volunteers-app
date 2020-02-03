import 'package:flutter/material.dart';
import 'request.dart';
import 'search.dart';
import 'team.dart';

List<Team> teamDetails;

class ResultsPageRoute extends MaterialPageRoute<String> {
  ResultsPageRoute({String title})
      : super(
          builder: (context) => new ResultsPage(title: title),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class ResultsPage extends StatefulWidget {
  final String title;

  ResultsPage({Key key, this.title}) : super(key: key);

  _ResultsPageState createState() => _ResultsPageState(
        title: this.title,
        
      );
}

class _ResultsPageState extends State<ResultsPage>
    implements HttpRequestContract {
  final String title;
  bool resultsReady;
  HttpRequest request;
var eventMap = {
    'OSPC': 'ospc',
    'JAVA': 'java',
    'DB Dwellers': 'dbd',
    'Python': 'python',
    'CnC': 'cnc',
    'CTCI': 'ctci'
  };

  _ResultsPageState({this.title});

  @override
  void initState() {
    super.initState();
    resultsReady = false;
    teamDetails = List<Team>();
    request = HttpRequest(this);
    request.loadResults();
  }

 String getEventId() => eventMap[this.title];

  void onLoadResultsComplete(List<Team> teams, int selected) {
    setState(() {

      teamDetails = teams;
      resultsReady = true;
    });
  }

  void onLoadResultsError(String errorMessage) {
    print(errorMessage);
    Navigator.pop(context,errorMessage);
  }
  @override
  Widget build(BuildContext context) {
    // teamDetails.forEach((a) => print(a.memberList()));
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: resultsReady
          ? new ListView.separated(
              itemCount: teamDetails.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ResultsContent(
                      team: Team(
                        teamID: 'Team ID',
                        members: <String>['Team Members'],
                        marks: 'Score',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                  );
                }
                return new ResultsContent(team: teamDetails[index - 1]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ResultsContent extends StatelessWidget {
  final Team team;

  ResultsContent({Key key, @required this.team})
      : assert(team != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = this.team.style;

    List names = [];
    team.members.forEach((key) => {
          if (key != "Team Members")
            {names.add(key['name'])}
          else
            {names.add("Team Members")}
        });

    final members = List<Widget>.from(names.map((key) => Center(
          child: Text(key, style: textStyle),
        )));
    final marksColumn = <Widget>[
      Center(child: Text("${team.marks}", style: textStyle)),
    ];
    if (team.isSelected) {
      marksColumn.add(Center(child: Text('Selected', style: textStyle)));
    }
    return Column(children: <Widget>[
      Row(children: <Widget>[
        SizedBox(
          width: 60,
          child: Center(
            child: Text("${team.teamID}", style: textStyle),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: members,
          ),
        ),
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: marksColumn,
          ),
        ),
      ]),
    ]);
  }
}
