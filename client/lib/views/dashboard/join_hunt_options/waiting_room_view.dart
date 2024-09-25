import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:praxis_afterhours/apis/teams_api.dart' as teams_api;
import 'package:praxis_afterhours/constants/colors.dart';

import '../../../reusables/hunt_structure.dart';
import '../../team/join_team_page_route.dart';

class TeamWaitingRoomView extends StatelessWidget {
  final Hunt hunt;
  final Team team;
  final String userId;
  final Stream<teams_api.JoinRequestStatus> statusStream;


  const TeamWaitingRoomView({super.key, required this.hunt, required this.team, required this.userId, required this.statusStream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: praxisRed,
      appBar: AppBar(
        backgroundColor: praxisRed,
        elevation: 0,
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: praxisWhite),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Instructions"),
                    content: const Text(
                        "You are currently in the waiting room. You will be assigned to a team shortly."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<teams_api.JoinRequestStatus>(
        stream: statusStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildStatusView(context, snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildStatusView(BuildContext context, teams_api.JoinRequestStatus status) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _buildContent(context, status),
            const SizedBox(height: 16),
            _buildButtons(context, status),
            // const SizedBox(height: 16),
            // _buildTestingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, teams_api.JoinRequestStatus status) {
    switch (status) {
      case teams_api.JoinRequestStatus.rejected:
        return const Column(
          children: [
            Icon(Icons.close, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "You have been kicked from the waiting room.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case teams_api.JoinRequestStatus.accepted:
        return const Column(
          children: [
            Icon(Icons.check_circle, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "Joined Team!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: 8),
            // Text(
            //   '"Recruit Mixer" is starting in 1 minute 15 seconds!',
            //   style: TextStyle(fontSize: 18, color: praxisWhite),
            //   textAlign: TextAlign.center,
            // ),
          ],
        );
      case teams_api.JoinRequestStatus.pending:
        return const Column(
          children: [
            Icon(Icons.hourglass_empty, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "Waiting for Team Leader",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // not implemented yet, requires minor API change
            // Text(
            //   "... don't worry! there are only 4 other people requesting this team",
            //   style: TextStyle(fontSize: 18, color: praxisWhite),
            //   textAlign: TextAlign.center,
            // ),
          ],
        );
      case teams_api.JoinRequestStatus.teamDeleted:
        return const Column(
          children: [
            Icon(Icons.close, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "The team has been deleted.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  Widget _buildButtons(BuildContext context, teams_api.JoinRequestStatus status) {
    switch (status) {
      case teams_api.JoinRequestStatus.rejected:
      case teams_api.JoinRequestStatus.teamDeleted:
        return ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: praxisRed,
            backgroundColor: praxisWhite,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "See other teams",
            style: TextStyle(fontSize: 18),
          ),
        );
      case teams_api.JoinRequestStatus.accepted:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  JoinTeamPageRoute(
                    hunt: hunt,
                    team: team,
                    userId: userId,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: praxisRed,
                backgroundColor: praxisWhite,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "My Team",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Handle "Instructions" button press
              },
              child: const Text(
                "Instructions",
                style: TextStyle(fontSize: 18, color: praxisWhite),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Handle "Exit Challenge" button press
              },
              child: const Text(
                "Exit Challenge",
                style: TextStyle(fontSize: 18, color: praxisWhite),
              ),
            ),
          ],
        );
      case teams_api.JoinRequestStatus.pending:
        return ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: praxisRed,
            backgroundColor: praxisWhite,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Leave Waiting Room",
            style: TextStyle(fontSize: 18),
          ),
        );
    }
  }

  // Widget _buildTestingButton() {
  //   return ElevatedButton(
  //     onPressed: _updateStatus,
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: praxisRed,
  //       backgroundColor: praxisWhite,
  //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //     ),
  //     child: Text(
  //       "Testing: $status",
  //       style: const TextStyle(fontSize: 14),
  //     ),
  //   );
  // }
}

class WaitingRoomPageRoute extends MaterialPageRoute {
  final Hunt hunt;
  final Team team;
  final String userId;
  final Stream<teams_api.JoinRequestStatus> statusStream;

  WaitingRoomPageRoute({
    required this.hunt,
    required this.team,
    required this.userId,
    required this.statusStream,
  }): super(
    builder: (context) {
      return TeamWaitingRoomView(
        hunt: hunt,
        team: team,
        userId: userId,
        statusStream: statusStream,
      );
    },
  );

  @override
  bool didPop(result) {
    if(kDebugMode) {
      print("Popping Waiting Room Page");
    }
    teams_api.cancelRequestJoinTeam(hunt.id, team.id).then((value) {
      Fluttertoast.showToast(msg: "Left waiting room.");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error leaving waiting room: $error");
    });
    return super.didPop(result);
  }
}

Future<void> openWaitingRoomView(BuildContext context, Hunt hunt, Team team, String userId) async {
  Stream<teams_api.JoinRequestStatus> statusStream = teams_api.requestJoinTeam(hunt.id, team.id);
  Navigator.push(
    context,
    WaitingRoomPageRoute(hunt: hunt, team: team, userId: userId, statusStream: statusStream),
  );
}

