import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/views/leaderboard_view.dart';
import 'package:praxis_afterhours/views/hunt/mock_question.dart';
import 'package:timelines/timelines.dart';

enum QuestionState { answeredCorrectly, answeredIncorrectly, notAnswered }

class Question {
  final int questionPoints;
  final int timeRemaining;
  final String questionTitle;
  final QuestionState questionState;

  const Question(
      {required this.questionPoints,
      required this.timeRemaining,
      required this.questionTitle,
      required this.questionState});
}

class HuntChallengeScreen extends StatelessWidget {
  final String title;
  final int points;
  final String duration;
  final List<List<Question>> questions;

  const HuntChallengeScreen(
      {super.key,
      this.title = "challenge 1 ",
      this.points = 10,
      this.duration = " 10 minutes",
      this.questions = const [
        [
          Question(
            questionPoints: 200,
            timeRemaining: 10,
            questionTitle: "Lorem 1",
            questionState: QuestionState.answeredCorrectly,
          ),
          Question(
            questionPoints: 400,
            timeRemaining: 6,
            questionTitle: "Lorem 2",
            questionState: QuestionState.answeredIncorrectly,
          ),
          Question(
            questionPoints: 0,
            timeRemaining: 0,
            questionTitle: "",
            questionState: QuestionState.notAnswered,
          ),
          Question(
            questionPoints: 0,
            timeRemaining: 0,
            questionTitle: "",
            questionState: QuestionState.notAnswered,
          )
        ]
      ]});

  Color getBoxColor(QuestionState questionState) {
    if (questionState == QuestionState.answeredCorrectly) {
      return Colors.green; // Green color for answered correctly
    } else if (questionState == QuestionState.answeredIncorrectly) {
      return praxisRed; // Red color for answered incorrectly
    } else {
      return Colors.grey; // Gray color for not answered
    }
  }

  Widget buildChallenge(BuildContext context, Question question) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: getBoxColor(question.questionState),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 360,
                height: 90,
                child: TextButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MockQuestionView(),
                      ),
                    )
                  },
                  child: ListTile(
                    title: Text(
                      question.questionTitle,
                      style: const TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                    subtitle: Row(
                      // Updated to use Row widget
                      children: [
                        const Icon(Icons.score,
                            color: Colors.white), // Set icon color to white
                        const SizedBox(width: 5), // Use SizedBox for spacing
                        Text(
                          '${question.questionPoints} points',
                          style: const TextStyle(
                              color: Colors.white), // Set text color to white
                        ),
                        const SizedBox(
                            width: 20), // Add spacing between points and time
                        const Icon(Icons.timer,
                            color: Colors.white), // Timer icon with white color
                        const SizedBox(
                            width:
                                5), // Add spacing between timer icon and text
                        Text(
                          '${question.timeRemaining} minutes \nremaining',
                          style: const TextStyle(
                              color: Colors.white), // Set text color to white
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Recruit Mixer",
            style: TextStyle(
              color: praxisWhite,
              fontSize: 30,
              fontFamily: 'Poppins',
            ),
          ),
          centerTitle: true,
          backgroundColor: praxisRed,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: praxisBlack, size: 35),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardView(),
                  ),
                );
              },
              icon: const Icon(Icons.leaderboard, color: praxisWhite, size: 35),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.person, color: praxisWhite, size: 35),
            ),
          ]),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          color: praxisRed,
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.timer,
              color: praxisWhite,
            ),
            SizedBox(width: 20),
            Text(
              "30:00 left",
              style: TextStyle(
                fontSize: 20,
                color: praxisWhite,
                fontFamily: 'Poppins',
              ),
            ),
          ]),
        ),
        Container(
          color: praxisRed,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.score,
                color: praxisWhite,
              ),
              SizedBox(width: 20),
              Text(
                "200 points",
                style: TextStyle(
                  fontSize: 20,
                  color: praxisWhite,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        for (var questionList in questions)
          Container(
            height: 700,
            child: Timeline.tileBuilder(
              padding: const EdgeInsets.only(left: 13, right: 16, top: 50),
              theme: TimelineThemeData(
                nodePosition: 0,
                connectorTheme: const ConnectorThemeData(
                  thickness: 3.0,
                ),
              ),
              builder: TimelineTileBuilder.connected(
                indicatorBuilder: (context, index) {
                  return DotIndicator(
                    size: 18,
                    color: praxisRed,
                    border: Border.all(
                      width: 3,
                      color: praxisRed,
                    ),
                  );
                },
                connectorBuilder: (_, index, connectorType) {
                  return SolidLineConnector(
                    color: praxisRed,
                    indent: connectorType == ConnectorType.start ? 5 : 5,
                    endIndent: connectorType == ConnectorType.end ? 5.0 : 5.0,
                    thickness: 2,
                  );
                },
                indicatorPositionBuilder: (context, index) => 0,
                contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: buildChallenge(context, questionList[index]),
                ),
                itemExtentBuilder: (_, index) {
                  return 150;
                },
                itemCount: questionList.length,
              ),
            ),
          ),
      ]),
      backgroundColor: Colors.white,
    );
  }
}
