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
