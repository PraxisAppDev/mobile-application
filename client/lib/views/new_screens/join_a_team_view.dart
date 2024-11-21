import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_teams.dart';
import 'package:praxis_afterhours/apis/post_join_team.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:provider/provider.dart';
import '../../provider/game_model.dart';
import 'my_team_view.dart';
import 'package:praxis_afterhours/apis/new_teams_api.dart' as teams_api;

class JoinATeamView extends StatelessWidget {
  // final String huntID;
  // const JoinATeamView({super.key, required this.huntID});
  const JoinATeamView({super.key});

  @override
  Widget build(BuildContext context) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);

    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Join A Team", context),
        body: DecoratedBox(
            decoration: AppStyles.backgroundStyle,
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchTeamsFromHunt(huntProgressModel.huntId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // If the data was successfully retrieved, display it
                  List<dynamic> teams = snapshot.data!['teams'];
                  print(snapshot.data);
                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      return TeamTile(
                          teamID: teams[index]['id'],
                          huntID: huntProgressModel.huntId,
                          isLocked: teams[index]['lockStatus'],
                          teamName: teams[index]['name'],
                          members: teams[index]['players']);
                    },
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            )),
      ),
    );
  }
}

// * will change based on state *
// individual team widget
class TeamTile extends StatefulWidget {
  final String teamName;
  final List<dynamic> members;
  final bool isLocked;
  final String huntID;
  final String teamID;

  const TeamTile({
    Key? key,
    required this.huntID,
    required this.teamID,
    required this.teamName,
    required this.members,
    required this.isLocked,
  }) : super(key: key);

  @override
  State<TeamTile> createState() => _TeamTileState();
}

class _TeamTileState extends State<TeamTile> {
  final TextEditingController _newMemberController = TextEditingController();
  bool hasAddedMember =
      false; //Track if a member has already been added to team

  // Function to handle the join_team API call and navigate to MyTeamView after successful joining
  void _handleJoinTeam(BuildContext context) async {
    if (_newMemberController.text.trim().isEmpty) {
      ShowEmptyTeamDialog(context);
      return;
    }
    try {
      // Get the entered name
      String playerName = _newMemberController.text.trim();

      await joinTeam(widget.huntID, widget.teamName, playerName);

      final huntProgressModel =
          Provider.of<HuntProgressModel>(context, listen: false);
      huntProgressModel.teamId = widget.teamID;
      // Store the player name in the model
      huntProgressModel.playerName = playerName; // Add this line

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyTeamView(playerName: playerName),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining team: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: DecoratedBox(
          decoration: AppStyles.infoBoxStyle,
          child: ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.teamName,
                  style: AppStyles.logisticsStyle.copyWith(fontSize: 24),
                ),
                Row(
                  children: [
                    if (widget.isLocked)
                      const Icon(Icons.lock, color: Colors.white),
                    Text(
                      "(${widget.members.length}/4)",
                      style: AppStyles.logisticsStyle,
                    ),
                  ],
                ),
              ],
            ),
            children: [
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
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: Row(
                        children: [
                          Text(
                            member,
                            style: AppStyles.logisticsStyle,
                          ),
                          if (teamLeader) // Add crown to team leader
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.star, color: Colors.amber),
                            ),
                        ],
                      ),
                    )
                  ]);
                }).toList(),
              ),
              if (widget.members.length < 4 && !hasAddedMember) ...[
                const Divider(
                    color: Colors.grey, indent: 15, endIndent: 15, height: 1),
                ListTile(
                  leading: Icon(Icons.person_add, color: Colors.grey),
                  title: TextField(
                    controller: _newMemberController,
                    decoration: InputDecoration(
                      hintText: "Enter new member name",
                      hintStyle:
                          AppStyles.logisticsStyle.copyWith(color: Colors.grey),
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
                            hasAddedMember =
                                true; //Set flag prevent further additions to team
                          });
                        },
                      ),
                    ),
                    style: AppStyles.logisticsStyle,
                  ),
                ),
              ],
              if (!widget.isLocked)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 175,
                      decoration: AppStyles.cancelButtonStyle,
                      child: ElevatedButton(
                        onPressed: widget.isLocked
                            ? null // Disable button if team is locked
                            : () {
                                _handleJoinTeam(context);

                                // joinTeam(widget.huntID, widget.teamName);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => MyTeamView(
                                //             huntID: widget.huntID,
                                //             teamID: widget.teamID,
                                //           )),
                                // );

                                // Join team functionality
                                /*
                               /*
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                     content:
                                         Text('Joined ${widget.teamName}')),
                               );
                               */
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => MyTeamView()),
                               );
                               */

                                // *****************
                                // setState(() {
                                //   widget.members.add("CURRENT USER NAME");
                                // });
                                // **************
                              },
                        style: AppStyles.elevatedButtonStyle,
                        child: const Text('Join Team!'),
                      ),
                    )),
            ],
          ),
        ));
  }

  //Tells players the game is starting, dissappears after 3 seconds
  Future<void> ShowEmptyTeamDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
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
                                    icon:
                                        Icon(Icons.close, color: Colors.white)))
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Your player name cannot be empty!',
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
}
