import 'package:flutter/material.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/my_team_create_view.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/apis/post_create_teams.dart';

class CreateATeamView extends StatefulWidget {
  final String huntID;

  const CreateATeamView({super.key, required this.huntID});

  @override
  _CreateATeamViewState createState() => _CreateATeamViewState();
}

class _CreateATeamViewState extends State<CreateATeamView> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _individualNameController = TextEditingController();
  final FocusNode _teamFocusNode = FocusNode();
  final FocusNode _individualFocusNode = FocusNode();
  late Map<String, dynamic> createData = {};

  @override
  void initState() {
    super.initState();
    _teamFocusNode.addListener(() {
      //setState(() {
        //_isFocused = _focusNode.hasFocus;
      //});
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamFocusNode.dispose();
    _individualNameController.dispose();
    _individualFocusNode.dispose();
    super.dispose();
  }

  Future<void> createTeamData() async {
    var data = await createTeam(widget.huntID, _teamNameController.text, _individualNameController.text, true); // Call the imported fetchChallenges function
    setState(() {
      createData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Create Team", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Choose Your Team Name",
                  style: AppStyles.logisticsStyle,
                ),
                const SizedBox(width: 350, child: Divider(thickness: 2)),
                SizedBox(
                  width: 325,
                  child: TextField(
                    controller: _teamNameController,
                    focusNode: _teamFocusNode,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Enter team name here...',
                        labelStyle:
                        TextStyle(color: Colors.white, fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 75,
                  width: 325,
                  padding: const EdgeInsets.all(16),
                  decoration: AppStyles.infoBoxStyle,
                  child: Row(
                    children: [
                      Text(
                        "(Me)",
                        style: AppStyles.logisticsStyle,
                      ),
                      Icon(Icons.person, color: Colors.green),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 205,
                        child: TextField(
                          controller: _individualNameController,
                          focusNode: _individualFocusNode,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit, color: Colors.white),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Enter name here...',
                              labelStyle:
                              TextStyle(color: Colors.white, fontSize: 14),
                              filled: true,
                              fillColor: Colors.grey),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.confirmButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      createTeamData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTeamCreateView(teamName: _teamNameController.text, individualName: _individualNameController.text, teamID: createData["teamId"].toString(), huntID: widget.huntID)),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Create',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.cancelButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartHuntView()),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Start Hunt',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
