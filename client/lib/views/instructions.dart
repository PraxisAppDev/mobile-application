import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key, required this.title});
  final String title;
  final EdgeInsets margins = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to Play',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: praxisWhite,
          ),
        ),
        backgroundColor: praxisRed,
        iconTheme: const IconThemeData(color: praxisWhite),
      ),
      body: Container(
        color: praxisWhite,
        child: Padding(
          padding: margins,
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to AFTERHOURS Hunts – an exhilarating experience where participants, either as individuals or teams, embark on a journey to solve a series of captivating challenges while immersing themselves in the world of Praxis. Combine your diverse talents, collaborate strategically, and unleash your creativity to triumph over each obstacle that stands in your way.\n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, color: praxisBlack),
                ),
                Divider(color: praxisRed, thickness: 2),
                SizedBox(height: 16),
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: praxisBlack,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Each challenge presents a unique puzzle to solve. Work together to find the solution, but remember, you have a limited number of attempts per challenge. A timer will determine when you can make your next attempt.\n\n'
                  '2. Detailed instructions for each challenge can be found on its respective page.\n\n'
                  '3. Keep track of your progress and see how your team compares to others by accessing the leaderboard through the menu icon. Stay motivated and strive for the top spot!\n\n'
                  '4. If you find yourself in need of assistance, don\'t hesitate to reach out to your fellow participants or the Praxis staff overseeing the event. They are here to guide and support you on your quest.\n\n'
                  '5. Prepare yourself for an unforgettable adventure that will test your wits, teamwork, and determination.\n\n'
                  'Let the hunt begin, and may the odds be ever in your favor!',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, color: praxisBlack),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
