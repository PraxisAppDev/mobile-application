import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view_no_buttons.dart';
import 'package:provider/provider.dart';

import '../../provider/game_model.dart';

class HuntProgressViewNoButtons extends StatefulWidget {
    const HuntProgressViewNoButtons({super.key});

  @override
  _HuntProgressViewNoButtonsState createState() =>
      _HuntProgressViewNoButtonsState();
}

class _HuntProgressViewNoButtonsState extends State<HuntProgressViewNoButtons> {
  List<dynamic> challenges = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    // Add the current round's data to the model
    huntProgressModel.addSecondsSpent(huntProgressModel.secondsSpentThisRound);
    huntProgressModel.addPointsEarned(huntProgressModel.pointsEarnedThisRound);
    huntProgressModel.startTimer();
    fetchChallengesData(); // Fetch challenges when the widget is initialized

    /* WILL CHANGE LATER TO LISTEN TO WEBSOCKET MESSAGE */
    _redirectToChallengeNoButtons(); // hardcoded
  }

  Future<void> _redirectToChallengeNoButtons() async {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    huntProgressModel.previousSeconds = huntProgressModel.totalSeconds;
    huntProgressModel.previousPoints = huntProgressModel.totalPoints;

    try {
      // Fetch challenges data to ensure it's available
      final challenges = await fetchChallenges(huntProgressModel.huntId);

      // Navigate to Challenge 1
      if (challenges.isNotEmpty) {
        huntProgressModel.challengeId = challenges[0]['id'];
        huntProgressModel.challengeNum = 0;
        huntProgressModel.totalChallenges = challenges.length;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeViewNoButtons(
              huntProgressModel.challengeId,
              currentChallenge: 1,
            ),
          ),
        );
      } else {
        // Handle case where no challenges are available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No challenges available for this hunt.")),
        );
      }
    } catch (e) {
      // Handle fetchChallenges error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading challenges: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.noBackArrowAppBarStyle("Hunt Progress", context),
      body: const Center(
        child:
            CircularProgressIndicator(), // Show loading spinner while redirecting
      ),
    );
  }

  Future<void> fetchChallengesData() async {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    var data = await fetchChallenges(
        huntProgressModel.huntId); // Call the imported fetchChallenges function
    setState(() {
      challenges = data; // Update the challenges list
      isLoading = false; // Update loading state
    });
  }

  @override
  void dispose() {
    Provider.of<HuntProgressModel>(context, listen: false).stopTimer();
    super.dispose();
  }

  String secondsToMinutes(int numSeconds) {
    int minutes = numSeconds ~/ 60;
    int seconds = numSeconds % 60;

    if (seconds < 10) {
      return "$minutes:0$seconds";
    }

    return "$minutes:$seconds";
  }
}
