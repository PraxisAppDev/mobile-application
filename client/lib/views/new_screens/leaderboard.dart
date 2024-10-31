
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/fetch_leaderboard.dart';

class Leaderboard extends StatefulWidget {

  const Leaderboard({Key? key}) : super (key: key);

  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBarStyle("Leaderboard Screen", context),
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
                String huntName = snapshot.data?['huntName'];

                //date format is a bit wack, too long. So making it better format
                String rawDate = snapshot.data?['startDate'];
                String cleanDate = rawDate.replaceAll(RegExp(r'\[UTC\]'), '');
                DateTime dater = DateTime.parse(cleanDate);
                String formattedDate = DateFormat('MM/dd/yyyy ' 'at' ' h:mm a').format(dater);


                List<dynamic> teams = snapshot.data?['teamsChallengeResults'];
                List<String> teamNames = teams.map((team) => team['teamName'] as String).toList();

                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 350,
                      padding: const EdgeInsets.all(16),
                      decoration: AppStyles.infoBoxStyle,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                huntName,
                                textAlign: TextAlign.left,
                                style: AppStyles.logisticsStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: Colors.white),
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
                    // Displaying team names
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(16),
                      decoration: AppStyles.infoBoxStyle,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: teamNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              teamNames[index],
                              style: AppStyles.logisticsStyle,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
