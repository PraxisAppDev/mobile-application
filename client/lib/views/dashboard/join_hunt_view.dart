import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_options/join_team_view.dart';
import 'package:praxis_afterhours/views/instructions.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../team/create_team_view.dart';

class JoinHuntView extends StatefulWidget {
  const JoinHuntView({super.key});

  @override
  State<JoinHuntView> createState() => _JoinHuntViewState();
}

class _JoinHuntViewState extends State<JoinHuntView> {
  List<Hunt> _hunts = [];

  @override
  void initState() {
    super.initState();
    _fetchUpcomingHunts();
  }

  Future<void> _fetchUpcomingHunts() async {
    final response =
        await http.get(Uri.parse('http://localhost:8001/hunts/upcoming'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> huntData = jsonData['content'];

      setState(() {
        _hunts = huntData.map((hunt) => Hunt.fromJson(hunt)).toList();
      });
    } else {
      // Handle error case
      if (kDebugMode) {
        print('Failed to fetch upcoming hunts');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              centerTitle: false,
              title: Text(
                "Join A Hunt",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Instructions(
                        title: 'Instructions',
                      ),
                    ),
                  )
                },
                icon: const Icon(Icons.info_outline),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.notifications),
              ),
            ],
            backgroundColor: praxisRed,
            elevation: 0,
          ),
          _hunts.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No hunts available!",
                      style: GoogleFonts.poppins(
                        color: praxisBlack,
                        fontSize: 32,
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final hunt = _hunts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: HuntWidget(hunt: hunt)
                            .animate(
                              delay: 150.milliseconds * index,
                            )
                            .fade()
                            .slideY(
                              begin: 0.5,
                              end: 0,
                            ),
                      );
                    },
                    childCount: _hunts.length,
                  ),
                ),
        ],
      ),
    );
  }
}

class HuntWidget extends StatelessWidget {
  const HuntWidget({
    super.key,
    required this.hunt,
  });

  final Hunt hunt;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        joinHuntOptionsDialog(context, hunt);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/praxis-afterhours-hunt-thumbnail.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hunt.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hunt.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: praxisRed,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: AutoSizeText(
                            'Open from ${DateFormat().format(hunt.startDate)} to ${DateFormat().format(hunt.endDate)}',
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 14,
                              color: praxisRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: praxisRed,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hunt.huntLocation.locationName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: praxisRed,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          joinHuntOptionsDialog(context, hunt);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: praxisWhite,
                          backgroundColor: praxisRed,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Join Hunt",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> joinHuntOptionsDialog(BuildContext context, Hunt hunt) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: JoinHuntOptionsDialogContent(hunt: hunt),
        );
      },
    );
  }
}

class JoinHuntOptionsDialogContent extends StatefulWidget {
  final Hunt hunt;

  const JoinHuntOptionsDialogContent({
    super.key,
    required this.hunt,
  });

  @override
  State<JoinHuntOptionsDialogContent> createState() =>
      _JoinHuntOptionsDialogContentState();
}

class _JoinHuntOptionsDialogContentState
    extends State<JoinHuntOptionsDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'How do you want to join ${widget.hunt.name}?',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              //close this dialog and open a new one to join a team
              Navigator.pop(context);
              String? userId = await getUserId();
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinTeamView(
                    hunt: widget.hunt,
                    userId: userId!,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: praxisRed,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Join Team',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              //close this dialog and open a new one to enter a team name
              Navigator.pop(context);
              showCreateHuntTeamNameDialog(context,
                  hunt: widget.hunt, isLocked: false);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: praxisRed,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Create Team',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              //close this dialog and open a new one to join a hunt alone
              Navigator.pop(context);
              showCreateHuntTeamNameDialog(context,
                  hunt: widget.hunt, isLocked: true);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: praxisRed,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Hunt Alone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCreateHuntTeamNameDialog(BuildContext context,
    {required Hunt hunt, required bool isLocked}) {
  final TextEditingController newTeamNameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isLocked ? 'Enter your team name' : 'Enter a team name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Team Name',
                ),
                controller: newTeamNameController,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  //close this dialog and open a new one to create a team
                  Navigator.pop(context);
                  MaterialPageRoute route = await openCreateTeamManagerRoute(
                    hunt: hunt,
                    initialTeamName: newTeamNameController.text,
                    lockTeam: isLocked,
                  );
                  if (!context.mounted) return;
                  Navigator.push(context, route);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: praxisRed,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      isLocked ? 'Join as Individual' : 'Create Team',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
