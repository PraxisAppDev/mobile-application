import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_teams.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;
import 'package:praxis_afterhours/apis/hunts_api.dart';
import 'package:praxis_afterhours/apis/post_join_team.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import '../../apis/new_teams_api.dart';
import 'my_team_view.dart';
import 'package:praxis_afterhours/apis/new_teams_api.dart' as teams_api;
// import 'package:provider/provider.dart';
// import 'package:praxis_afterhours/provider/websocket_model.dart';

class JoinATeamView extends StatelessWidget {
  const JoinATeamView({super.key, required this.huntID});
  final String huntID;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Join A Team", context),
        body: DecoratedBox(
            decoration: AppStyles.backgroundStyle,
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchTeamsFromHunt(huntID!),
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
                          huntID: huntID,
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

  // Function to handle the join_team API call and navigate to MyTeamView after successful joining
  void _handleJoinTeam(BuildContext context) async {
    try {
      await joinTeam(widget.huntID, widget.teamName, "placeholder");

      /* FOR TESTING PURPOSES */
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Successfully joined ${widget.teamName} with response ${response}')),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyTeamView(
            huntID: widget.huntID,
            teamID: widget.teamID,
          ),
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
}
