import 'package:flutter/material.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/my_team_create_view.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/apis/post_create_teams.dart';
import 'package:praxis_afterhours/apis/patch_update_team.dart';
import 'package:provider/provider.dart';

import '../../provider/game_model.dart';
import '../instructions.dart';

class CreateATeamView extends StatefulWidget {
  // final String huntId;
  // final String huntName;
  // String? teamId;
  // CreateATeamView({super.key, required this.huntId, this.teamId, required this.huntName});
  CreateATeamView({super.key});

  @override
  _CreateATeamViewState createState() => _CreateATeamViewState();
}

class _CreateATeamViewState extends State<CreateATeamView> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();
  final FocusNode _teamFocusNode = FocusNode();
  final FocusNode _playerFocusNode = FocusNode();
  //bool _isFocused = false;

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
    _playerNameController.dispose();
    _playerFocusNode.dispose();
    super.dispose();
  }

  Future<String> makeTeam(HuntProgressModel model) async {
    try {
      String playerName = _playerNameController.text.trim();
      if (playerName.isEmpty) {
        throw Exception("Player name cannot be empty");
      }
      String teamName = _teamNameController.text.trim();
      if (teamName.isEmpty) {
        throw Exception("Team name cannot be empty");
      }
      final postResponse =
          await createTeam(model.huntId, teamName, playerName, false);
      return postResponse['teamId'];
    } catch (e) {
      throw e;
    }
  }

  void _createTeam(HuntProgressModel model) async {
    try {
      model.teamId = await makeTeam(model);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyTeamCreateView(
                huntId: model.huntId,
                huntName: model.huntName,
                teamId: model.teamId,
                teamName: _teamNameController.text,
                playerName: _playerNameController.text)),
      );
    } catch (e) {
      print("Failed to create team: $e");
      // Not working
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to create team: $e')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);

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
                          controller: _playerNameController,
                          focusNode: _playerFocusNode,
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
                      _createTeam(huntProgressModel);
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Create',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                // This button leads to a screen that is not supposed to be in the final product
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.cancelButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => StartHuntView(huntID: widget.huntId)),
                              builder: (context) =>
                                  Instructions(title: "Randomness")));
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
