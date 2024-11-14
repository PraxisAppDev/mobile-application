import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
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
                  _SectionHeader(text: 'Hunt alone or in a pack...'),
                  _ContentText(
                    'Want to go solo? Or perhaps hunt with some friends? '
                    'Both are great options for completing challenges- just '
                    'don\'t forget to name your team!',
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(text: 'Challenges...'),
                  _ContentText(
                    'This game is designed to be a fun way to get to know '
                    'Praxis as you break the ice with your peers. There are '
                    'challenges- or questions- pertaining to Praxis which help '
                    'make you familiar with the company!',
                  ),
                  SizedBox(height: 16),
                  _ContentText(
                    'Each challenge is worth anywhere between 200-600 points, '
                    'and the time spent on each question is recorded and can '
                    'be used as a tie-breaker in the event that two teams '
                    'earn the same score!',
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(text: 'Hints...'),
                  _ContentText(
                    'Each challenge comes with three available hints relevant '
                    'to the question- but beware! A hint will cost some points!',
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(text: 'Team Leader vs Team Member...'),
                  _ContentText(
                    'If you join a team before the game starts, you can leave '
                    'freely. Once the team reaches four members, the game begins '
                    'automatically. The team leader can start the game early with '
                    'fewer than four members and is the only one who can submit '
                    'answers and review hints.',
                  ),
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
