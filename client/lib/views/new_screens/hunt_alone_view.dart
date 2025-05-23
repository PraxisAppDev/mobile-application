import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_with_team_view.dart';
import 'package:praxis_afterhours/views/new_screens/leaderboard.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/apis/DEPRECATEDfetch_hunts.dart';
import 'package:praxis_afterhours/apis/fetch_teams.dart';
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/apis/fetch_challenge_hint.dart';
import 'package:praxis_afterhours/apis/post_create_teams.dart';
import 'package:praxis_afterhours/apis/put_start_hunt.dart';
import 'package:praxis_afterhours/apis/delete_team.dart';
import 'package:praxis_afterhours/apis/post_join_team.dart';
import '../../provider/game_model.dart';
import 'package:provider/provider.dart';
import '../../provider/websocket_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HuntAloneView extends StatefulWidget {
  // String teamName;
  // final String huntId;
  // final String huntName;
  // final String venue;
  // final String huntDate;
  // String? teamId;
  //
  // HuntAloneView({
  //   super.key,
  //   required this.teamName,
  //   required this.huntId,
  //   required this.huntName,
  //   required this.venue,
  //   required this.huntDate,
  //   this.teamId,
  // });

  const HuntAloneView({super.key});

  @override
  _HuntAloneViewState createState() => _HuntAloneViewState();
}

@override
_HuntAloneViewState createState() => _HuntAloneViewState();

// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: Scaffold(
//       appBar: AppStyles.appBarStyle("Hunt Alone Screen", context),
//       body: DecoratedBox(
//         decoration: AppStyles.backgroundStyle,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                   height: 150,
//                   width: 350,
//                   padding: const EdgeInsets.all(16),
//                   decoration: AppStyles.infoBoxStyle,
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Explore Praxis",
//                             textAlign: TextAlign.left,
//                             style: AppStyles.logisticsStyle,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_pin, color: Colors.white),
//                           Text(
//                             "The Greene Turtle (in-person only)",
//                             style: AppStyles.logisticsStyle,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           const Icon(Icons.calendar_month, color: Colors
//                               .white),
//                           Text(
//                             "01/30/2024 at 8:30pm",
//                             style: AppStyles.logisticsStyle,
//                           ),
//                         ],
//                       ),
//                     ],
//                   )),
//               const SizedBox(height: 20),
//               Text(
//                 "You are currently hunting alone as...",
//                 style: AppStyles.logisticsStyle,
//               ),
//               const SizedBox(width: 350, child: Divider(thickness: 2)),
//               Container(
//                 height: 75,
//                 width: 350,
//                 padding: const EdgeInsets.all(16),
//                 decoration: AppStyles.infoBoxStyle,
//                 child: Row(
//                   children: [
//                     const Icon(Icons.person, color: Colors.white),
//                     const SizedBox(width: 5),
//                     SizedBox(
//                       width: 205,
//                       child: TextField(
//                         decoration: InputDecoration(
//                             suffixIcon: const Icon(
//                                 Icons.edit, color: Colors.white),
//                             border: UnderlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                     color: Colors.white)),
//                             labelText: 'Enter name here...',
//                             labelStyle:
//                             const TextStyle(
//                                 color: Colors.white, fontSize: 14),
//                             filled: true,
//                             fillColor: Colors.grey),
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     const Icon(Icons.lock, color: Colors.white),
//                     const SizedBox(width: 5),
//                     Text(
//                       "(Solo)",
//                       style: AppStyles.logisticsStyle,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const SizedBox(width: 350, child: Divider(thickness: 2)),
//               Container(
//                 width: 350,
//                 padding: const EdgeInsets.all(16),
//                 decoration: AppStyles.infoBoxStyle,
//                 child: const Text(
//                   "There are 3 teams and one solo team currently hunting. Select \"Start Hunt\" when you are ready to begin.",
//                   style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontFamily: 'InriaSerif'),
//                 ),
//               ),
//               const SizedBox(height: 50), // Add space between buttons
//               Container(
//                 height: 50,
//                 width: 175,
//                 decoration: AppStyles.confirmButtonStyle,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const StartHuntView(huntID: widget.huntID)),
//                     );
//                   },
//                   style: AppStyles.elevatedButtonStyle,
//                   child: const Text('Start Hunt',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//               ),
//               const SizedBox(height: 50), // Add space between buttons
//               Container(
//                 height: 50,
//                 width: 175,
//                 decoration: AppStyles.cancelButtonStyle,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const StartHuntView(huntID: widget.huntID)),
//                     );
//                   },
//                   style: AppStyles.elevatedButtonStyle,
//                   child: const Text('Delete Team',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

class _HuntAloneViewState extends State<HuntAloneView> {
  bool _showPopup = false;
  int _countdown = 3;
  Timer? _timer;

  String? _updatedTeamId; // will hold new Team ID when team is created

  late String huntName;
  late String venue;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // void showSnackbarMessage(String message) {
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(message)),
  //     );
  //   }
  // }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void handleMessage(BuildContext context, String message) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
  }

  void connectWebSocket(
      BuildContext context,
      HuntProgressModel huntProgressModel,
      WebSocketModel webSocketModel) async {
    final playerName = huntProgressModel.playerName;
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player name cannot be empty')),
      );
      return;
    }

    final wsUrl =
        'ws://afterhours.praxiseng.com/ws/hunt?huntId=${huntProgressModel.huntId}&teamId=${huntProgressModel.teamName}&playerName=$playerName&huntAlone=true';
    try {
      // print('Connecting to WebSocket at: $wsUrl');
      webSocketModel.connect(wsUrl);
      // print('Connected to WebSocket. Awaiting messages...');
      final channel = webSocketModel.messages;
      channel.listen(
        (message) {
          try {
            final Map<String, dynamic> data = json.decode(message);
            final String eventType = data['eventType'];
            if (eventType == "PLAYER_JOINED_TEAM") {
              showToast("${data['playerName']} joined team");
            } else if (eventType == "PLAYER_LEFT_TEAM") {
              showToast("${data['playerName']} left team");
            } else if (eventType == "HUNT_STARTED") {
              showToast("Hunt started");
            } else if (eventType == "HUNT_ENDED") {
              showToast("Hunt ended");
            } else if (eventType == "CHALLENGE_STARTED") {
              var challengeName = fetchChallenge(data['huntId'], data['challengeId']);
              showToast("Challenge $challengeName started");
            } else if (eventType == "CHALLENGE_RESPONSE") {
              showToast("Challenge response");
            } else if (eventType == "TEAM_UPDATED") {
              showToast("${data['teamName']} Team updated");
            } else if (eventType == "SHOW_CHALLENGE_HINT") {
              var hint = fetchChallengeHint(data['huntId'], data['challengeId'], data['hintId']);
              showToast("$hint");
            }
          } catch (e) {
            print(e);
          }
          // print('Received message: $message');
        },
        onError: (error) {
          // print('WebSocket error: $error');
          // showToast("WebSocket error: $error");
        },
        onDone: () {
          // print('WebSocket closed');
          //showToast("Websocket closed");
        },
        cancelOnError: true,
      );
    } catch (e) {
      // print('Failed to connect to WebSocket: $e');
    }
  }

  void _startHunt(HuntProgressModel huntProgressModel) async {
    try {
      final huntProgressModel =
          Provider.of<HuntProgressModel>(context, listen: false);

      setState(() {
        _showPopup = true;
      });

      showDialog(
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
                      _showPopup = false;

                      huntProgressModel.totalSeconds = 0;
                      huntProgressModel.totalPoints = 0;
                      huntProgressModel.secondsSpentThisRound = 0;
                      huntProgressModel.pointsEarnedThisRound = 0;
                      huntProgressModel.currentChallenge = 0;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HuntProgressView()));
                    });
                  }
                });
              });

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
                        const Text(
                          'You have started the hunt!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Game will begin in',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$_countdown',
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'seconds',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start hunt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel =
        Provider.of<HuntProgressModel>(context, listen: false);
    final webSocketModel = Provider.of<WebSocketModel>(context, listen: true);

    return Scaffold(
      appBar: AppStyles.appBarStyle("Hunt Alone", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 350,
                height: 150,
                padding: EdgeInsets.all(16),
                decoration: AppStyles.infoBoxStyle,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          huntProgressModel.huntName,
                          textAlign: TextAlign.left,
                          style: AppStyles.logisticsStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.white),
                        Text(
                          huntProgressModel.venue,
                          style: AppStyles.logisticsStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.white),
                        Text(
                          huntProgressModel.huntDate,
                          style: AppStyles.logisticsStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You are currently hunting in team: ${huntProgressModel.teamName}",
                style: AppStyles.logisticsStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 2)),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: AppStyles.infoBoxStyle,
                  child: FutureBuilder<List<dynamic>>(
                    future: fetchTeamsFromHunt(huntProgressModel.huntId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        // If the data was successfully retrieved, display it
                        List<dynamic> teams = snapshot.data!;
                        // print(snapshot.data);
                        return Text(
                          "There are ${teams.length} teams hunting. Select \"Start Hunt\" when you are ready to begin.",
                          style:
                              AppStyles.logisticsStyle.copyWith(fontSize: 16),
                        );
                      } else {
                        return const Center(child: Text('No data available.'));
                      }
                    },
                  )),
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.confirmButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      connectWebSocket(
                          context, huntProgressModel, webSocketModel);
                      _startHunt(huntProgressModel);
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Start Hunt',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
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

Future<void> ShowDeleteConfirmationDialog(
    BuildContext context, String huntId, String teamId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap a button!
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
                    'Are you sure you want to delete the team?',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // No Button
                    Container(
                      height: 50,
                      width: 80,
                      decoration: AppStyles.cancelButtonStyle,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: AppStyles
                            .elevatedButtonStyle, // Applying elevatedButtonStyle
                        child: const Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Yes Button
                    Container(
                      height: 50,
                      width: 80,
                      decoration: AppStyles.confirmButtonStyle,
                      child: ElevatedButton(
                        onPressed: () {
                          deleteTeam(huntId, teamId);
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context)
                              .pop(); // Navigate back to hunt mode screen
                          Navigator.of(context).pop();
                        },
                        style: AppStyles
                            .elevatedButtonStyle, // Applying elevatedButtonStyle
                        child: const Text(
                          'Yes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(height: 45, child: DotDivider),
              ],
            ),
          ),
        ),
      );
    },
  );
}

//Tells players the game is starting, dissappears after 3 seconds
Future<void> ShowGameStartDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 3), () => Navigator.of(context).pop());
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.all(0),
          content: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff261919),
                    Color(0xff332323),
                    Color(0xff261919),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: DotDivider,
                          ),
                          SizedBox(
                            width: 32,
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Your team leader has started the game, beginning play',
                        style: AppStyles.titleStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 45, child: DotDivider)
                  ],
                ),
              )));
    },
  );
}

Future<void> showNoPlayerNameDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.all(0),
          content: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff261919),
                    Color(0xff332323),
                    Color(0xff261919),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: DotDivider,
                          ),
                          SizedBox(
                              width: 32,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close, color: Colors.white)))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Your player name cannot be empty!',
                        style: AppStyles.titleStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 45, child: DotDivider)
                  ],
                ),
              )
          )
      );
    },
  );
}