import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/constants/colors.dart';
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

class TeamStatisticsView extends StatelessWidget {
  final String title;
  final int points;
  final String duration;
  final List<List<Question>> questions;

  const TeamStatisticsView({
    super.key,
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
    ],
  });

  Color getBoxColor(QuestionState questionState) {
    if (questionState == QuestionState.answeredCorrectly) {
      return Colors.green; // Green color for answered correctly
    } else if (questionState == QuestionState.answeredIncorrectly) {
      return praxisRed; // Red color for answered incorrectly
    } else {
      return Colors.grey; // Gray color for not answered
    }
  }

  Widget buildChallenge(Question question) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: getBoxColor(question.questionState),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 330,
                height: 90,
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
                          width: 5), // Add spacing between timer icon and text
                      Text(
                        '${question.timeRemaining} minutes remaining',
                        style: const TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                    ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Team Statistics",
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: praxisWhite,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ),
        ],
        backgroundColor: praxisRed,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: praxisRed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 15.0),
                    const Icon(
                      Icons.timer,
                      color: praxisWhite,
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      "36.42 left",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: praxisWhite,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 15.0),
                    const Icon(
                      Icons.score,
                      color: praxisWhite,
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      "3000 total points",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: praxisWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            margin: const EdgeInsets.only(left: 30.0, right: 30.0),
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["Joe", "Bob", "Jim", "Frank"].map(
                (name) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: praxisBlack,
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
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
                    child: buildChallenge(questionList[index]),
                  ),
                  itemExtentBuilder: (_, index) {
                    return 150;
                  },
                  itemCount: questionList.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
