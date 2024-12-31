import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/patch_update_team.dart';
import 'package:praxis_afterhours/apis/post_create_teams.dart';
import 'package:praxis_afterhours/apis/delete_team.dart';
import 'package:praxis_afterhours/apis/post_join_team.dart';
import 'package:praxis_afterhours/apis/post_leave_team.dart';
import 'package:praxis_afterhours/apis/post_solve_challenge.dart';
import 'package:praxis_afterhours/apis/put_start_hunt.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/apis/fetch_hunts.dart';
import 'package:praxis_afterhours/apis/fetch_teams.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class StartHuntView2 extends StatefulWidget {
  const StartHuntView2({super.key});

  @override
  _StartHuntView2State createState() => _StartHuntView2State();
}

class _StartHuntView2State extends State<StartHuntView2> {
  // List<dynamic> challenges = [];
  // List<dynamic> hunts = [];
  late Map<String, dynamic> teams = {};
  late Map<String, dynamic> createData = {};
  late Map<String, dynamic> joinData = {};
  late Map<String, dynamic> updateData = {};
  late Map<String, dynamic> leaveData = {};
  late Map<String, dynamic> deleteData = {};
  late Map<String, dynamic> startData = {};
  late Map<String, dynamic> solveData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchChallengesData();
    // fetchHuntsData();
    // fetchTeamsData();
    createTeamData();
    joinTeamData();
    updateTeamData();
    leaveTeamData();
    deleteTeamData();
    startHuntData();
    solveChallengeData();
  }

  Future<void> createTeamData() async {
    var data = await createTeam("1", "Eagles", "Andy", true); // Call the imported fetchChallenges function
    setState(() {
      createData = data;
      isLoading = false;  // Update loading state
    });
  }

  Future<void> joinTeamData() async {
    var data = await joinTeam("1", "Eagles", "Andy"); // Call the imported fetchChallenges function
    setState(() {
      joinData = data;
      isLoading = false;  // Update loading state
    });
  }

  Future<void> updateTeamData() async {
    var data = await updateTeam("1", "23453", "Birds");
    setState(() {
      updateData = data;
      isLoading = false;  // Update loading state
    });
  }

  Future<void> leaveTeamData() async {
    var data = await leaveTeam("1", "23453", "Andy");
    setState(() {
      leaveData = data;
      isLoading = false;  // Update loading state
    });
  }

  Future<void> deleteTeamData() async {
    var data = await deleteTeam("1", "23453");
    setState(() {
      deleteData = data;
      isLoading = false;  // Update loading state
    });
  }

  Future<void> startHuntData() async {
    var data = await startHunt("1", "23453");
    setState(() {
      startData = data;
      isLoading = false;  // Update loading state
    });
  }

  Future<void> solveChallengeData() async {
    var data = await solveChallenge("1", "23453", "123", 3, 10000, 1, "bob");
    setState(() {
      solveData = data;
      isLoading = false;
    });
  }

  Future<void> fetchTeamsData() async {
    var data = await fetchTeams();
    setState(() {
      teams = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Start Hunt 2", context),
        body: Center(
            child: Column(
              children: [
                Text("Create Team:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: createData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                          '$key: $value',
                          style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("Join Team:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: joinData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nUpdate Team:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: updateData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nLeave Team:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: leaveData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nDelete Team:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: deleteData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nStart Hunt Data:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: startData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nSolve Challenge Data:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: solveData.entries.map((entry) {
                      String key = entry.key;
                      dynamic value = entry.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nEnd", style: TextStyle(fontSize: 12)),
                // const SizedBox(height: 20),
                // Container(
                //   height: 50,
                //   width: 175,
                //   decoration: AppStyles.confirmButtonStyle,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ChallengeView()),
                //       );
                //     },
                //     style: AppStyles.elevatedButtonStyle,
                //     child: const Text('Start Hunt 3',
                //         style: TextStyle(fontWeight: FontWeight.bold)),
                //   ),
                // ),
              ],
            ),
          ),
      ),
    );
  }
}
