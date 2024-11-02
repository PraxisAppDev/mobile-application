import 'package:flutter/material.dart';
import 'dart:async';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_with_team_view.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/apis/fetch_hunts.dart';
import 'package:praxis_afterhours/apis/fetch_teams.dart';
import 'package:praxis_afterhours/apis/post_create_teams.dart';
import 'package:praxis_afterhours/apis/put_start_hunt.dart';

class HuntAloneView extends StatefulWidget {
  final String teamName;
  final String huntID;
  final String huntName;
  final String venue;
  final String huntDate;

  const HuntAloneView({
    super.key,
    required this.teamName,
    required this.huntID,
    required this.huntName,
    required this.venue,
    required this.huntDate
  });

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
}

class _HuntAloneViewState extends State<HuntAloneView> {
  late TextEditingController _playerNameController;
  late FocusNode _focusNode;
  bool _isEditing = false;
  bool _showPopup = false;
  int _countdown = 3;
  Timer? _timer;
  
  late String huntName;
  late String venue;

  @override
  void initState() {
    super.initState();
    _playerNameController = TextEditingController();
    _focusNode = FocusNode();
    huntName = widget.huntName;
    venue = widget.venue;

    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _focusNode.dispose();
    _timer?.cancel(); 
    super.dispose();
  }

  void _unfocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  Future<void> makeTeam() async {
    String playerName = _playerNameController.text.trim();
    if (playerName.isEmpty) {
      throw Exception("Player name cannot be empty");
    }

    try {
      final postResponse = await createTeam(widget.huntID, widget.teamName, playerName, true);
      await startHunt(widget.huntID, postResponse['teamId']);
    } catch (e) {
      throw e;
    }
  }

  void _startHunt() async {
    try {
      await makeTeam();
      
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HuntProgressView(huntName: huntName, huntID: widget.huntID, totalSeconds: 0, totalPoints: 0, secondsSpentThisRound: 0, pointsEarnedThisRound: 0, currentChallenge: 0)),
                      );
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
    return GestureDetector(
      onTap: _unfocusTextField,
      child: Scaffold(
        appBar: AppStyles.appBarStyle("Hunt Alone", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 350,
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
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.white),
                            Text(
                              widget.venue,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.white),
                            Text(
                              widget.huntDate,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "You are currently hunting in team: ${widget.teamName}",
                    style: AppStyles.logisticsStyle,
                  ),
                  const SizedBox(width: 350, child: Divider(thickness: 2)),
                  Container(
                    height: 75,
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 205,
                          child: TextField(
                            controller: _playerNameController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit, color: Colors.white),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: _isEditing ? null : "Enter Player Name",
                              labelStyle: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              filled: true,
                              fillColor: Colors.grey,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.lock, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          "(Solo)",
                          style: AppStyles.logisticsStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(width: 350, child: Divider(thickness: 2)),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: const Text(
                      "There are 3 teams and one solo team currently hunting. Select \"Start Hunt\" when you are ready to begin.",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'InriaSerif'),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: 175,
                    decoration: AppStyles.confirmButtonStyle,
                    child: ElevatedButton(
                      onPressed: _startHunt,
                      style: AppStyles.elevatedButtonStyle,
                      child: const Text('Start Hunt',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: 175,
                    decoration: AppStyles.cancelButtonStyle,
                    child: ElevatedButton(
                      onPressed: () {
                        ShowDeleteConfirmationDialog(context);
                      },
                      style: AppStyles.elevatedButtonStyle,
                      child: const Text('Delete Team',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

Future<void> ShowDeleteConfirmationDialog(BuildContext context) async {
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
                      decoration: AppStyles.cancelButtonStyle,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: AppStyles.elevatedButtonStyle, // Applying elevatedButtonStyle
                        child: const Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Yes Button
                    Container(
                      decoration: AppStyles.confirmButtonStyle,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(); // Navigate back to hunt mode screen
                          Navigator.of(context).pop();
                        },
                        style: AppStyles.elevatedButtonStyle, // Applying elevatedButtonStyle
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