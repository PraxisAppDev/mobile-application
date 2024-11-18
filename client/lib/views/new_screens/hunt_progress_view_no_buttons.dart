import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view_no_buttons.dart';
import 'package:provider/provider.dart';

import '../../provider/game_model.dart';

class HuntProgressViewNoButtons extends StatefulWidget {
  // final String huntName;
  // final String huntID;
  // final String teamID;
  // final int totalSeconds;
  // final int totalPoints;
  // final int secondsSpentThisRound;
  // final int pointsEarnedThisRound;
  // final int currentChallenge;
  //
  // const HuntProgressViewNoButtons(
  //     {super.key,
  //       required this.huntName,
  //       required this.huntID,
  //       required this.teamID,
  //       required this.totalSeconds,
  //       required this.totalPoints,
  //       required this.secondsSpentThisRound,
  //       required this.pointsEarnedThisRound,
  //       required this.currentChallenge}
  //     );

  const HuntProgressViewNoButtons({super.key});

  @override
  _HuntProgressViewNoButtonsState createState() =>
      _HuntProgressViewNoButtonsState();
}

class _HuntProgressViewNoButtonsState extends State<HuntProgressViewNoButtons> {
  List<dynamic> challenges = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    // Add the current round's data to the model
    // print("CHECKKK ${widget.secondsSpentThisRound}");
    huntProgressModel.addSecondsSpent(huntProgressModel.secondsSpentThisRound);
    huntProgressModel.addPointsEarned(huntProgressModel.pointsEarnedThisRound);
    huntProgressModel.startTimer();
    fetchChallengesData(); // Fetch challenges when the widget is initialized

    /* WILL CHANGE LATER TO LISTEN TO WEBSOCKET MESSAGE */
    _redirectToChallengeNoButtons(); // hardcoded
  }

   Future<void> _redirectToChallengeNoButtons() async {
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    huntProgressModel.previousSeconds = huntProgressModel.totalSeconds;
    huntProgressModel.previousPoints = huntProgressModel.totalPoints;
    

    try {
      // Fetch challenges data to ensure it's available
      final challenges = await fetchChallenges(huntProgressModel.huntId);

      // Navigate to Challenge 1
      if (challenges.isNotEmpty) {
        huntProgressModel.challengeId = challenges[0]['id'];
        huntProgressModel.challengeNum = 0;
        huntProgressModel.totalChallenges = challenges.length;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeViewNoButtons(huntProgressModel.challengeId, currentChallenge: 1,),
          ),
        );
      } else {
        // Handle case where no challenges are available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No challenges available for this hunt.")),
        );
      }
    } catch (e) {
      // Handle fetchChallenges error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading challenges: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.noBackArrowAppBarStyle("Hunt Progress", context),
      body: const Center(
        child: CircularProgressIndicator(), // Show loading spinner while redirecting
      ),
    );
  }
  
  Future<void> fetchChallengesData() async {
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    var data = await fetchChallenges(huntProgressModel.huntId); // Call the imported fetchChallenges function
    setState(() {
      challenges = data; // Update the challenges list
      isLoading = false; // Update loading state
    });
  }

  @override
  void dispose() {
    Provider.of<HuntProgressModel>(context, listen: false).stopTimer();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final huntProgressModel =
  //   Provider.of<HuntProgressModel>(context, listen: false);

  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppStyles.noBackArrowAppBarStyle("Hunt Progress", context),
  //       body: DecoratedBox(
  //         decoration: AppStyles.backgroundStyle,
  //         // child:
  //         child: Center(
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 25),
  //               Container(
  //                   width: 350,
  //                   height: 150,
  //                   padding: const EdgeInsets.all(16),
  //                   decoration: AppStyles.infoBoxStyle,
  //                   child: Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             huntProgressModel.huntName,
  //                             textAlign: TextAlign.left,
  //                             style: AppStyles.logisticsStyle,
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(height: 20),
  //                       Consumer<HuntProgressModel>(
  //                         builder: (context, huntProgressModel, child) {
  //                           final minutes =
  //                           (huntProgressModel.secondsSpent ~/ 60)
  //                               .toString()
  //                               .padLeft(2, '0');
  //                           final seconds =
  //                           (huntProgressModel.secondsSpent % 60)
  //                               .toString()
  //                               .padLeft(2, '0');
  //                           return Row(
  //                             children: [
  //                               Icon(Icons.timer,
  //                                   color: Colors.white, size: 25),
  //                               Text(
  //                                 '$minutes:$seconds',
  //                                 style: AppStyles.logisticsStyle,
  //                               ),
  //                             ],
  //                           );
  //                         },
  //                       ),
  //                       SizedBox(height: 20),
  //                       Row(
  //                         children: [
  //                           Icon(Icons.two_mp_outlined,
  //                               color: Colors.white, size: 25),
  //                           Text(
  //                             "${huntProgressModel.totalPoints} points",
  //                             style: AppStyles.logisticsStyle,
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   )),
  //               const SizedBox(height: 20),
  //               Expanded(
  //                 child: FutureBuilder<List<dynamic>>(
  //                   future: fetchChallenges(huntProgressModel.huntId),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return const Center(child: CircularProgressIndicator());
  //                     } else if (snapshot.hasError) {
  //                       return Center(child: Text('Error: ${snapshot.error}'));
  //                     } else if (snapshot.hasData) {
  //                       final List<dynamic> challengeResponse = snapshot.data!;
  //                       return ListView.builder(
  //                         itemCount: challengeResponse.length,
  //                         itemBuilder: (context, index) {
  //                           return Column(
  //                             children: [
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment
  //                                     .center, // Center items in the row
  //                                 children: [
  //                                   Column(
  //                                     // Circle container
  //                                     children: [
  //                                       Container(
  //                                         width: 20.0, // Increased size
  //                                         height: 20.0, // Increased size
  //                                         margin:
  //                                         const EdgeInsets.only(right: 8.0),
  //                                         decoration: BoxDecoration(
  //                                           shape: BoxShape.circle,
  //                                           color: index <
  //                                               huntProgressModel
  //                                                   .currentChallenge
  //                                               ? Colors.green
  //                                               : index >
  //                                               huntProgressModel
  //                                                   .currentChallenge
  //                                               ? Colors.grey
  //                                               : Colors.amber,
  //                                           border: Border.all(
  //                                             color: index <
  //                                                 huntProgressModel
  //                                                     .currentChallenge
  //                                                 ? Colors.greenAccent
  //                                                 : index >
  //                                                 huntProgressModel
  //                                                     .currentChallenge
  //                                                 ? Colors.grey
  //                                                 : Colors.amberAccent,
  //                                             //width: 2.0,
  //                                           ),
  //                                         ),
  //                                         child: Center(
  //                                           child: Text(
  //                                             '${index + 1}', // Displaying the index as a number (1-based)
  //                                             textAlign: TextAlign.center,
  //                                             style: const TextStyle(
  //                                               color:
  //                                               Colors.white, // Text color
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 12, // Text size
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         width: 5,
  //                                         height: 150,
  //                                         margin:
  //                                         const EdgeInsets.only(right: 8.0),
  //                                         decoration: BoxDecoration(
  //                                           color: index <
  //                                               huntProgressModel
  //                                                   .currentChallenge
  //                                               ? Colors.green
  //                                               : index >
  //                                               huntProgressModel
  //                                                   .currentChallenge
  //                                               ? Colors.grey
  //                                               : Colors.amber,
  //                                           borderRadius: BorderRadius.circular(
  //                                               8.0), // Rounded corners
  //                                         ),
  //                                       ),
  //                                       if (index ==
  //                                           challengeResponse.length - 1)
  //                                         Container(
  //                                           width: 20.0, // Increased size
  //                                           height: 20.0, // Increased size
  //                                           margin: const EdgeInsets.only(
  //                                               right: 8.0),
  //                                           decoration: BoxDecoration(
  //                                             shape: BoxShape.circle,
  //                                             color: Colors
  //                                                 .red, // Background color
  //                                             border: Border.all(
  //                                               color: Colors.redAccent,
  //                                               width: 2.0,
  //                                             ),
  //                                           ),
  //                                           child: Center(
  //                                             child: Icon(
  //                                               Icons
  //                                                   .outlined_flag, // Replace with the desired icon
  //                                               color:
  //                                               Colors.white, // Icon color
  //                                               size:
  //                                               12, // Adjust size as needed
  //                                             ),
  //                                           ),
  //                                         ),
  //                                     ],
  //                                   ),
  //                                   // Challenge container
  //                                   Container(
  //                                     height: 135,
  //                                     width: 300,
  //                                     padding: const EdgeInsets.all(16),
  //                                     decoration: AppStyles.challengeBoxStyle(
  //                                         index,
  //                                         huntProgressModel.currentChallenge),
  //                                     child: Center(
  //                                       // Center content inside the challenge container
  //                                       child: Column(
  //                                         mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                         crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                         children: [
  //                                           // Check if the index is less than or equal to currentChallenge
  //                                           if (index <=
  //                                               huntProgressModel
  //                                                   .currentChallenge) ...[
  //                                             Row(
  //                                               mainAxisAlignment:
  //                                               MainAxisAlignment.center,
  //                                               children: [
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     challengeResponse[index]
  //                                                     ["description"]
  //                                                         .toString(),
  //                                                     textAlign: TextAlign.left,
  //                                                     style: AppStyles
  //                                                         .logisticsStyle,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             Row(
  //                                               mainAxisAlignment:
  //                                               MainAxisAlignment.center,
  //                                               children: [
  //                                                 Icon(Icons.timer,
  //                                                     color: Colors.white),
  //                                                 const SizedBox(width: 5),
  //                                                 if (index <
  //                                                     huntProgressModel
  //                                                         .currentChallenge) ...[
  //                                                   // Display timer from the HuntProgressModel for completed challenges
  //                                                   Text(
  //                                                     secondsToMinutes(Provider
  //                                                         .of<HuntProgressModel>(
  //                                                         context)
  //                                                         .secondsSpentList[
  //                                                     index + 1]),
  //                                                     style: AppStyles
  //                                                         .logisticsStyle,
  //                                                   ),
  //                                                 ] else if (index ==
  //                                                     huntProgressModel
  //                                                         .currentChallenge) ...[
  //                                                   // Display "Not yet started" for the current challenge
  //                                                   Text(
  //                                                     "Not yet started",
  //                                                     style: AppStyles
  //                                                         .logisticsStyle,
  //                                                   ),
  //                                                 ] else ...[
  //                                                   // Placeholder for upcoming challenges
  //                                                   Text(
  //                                                     secondsToMinutes(
  //                                                         huntProgressModel
  //                                                             .totalSeconds),
  //                                                     style: AppStyles
  //                                                         .logisticsStyle,
  //                                                   ),
  //                                                 ],
  //                                                 Spacer(),
  //                                                 SizedBox(
  //                                                   height: 50,
  //                                                   width: 75,
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             Row(
  //                                               children: [
  //                                                 Icon(Icons.two_mp_outlined,
  //                                                     color: Colors.white),
  //                                                 const SizedBox(width: 5),
  //                                                 if (index <
  //                                                     huntProgressModel
  //                                                         .currentChallenge) ...[
  //                                                   // Display points from the HuntProgressModel for completed challenges
  //                                                   Text(
  //                                                     "${Provider.of<HuntProgressModel>(context).pointsEarnedList[index + 1]}/300 points",
  //                                                     style: AppStyles
  //                                                         .logisticsStyle,
  //                                                   ),
  //                                                 ] else if (index ==
  //                                                     huntProgressModel
  //                                                         .currentChallenge) ...[
  //                                                   // Display "Not yet started" for the current challenge
  //                                                   Text(
  //                                                     "300 points possible",
  //                                                     style: AppStyles
  //                                                         .logisticsStyle,
  //                                                   ),
  //                                                 ],
  //                                               ],
  //                                             ),
  //                                           ] else if (index >
  //                                               huntProgressModel
  //                                                   .currentChallenge) ...[
  //                                             Row(
  //                                               mainAxisAlignment:
  //                                               MainAxisAlignment.center,
  //                                               children: [
  //                                                 Center(
  //                                                   child: Icon(Icons.lock,
  //                                                       color: Colors.black,
  //                                                       size: 50),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           );
  //                         },
  //                       );
  //                     } else {
  //                       return const Center(child: Text('No data available.'));
  //                     }
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  String secondsToMinutes(int numSeconds) {
    int minutes = numSeconds ~/ 60;
    int seconds = numSeconds % 60;

    if (seconds < 10) {
      return "$minutes:0$seconds";
    }

    return "$minutes:$seconds";
  }
}