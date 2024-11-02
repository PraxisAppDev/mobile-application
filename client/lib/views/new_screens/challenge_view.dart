import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/apis/post_solve_challenge.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';

class ChallengeView extends StatelessWidget {
  final String huntName;
  final String huntID;
  final String teamID;
  final int previousSeconds;
  final int previousPoints;
  final String challengeID;
  final int challengeNum;

  const ChallengeView({
    super.key,
    required this.huntName,
    required this.huntID,
    required this.teamID,
    required this.previousSeconds,
    required this.previousPoints,
    required this.challengeID,
    required this.challengeNum,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.noBackArrowAppBarStyle("Hunt", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Column(
            children: [
              const SizedBox(height: 20), // Adds padding above the header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HeaderWidget(
                  huntID: huntID,
                  challengeID: challengeID,
                  challengeNum: challengeNum,
                  previousSeconds: previousSeconds,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ChallengeContent(
                  huntID: huntID,
                  challengeID: challengeID,
                  teamID: teamID,
                  previousSeconds: previousSeconds,
                  previousPoints: previousPoints,
                  challengeNum: challengeNum,
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
  final String huntID;
  final String challengeID;
  final int challengeNum;
  final int previousSeconds;

  const HeaderWidget({
    super.key,
    required this.huntID,
    required this.challengeID,
    required this.challengeNum,
    required this.previousSeconds,
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsSpent++;
      });
    });
  }

  Future<void> _fetchChallenge() async {
    try {
      final challengeData = await fetchChallenge(widget.huntID, widget.challengeID);
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
      padding: const EdgeInsets.all(16.0),
      decoration: AppStyles.infoBoxStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _challengeData['description'] ?? 'Challenge Description',
                style: AppStyles.logisticsStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
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
  final String huntID;
  final String teamID;
  final String challengeID;
  final int previousSeconds;
  final int previousPoints;
  final int challengeNum;

  const ChallengeContent({
    super.key,
    required this.huntID,
    required this.teamID,
    required this.challengeID,
    required this.previousSeconds,
    required this.previousPoints,
    required this.challengeNum,
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

  Future<void> _fetchChallenge() async {
    try {
      final challengeData = await fetchChallenge(widget.huntID, widget.challengeID);
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
    // Decrement the guesses left and store the current time spent
    int totalSeconds = widget.previousSeconds; // assuming `_secondsSpent` tracks the current challenge time
    guessesLeft--;

    try {
      // Call the solveChallenge API with the necessary parameters
      final result = await solveChallenge(widget.huntID, widget.teamID, widget.challengeID);

      bool isCorrect = result['challengeSolved'];

      if (isCorrect) {
        // Show correct answer dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pop(context); // Close the dialog
              _navigateToHuntProgress(totalSeconds); // end that challenge and return to hunt progress screen
            });

            return _buildResultDialog('The question was answered correctly! Your team is moving on to the next question.');
          },
        );
      } else if (!isCorrect && guessesLeft > 0) {// incorrect answer but more guesses left
        // Show incorrect answer dialog with guesses left
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context); // Close the dialog
            });

            return _buildResultDialog('Incorrect! Try again! You have $guessesLeft guesses left.');
          },
        );
      } else {// incorrect and no guesses left!
        // No guesses left, show dialog and navigate back to Hunt Progress
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context); // Close the dialog
              _navigateToHuntProgress(totalSeconds);
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

  // Helper method to navigate to HuntProgressView
  void _navigateToHuntProgress(int totalSec) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HuntProgressView(
          huntName: widget.huntID,
          huntID: widget.huntID,
          teamID: widget.teamID,
          totalSeconds: totalSec,
          totalPoints: widget.previousPoints,
          secondsSpentThisRound: _challengeData['secondsSpent'] ?? 0,
          pointsEarnedThisRound: 0,
          currentChallenge: widget.challengeNum + 1,
        ),
      ),
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
                    hasHints ? _hints[_hintIndex]['description'] : 'No more hints left!',
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

    return LayoutBuilder(
      builder: (context, constraints){
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              // Question description and image section
                  Flexible(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: AppStyles.infoBoxStyle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This is a question about something...',
                            style: AppStyles.logisticsStyle,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Center(
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 20),

              // Team Answer header and input field
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Answer...',
                      style: AppStyles.logisticsStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: AppStyles.textFieldStyle,
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: 'Enter answer here...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: Icon(Icons.edit, color: Colors.grey),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              Flexible(
                flex: 1,
                child: Container(
                  decoration: AppStyles.confirmButtonStyle,
                  child: ElevatedButton(
                    onPressed: _submitAnswer,
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Flexible(// Hint and guesses left section
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: AppStyles.infoBoxStyle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Stuck? Reveal a hint...",
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Hint Button
                      Container(
                        decoration: AppStyles.challengeButtonStyle,
                        child: ElevatedButton(
                          onPressed: _revealHint,
                          style: AppStyles.elevatedButtonStyle,
                          child: const Text('Hint', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),

                      // Guesses Left Display
                      const SizedBox(height: 10),
                      Text(
                        "Your team has $guessesLeft guesses left.",
                        style: AppStyles.logisticsStyle.copyWith(color: Colors.amber),
                      ),
                    ],
                  ),
                  
                ),
              ),
            ],
          ),
        );
    });

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