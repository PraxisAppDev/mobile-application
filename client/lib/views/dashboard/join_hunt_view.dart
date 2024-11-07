import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';
import 'package:praxis_afterhours/apis/fetch_hunts.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_options/join_team_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_mode_view.dart';
import 'package:praxis_afterhours/views/instructions.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;
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
  @override
  void initState() {
    super.initState();
  }

  /*final sampleHuntsResponse = [
    {
      'id': 1,
      'name': 'Explore Praxis',
      'venue': 'Green Turtle',
      'address': '123 Green Way',
      'city': 'Columbia',
      'stateAbbr': 'MD',
      'zipcode': '21044',
      'logoURL': 'https://afterhours-content.s3.amazonaws.com/hunt-logo.png',
      'startDate': '2024-11-07T02:51:02.027885208Z[UTC]',
      'endDate': '2024-11-07T02:51:02.027885208Z[UTC]',
      'teamLimit': 4
    },
    {
      'id': 2,
      'name': 'Praxis Intern Challenge',
      'venue': 'Praxis HQ',
      'address': '135 National Business Parkway, Suite 310',
      'city': 'Annapolis Junction',
      'stateAbbr': 'MD',
      'zipcode': '20701',
      'logoURL': 'https://afterhours-content.s3.amazonaws.com/hunt-logo.png',
      'startDate': '2024-11-07T02:51:02.027885208Z[UTC]',
      'endDate': '2024-11-07T02:51:02.027885208Z[UTC]',
      'teamLimit': 4
    },
    {
      'id': 3,
      'name': 'Screaming Bunny Hunt',
      'venue': 'Praxis HQ',
      'address': '135 National Business Parkway, Suite 310',
      'city': 'Annapolis Junction',
      'stateAbbr': 'MD',
      'zipcode': '20701',
      'logoURL': 'https://afterhours-content.s3.amazonaws.com/hunt-logo.png',
      'startDate': '2024-11-07T02:51:02.027885208Z[UTC]',
      'endDate': '2024-11-07T02:51:02.027885208Z[UTC]',
      'teamLimit': 4
    }
  ];*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppStyles.noIconsAppBarStyle("Hunt", context),
        body: DecoratedBox(
            decoration: AppStyles.backgroundStyle,
            //TODO: Non hard coded dates
            child: FutureBuilder<List<dynamic>>(
                future: hunts_api.getHunts(
                    startdate: '2024-10-01', enddate: '2024-10-31', limit: 4),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<dynamic> huntsResponse = snapshot.data!;
                    return ListView.builder(
                      itemCount: huntsResponse.length,
                      itemBuilder: (context, index) {
                        return HuntWidget(hunt: huntsResponse[index]);
                      },
                    );
                  } else {
                    return Center(child: Text('No data available.'));
                  }
                })));
  }
}

DateTime parseToLocal(String startDate) {
  var dateTime = DateFormat("yyyy-mm-ddTHH:mm:ssZ").parse(startDate, true);
  var dateLocal = dateTime.toLocal();

  return dateLocal;
}

class HuntWidget extends StatelessWidget {
  const HuntWidget({
    super.key,
    required this.hunt,
  });

  final hunts_api.HuntResponseModel hunt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: AppStyles.infoBoxStyle
          .copyWith(border: Border.all(color: Colors.black, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 225,
                      child: Text(
                        hunt.name,
                        style: AppStyles.titleStyle.copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                        height: 33,
                        width: 100,
                        decoration: AppStyles.confirmButtonStyle,
                        child: ElevatedButton(
                          style: AppStyles.elevatedButtonStyle,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HuntModeView(
                                  huntId: hunt.id,
                                  huntName: hunt.name,
                                  venue: hunt.venue,
                                  huntDate:
                                      '${DateFormat.yMd().format(parseToLocal(hunt.startDate))} at ${DateFormat.jm().format(parseToLocal((hunt.endDate)))}',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'GO',
                            style: AppStyles.logisticsStyle,
                          ),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                        "${hunt.venue}\n${hunt.address}\n${hunt.city}, ${hunt.stateAbbr} ${hunt.zipcode}",
                        style: AppStyles.logisticsStyle.copyWith(
                            height: 1.2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      style: AppStyles.logisticsStyle.copyWith(
                          height: 1.2,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      '${DateFormat.yMd().format(parseToLocal(hunt.startDate))} at ${DateFormat.jm().format(parseToLocal((hunt.endDate)))}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> joinHuntOptionsDialog(BuildContext context, dynamic hunt) {
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
  final dynamic hunt;

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
            'How do you want to join ${widget.hunt['name']}?',
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
