import 'package:flutter/material.dart';
import 'package:praxis_afterhours/app_utils/leaderboard_tile.dart';
import 'package:praxis_afterhours/constants/colors.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            color: praxisWhite,
            fontSize: 50,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Column(
            children: [
              Text(
                "Recruit Mixer",
                style: TextStyle(
                  color: praxisWhite,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: praxisRed,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: praxisRed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: praxisWhite,
                      width: 3,
                    ),
                  ),
                  child: const Text(
                    "Exit",
                    style: TextStyle(
                      color: praxisWhite,
                      fontSize: 35,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: praxisWhite,
                      width: 3,
                    ),
                  ),
                  child: const Text(
                    "Review",
                    style: TextStyle(
                      color: praxisWhite,
                      fontSize: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30.0),
            child: const Column(
              children: [
                LeaderboardTile(place: 1, teamName: "49ers", score: 5555),
                SizedBox(height: 30),
                LeaderboardTile(place: 2, teamName: "Chiefs", score: 4444),
                SizedBox(height: 30),
                LeaderboardTile(place: 3, teamName: "Ravens", score: 3333),
                SizedBox(height: 30),
                LeaderboardTile(place: 4, teamName: "Lions", score: 2222),
                SizedBox(height: 30),
                LeaderboardTile(place: 5, teamName: "Packers", score: 2211),
                SizedBox(height: 30),
                LeaderboardTile(place: 6, teamName: "Broncos", score: 999),
                SizedBox(height: 30),
                LeaderboardTile(place: 7, teamName: "Raiders", score: 870),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
