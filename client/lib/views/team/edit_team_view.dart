/*import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/apis/teams_api.dart' as teams_api;
import 'package:praxis_afterhours/views/hunt/get_ready_hunt.dart';
import 'package:praxis_afterhours/views/leaderboard_view.dart';

import '../../reusables/hunt_structure.dart';

class TeamMembersView extends StatelessWidget {
  final String userId;
  final Team team;
  final Hunt hunt;
  final bool editMode;

  const TeamMembersView(
      {super.key,
      required this.userId,
      required this.team,
      required this.hunt,
      required this.editMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 165,
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 16,
                bottom: 75,
              ),
              centerTitle: false,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  team.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardView(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.leaderboard,
                  size: 50,
                ),
              )
            ],
            backgroundColor: praxisRed,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TeamMembersListView(hunt: hunt, team: team, userId: userId),
                  if (editMode) const SizedBox(height: 8),
                  if (editMode) const Divider(),
                  if (editMode) const SizedBox(height: 8),
                  if (editMode)
                    TeamRequestsView(hunt: hunt, team: team, userId: userId),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (await _confirmLeaveTeam(context)) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: praxisRed,
                    ),
                    child: const Text('Leave Team'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GetReadyHuntView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: praxisRed,
                    ),
                    child: const Text('I\'m Ready!'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmLeaveTeam(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 215),
        backgroundColor: praxisGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.black),
        ),
        title: const Text('Leave Team?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Leave'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class TeamRequestsView extends StatelessWidget {
  final String userId;
  final Hunt hunt;
  final Team team;
  final Stream<List<String>> _requests;

  TeamRequestsView(
      {super.key, required this.userId, required this.hunt, required this.team})
      : _requests = teams_api.watchListJoinRequestsForTeam(hunt.id, team.id);

  List<String> _sortJoinRequests(List<String> requests) {
    requests.sort((a, b) {
      if (a == team.teamLeader) {
        return -1;
      } else if (b == team.teamLeader) {
        return 1;
      } else if (a == userId) {
        return -1;
      } else if (b == userId) {
        return 1;
      } else {
        return a.compareTo(b);
      }
    });
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _requests.map(_sortJoinRequests),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Text(
                'Requests',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (snapshot.data?.isEmpty ?? false)
                const Text(
                  'No pending requests.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final request = snapshot.data?[index];
                    return ListTile(
                      leading:
                          const CircleAvatar(child: Icon(Icons.person_add)),
                      title: Text(request!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => _acceptRequest(request),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _rejectRequest(request),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        }
      },
    );
  }

  void _acceptRequest(String request) async {
    teams_api.TeamOperationSuccessMessage message =
        await teams_api.acceptRequestJoinTeam(hunt.id, team.id, request);
    Fluttertoast.showToast(msg: message.message);
  }

  void _rejectRequest(String request) async {
    teams_api.TeamOperationSuccessMessage message =
        await teams_api.rejectRequestJoinTeam(hunt.id, team.id, request);
    Fluttertoast.showToast(msg: message.message);
  }
}

class TeamMembersListView extends StatelessWidget {
  final String userId;
  final Hunt hunt;
  final Team team;
  final Stream<List<Player>> _teamMembers;

  List<Player> _sortTeamMembers(List<Player> requests) {
    requests.sort((a, b) {
      if (a.playerId == team.teamLeader) {
        return -1;
      } else if (b.playerId == team.teamLeader) {
        return 1;
      } else if (a.playerId == userId) {
        return -1;
      } else if (b.playerId == userId) {
        return 1;
      } else {
        return a.playerId.compareTo(b.playerId);
      }
    });
    return requests;
  }

  TeamMembersListView(
      {super.key, required this.userId, required this.hunt, required this.team})
      : _teamMembers = teams_api.watchListPlayersForTeam(hunt.id, team.id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _teamMembers.map(_sortTeamMembers),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Text(
                'Team Members',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (snapshot.data?.isEmpty ?? false)
                const Text(
                  'No team members yet.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final member = snapshot.data?[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(member!.playerId),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeMember(member),
                      ),
                    );
                  },
                ),
            ],
          );
        }
      },
    );
  }

  void _removeMember(Player member) async {
    teams_api.TeamOperationSuccessMessage message =
        await teams_api.removePlayerFromTeam(hunt.id, team.id, member.playerId);
    Fluttertoast.showToast(msg: message.message);
  }
}*/
