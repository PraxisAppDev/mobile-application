import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;

class JoinATeamView extends StatelessWidget {
  const JoinATeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Join A Team Screen'),
          ),
          body: FutureBuilder<List<hunts_api.HuntResponseModel>>(
            future: hunts_api.getHunts(
                startdate: '2024-10-01', enddate: '2024-10-31', limit: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // If the data was successfully retrieved, display it
                final List<hunts_api.HuntResponseModel> huntResponse =
                    snapshot.data!;
                print(snapshot.data);
                return ListView.builder(
                  itemCount: huntResponse.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(huntResponse[index].name),
                      subtitle: Text(huntResponse[index].venue),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No data available.'));
              }
            },
          )),
    );
  }
}

// * will change based on state *
// holds list of all teams that are available
// list of TeamTile objects
class TeamList extends StatefulWidget {
  const TeamList({super.key});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  // Hardcoding team data for now
  // ** later teams will be set equal to response from web socket for current teams **
  final List<Map<String, dynamic>> teams = [
    {
      'teamName': 'Chiefs!',
      'members': ['John', 'Doe', 'Jane', 'Smith'],
      'isLocked': true,
    },
    {
      'teamName': 'Bob’s Team',
      'members': ['Bob', 'Alice', 'Jane'],
      'isLocked': false,
    },
    {
      'teamName': 'Science #1',
      'members': ['John B.', 'Melissa'],
      'isLocked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return TeamTile(
          teamName: team['teamName'],
          members: team['members'],
          isLocked: team['isLocked'],
        );
      },
    );
  }
}

// * will change based on state *
// individual team widget
class TeamTile extends StatefulWidget {
  final String teamName;
  final List<String> members;
  final bool isLocked;

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
                  String member = entry.value;
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
                          if (index == 0) // Add crown to the first member
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
                                // Join team functionality
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
