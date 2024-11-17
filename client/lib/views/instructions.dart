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
<<<<<<< HEAD
        centerTitle: true,
=======
>>>>>>> 4652eb375c5dee7ca1b699fc80edf431f892060d
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
<<<<<<< HEAD
                        'Both are great options for completing challenges- just '
                        'don\'t forget to name your team!',
=======
                    'Both are great options for completing challenges- just '
                    'don\'t forget to name your team!',
>>>>>>> 4652eb375c5dee7ca1b699fc80edf431f892060d
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(text: 'Challenges...'),
                  _ContentText(
                    'This game is designed to be a fun way to get to know '
<<<<<<< HEAD
                        'Praxis as you break the ice with your peers. There are '
                        'challenges- or questions- pertaining to Praxis which help '
                        'make you familiar with the company!',
=======
                    'Praxis as you break the ice with your peers. There are '
                    'challenges- or questions- pertaining to Praxis which help '
                    'make you familiar with the company!',
>>>>>>> 4652eb375c5dee7ca1b699fc80edf431f892060d
                  ),
                  SizedBox(height: 16),
                  _ContentText(
                    'Each challenge is worth anywhere between 200-600 points, '
<<<<<<< HEAD
                        'and the time spent on each question is recorded and can '
                        'be used as a tie-breaker in the event that two teams '
                        'earn the same score!',
=======
                    'and the time spent on each question is recorded and can '
                    'be used as a tie-breaker in the event that two teams '
                    'earn the same score!',
>>>>>>> 4652eb375c5dee7ca1b699fc80edf431f892060d
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(text: 'Hints...'),
                  _ContentText(
                    'Each challenge comes with three available hints relevant '
<<<<<<< HEAD
                        'to the question- but beware! A hint will cost some points!',
=======
                    'to the question- but beware! A hint will cost some points!',
>>>>>>> 4652eb375c5dee7ca1b699fc80edf431f892060d
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(text: 'Team Leader vs Team Member...'),
                  _ContentText(
                    'If you join a team before the game starts, you can leave '
<<<<<<< HEAD
                        'freely. Once the team reaches four members, the game begins '
                        'automatically. The team leader can start the game early with '
                        'fewer than four members and is the only one who can submit '
                        'answers and review hints.',
=======
                    'freely. Once the team reaches four members, the game begins '
                    'automatically. The team leader can start the game early with '
                    'fewer than four members and is the only one who can submit '
                    'answers and review hints.',
>>>>>>> 4652eb375c5dee7ca1b699fc80edf431f892060d
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
// import 'package:flutter/material.dart';
// import 'package:praxis_afterhours/constants/colors.dart';
//
// class Instructions extends StatelessWidget {
//   const Instructions({super.key, required this.title});
//   final String title;
//   final EdgeInsets margins = const EdgeInsets.all(16.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'How to Play',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: praxisWhite,
//           ),
//         ),
//         backgroundColor: praxisRed,
//         iconTheme: const IconThemeData(color: praxisWhite),
//       ),
//       body: Container(
//         color: praxisWhite,
//         child: Padding(
//           padding: margins,
//           child: const SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Welcome to AFTERHOURS Hunts – an exhilarating experience where participants, either as individuals or teams, embark on a journey to solve a series of captivating challenges while immersing themselves in the world of Praxis. Combine your diverse talents, collaborate strategically, and unleash your creativity to triumph over each obstacle that stands in your way.\n',
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(fontSize: 18, color: praxisBlack),
//                 ),
//                 Divider(color: praxisRed, thickness: 2),
//                 SizedBox(height: 16),
//                 Text(
//                   'Instructions:',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: praxisBlack,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '1. Each challenge presents a unique puzzle to solve. Work together to find the solution, but remember, you have a limited number of attempts per challenge. A timer will determine when you can make your next attempt.\n\n'
//                   '2. Detailed instructions for each challenge can be found on its respective page.\n\n'
//                   '3. Keep track of your progress and see how your team compares to others by accessing the leaderboard through the menu icon. Stay motivated and strive for the top spot!\n\n'
//                   '4. If you find yourself in need of assistance, don\'t hesitate to reach out to your fellow participants or the Praxis staff overseeing the event. They are here to guide and support you on your quest.\n\n'
//                   '5. Prepare yourself for an unforgettable adventure that will test your wits, teamwork, and determination.\n\n'
//                   'Let the hunt begin, and may the odds be ever in your favor!',
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(fontSize: 18, color: praxisBlack),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }