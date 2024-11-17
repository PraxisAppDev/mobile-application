import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/apis/post_solve_challenge.dart';
import 'package:provider/provider.dart';
import '../../provider/game_model.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';

class ChallengeViewNoButtons extends StatefulWidget {
  // final String huntName;
  // final String huntID;
  // final String teamID;
  // final int previousSeconds;
  // final int previousPoints;
  // final String challengeID;
  // final int challengeNum;
  //
  // const ChallengeViewNoButtons({
  //   super.key,
  //   required this.huntName,
  //   required this.huntID,
  //   required this.teamID,
  //   required this.previousSeconds,
  //   required this.previousPoints,
  //   required this.challengeID,
  //   required this.challengeNum,
  // });

  const ChallengeViewNoButtons({super.key});
  @override
  _ChallengeViewNoButtonsState createState() => _ChallengeViewNoButtonsState();
}

class _ChallengeViewNoButtonsState extends State<ChallengeViewNoButtons> {
  int _totalSeconds =
  0; // cumulative state var to track total seconds spent on current challenge + all previous challanges

  @override
  void initState() {
    super.initState();
    final huntProgressModel =
    Provider.of<HuntProgressModel>(context, listen: false);
    _totalSeconds = huntProgressModel.previousSeconds;
  }

  // Callback func to update total seconds, will be called from HeaderWidget
  void _updateTotalSeconds(int seconds) {
    setState(() {
      _totalSeconds = seconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel =
    Provider.of<HuntProgressModel>(context, listen: false);

    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.noBackArrowAppBarStyle("Hunt", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Column(
            children: [
              const SizedBox(height: 10), // Adds padding above the header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HeaderWidget(
                  huntName: huntProgressModel.huntName,
                  huntID: huntProgressModel.huntId,
                  challengeID: huntProgressModel.challengeId,
                  challengeNum: huntProgressModel.challengeNum,
                  previousSeconds: huntProgressModel.previousSeconds,
                  onTimeUpdated:
                  _updateTotalSeconds, // pass the callback to update total seconds
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ChallengeContent(
                  huntName: huntProgressModel.huntName,
                  huntID: huntProgressModel.huntId,
                  challengeID: huntProgressModel.challengeId,
                  teamID: huntProgressModel.teamId,
                  previousSeconds: huntProgressModel.previousSeconds,
                  previousPoints: huntProgressModel.previousPoints,
                  challengeNum: huntProgressModel.challengeNum,
                  totalSeconds:
                  _totalSeconds, // pass totalSeconds to ChallengeContent to be used in submit algorithm
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  final String huntName;
  final String huntID;
  final String challengeID;
  final int challengeNum;
  final int previousSeconds;
  final Function(int)
  onTimeUpdated; // Callback to send total seconds elasped on this challenge

  const HeaderWidget({
    super.key,
    required this.huntName,
    required this.huntID,
    required this.challengeID,
    required this.challengeNum,
    required this.previousSeconds,
    required this.onTimeUpdated, // Pass the callback function
  });

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  int _secondsSpent = 0;
  Timer? _timer;
  Map<String, dynamic> _challengeData = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
    _fetchChallenge();
  }

  // starts timer to count seconds spent on challenge
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsSpent++;
        widget.onTimeUpdated(
            totalSeconds); // Calls the callback function with updated total seconds
      });
    });
  }

  // fetches specific challenge data from API
  Future<void> _fetchChallenge() async {
    try {
      final challengeData =
      await fetchChallenge(widget.huntID, widget.challengeID);
      setState(() {
        _challengeData = challengeData;
      });
    } catch (e) {
      print("Error loading challenge data: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // helper function to get total seconds ellipsed when submit is clicked
  int get totalSeconds => widget.previousSeconds + _secondsSpent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
      decoration: AppStyles.infoBoxStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _challengeData['description'] ?? 'Challenge Description',
                style: AppStyles.logisticsStyle
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    '${(_secondsSpent ~/ 60).toString().padLeft(2, '0')}:${(_secondsSpent % 60).toString().padLeft(2, '0')}',
                    style: AppStyles.logisticsStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChallengeContent extends StatefulWidget {
  final String huntName;
  final String huntID;
  final String teamID;
  final String challengeID;
  final int previousSeconds;
  final int previousPoints;
  final int challengeNum;
  final int totalSeconds;

  const ChallengeContent({
    super.key,
    required this.huntName,
    required this.huntID,
    required this.teamID,
    required this.challengeID,
    required this.previousSeconds,
    required this.previousPoints,
    required this.challengeNum,
    required this.totalSeconds,
  });

  @override
  _ChallengeContentState createState() => _ChallengeContentState();
}

class _ChallengeContentState extends State<ChallengeContent> {
  final TextEditingController _answerController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic> _challengeData = {};
  late final List<dynamic> _hints; // Load hints from the challenge data

  int _hintIndex = -1; //Tracks the number of hints revealed
  int guessesLeft = 3; // initially starts out with 3 guesses

  @override
  void initState() {
    super.initState();
    _fetchChallenge();
  }

  // fetches specific challenge data from API
  Future<void> _fetchChallenge() async {
    try {
      final challengeData =
      await fetchChallenge(widget.huntID, widget.challengeID);
      setState(() {
        _challengeData = challengeData;
        _hints = challengeData['hints'] ?? []; // Initialize _hints here
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading challenge data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitAnswer() async {
    // Decrement the guesses left
    guessesLeft--;

    try {
      // Call the solveChallenge API with the necessary parameters
      final result = await solveChallenge(widget.huntID, widget.teamID,
          widget.challengeID, _answerController.text);

      bool isCorrect = result['challengeSolved'];

      if (isCorrect) {
        // Show correct answer dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context); // Close the dialog
              _navigateToHuntProgress(widget
                  .totalSeconds); // end that challenge and return to hunt progress screen
            });

            return _buildResultDialog(
                'The question was answered correctly! Your team is moving on to the next question.');
          },
        );
      } else if (!isCorrect && guessesLeft > 0) {
        // incorrect answer but more guesses left
        // Show incorrect answer dialog with guesses left
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context); // Close the dialog
            });

            return _buildResultDialog(
                'Incorrect! Try again! You have $guessesLeft guesses left.');
          },
        );
      } else {
        // incorrect and no guesses left!
        // No guesses left, show dialog and navigate back to Hunt Progress
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context); // Close the dialog
              _navigateToHuntProgress(widget.totalSeconds);
            });

            return _buildResultDialog('Incorrect! You ran out of guesses!');
          },
        );
      }
    } catch (e) {
      // Handle any errors in the API call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking answer: $e')),
      );
    }
  }

  int randomPoints() {
    Random random = Random();
    int randomPoints = 50 * (random.nextInt(6) + 1);
    return randomPoints;
  }

  // Helper method to navigate to HuntProgressView
  void _navigateToHuntProgress(int totalSec) {
    final huntProgressModel =
    Provider.of<HuntProgressModel>(context, listen: false);
    int points = randomPoints();

    huntProgressModel.totalSeconds = totalSec;
    huntProgressModel.totalPoints = huntProgressModel.previousPoints + points;
    huntProgressModel.secondsSpentThisRound =
        totalSec - huntProgressModel.previousSeconds;
    huntProgressModel.pointsEarnedThisRound = points;
    huntProgressModel.currentChallenge = huntProgressModel.challengeNum + 1;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // builder: (context) => HuntProgressView(
        //   huntName: widget.huntName,
        //   huntID: widget.huntID,
        //   teamID: widget.teamID,
        //   totalSeconds: totalSec,
        //   totalPoints: widget.previousPoints + points,
        //   secondsSpentThisRound: totalSec - widget.previousSeconds,
        //   pointsEarnedThisRound: points,
        //   currentChallenge: widget.challengeNum + 1,
        // ),
          builder: (context) => HuntProgressView()),
    );
  }

  // Helper method to build a result dialog
  Widget _buildResultDialog(String message) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // void _submitAnswer() {
  //   /*** update this  */
  //   int totalSeconds = widget.previousSeconds;
  //   guessesLeft--; // decrements the amount of guesses left

  //   if(guessesLeft == 0) {// no more guesses left, take you back to HuntProgressView
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HuntProgressView(
  //           huntName: widget.huntID,
  //           huntID: widget.huntID,
  //           teamID: widget.teamID,
  //           totalSeconds: totalSeconds,
  //           totalPoints: widget.previousPoints,
  //           secondsSpentThisRound: _challengeData['secondsSpent'],
  //           pointsEarnedThisRound: 0,
  //           currentChallenge: widget.challengeNum + 1,
  //         ),
  //       ),
  //     );
  //   } else { // more guesses left, just open up a dialog box
  //     /** NEED TO IMPLEMENT HOW TO CHECK ANSWER, API DOESN'T PROVIDE ANY QUESTIONS OR ANSWERS */

  //   }
  // }

  void _revealHint() {
    setState(() {
      if (_hintIndex < _challengeData['hints'].length - 1) {
        _hintIndex++;
      }
    });
    _showHintDialog(context);
  }

  // opens dialog box for the hint
  void _showHintDialog(BuildContext context) {
    bool hasHints = _hintIndex < _hints.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hasHints
                        ? _hints[_hintIndex]['description']
                        : 'No more hints left!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (hasHints && _hints[_hintIndex]['url'] != null)
                    Image.network(
                      _hints[_hintIndex]['url'],
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Image not available',
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (hasHints) {
                        setState(() {
                          _hintIndex++;
                        });
                      }
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // int hintsLeft = (_challengeData['hints']?.length ?? 0) - _hintIndex - 1;

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
        child: Column(
          children: [
            // Question description and image section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: AppStyles.redInfoBoxStyle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This is a question about something...',
                    style: AppStyles.logisticsStyle,
                  ),
                  /*const SizedBox(height: 10),
                  Center(
                    child: _challengeData['clueUrl'] != null
                        ? Image.network(
                            _challengeData['clueUrl'],
                            height: constraints.maxHeight * 0.2,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/huntLogo.png',
                                height: constraints.maxHeight * 0.2,
                              );
                            },
                          )
                        : const Text(
                            'Picture (if needed)',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),*/
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Team Answer header and input field

            // Submit Button

            //SHOW HINTS CONTAINER IF AT LEAST ONE HINT IS REVEALED
            if (_hintIndex > -1)
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                padding: const EdgeInsets.all(16.0),
                decoration: AppStyles.infoBoxStyle,
                child: CupertinoScrollbar(
                  child: ListView(
                    children: [
                      Text(
                        "Hints...",
                        style: AppStyles.logisticsStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: _hints.length,
                        itemBuilder: (context, index) {
                          if (index < _hintIndex) {
                            return Column(children: [
                              Text(
                                _hints[index]['description'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Image.network(
                                _hints[index]['url'],
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'Image not available',
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                            ]);
                          } else {
                            return null;
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),

            Expanded(
              child: SizedBox(),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
              decoration: AppStyles.infoBoxStyle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Stuck? Ask the team leader to reveal a hint...",
                    style: AppStyles.logisticsStyle
                        .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),

                  // Guesses Left Display
                  const SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Your team has $guessesLeft guesses left.",
              style: AppStyles.logisticsStyle.copyWith(color: Colors.amber),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      );
    });
  }
}