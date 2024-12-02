import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_view.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_mode_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_with_team_view.dart';
import 'package:praxis_afterhours/apis/put_start_hunt.dart';
import 'package:praxis_afterhours/apis/delete_team.dart';
import 'package:praxis_afterhours/apis/patch_update_team.dart';
import 'package:praxis_afterhours/apis/post_join_team.dart';
import 'package:praxis_afterhours/views/new_screens/my_team_create_view.dart';
import '../../apis/post_create_teams.dart';
import 'package:provider/provider.dart';
import '../../provider/game_model.dart';
import '../../provider/websocket_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateATeamView extends StatefulWidget {
  CreateATeamView({super.key});

  @override
  _CreateATeamViewState createState() => _CreateATeamViewState();
}

class _CreateATeamViewState extends State<CreateATeamView> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();
  final FocusNode _teamFocusNode = FocusNode();
  final FocusNode _playerFocusNode = FocusNode();

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamFocusNode.dispose();
    _playerNameController.dispose();
    _playerFocusNode.dispose();
    super.dispose();
  }

  // Show toast messages for WebSocket events
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Connect to WebSocket after team creation
  void connectWebSocket(WebSocketModel webSocketModel, String huntId, String teamName, String playerName) async {
    final wsUrl = 'ws://afterhours.praxiseng.com/ws/hunt?huntId=$huntId&teamId=$teamName&playerName=$playerName&huntAlone=false';
    try {
      print('Connecting to WebSocket at: $wsUrl');
      webSocketModel.connect(wsUrl);
      print('WebSocket connected successfully.');

      final channel = webSocketModel.messages;
      channel.listen(
            (message) {
          final Map<String, dynamic> data = json.decode(message);
          final String eventType = data['eventType'];

          if (eventType == "PLAYER_JOINED_TEAM") {
            showToast("${data['playerName']} joined the team");
          } else if (eventType == "PLAYER_LEFT_TEAM") {
            showToast("${data['playerName']} left the team");
          } else if (eventType == "HUNT_STARTED") {
            showToast("Hunt started");
          } else if (eventType == "HUNT_ENDED") {
            showToast("Hunt ended");
          } else if (eventType == "CHALLENGE_RESPONSE") {
            showToast("Challenge response received");
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          showToast("WebSocket error: $error");
        },
        onDone: () {
          print('WebSocket closed');
          showToast("WebSocket connection closed");
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      showToast("Failed to connect to WebSocket: $e");
    }
  }

  // Create a team and navigate to the next screen
  void _createTeam(HuntProgressModel model, WebSocketModel webSocketModel) async {
    try {
      // Get user inputs
      final teamName = _teamNameController.text.trim();
      final playerName = _playerNameController.text.trim();

      model.teamName = teamName;
      model.playerName = playerName;

      // Validate inputs
      if (teamName.isEmpty) {
        throw Exception("Team name cannot be empty");
      }
      if (playerName.isEmpty) {
        throw Exception("Player name cannot be empty");
      }

      // Create team
      final response = await createTeam(model.huntId, teamName, playerName, false);
      model.teamId = response['teamId'];

      // Connect to WebSocket
      connectWebSocket(webSocketModel, model.huntId, teamName, playerName);

      // Navigate to the next view
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyTeamCreateView(
            huntId: model.huntId,
            huntName: model.huntName,
            teamId: model.teamId,
            teamName: model.teamName,
            playerName: model.playerName,
          ),
        ),
      );
    } catch (e) {
      print("Failed to create team: $e");
      showToast("Failed to create team: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: true);
    final webSocketModel = Provider.of<WebSocketModel>(context, listen: true);

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
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Enter team name here...',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
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
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Enter name here...',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                            filled: true,
                            fillColor: Colors.grey,
                          ),
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
                    onPressed: () => _createTeam(huntProgressModel, webSocketModel),
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
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