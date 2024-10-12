import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Challenge Screen", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Column(
            children: [
              HeaderWidget(),
              SizedBox(height: 20),
              Expanded(
                flex: 5,
                child: QuestionSection(),
              ),
              Spacer(), // Adjust positioning below the main content
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
            height: 60,
            width: 60,
          ),
          Text(
            _texts[_currentTextIndex],
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'images/huntLogo.png',
            height: 60,
            width: 60,
          ),
        ],
      ),
    );
  }
}

class QuestionSection extends StatefulWidget {
  const QuestionSection({super.key});

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
    Image.asset("images/President.png"), // Image hint for question 1
    const Text("2000 and what?", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)), // Text hint for question 2
    Image.asset("images/location.png"), // Image hint for question 3
    const Text("CS...", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)), // Text hint for question 4
    Image.asset("images/Continent.png"), // Image hint for question 5
    const Text("Duh ofc he is🤦‍♂️", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)), // Text hint for question 6
  ];

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
      _answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display the question number
          Text(
            "Question ${_currentQuestionIndex + 1}/${_questions.length}",
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Display the current question
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
              Container(
                height: 50,
                width: 175,
                decoration: AppStyles.confirmButtonStyle,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text('Submit',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                height: 50,
                width: 175,
                decoration: AppStyles.cancelButtonStyle,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text('Skip',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}