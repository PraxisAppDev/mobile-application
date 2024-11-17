import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_team.dart';
import 'package:praxis_afterhours/apis/post_leave_team.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view_no_buttons.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view_no_buttons.dart';
import 'package:provider/provider.dart';

import '../../provider/game_model.dart';
import 'package:praxis_afterhours/views/new_screens/join_a_team_view.dart';

class MyTeamView extends StatelessWidget {
  // final String teamID;
  // final String huntID;
  // late String teamName;
  //
  // MyTeamView({super.key, required this.huntID, required this.teamID});

  MyTeamView({super.key});

  // Function to show the confirmation dialog for leaving a team
Future<void> _showLeaveTeamConfirmation(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        contentPadding: EdgeInsets.zero,
        content: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Are you sure you would like to leave this team?',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Container(
      height: 50,
      width: 120,
      decoration: AppStyles.cancelButtonStyle,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: AppStyles.elevatedButtonStyle,
        child: const Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Container(
      height: 50,
      width: 120,
      decoration: AppStyles.confirmButtonStyle,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pop();
          await leaveTeamAndUpdateView(context);
        },
        style: AppStyles.elevatedButtonStyle,
        child: const Text(
          'Confirm',  // Changed from a possible line break to a single word
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,  // Added to prevent text wrapping
          softWrap: false,  // Added to prevent text wrapping
        ),
      ),
    ),
  ],
),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  // Updated leaveTeam function to handle the API calls and leave the team
  Future<void> leaveTeamAndUpdateView(BuildContext context) async {
    try {
      final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
      // Call the leaveTeam API
      await leaveTeam(huntProgressModel.huntId, huntProgressModel.teamId, "placeholder"); // TODO: Fix
      // Show a success message or refresh the view
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully left the team')),
      );
      // Navigate back to join_a_team_view after leaving the team
      Navigator.pop(context);
    } catch (error) {
      // Handle any errors from the leaveTeam call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error leaving the team: $error')),
      );
    }
  }


  // // Auxiliary function to handle leave team POST API call and handle view updates
  // Future<void> leaveTeamAndUpdateView(BuildContext context) async {
  //   try {
  //     // Call the leaveTeam API
  //     await leaveTeam(huntID, teamID, "placeholder"); // TODO: Fix
  //     // Show a success message or refresh the view
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Successfully left the team')),
  //     );
  //     // Navigate back after leaving the team
  //     Navigator.pop(context);
  //   } catch (error) {
  //     // Handle any errors from the leaveTeam call
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error leaving the team: $error')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);

    // print("current huntID: $huntID");
    // print("current teamID: $teamID");
    //AUTOMATICALLY SHOWS TEAM FULL DIALOG AND THEN GAME STARTING DIALOG
    //Future.delayed(Duration(seconds: 3), () => ShowTeamFullDialog(context));
    //Future.delayed(Duration(seconds: 6), () => ShowGameStartDialog(context));
    return MaterialApp(
      home: Scaffold(
          appBar: AppStyles.appBarStyle("My Team", context),
          body: DecoratedBox(
              decoration: AppStyles.backgroundStyle,
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: fetchTeam(huntProgressModel.huntId, huntProgressModel.teamId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        // If the data was successfully retrieved, display it
                        print(snapshot.data);
                        huntProgressModel.teamName = snapshot.data!['name'];
                        return TeamTile(
                            isLocked: snapshot.data!['lockStatus'],
                            teamName: snapshot.data!['name'],
                            members: snapshot.data!['players']);
                      } else {
                        return const Center(child: Text('No data available.'));
                      }
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 50,
                        width: 175,
                        decoration: AppStyles.confirmButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            huntProgressModel.totalSeconds = 0;
                            huntProgressModel.totalPoints = 0;
                            huntProgressModel.secondsSpentThisRound = 0;
                            huntProgressModel.pointsEarnedThisRound = 0;
                            huntProgressModel.currentChallenge = 0;

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HuntProgressViewNoButtons())
                            );
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text('Progress NB'),
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 50,
                        width: 175,
                        decoration: AppStyles.confirmButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            huntProgressModel.totalSeconds = 0;
                            huntProgressModel.totalPoints = 0;
                            huntProgressModel.secondsSpentThisRound = 0;
                            huntProgressModel.pointsEarnedThisRound = 0;
                            huntProgressModel.currentChallenge = 0;
                            huntProgressModel.previousSeconds = huntProgressModel.totalSeconds;
                            huntProgressModel.previousPoints = huntProgressModel.totalPoints;
                            huntProgressModel.challengeId = "1";
                            huntProgressModel.challengeNum = 0;
                            //huntProgressModel.challengeId = challengeResponse[index]['id'];
                            //huntProgressModel.challengeNum = index;

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ChallengeViewNoButtons())
                            );
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text('Challenge NB'),
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 50,
                        width: 175,
                        decoration: AppStyles.cancelButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            // opens dialog box asking for confirmation to leave team
                            _showLeaveTeamConfirmation(context);
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text('Leave Team'),
                        ),
                      )
                  ),
                ],
              ))),
    );
  }
}

// * will change based on state *
// individual team widget
class TeamTile extends StatefulWidget {
  final String teamName;
  final List<dynamic> members;
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

  // Text controller for the new member input
  final TextEditingController _newMemberController = TextEditingController();
  bool hasAddedMember = false; //Track if a member has already been added to team

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
                          //TODO: Should length be hard coded at 4?
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
                        String member = entry.value['name'];
                        bool teamLeader = entry.value['teamLeader'];

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
                                /*if (index == 3)
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
                                  ),*/
                                Text(
                                  member,
                                  style: AppStyles.logisticsStyle,
                                ),
                                if (teamLeader) // Add crown to the first member
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
                    if (widget.members.length < 4 && !hasAddedMember) ...[
                      const Divider(color: Colors.grey, indent: 15, endIndent: 15, height: 1),
                      ListTile(
                        leading: Icon(Icons.person_add, color: Colors.grey),
                        title: TextField(
                          controller: _newMemberController,
                          decoration: InputDecoration(
                            hintText: "Enter new member name",
                            hintStyle: AppStyles.logisticsStyle.copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  widget.members.add({
                                    'name': _newMemberController.text,
                                    'teamLeader': false,
                                  });
                                  _newMemberController.clear();
                                  hasAddedMember = true; //Set flag prevent furthur additions to team
                                });
                              },
                            ),
                          ),
                          style: AppStyles.logisticsStyle,
                        ),
                      ),
                    ],
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
