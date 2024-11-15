import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/fetch_leaderboard.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  String formatDate(String dateString) {
      String cleanDate = dateString.replaceAll(RegExp(r'\[UTC\]'), '');
      DateTime dater = DateTime.parse(cleanDate);
      return DateFormat('  MM/dd/yyyy ' ' h:mm a').format(dater);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.noLeaderboardAppBarStyle("Leaderboard", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: Center(
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchLeaderboard("1"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                );
              } else if (snapshot.hasData) {
                print(snapshot.data);

                String huntName = snapshot.data?['huntName'];
                // String huntVenue = snapshot.data?['venue'];
                String formattedDate = formatDate(snapshot.data?['startDate']);

                List<dynamic> teams = snapshot.data?['teamsChallengeResults'];
                List<String> teamNames =
                    teams.map((team) => team['teamName'] as String).toList();

                return DecoratedBox(
                  decoration: AppStyles.backgroundStyle,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 350,
                          padding: const EdgeInsets.all(16),
                          decoration: AppStyles.infoBoxStyle,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                huntName,
                                style: AppStyles.logisticsStyle,
                              ),
                              const SizedBox(height: 10),
                              // Text(
                              //   huntVenue,
                              //   style: AppStyles.logisticsStyle
                              //       .copyWith(fontSize: 14),
                              // ),
                              // const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    formattedDate,
                                    style: AppStyles.logisticsStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              final team = teams[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                decoration: AppStyles.infoBoxStyle,
                                child: ExpansionTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Colors.white, // Color of the ring
                                        width: 2.0, // Thickness of the ring
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Text("${index + 1}",
                                          style: AppStyles.logisticsStyle
                                              .copyWith(fontSize: 24)),
                                    ),
                                  ),
                                  title: Text(
                                    team['teamName'],
                                    style: AppStyles.logisticsStyle
                                        .copyWith(fontSize: 24),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  collapsedBackgroundColor: Colors.transparent,
                                  // trailing: const Icon(Icons.arrow_drop_down,
                                  //     color: Colors.white,
                                  //     size: 50),
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                      color: Colors.white,
                                                      width: 1),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "Challenge",
                                                style: AppStyles.logisticsStyle
                                                    .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                      color: Colors.white,
                                                      width: 1),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "Score",
                                                style: AppStyles.logisticsStyle
                                                    .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Time",
                                              style: AppStyles.logisticsStyle
                                                  .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider below header
                                    Divider(
                                      color: Colors.white,
                                      thickness: 1,
                                      height: 1,
                                      indent: 15,
                                      endIndent: 15,
                                    ),
                                    for (var i = 0;
                                        i < team['challengeResults'].length;
                                        i++) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                ),
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Text(
                                                  team['challengeResults'][i]['name'],
                                                  style: AppStyles
                                                      .logisticsStyle
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  "${team['challengeResults'][i]['score']}",
                                                  style: AppStyles
                                                      .logisticsStyle
                                                      .copyWith(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  formatDate(team['challengeResults'][i]['timeToComplete']),
                                                  style: AppStyles
                                                      .logisticsStyle
                                                      .copyWith(fontSize: 16),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (i < team['challengeResults'].length - 1)
                                        Divider(
                                          color: Colors.white,
                                          thickness: 1,
                                          height: 1,
                                          indent: 15,
                                          endIndent: 15,
                                        ),
                                    ]
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Text("No data");
              }
            },
          ),
        ),
      ),
    );
  }
}