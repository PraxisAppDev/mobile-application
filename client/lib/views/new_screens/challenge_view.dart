import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/apis/post_solve_challenge.dart';
import 'package:praxis_afterhours/provider/game_model.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';
import 'package:provider/provider.dart';
import '../../provider/websocket_model.dart';

class ChallengeView extends StatefulWidget {
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
          widget.challengeID, 3 - guessesLeft, widget.totalSeconds - widget.previousSeconds, _hintIndex + 1, _answerController.text);

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
        // Incorrect and no guesses left!
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
  
  void _navigateToHuntProgress(int totalSec) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    final int points = _finalPoints ?? 0; // defaults to 0 if not received.

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
