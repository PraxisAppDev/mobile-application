import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:praxis_afterhours/styles/app_styles.dart';

class ChallengeView extends StatefulWidget {
  const ChallengeView({super.key});

  @override
  _ChallengeViewState createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    String answer = _answerController.text.trim();

    if (answer.isEmpty) {
      print("Enter an answer!");
    }
    if (answer == "1") {
      showCorrectAnswerAlert(context); // Show correct answer alert
    } else if (answer == "2") {
      showIncorrectAnswerPopup(context); // Show incorrect answer popup
    }
  }

  Future<void> showIncorrectAnswerPopup(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 250,
                  height: 200,
                  decoration: AppStyles.popupStyle(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "...",
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 50),
                      ),
                      Text(
                        'Incorrect! Try again.',
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 20),
                      ),
                      Text(
                        "...",
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 50),
                      )
                    ],
                  ),
                ),
              ),
              // ),
              Positioned(
                right: 30,
                top: 260,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showCorrectAnswerAlert(BuildContext context) {
    int _countdown = 3;
    Timer? _timer;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                if (_countdown > 1) {
                  _countdown--;
                } else {
                  timer.cancel();
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChallengeView()),
                    );
                  });
                }
              });
            });

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: Container(
                  decoration: AppStyles.popupStyle(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "...",
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 50),
                      ),
                      Text(
                        'The question was answered correctly! Your team is now moving on to the next question.',
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "...",
                        style: AppStyles.logisticsStyle.copyWith(fontSize: 50),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyleWithActions("Hunt", context, [
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined,
                color: Colors.white, size: 40),
            onPressed: () {
              //TODO: Navigate to leaderboard screen
            },
          ),
        ]),
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cracked_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              const HeaderWidget(),
              const QuestionSection(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Team Answer",
                    style: AppStyles.titleStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
              const Divider(
                endIndent: 20,
                indent: 20,
                color: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: AppStyles.textFieldStyle,
                child: TextField(
                  controller: _answerController, // Attach the controller here
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: "Enter answer here....",
                    hintStyle:
                        AppStyles.logisticsStyle.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: AppStyles.logisticsStyle.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 120),
                height: 30,
                decoration: AppStyles.confirmButtonStyle.copyWith(
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: ElevatedButton(
                  onPressed: _submitAnswer,
                  style: AppStyles.elevatedButtonStyle,
                  child: Text(
                    'Submit',
                    style: AppStyles.titleStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
              Container(
                decoration: AppStyles.infoBoxStyle,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Column(
                  children: [
                    Text("Stuck? Reveal a hint...",
                        style: AppStyles.logisticsStyle),
                    Container(
                      height: 25,
                      decoration: AppStyles.hintButtonStyle,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Handle hint submission
                        },
                        style: AppStyles.elevatedButtonStyle,
                        child: Text(
                          'Hint',
                          style: AppStyles.logisticsStyle
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Your team has ',
                    style: AppStyles.logisticsStyle.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '2 ',
                          style: AppStyles.logisticsStyle.copyWith(
                              color: Colors.yellow,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline)),
                      TextSpan(
                          text: 'guesses left',
                          style: AppStyles.logisticsStyle.copyWith(
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
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
          Text(
            "Challenge 1", //TODO: Update from API
            style: AppStyles.titleStyle.copyWith(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white, size: 30),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 45,
                child: Text(
                  "${(time / 60).truncate()}:${(time % 60).toString().padLeft(2, '0')}",
                  style: AppStyles.titleStyle.copyWith(fontSize: 20),
                ),
              )
            ],
          )
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

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
      _answerController.clear();
    });
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
              child: Text(
                "Picture (if needed)", //TODO: Get picture from API or placeholder if none needed
                style: AppStyles.logisticsStyle
                    .copyWith(color: const Color.fromARGB(255, 27, 27, 27)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
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