import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Challenge Screen'),
        ),
        body: const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cracked_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              HeaderWidget(),
              SizedBox(height: 20),
              Expanded(
                flex: 5,
                child: QuestionSection(),
              ),
              Spacer(flex: 1),
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
  int time = 120; //time in seconds
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (time > 0) {
          time -= 1;
        }
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppStyles.infoBoxStyle,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/huntlogo.png',
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
            'images/huntlogo.png',
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
  final int previousSeconds;
  final int previousPoints;
  final int challengeNum;
  const QuestionSection({super.key, required this.huntName, required this.previousSeconds, required this.previousPoints, required this.challengeNum});

  @override
  _QuestionSectionState createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  int _currentQuestionIndex = 0; // Track the current question index
  final TextEditingController _answerController = TextEditingController();

  final List<String> _questions = [
    "Who is the Current President of Praxis Engineering?",
    "In what year was Praxis founded?",
    "What city is Praxis Engineering headquartered in?",
    "Who owns Praxis Engineering?",
    "Name a continent other than North America that Praxis has an active project in.",
    "Is Jim the GOAT??"
  ];

  final List<Widget> _hints = [
    Image.asset('images/President.png'), // Image hint for question 1
    const Text("2000 and what?",
        style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold)), // Text hint for question 2
    Image.asset('images/location.png'), // Image hint for question 3
    const Text("CS...",
        style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold)), // Text hint for question 4
    Image.asset('images/Cont.png'), // Image hint for question 5
    const Text("Duh ofc he is🤦‍♂️",
        style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold)), // Text hint for question 6
  ];

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
    String apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/challenges/${_currentQuestionIndex}/solve";

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
    return Container(
      decoration: AppStyles.cancelButtonStyle,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "This is a question about .............",
            style: AppStyles.logisticsStyle,
          ),
          const SizedBox(height: 10),
          // Display the current question
          /*Container(
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
          ),*/
          const SizedBox(height: 10),

          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.white54,
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
                onPressed: _nextQuestion,
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

/**
 * ElevatedButton(
                    onPressed: () {
                      //TODO: Handle on press
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
 */