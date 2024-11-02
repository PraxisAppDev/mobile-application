import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praxis_afterhours/apis/fetch_challenge.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';

class ChallengeView extends StatelessWidget {
  final String huntName;
  final String huntID;
  final int previousSeconds;
  final int previousPoints;
  final int challengeNum;

  const ChallengeView({super.key, required this.huntName, required this.huntID, required this.previousSeconds, required this.previousPoints, required this.challengeNum});


  // Future<void> loadChallengeData() async {
  //   int huntId = 1; // or get this from the context/state as needed
  //   int challengeId = widget.challengeNum; // assuming challengeNum corresponds to the specific ID

  //   var challengeData = await fetchChallenge(huntId, challengeId);

  //   if (challengeData.isNotEmpty) {
  //     // Use challengeData to update the UI or populate fields
  //   } else {
  //     // Handle the case where data is not available
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.noBackArrowAppBarStyle("Challenge Screen", context),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cracked_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              HeaderWidget(),
              const SizedBox(height: 20),
              Expanded(
                flex: 5,
                child: QuestionSection(huntName: huntName, huntID: huntID, previousSeconds: previousSeconds, previousPoints: previousPoints, challengeNum: challengeNum),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
  late Timer _timer;
  int _currentTextIndex = 0;
  final List<String> _texts = [
    DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
    "Let's Hunt!",
    'Praxis Engineering',
  ];

  @override
  void initState() {
    super.initState();
    // Start a timer to change the text every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentTextIndex = (_currentTextIndex + 1) % _texts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.black45, // Slight background color for better visibility
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/huntLogo.png',
            height: 120,
            width: 120,
          ),
          const Text(
            "Let's Hunt!",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'images/huntLogo.png',
            height: 120,
            width: 120,
          ),
        ],
      ),
    );
  }
}

class QuestionSection extends StatefulWidget {
  final String huntName;
  final String huntID;
  final int previousSeconds;
  final int previousPoints;
  final int challengeNum;
  const QuestionSection({super.key, required this.huntName, required this.huntID, required this.previousSeconds, required this.previousPoints, required this.challengeNum});

  @override
  _QuestionSectionState createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  List<String> _questions = [];
  List<Widget> _hints = [];
  bool _isLoading = true;
  bool _hasError = false;
  List<String> _solutionTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    String apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/1/challenges";

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _questions = data.map<String>((challenge) {
            return challenge['description']?.toString() ?? 'No description available';
          }).toList();

          _hints = data.map((challenge) {
            if (challenge['hints'] != null && challenge['hints'].isNotEmpty) {
              return Image.network(
                challenge['hints'][0]['url'],
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Image not available');
                },
              );
            } else {
              return const Text('No hint available');
            }
          }).toList();

          _solutionTypes = data.map<String>((challenge) {
            return challenge['solutionType'] ?? 'STRING';
          }).toList();

          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // void _nextQuestion() {
  //   setState(() {
  //     _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
  //     _answerController.clear();
  //   });
  // }

  int randomSeconds() {
    Random random = Random();
    int randomSeconds = 25 * (random.nextInt(4) + 1);
    return randomSeconds;
  }

  int randomPoints() {
    Random random = Random();
    int randomPoints = 50 * (random.nextInt(6) + 1);
    return randomPoints;
  }

  void _submitAnswer(int huntId, int teamId) async {
    // Construct the URL dynamically using huntId, teamId, and challengeId
    String apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/challenges/$_currentQuestionIndex/solve";

    String userAnswer = _answerController.text;
    String solutionType = _solutionTypes[_currentQuestionIndex];

    var requestBody = json.encode({
      "solutionType": solutionType,
      "userAnswer": userAnswer,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Handle success
        var result = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Answer submitted: ${result['challengeSolved']}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting answer")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }
  }

  void _retryFetch() {
    _fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "Oops! Something went wrong.",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "We couldn't load the challenges. Please try again.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _retryFetch,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_questions.isEmpty || _hints.isEmpty) {
      return const Center(
        child: Text(
          "No challenges available.",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Question ${_currentQuestionIndex + 1}/${_questions.length}",
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              _questions[_currentQuestionIndex],
              style: const TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Hint",
            style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: _hints[_currentQuestionIndex],
            ),
          ),
          const SizedBox(height: 20),
          // Answer Input Box
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Type your answer here...",
                hintStyle: TextStyle(color: Colors.black38),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _submitAnswer(1, 1), // Provide appropriate huntId and teamId
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                //onPressed: _nextQuestion,
                onPressed: () {
                  int points = randomPoints();
                  int seconds = randomSeconds();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HuntProgressView(huntName: widget.huntName, huntID: widget.huntID, totalSeconds: widget.previousSeconds + seconds, totalPoints: widget.previousPoints + points, secondsSpentThisRound: seconds, pointsEarnedThisRound: points, currentChallenge: widget.challengeNum + 1)),
                    );
                  },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}