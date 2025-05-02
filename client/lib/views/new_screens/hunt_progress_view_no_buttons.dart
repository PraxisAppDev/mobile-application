// import 'package:flutter/material.dart';
// import 'package:praxis_afterhours/apis/fetch_challenges.dart';
// import 'package:praxis_afterhours/styles/app_styles.dart';
// import 'package:praxis_afterhours/views/new_screens/challenge_view_no_buttons.dart';
// import 'package:provider/provider.dart';

// import '../../provider/game_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view_no_buttons.dart';
import 'package:praxis_afterhours/views/new_screens/end_game_view.dart';

import '../../provider/game_model.dart';
import '../../provider/websocket_model.dart';

class HuntProgressViewNoButtons extends StatefulWidget {
    const HuntProgressViewNoButtons({super.key});

  @override
  State<HuntProgressViewNoButtons> createState() =>
      _HuntProgressViewNoButtonsState();
}

class _HuntProgressViewNoButtonsState extends State<HuntProgressViewNoButtons> {
  List<dynamic> challenges = [];
  bool isLoading = true; // Loading state

  late ConfettiController _confettiController;


  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    final webSocketModel = Provider.of<WebSocketModel>(context, listen: false);
    // Add the current round's data to the model
    huntProgressModel.addSecondsSpent(huntProgressModel.secondsSpentThisRound);
    huntProgressModel.addPointsEarned(huntProgressModel.pointsEarnedThisRound);
    huntProgressModel.startTimer();
    fetchChallengesData(); // Fetch challenges when the widget is initialized
    connectWebSocket(context, huntProgressModel, webSocketModel);

    /* WILL CHANGE LATER TO LISTEN TO WEBSOCKET MESSAGE */
    // _redirectToChallengeNoButtons(); // hardcoded
  }

  // Future<void> _redirectToChallengeNoButtons() async {
  //   final huntProgressModel =
  //       Provider.of<HuntProgressModel>(context, listen: false);
  //   huntProgressModel.previousSeconds = huntProgressModel.totalSeconds;
  //   huntProgressModel.previousPoints = huntProgressModel.totalPoints;
  //   try {
  //     // Fetch challenges data to ensure it's available
  //     final challenges = await fetchChallenges(huntProgressModel.huntId);

  //     // Navigate to Challenge 1
  //     if (challenges.isNotEmpty) {
  //       huntProgressModel.challengeId = challenges[0]['id'];
  //       huntProgressModel.challengeNum = 0;
  //       huntProgressModel.totalChallenges = challenges.length;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChallengeViewNoButtons(
  //             huntProgressModel.challengeId,
  //             currentChallenge: 1,
  //           ),
  //         ),
  //       );
  //     } else {
  //       // Handle case where no challenges are available
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text("No challenges available for this hunt.")),
  //       );
  //     }
  //   } catch (e) {
  //     // Handle fetchChallenges error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error loading challenges: $e")),
  //     );
  //   }
  // }
  
  
  void connectWebSocket(
    BuildContext context, 
    HuntProgressModel huntProgressModel, 
    WebSocketModel webSocketModel ) async {
    
    final wsUrl = 'wss://scavengerhunt.afterhoursdev.com/ws/scavengerhunt?huntId=${huntProgressModel.huntId}&teamId=${huntProgressModel.teamId}&playerName=${huntProgressModel.playerName}&huntAlone=false';

    try {
      print('Connecting to WebSocket at: $wsUrl');
      webSocketModel.connect(wsUrl);
      print('WebSocket connected successfully.');
      final channel = webSocketModel.messages;
      channel.listen(
        (message) {
          final Map<String, dynamic> data = json.decode(message);
          print("Incoming web socket message: {$data}");
          final eventType = data['messageType'];

          if (eventType == 'CHALLENGE_STARTED') {
            huntProgressModel.previousSeconds = huntProgressModel.totalSeconds;
            huntProgressModel.previousPoints = huntProgressModel.totalPoints;
            huntProgressModel.currentChallenge += 1;
            huntProgressModel.challengeNum = huntProgressModel.currentChallenge;
            huntProgressModel.challengeId = data['challengeId'];

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengeViewNoButtons(
                  huntProgressModel.challengeId,
                  currentChallenge: huntProgressModel.currentChallenge,
                ),
              ),
            );
          }
          // print('Received message: $message');
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket connection closed.');
          showToast("WebSocket connection closed");
        },
        cancelOnError: true,
      );
    } catch (e) {
      // print('Failed to connect to WebSocket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to WebSocket: $e')),
      );
    }
    
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> fetchChallengesData() async {
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    var data = await fetchChallenges(
        huntProgressModel.huntId); // Call the imported fetchChallenges function
    setState(() {
      challenges = data; // Update the challenges list
      huntProgressModel.totalChallenges = challenges.length;
      isLoading = false; // Update loading state
    });

    if (huntProgressModel.currentChallenge >= data.length) {
      _confettiController.play();
      huntProgressModel.stopTimer();
      _showCompletionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel = Provider.of<HuntProgressModel>(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppStyles.noBackArrowAppBarStyle("Hunt Progress", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: Column(
          children: [
            const SizedBox(height: 25),
            _buildStatsBox(huntProgressModel),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: challenges.length,
                itemBuilder: (context, index) => _buildChallengeTile(
                    index, challenges, huntProgressModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    Provider.of<HuntProgressModel>(context, listen: false).stopTimer();
    super.dispose();
  }

Widget _buildStatsBox(HuntProgressModel model) {
    final minutes = (model.secondsSpent ~/ 60).toString().padLeft(2, '0');
    final seconds = (model.secondsSpent % 60).toString().padLeft(2, '0');

    return Container(
      width: 350,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.infoBoxStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.huntName, style: AppStyles.logisticsStyle),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white),
              Text('$minutes:$seconds', style: AppStyles.logisticsStyle),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.two_mp_outlined, color: Colors.white),
              Text("${model.totalPoints} points",
                  style: AppStyles.logisticsStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeTile(
      int index, List<dynamic> challengeData, HuntProgressModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildCircle(index, model),
            _buildLine(index, model),
          ],
        ),
        Container(
          height: 160,
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: AppStyles.challengeBoxStyle(index, model.currentChallenge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(challengeData[index]['description'],
                  style: AppStyles.logisticsStyle),
              const SizedBox(height: 10),
              _buildTimerRow(index, model),
              const SizedBox(height: 10),
              _buildPointsRow(index, model),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(int index, HuntProgressModel model) {
    return Container(
      width: 20.0,
      height: 20.0,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index < model.currentChallenge
            ? Colors.green
            : index > model.currentChallenge
                ? Colors.grey
                : Colors.amber,
        border: Border.all(
          color: index < model.currentChallenge
              ? Colors.greenAccent
              : index > model.currentChallenge
                  ? Colors.grey
                  : Colors.amberAccent,
        ),
      ),
      child: Center(
        child: Text('${index + 1}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildLine(int index, HuntProgressModel model) {
    return Container(
      width: 5,
      height: 160,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: index < model.currentChallenge
            ? Colors.green
            : index > model.currentChallenge
                ? Colors.grey
                : Colors.amber,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildTimerRow(int index, HuntProgressModel model) {
    return Row(
      children: [
        const Icon(Icons.timer, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          index < model.currentChallenge
              ? secondsToMinutes(model.secondsSpentList[index + 1])
              : "Locked",
          style: AppStyles.logisticsStyle,
        ),
        const Spacer(),
        SizedBox(width: 75), // Placeholder where "GO" button would go
      ],
    );
  }

  Widget _buildPointsRow(int index, HuntProgressModel model) {
    return Row(
      children: [
        const Icon(Icons.two_mp_outlined, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          index < model.currentChallenge
              ? "${model.pointsEarnedList[index + 1]} points"
              : "- points possible",
          style: AppStyles.logisticsStyle,
        ),
      ],
    );
  }

  void _showCompletionDialog(BuildContext context) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.black.withOpacity(0.8),
              contentPadding: EdgeInsets.zero,
              content: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff261919),
                      Color(0xff332323),
                      Color(0xff261919),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Congratulations! You completed all challenges!',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 50,
                        width: 125,
                        decoration: AppStyles.confirmButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            huntProgressModel.markHuntCompleted(
                                huntProgressModel.currentHuntIndex);
                            huntProgressModel.totalPoints = 0;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EndGameScreen()),
                            );
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text(
                            'Continue',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ],
        );
      },
    );
  }

  String secondsToMinutes(int numSeconds) {
    int minutes = numSeconds ~/ 60;
    int seconds = numSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}


