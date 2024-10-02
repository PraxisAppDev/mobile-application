import 'package:flutter/material.dart';

class JoinATeamView extends StatelessWidget {
  const JoinATeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Join A Team Screen'),
        ),
        body: const TeamList(),
        // body: const Center(
        //   child: Text(
        //     'Join A Team Screen, waiting for team leader to start hunt...',
        //     style: TextStyle(fontSize: 24), // Set font size
        //   ),
        // ),
      ),
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
      'members': ['Bob', 'Alice'],
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
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.teamName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (widget.isLocked)
                  const Icon(Icons.lock, color: Colors.grey),
                Text("(${widget.members.length}/4)",
                    style: const TextStyle(fontSize: 16)),
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
              return ListTile(
                leading: const Icon(Icons.person),
                title: Row(
                  children: [
                    Text(member),
                    if (index == 0) // Add crown to the first member
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.star, color: Colors.amber),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: widget.isLocked
                  ? null // Disable button if team is locked
                  : () {
                      // Join team functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Joined ${widget.teamName}')),
                      );
                      // // *****************
                      // setState(() {
                      //   widget.members.add();
                      // });
                      // // **************
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLocked
                    ? Colors.grey
                    : Colors.redAccent, // Button color
              ),
              child: const Text('Join Team!'),
            ),
          ),
        ],
      ),
    );
  }
}