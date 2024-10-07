import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class MyTeamView extends StatelessWidget {
  MyTeamView({super.key});

  final Map<String, dynamic> teamData = {
    'teamName': 'Bob\'s Team',
    'members': ['Bob', 'Alice', 'Jane', 'Isa'],
    'isLocked': false,
  };

  @override
  Widget build(BuildContext context) {
    //AUTOMATICALLY SHOWS TEAM FULL DIALOG AND THEN GAME STARTING DIALOG
    Future.delayed(Duration(seconds: 3), () => ShowTeamFullDialog(context));
    Future.delayed(Duration(seconds: 6), () => ShowGameStartDialog(context));
    return MaterialApp(
      home: Scaffold(
          appBar: AppStyles.appBarStyle("My Team", context),
          body: DecoratedBox(
              decoration: AppStyles.backgroundStyle,
              child: Column(
                children: [
                  TeamTile(
                    isLocked: teamData['isLocked'],
                    teamName: teamData['teamName'],
                    members: teamData['members'],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 50,
                        width: 175,
                        decoration: AppStyles.cancelButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            //TODO: Implement Leaving Team API Call
                            Navigator.pop(context);
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text('Leave Team'),
                        ),
                      )),
                ],
              ))),
      // body: const Center(
      //   child: Text(
      //     'Join A Team Screen, waiting for team leader to start hunt...',
      //     style: TextStyle(fontSize: 24), // Set font size
      //   ),
      // ),
    );
  }
}

// * will change based on state *
// individual team widget
class TeamTile extends StatefulWidget {
  final String teamName;
  final List<String> members;
  final bool isLocked;
  final colors = const [Colors.blue, Colors.green, Colors.purple, Colors.red];
  const TeamTile({
    Key? key,
    required this.teamName,
    required this.members,
    required this.isLocked,
  }) : super(key: key);

  @override
  State<TeamTile> createState() => _TeamTileState();
}

class _TeamTileState extends State<TeamTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: DecoratedBox(
              decoration: AppStyles.infoBoxStyle,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.teamName,
                            style:
                                AppStyles.logisticsStyle.copyWith(fontSize: 24),
                          ),
                          Text(
                            "(${widget.members.length}/4)",
                            style:
                                AppStyles.logisticsStyle.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Members...",
                        style: AppStyles.logisticsStyle,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.members.asMap().entries.map((entry) {
                        int index = entry.key;
                        String member = entry.value;
                        return Column(children: [
                          Divider(
                              color: Colors.grey,
                              indent: 15,
                              endIndent: 15,
                              height: 1),
                          ListTile(
                            leading:
                                Icon(Icons.person, color: widget.colors[index]),
                            title: Row(
                              children: [
                                if (index == 3)
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xff363737),
                                        border: Border.all(color: Colors.grey)),
                                    child: Row(children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: TextFormField(
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    InputBorder.none),
                                            initialValue: "Isa",
                                            style: AppStyles.logisticsStyle),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.create_outlined,
                                              color: Colors.grey),
                                          onPressed: () {
                                            //TODO: Push name change
                                          })
                                    ]),
                                  ),
                                if (index != 3)
                                  Text(
                                    member,
                                    style: AppStyles.logisticsStyle,
                                  ),
                                if (index == 0) // Add crown to the first member
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:
                                        Icon(Icons.star, color: Colors.amber),
                                  ),
                              ],
                            ),
                          )
                        ]);
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                  ])),
        ));
  }
}

Future<void> ShowTeamFullDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.all(0),
          content: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff261919),
                    Color(0xff332323),
                    Color(0xff261919),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: DotDivider,
                          ),
                          SizedBox(
                              width: 32,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close, color: Colors.white)))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Your team has reached it\'s limit, waiting for team leader to start game',
                        style: AppStyles.titleStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 45, child: DotDivider)
                  ],
                ),
              )));
    },
  );
}

//Tells players the game is starting, dissappears after 3 seconds
Future<void> ShowGameStartDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 3), () => Navigator.of(context).pop());
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.all(0),
          content: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff261919),
                    Color(0xff332323),
                    Color(0xff261919),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: DotDivider,
                          ),
                          SizedBox(
                            width: 32,
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Your team leader has started the game, beginning play',
                        style: AppStyles.titleStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 45, child: DotDivider)
                  ],
                ),
              )));
    },
  );
}

final DotDivider = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      width: 5.0,
      height: 5.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    ),
    SizedBox(
      width: 5,
    ),
    Container(
      width: 5.0,
      height: 5.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    ),
    SizedBox(
      width: 5,
    ),
    Container(
      width: 5.0,
      height: 5.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    ),
  ],
);
