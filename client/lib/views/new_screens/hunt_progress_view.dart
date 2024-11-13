import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../../provider/game_model.dart';

class HuntProgressView extends StatefulWidget {
  final String huntName;
  final String huntID;
  final String teamID;
  final int totalSeconds;
  final int totalPoints;
  final int secondsSpentThisRound;
  final int pointsEarnedThisRound;
  final int currentChallenge;

  const HuntProgressView(
      {super.key,
      required this.huntName,
      required this.huntID,
      required this.teamID,
      required this.totalSeconds,
      required this.totalPoints,
      required this.secondsSpentThisRound,
      required this.pointsEarnedThisRound,
      required this.currentChallenge});

  @override
  _HuntProgressViewState createState() => _HuntProgressViewState();
}

class _HuntProgressViewState extends State<HuntProgressView> {
  List<dynamic> challenges = [];
  bool isLoading = true; // Loading state
  bool isHuntCompleted = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    // Add the current round's data to the model
    huntProgressModel.addSecondsSpent(widget.secondsSpentThisRound);
    huntProgressModel.addPointsEarned(widget.pointsEarnedThisRound);
    fetchChallengesData(); // Fetch challenges when the widget is initialized
  }

  Future<void> fetchChallengesData() async {
    var data = await fetchChallenges(widget.huntID); // Call the imported fetchChallenges function
    setState(() {
      challenges = data;  // Update the challenges list
      isLoading = false;  // Update loading state
      if (widget.currentChallenge >= data.length) {
        isHuntCompleted = true;
        _confettiController.play(); // Play confetti animation when hunt is completed
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.noBackArrowAppBarStyle("Hunt Progress", context),
        body: Stack(
          children: [
            DecoratedBox(
              decoration: AppStyles.backgroundStyle,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Container(
                        width: 350,
                        height: 150,
                        padding: const EdgeInsets.all(16),
                        decoration: AppStyles.infoBoxStyle,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.huntName,
                                  textAlign: TextAlign.left,
                                  style: AppStyles.logisticsStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.timer, color: Colors.white, size: 25),
                                Text(
                                  secondsToMinutes(widget.totalSeconds),
                                  style: AppStyles.logisticsStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.two_mp_outlined, color: Colors.white, size: 25),
                                Text(
                                  widget.totalPoints.toString(),
                                  style: AppStyles.logisticsStyle,
                                ),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: fetchChallenges(widget.huntID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final List<dynamic> challengeResponse = snapshot.data!;
                            return ListView.builder(
                              itemCount: challengeResponse.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center, // Center items in the row
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 20.0,
                                              height: 20.0,
                                              margin: const EdgeInsets.only(right: 8.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: index < widget.currentChallenge
                                                    ? Colors.green
                                                    : index > widget.currentChallenge
                                                        ? Colors.grey
                                                        : Colors.amber,
                                                border: Border.all(
                                                  color: index < widget.currentChallenge
                                                      ? Colors.greenAccent
                                                      : index > widget.currentChallenge
                                                          ? Colors.grey
                                                          : Colors.amberAccent,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 5,
                                              height: 150,
                                              margin: const EdgeInsets.only(right: 8.0),
                                              decoration: BoxDecoration(
                                                color: index < widget.currentChallenge
                                                    ? Colors.green
                                                    : index > widget.currentChallenge
                                                        ? Colors.grey
                                                        : Colors.amber,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            if (index == challengeResponse.length - 1)
                                              Container(
                                                width: 20.0,
                                                height: 20.0,
                                                margin: const EdgeInsets.only(right: 8.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                  border: Border.all(
                                                    color: Colors.redAccent,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.outlined_flag,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Container(
                                          height: 135,
                                          width: 300,
                                          padding: const EdgeInsets.all(16),
                                          decoration: AppStyles.challengeBoxStyle(index, widget.currentChallenge),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if (index <= widget.currentChallenge) ...[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          challengeResponse[index]["description"].toString(),
                                                          textAlign: TextAlign.left,
                                                          style: AppStyles.logisticsStyle,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.timer, color: Colors.white),
                                                      const SizedBox(width: 5),
                                                      if (index < widget.currentChallenge) ...[
                                                        Text(
                                                          secondsToMinutes(Provider.of<HuntProgressModel>(context).secondsSpentList[index + 1]),
                                                          style: AppStyles.logisticsStyle,
                                                        ),
                                                      ] else if (index == widget.currentChallenge) ...[
                                                        Text(
                                                          "Not yet started",
                                                          style: AppStyles.logisticsStyle,
                                                        ),
                                                      ] else ...[
                                                        Text(
                                                          secondsToMinutes(widget.totalSeconds),
                                                          style: AppStyles.logisticsStyle,
                                                        ),
                                                      ],
                                                      Spacer(),
                                                      if (index == widget.currentChallenge) ...[
                                                        Container(
                                                          height: 50,
                                                          width: 75,
                                                          decoration: AppStyles.challengeButtonStyle,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ChallengeView(
                                                                huntName: widget.huntName,
                                                                huntID: widget.huntID,
                                                                teamID: widget.teamID,
                                                                previousSeconds: widget.totalSeconds,
                                                                previousPoints: widget.totalPoints,
                                                                challengeID: challengeResponse[index]['id'], // Pass the correct challenge ID
                                                                challengeNum: index,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        style: AppStyles.elevatedButtonStyle,
                                                        child: const Text(
                                                          'GO',
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    SizedBox(
                                                      height: 50,
                                                      width: 75,
                                                    ),
                                                  ]
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.two_mp_outlined, color: Colors.white),
                                                  const SizedBox(width: 5),
                                                  if (index < widget.currentChallenge) ...[
                                                    // Display points from the HuntProgressModel for completed challenges
                                                    Text(
                                                      "${Provider.of<HuntProgressModel>(context).pointsEarnedList[index+1]}/300 points",
                                                      style: AppStyles.logisticsStyle,
                                                    ),
                                                  ] else if (index == widget.currentChallenge) ...[
                                                    // Display "Not yet started" for the current challenge
                                                    Text(
                                                      "300 points possible",
                                                      style: AppStyles.logisticsStyle,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ] else if (index > widget.currentChallenge) ...[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Icon(Icons.lock, color: Colors.black, size: 50),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No data available.'));
                      }
                    },
                  ),
                )
               ],
            ),
          ),
        ),
      ]),
    ));
  }

  String secondsToMinutes(int numSeconds) {
    int minutes = numSeconds ~/ 60;
    int seconds = numSeconds % 60;

    if (seconds < 10) {
      return "$minutes:0$seconds";
    }

    return "$minutes:$seconds";
  }
}