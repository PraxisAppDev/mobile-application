import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../reusables/hunt_structure.dart';

import '../../apis/teams_api.dart' as teams_api;
import 'edit_team_view.dart';

class JoinTeamPageRoute extends MaterialPageRoute {
  final Hunt hunt;
  final Team team;
  final String userId;

  JoinTeamPageRoute({
    required this.hunt,
    required this.team,
    required this.userId,
  }): super(
    builder: (context) {
      return TeamMembersView(
        hunt: hunt,
        team: team,
        userId: userId,
        editMode: false,
      );
    },
  );

  @override
  bool didPop(result) {
    teams_api.removePlayerFromTeam(hunt.id, team.id, userId).then((_) {
      Fluttertoast.showToast(msg: "Successfully left team!");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error leaving team: $error");
    });
    return super.didPop(result);
  }
}