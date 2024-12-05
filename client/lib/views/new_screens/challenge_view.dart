import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/apis/post_solve_challenge.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:praxis_afterhours/provider/game_model.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';
import 'package:provider/provider.dart';
import '../../provider/websocket_model.dart';

class ChallengeView extends StatefulWidget {
  // final String huntName;
  // final String huntID;
  // final String teamID;
  // final int previousSeconds;
  // final int previousPoints;
  // final String challengeID;
  // final int challengeNum;
  //
  // const ChallengeView({
  //   super.key,
  //   required this.huntName,
  //   required this.huntID,
  //   required this.teamID,
  //   required this.previousSeconds,
  //   required this.previousPoints,
  //   required this.challengeID,
  //   required this.challengeNum,
  // });
  const ChallengeView({super.key});

  @override
  _ChallengeViewState createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  int _totalSeconds =
      0; // cumulative state var to track total seconds spent on current challenge + all previous challenges

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
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
      decoration: AppStyles.infoBoxStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   _challengeData['description'] ?? 'Challenge Description',
              //   style: AppStyles.logisticsStyle
              //       .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              Flexible(
                child: Text(
                  "Challenge ${huntProgressModel.challengeNum + 1}",
                  style: AppStyles.logisticsStyle
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
  late final String _clueImage; // Load clue image from the challenge data

  int _hintIndex = -1; //Tracks the number of hints revealed
  int guessesLeft = 3; // initially starts out with 3 guesses

  int? _finalPoints; // Points received from WebSocket
  late WebSocketModel _webSocketModel;

  @override
  void initState() {
    super.initState();
    _webSocketModel = Provider.of<WebSocketModel>(context, listen: false);
    _fetchChallenge();
    // _connectWebSocket();
  }

  @override
  void dispose() {
    _webSocketModel.disconnect(); // Disconnect WebSocket when widget is disposed
    _answerController.dispose();
    super.dispose();
  }

  // Connect to WebSocket and listen for messages
  // COMMENTED OUT FOR NOW AS POINTS FIELD NOT IN WEB SOCKET MESSAGE
  // void _connectWebSocket() {
  //   final wsUrl =
  //       'ws://afterhours.praxiseng.com/ws/hunt?huntId=${widget.huntID}&teamId=${widget.teamID}&playerName=YourPlayerName';
  //   try {
  //     print('Connecting to WebSocket at: $wsUrl');
  //     _webSocketModel.connect(wsUrl);
  //     print('WebSocket connected successfully.');

  //     _webSocketModel.messages.listen(
  //       (message) {
  //          //for debugging purposes

  //         final Map<String, dynamic> data = json.decode(message);
  //         final String eventType = data['eventType'];

  //         if (eventType == "CHALLENGE_RESPONSE") {
  //           print("JEFF CHEKC: $message");
  //           setState(() {
  //             _finalPoints = data['pointsEarned'];
  //           });
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Challenge Complete! Points Earned: $_finalPoints")),
  //           );
  //         }
  //       },
  //       onError: (error) {
  //         print('WebSocket error: $error');
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("WebSocket Error: $error")),
  //         );
  //       },
  //       onDone: () {
  //         print('WebSocket closed');
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("WebSocket connection closed")),
  //         );
  //       },
  //       cancelOnError: true,
  //     );
  //   } catch (e) {
  //     print('Failed to connect to WebSocket: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to connect to WebSocket: $e")),
  //     );
  //   }
  // }

  // fetches specific challenge data from API
  Future<void> _fetchChallenge() async {
    try {
      final challengeData =
          await fetchChallenge(widget.huntID, widget.challengeID);
      setState(() {
        _challengeData = challengeData;
        _clueImage = challengeData['clue'] ?? '';
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
            _finalPoints = 300; // hardcoded for now, will take out when websocket message updated;
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

  // int randomPoints() {
  //   Random random = Random();
  //   int randomPoints = 50 * (random.nextInt(6) + 1);
  //   return randomPoints;
  // }

  
  void _navigateToHuntProgress(int totalSec) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    final int points = _finalPoints ?? 0; // defaults to 0 if not recieved.

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

  final DotDivider = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 5.0,
        height: 5.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
      SizedBox(
        width: 5,
      ),
      Container(
        width: 5.0,
        height: 5.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
      SizedBox(
        width: 5,
      ),
      Container(
        width: 5.0,
        height: 5.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
    ],
  );

  // Show a confirmation dialog before giving up
  void _showGiveUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: Colors.black,
          contentPadding: const EdgeInsets.all(0),
          content: DecoratedBox(
            decoration: AppStyles.popupStyle(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Top Divider with Close Button
                  SizedBox(
                    height: 45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 32),
                        Expanded(child: DotDivider),
                        SizedBox(
                          width: 32,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Flexible(
                    child: Text(
                      'Are you sure?\n',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Dialog Content
                  const Flexible(
                    child: Text(
                      'If you give up, you will receive 0 points for this challenge.',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel Button
                      Container(
                        width: 130,
                        height: 50,
                        decoration: AppStyles.cancelButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Confirm Button
                      Container(
                        width: 130,
                        height: 50,
                        decoration: AppStyles.confirmButtonStyle,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            _finalPoints = 0; // Set points to 0
                            _navigateToHuntProgress(widget.totalSeconds); // Navigate to the progress screen
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Bottom Divider
                  SizedBox(height: 45, child: DotDivider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _revealHint() {
    setState(() {
      if (_hintIndex < _hints.length) {
        _hintIndex++;
      }
    });
    _showHintDialog(context);
  }

  // Opens dialog box for the hint
  void _showHintDialog(BuildContext context) {
    bool hasHints = _hintIndex >= 0 && _hintIndex < _hints.length;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question description and image section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: AppStyles.redInfoBoxStyle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _challengeData['description'] ?? 'No description available',
                      style: AppStyles.logisticsStyle,
                    ),
                    const SizedBox(height: 10),
                    // Clue Image Section
                    Center(
                      child: _clueImage.isNotEmpty
                          ? GestureDetector(
                              onTap: () => _showFullScreenHintImage(context, _clueImage),
                              child: Image.network(
                                _clueImage,
                                height: constraints.maxHeight * 0.25,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'Clue image could not be displayed',
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            )
                          : Image.asset(
                              "images/huntLogo.png",
                              height: 100,
                              width: 100,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Team Answer section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
                decoration: AppStyles.infoBoxStyle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Answer...',
                      style: AppStyles.logisticsStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 50,
                      decoration: AppStyles.textFieldStyle,
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: 'Enter answer here...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // "I Quit" and "Submit" buttons in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      decoration: AppStyles.cancelButtonStyle, // Use AppStyles for decoration
                      child: ElevatedButton(
                        onPressed: _showGiveUpDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Make button background transparent
                          shadowColor: Colors.transparent, // Remove shadow
                        ),
                        child: Text(
                          'I Quit',
                          style: AppStyles.logisticsStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ), // Ensure font consistency
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      decoration: AppStyles.confirmButtonStyle, // Use AppStyles for decoration
                      child: ElevatedButton(
                        onPressed: _submitAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Make button background transparent
                          shadowColor: Colors.transparent, // Remove shadow
                        ),
                        child: Text(
                          'Submit',
                          style: AppStyles.logisticsStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ), // Ensure font consistency
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hint section with reveal button
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: AppStyles.infoBoxStyle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hints",
                        style: AppStyles.logisticsStyle
                            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _hintIndex + 1,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hint ${index + 1}: ${_hints[index]['description'] ?? 'No description available'}",
                                  style: AppStyles.logisticsStyle,
                                ),
                                const SizedBox(height: 10),
                                if (_hints[index]['hint'] != null)
                                  GestureDetector(
                                    onTap: () => _showFullScreenHintImage(
                                      context,
                                      _hints[index]['hint'],
                                    ),
                                    child: Center(
                                      child: Image.network(
                                        _hints[index]['hint'] ?? '',
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Text(
                                            'Image not available',
                                            style: TextStyle(color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Reveal Hint Button
                      Center(
                        child: Container(
                          decoration: AppStyles.hintBoxStyle, // Use AppStyles for decoration
                          child: ElevatedButton(
                            onPressed: _revealHint,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Make button background transparent
                              shadowColor: Colors.transparent, // Remove shadow
                            ),
                            child: Text(
                              'Reveal Hint',
                              style: AppStyles.logisticsStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ), // Ensure font consistency
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                            "Your team has $guessesLeft guesses left.",
                            style:
                            AppStyles.logisticsStyle.copyWith(color: Colors.amber),
                          ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  
  void _showFullScreenHintImage(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: true, // Allows user to dismiss by tapping outside
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context), // Close popup on tap
          child: Scaffold(
            backgroundColor: Colors.black, // Full-screen background
            body: Center(
              child: InteractiveViewer( // Allow zoom and pan
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Image could not be displayed',
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

// class ChallengeView extends StatelessWidget {
//   final String huntName;
//   final String huntID;
//   final int previousSeconds;
//   final int previousPoints;
//   final String challengeID;
//   final int challengeNum;

//   const ChallengeView({super.key, required this.huntName, required this.huntID, required this.previousSeconds, required this.previousPoints, required this.challengeID, required this.challengeNum});

//   // Future<void> loadChallengeData() async {
//   //   int huntId = 1; // or get this from the context/state as needed
//   //   int challengeId = widget.challengeNum; // assuming challengeNum corresponds to the specific ID

//   //   var challengeData = await fetchChallenge(huntId, challengeId);

//   //   if (challengeData.isNotEmpty) {
//   //     // Use challengeData to update the UI or populate fields
//   //   } else {
//   //     // Handle the case where data is not available
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppStyles.noBackArrowAppBarStyle("Challenge Screen", context),
//         body: DecoratedBox(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("images/cracked_background.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             children: [
//               HeaderWidget(),
//               const SizedBox(height: 20),
//               Expanded(
//                 flex: 5,
//                 child: QuestionSection(huntName: huntName, huntID: huntID, previousSeconds: previousSeconds, previousPoints: previousPoints, challengeID: challengeID, challengeNum: challengeNum,),
//               ),
//               const Spacer(flex: 1),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HeaderWidget extends StatefulWidget {
//   const HeaderWidget({super.key});

//   @override
//   _HeaderWidgetState createState() => _HeaderWidgetState();
// }

// class _HeaderWidgetState extends State<HeaderWidget> {
//   String currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
//   late Timer _timer;
//   int _currentTextIndex = 0;
//   final List<String> _texts = [
//     DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
//     "Let's Hunt!",
//     'Praxis Engineering',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Start a timer to change the text every 3 seconds
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       setState(() {
//         _currentTextIndex = (_currentTextIndex + 1) % _texts.length;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.2,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: const BoxDecoration(
//         color: Colors.black45, // Slight background color for better visibility
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             'images/huntLogo.png',
//             height: 120,
//             width: 120,
//           ),
//           const Text(
//             "Let's Hunt!",
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Image.asset(
//             'images/huntLogo.png',
//             height: 120,
//             width: 120,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class QuestionSection extends StatefulWidget {
//   final String huntName;
//   final String huntID;
//   final int previousSeconds;
//   final int previousPoints;
//   final String challengeID;
//   final int challengeNum;

//   const QuestionSection({super.key, required this.huntName, required this.huntID, required this.previousSeconds, required this.previousPoints, required this.challengeID, required this.challengeNum});

//   @override
//   _QuestionSectionState createState() => _QuestionSectionState();
// }

// class _QuestionSectionState extends State<QuestionSection> {
//   int _currentQuestionIndex = 0;
//   final TextEditingController _answerController = TextEditingController();
//   List<String> _questions = [];
//   List<Widget> _hints = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   List<String> _solutionTypes = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchChallenge();
//   }

//   Future<void> _fetchChallenge() async {
//   setState(() {
//     _isLoading = true;
//     _hasError = false;
//   });

//   try {
//     // Call fetchChallenge with the huntID and challengeNum from the widget
//     final challengeData = await fetchChallenge(widget.huntID, widget.challengeID);

//     setState(() {
//       if (challengeData.isNotEmpty) {
//         // Update the data lists with details for the specific challenge
//         _questions = [challengeData['description'] ?? 'No description available'];
//         _solutionTypes = [challengeData['solutionType'] ?? 'STRING'];

//         _hints = (challengeData['hints'] as List<dynamic>?)
//             ?.map((hint) => Image.network(
//                   hint['url'] ?? '',
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Text('Image not available');
//                   },
//                 ))
//             .toList() ??
//             [const Text('No hint available')];

//         _isLoading = false;
//       } else {
//         _hasError = true;
//         _isLoading = false;
//       }
//     });
//   } catch (e) {
//       print("Error occurred: $e");
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//     }
//   }

//   // Future<void> _fetchChallenge() async {
//   //   String apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/1/challenges";

//   //   setState(() {
//   //     _isLoading = true;
//   //     _hasError = false;
//   //   });

//   //   try {
//   //     final response = await http.get(Uri.parse(apiUrl));

//   //     if (response.statusCode == 200) {
//   //       final List<dynamic> data = json.decode(response.body);

//   //       setState(() {
//   //         _questions = data.map<String>((challenge) {
//   //           return challenge['description']?.toString() ?? 'No description available';
//   //         }).toList();

//   //         _hints = data.map((challenge) {
//   //           if (challenge['hints'] != null && challenge['hints'].isNotEmpty) {
//   //             return Image.network(
//   //               challenge['hints'][0]['url'],
//   //               errorBuilder: (context, error, stackTrace) {
//   //                 return const Text('Image not available');
//   //               },
//   //             );
//   //           } else {
//   //             return const Text('No hint available');
//   //           }
//   //         }).toList();

//   //         _solutionTypes = data.map<String>((challenge) {
//   //           return challenge['solutionType'] ?? 'STRING';
//   //         }).toList();

//   //         _isLoading = false;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         _hasError = true;
//   //         _isLoading = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     print("Error occurred: $e");
//   //     setState(() {
//   //       _hasError = true;
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }

//   // void _nextQuestion() {
//   //   setState(() {
//   //     _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
//   //     _answerController.clear();
//   //   });
//   // }

//   int randomSeconds() {
//     Random random = Random();
//     int randomSeconds = 25 * (random.nextInt(4) + 1);
//     return randomSeconds;
//   }

//   int randomPoints() {
//     Random random = Random();
//     int randomPoints = 50 * (random.nextInt(6) + 1);
//     return randomPoints;
//   }

//   void _submitAnswer(int huntId, int teamId) async {
//     // Construct the URL dynamically using huntId, teamId, and challengeId
//     String apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/challenges/$_currentQuestionIndex/solve";

//     String userAnswer = _answerController.text;
//     String solutionType = _solutionTypes[_currentQuestionIndex];

//     var requestBody = json.encode({
//       "solutionType": solutionType,
//       "userAnswer": userAnswer,
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: requestBody,
//       );

//       if (response.statusCode == 200) {
//         // Handle success
//         var result = json.decode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Answer submitted: ${result['challengeSolved']}")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error submitting answer")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Network error: $e")),
//       );
//     }
//   }

//   void _retryFetch() {
//     _fetchChallenge();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_hasError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.red,
//               size: 80,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Oops! Something went wrong.",
//               style: TextStyle(fontSize: 24, color: Colors.white),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "We couldn't load the challenges. Please try again.",
//               style: TextStyle(fontSize: 16, color: Colors.white70),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _retryFetch,
//               child: const Text("Retry"),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_questions.isEmpty || _hints.isEmpty) {
//       return const Center(
//         child: Text(
//           "No challenges available.",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//       );
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "Question ${_currentQuestionIndex + 1}/${_questions.length}",
//             style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             padding: const EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Text(
//               _questions[_currentQuestionIndex],
//               style: const TextStyle(fontSize: 24, color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "Hint",
//             style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             height: 120,
//             width: MediaQuery.of(context).size.width * 0.7,
//             decoration: BoxDecoration(
//               color: Colors.white54,
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: Center(
//               child: _hints[_currentQuestionIndex],
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Answer Input Box
//           Container(
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.7,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: TextField(
//               controller: _answerController,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Type your answer here...",
//                 hintStyle: TextStyle(color: Colors.black38),
//               ),
//               style: const TextStyle(color: Colors.black),
//             ),
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () => _submitAnswer(1, 1), // Provide appropriate huntId and teamId
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 ),
//                 child: const Text(
//                   "Submit",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               ElevatedButton(
//                 //onPressed: _nextQuestion,
//                 onPressed: () {
//                   int points = randomPoints();
//                   int seconds = randomSeconds();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HuntProgressView(
//                         huntName: widget.huntName,
//                         huntID: widget.huntID,
//                         totalSeconds: widget.previousSeconds + seconds,
//                         totalPoints: widget.previousPoints + points,
//                         secondsSpentThisRound: seconds,
//                         pointsEarnedThisRound: points,
//                         currentChallenge: widget.challengeNum + 1)),
//                     );
//                   },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 ),
//                 child: const Text(
//                   "Skip",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
