import 'package:flutter/material.dart';
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            fontFamily: 'InriaSerif',
          ),
        ),
        Container(
          height: 1,
          color: Colors.white,
          margin: const EdgeInsets.only(top: 4, bottom: 16),
        ),
      ],
    );
  }
}
class _ContentText extends StatelessWidget {
  final String text;
  const _ContentText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        height: 1.5,
        fontFamily: 'InriaSerif',
      ),
    );
  }
}
class Instructions extends StatelessWidget {
  const Instructions({super.key, required this.title});
  final String title;
  final EdgeInsets margins = const EdgeInsets.all(16.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_double_arrow_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'How To Play!',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontFamily: 'InriaSerif',
            fontWeight: FontWeight.w300,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF942929),
                Color(0xFF2A0D0D),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF942929),
              Color(0xFF2A0D0D),
            ],
          ),
        ),
        child: Padding(
          padding: margins,
          child: Scrollbar(
            thumbVisibility: true, // Always show the scrollbar
            thickness: 8, // Width of the scrollbar
            radius: const Radius.circular(4), // Rounded corners
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionHeader(text: 'Welcome to the AFTERHOURS Scavenger Hunt Game!'),
                  _ContentText('Get ready for a fun-filled adventure where you will solve a series of challenges to earn points. Whether you\'re playing solo or in a team, the goal is simple: complete all the challenges, score as many points as possible, and be the first to top the leaderboard! The player or team with the highest score at the end of the Hunt wins the Scavenger Hunt!'),
                  SizedBox(height: 24),

                  _SectionHeader(text: 'How to Hunt'),
                  _ContentText('Hunt alone or in a pack...\nSolo Play: You can choose to hunt alone, competing against other players or teams.\nTeam Play: You can form teams. Each team will collaborate to complete challenges and earn points. Teams can consist of up to four players.\n'),
                  SizedBox(height: 24),

                  _SectionHeader(text: 'Start Completing Challenges'),
                  _ContentText('Once the Hunt begins, you’ll will need to solve individual challenges to complete the Hunt. Each challenge has a specific point value and difficulty assigned. Each challenge comes with available hints. But beware! Viewing a hint will cost some points!'),
                  SizedBox(height: 24),

                  _SectionHeader(text: 'Scoring'),
                  _ContentText('Difficulty of Challenge\nEach challenge will be assigned a base point value based on its difficulty level. The more difficult a challenge, the more points it is worth. The point value will be determined by the Hunt organizer before the Hunt starts.'),
                  SizedBox(height: 16),

                  _ContentText('Number of Missed Guesses\nPoints will be deducted for each incorrect attempt to solve the challenge. The more wrong guesses, the lower the challenge score. Each wrong guess reduces the overall points for the challenge. However, after a certain number of incorrect guesses, players will either receive a penalty or be allowed to skip the challenge.'),
                  SizedBox(height: 16),

                  _ContentText('Number of Viewed Hints\nHints are provided to assist players in completing difficult challenges. However, using hints will decrease the points you earn for a challenge. The fewer hints viewed, the higher the challenge score.'),
                  SizedBox(height: 16),

                  _ContentText('Time to Complete the Challenge\nEfficiency is key! The quicker a challenge is completed, the higher the challenge score.'),
                  SizedBox(height: 16),

                  _ContentText('Total Score\nThe sum of all individual challenges scores. The highest score wins the Hunt.'),
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Good luck and happy hunting!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'InriaSerif',
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}