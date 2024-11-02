import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/fetch_leaderboard.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  _LeaderboardState createState() => _LeaderboardState();
}

// class _LeaderboardState extends State<Leaderboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppStyles.appBarStyle("Leaderboard", context),
//       body: DecoratedBox(
//         decoration: AppStyles.backgroundStyle,
//         child: Center(
//           child: FutureBuilder<Map<String, dynamic>>(
//                 future: fetchLeaderboard("1"),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else if (snapshot.hasError) {
//                     return Text(
//                       "Error: ${snapshot.error}",
//                       style: const TextStyle(color: Colors.red),
//                     );
//                   } else if (snapshot.hasData) {
//                 String huntName = snapshot.data?['huntName'];

//                 //date format is a bit wack, too long. So making it better format
//                 String rawDate = snapshot.data?['startDate'];
//                 String cleanDate = rawDate.replaceAll(RegExp(r'\[UTC\]'), '');
//                 DateTime dater = DateTime.parse(cleanDate);
//                 String formattedDate = DateFormat('MM/dd/yyyy ' 'at' ' h:mm a').format(dater);

//                 List<dynamic> teams = snapshot.data?['teamsChallengeResults'];
//                 List<String> teamNames = teams.map((team) => team['teamName'] as String).toList();

//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 150,
//                       width: 350,
//                       padding: const EdgeInsets.all(16),
//                       decoration: AppStyles.infoBoxStyle,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 huntName,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyles.logisticsStyle,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Row(
//                             children: [
//                               const Icon(Icons.calendar_month, color: Colors.white),
//                               Text(
//                                 formattedDate,
//                                 style: AppStyles.logisticsStyle,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     // Displaying team names
//                     Container(
//                       width: 350,
//                       padding: const EdgeInsets.all(16),
//                       decoration: AppStyles.infoBoxStyle,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: teamNames.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(
//                               teamNames[index],
//                               style: AppStyles.logisticsStyle,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               } else {
//                 return const Text("No data");
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    String huntName = "Explore Praxis";
    String huntLocation =
        "The Greene Turtle (in-person only)\n128 Acer Drive\nColumbia, MD 21044";
    String rawDate = "2024-01-30T20:30:00";
    DateTime dater = DateTime.parse(rawDate);
    String formattedDate =
        DateFormat('MM/dd/yyyy ' 'at' ' h:mm a').format(dater);

    List<Map<String, dynamic>> teams = [
      {
        "name": "Rams",
        "challenges": [
          {"name": "Challenge 1", "score": 120, "time": "12 minutes"},
          {"name": "Challenge 2", "score": 100, "time": "10 minutes"},
        ]
      },
      {
        "name": "Steelers",
        "challenges": [
          {"name": "Challenge 1", "score": 120, "time": "12 minutes"},
          {"name": "Challenge 2", "score": 100, "time": "10 minutes"},
        ]
      },
      {
        "name": "Cowboys",
        "challenges": [
          {"name": "Challenge 1", "score": 120, "time": "12 minutes"},
          {"name": "Challenge 2", "score": 100, "time": "10 minutes"},
        ]
      },
      {
        "name": "Miami",
        "challenges": [
          {"name": "Challenge 1", "score": 120, "time": "12 minutes"},
          {"name": "Challenge 2", "score": 100, "time": "10 minutes"},
        ]
      },
      {
        "name": "Giants",
        "challenges": [
          {"name": "Challenge 1", "score": 120, "time": "12 minutes"},
          {"name": "Challenge 2", "score": 100, "time": "10 minutes"},
        ]
      },
    ];

    return Scaffold(
      appBar: AppStyles.appBarStyle("Leaderboard", context),
      body: DecoratedBox(
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
                    Text(
                      huntLocation,
                      style: AppStyles.logisticsStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white),
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

              // TODO: Fix styling
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
                              color: Colors.white, // Color of the ring
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
                          team['name'],
                          style:
                              AppStyles.logisticsStyle.copyWith(fontSize: 24),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            color: Colors.white, width: 1),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      "Challenge",
                                      style: AppStyles.logisticsStyle.copyWith(
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
                                            color: Colors.white, width: 1),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      "Score",
                                      style: AppStyles.logisticsStyle.copyWith(
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
                                    style: AppStyles.logisticsStyle.copyWith(
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
                              i < team['challenges'].length;
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
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        team['challenges'][i]['name'],
                                        style: AppStyles.logisticsStyle
                                            .copyWith(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        "${team['challenges'][i]['score']}",
                                        style: AppStyles.logisticsStyle
                                            .copyWith(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        team['challenges'][i]['time'],
                                        style: AppStyles.logisticsStyle
                                            .copyWith(fontSize: 16),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i < team['challenges'].length - 1)
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
      ),
    );
  }
}