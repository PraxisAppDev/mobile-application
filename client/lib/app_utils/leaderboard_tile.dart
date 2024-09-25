import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/views/team_statistics_view.dart';

class LeaderboardTile extends StatelessWidget {
  final int place;
  final String teamName;
  final int score;

  const LeaderboardTile({
    super.key,
    required this.place,
    required this.teamName,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: praxisGrey,
          boxShadow: [
            BoxShadow(
              color: praxisBlack.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(3, 3),
            )
          ]),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeamStatisticsView(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "#${place.toString()}",
              style: const TextStyle(
                color: praxisBlack,
                fontSize: 35,
              ),
            ),
            Text(
              teamName,
              style: const TextStyle(
                  color: praxisBlack,
                  fontSize: 35,
                  decoration: TextDecoration.underline),
            ),
            Text(
              score.toString(),
              style: const TextStyle(
                color: praxisBlack,
                fontSize: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
