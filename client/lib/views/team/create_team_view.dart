import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';
import 'package:praxis_afterhours/views/team/edit_team_view.dart';

import '../../reusables/hunt_structure.dart';

import '../../apis/teams_api.dart' as teams_api;

class CreateTeamView extends StatelessWidget {
  final String userId;
  final Hunt hunt;
  final String initialTeamName;
  final bool lockTeam;
  final Future<Team> futureTeam;

  const CreateTeamView(
      {super.key, required this.userId, required this.hunt, required this.initialTeamName, required this.lockTeam, required this.futureTeam});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureTeam,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            );
          } else {
            return TeamMembersView(
              team: snapshot.data!,
              hunt: hunt,
              editMode: true,
              userId: userId
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Future<CreateTeamManagerRoute> openCreateTeamManagerRoute({required Hunt hunt, required String initialTeamName, required bool lockTeam}) async {
  String? userId = await getUserId();
  Future<Team> team = teams_api.createTeam(hunt.id, initialTeamName, isLocked: lockTeam);
  return CreateTeamManagerRoute(
    view: CreateTeamView(
      hunt: hunt, initialTeamName:
      initialTeamName,
      lockTeam: lockTeam,
      futureTeam: team,
      userId: userId!
    ),
    futureTeam: team
  );
}

class CreateTeamManagerRoute extends MaterialPageRoute {
  final CreateTeamView view;
  Future<Team> futureTeam;

  CreateTeamManagerRoute({required this.view, required this.futureTeam})
      : super(builder: (context) => view);

  Future<Team> createTeam(String huntId, String teamName, {bool isLocked = false}) async {
    return teams_api.createTeam(huntId, teamName, isLocked: isLocked);
  }

  @override
  bool didPop(dynamic result) {
    futureTeam.then((team) {
      return teams_api.removePlayerFromTeam(view.hunt.id, team.id, team.teamLeader);
    }).then((_) {
      Fluttertoast.showToast(msg: "Left team successfully!");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error leaving team: $error");
    });
    super.didPop(result);
    return true;
  }
}