import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/apis/post_solve_challenge.dart';
import 'package:praxis_afterhours/views/new_screens/end_game_view.dart';
import 'package:provider/provider.dart';
import '../../provider/game_model.dart';
import '../../provider/websocket_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';

class ChallengeViewNoButtons extends StatefulWidget {
  final int currentChallenge;
  const ChallengeViewNoButtons(String challengeId,
      {Key? key, required this.currentChallenge})
      : super(key: key);

  @override
  _ChallengeViewNoButtonsState createState() => _ChallengeViewNoButtonsState();
}

class _ChallengeViewNoButtonsState extends State<ChallengeViewNoButtons> {
  late final StreamSubscription<dynamic> _webSocketSubscription;
  late final huntProgressModel;
  bool _isLoading = true;
  int _incorrectResponseCount = 0;
  List<dynamic> _challengeData = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    final webSocketModel = Provider.of<WebSocketModel>(context, listen: false);
    _webSocketSubscription =
        webSocketModel.messages.listen(_handleWebSocketMessage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      huntProgressModel =
          Provider.of<HuntProgressModel>(context, listen: false);
      _initializeChallenges();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _webSocketSubscription.cancel();
    super.dispose();
  }

  Future<void> _initializeChallenges() async {
    try {
      final challenges = await fetchChallenges(huntProgressModel.huntId);
      setState(() {
        _challengeData = challenges;
        _isLoading = false;
      });

      // Update total challenges in the progress model
      huntProgressModel.totalChallenges = challenges.length;
    } catch (e) {
      // print("Error fetching challenges: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = message is String ? json.decode(message) : message;
      if (data['eventType'] == 'CHALLENGE_RESPONSE') {
        final challengeSolved = data['challengeSolved'] == "true";

        if (!challengeSolved) {
          // incorrect answer submitted
          _incorrectResponseCount++;

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Incorrect response!')),
          // );

          if (_incorrectResponseCount >= 3) {
            // Show popup for exceeding incorrect attempts
            _showPopup(
              "Out of Attempts",
              "Your team leader has used all attempts. Moving to the next challenge.",
              onClose: () {
                _progressToNextChallenge(huntProgressModel);
              },
            );
          } else {
            // incorrect response, but more guesses left
            // Show popup for incorrect answer
            _showPopup(
              "Your team leader submitted an Incorrect Answer",
              "Try again! You have ${3 - _incorrectResponseCount} attempts left.",
            );
          }
        } else {
          // correct answer submitted
          // Show popup for correct answer
          _showPopup(
            "Your team leader answered correctly!",
            "Your team has answered correctly. Proceeding to the next challenge.",
            onClose: () {
              _progressToNextChallenge(huntProgressModel);
            },
          );
        }
      }
    } catch (e) {
      // print("Error handling WebSocket message: $e");
    }
  }

  void _progressToNextChallenge(HuntProgressModel huntProgressModel) {
    setState(() {
      _incorrectResponseCount = 0;
    });

    // print("current challenge: ${widget.currentChallenge}");
    // print("total challenges: ${huntProgressModel.totalChallenges}");

    // Increment the challenge only if not the last one
    if (widget.currentChallenge < huntProgressModel.totalChallenges) {
      huntProgressModel.incrementCurrentChallenge();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChallengeViewNoButtons(
                  huntProgressModel.challengeId,
                  currentChallenge: widget.currentChallenge + 1,
                )),
      );
    } else {
      // Navigate to HuntProgressView or EndGameScreen if all challenges are completed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EndGameScreen()),
      );
    }
  }

  // Helper method to build a result dialog
  void _showPopup(String title, String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (onClose != null) {
                  onClose();
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);

    return Scaffold(
      appBar: AppStyles.noBackArrowAppBarStyle("Hunt", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HeaderWidget(
                huntName: huntProgressModel.huntName,
                huntID: huntProgressModel.huntId,
                challengeID: huntProgressModel.challengeId,
                challengeNum: widget.currentChallenge,
                previousSeconds: huntProgressModel.previousSeconds,
                onTimeUpdated: (seconds) {
                  // Update total seconds in HuntProgressModel
                  huntProgressModel.previousSeconds = seconds;
                },
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
                challengeNum: huntProgressModel.currentChallenge,
                totalSeconds: huntProgressModel.previousSeconds,
              ),
            ),
          ],
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
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers

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
      // print("Error loading challenge data: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // helper function to get total seconds elapsed when submit is clicked
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
                'Challenge ${widget.challengeNum}',
                // _challengeData['description'] ?? 'Challenge Description',
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
      // print("Error loading challenge data: $e");
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
          widget.challengeID, 3 - guessesLeft, widget.totalSeconds - widget.previousSeconds, _hintIndex, _answerController.text);

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  const SizedBox(height: 10),
                  Center(
                      child: _challengeData['url'] != null
                          ? Image.network(
                              _challengeData['url'],
                              height: constraints.maxHeight * 0.2,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  'clueUrl could not be displayed',
                                  style: TextStyle(color: Colors.white),
                                );
                              },
                            )
                          : Image.asset("images/huntLogo.png",
                              height: 150, width: 150)
                  ),
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
