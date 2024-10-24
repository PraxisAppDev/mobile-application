import 'package:flutter/material.dart';
import 'dart:async';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';

class HuntAloneView extends StatefulWidget {
  final String teamName;
  final String huntName;
  final String venue;
  final String huntDate;

  const HuntAloneView(
      {super.key,
      required this.teamName,
      required this.huntName,
      required this.venue,
      required this.huntDate});

  @override
  _HuntAloneViewState createState() => _HuntAloneViewState();
}

@override
_HuntAloneViewState createState() => _HuntAloneViewState();

@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppStyles.appBarStyle("Hunt Alone Screen", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: Center(
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
                            "Explore Praxis",
                            textAlign: TextAlign.left,
                            style: AppStyles.logisticsStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.location_pin, color: Colors.white),
                          Text(
                            "The Greene Turtle (in-person only)",
                            style: AppStyles.logisticsStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.white),
                          Text(
                            "01/30/2024 at 8:30pm",
                            style: AppStyles.logisticsStyle,
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              Text(
                "You are currently hunting alone as...",
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
                    const Icon(Icons.person, color: Colors.white),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 205,
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.edit, color: Colors.white),
                            border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            labelText: 'Enter name here...',
                            labelStyle: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            filled: true,
                            fillColor: Colors.grey),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.lock, color: Colors.white),
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
              const SizedBox(height: 50), // Add space between buttons
              Container(
                height: 50,
                width: 175,
                decoration: AppStyles.confirmButtonStyle,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartHuntView()),
                    );
                  },
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text('Start Hunt',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 50), // Add space between buttons
              Container(
                height: 50,
                width: 175,
                decoration: AppStyles.cancelButtonStyle,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartHuntView()),
                    );
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
  );
}

class _HuntAloneViewState extends State<HuntAloneView> {
  late TextEditingController _teamNameController;
  late FocusNode _focusNode;
  bool _isEditing = false;
  bool _showPopup = false;
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.teamName);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _unfocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _startHunt() {
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
                    _showPopup = false; // Hide the popup
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
                      // ElevatedButton(
                      //   onPressed: () {
                      //     _timer?.cancel(); // Stop the timer
                      //     Navigator.pop(context); // Close the dialog
                      //   },
                      //   child: const Text('Cancel'),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     if (_countdown > 0) {
    //       _countdown--;
    //     } else {
    //       timer.cancel();
    //       _showPopup = false;
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const ChallengeView()),
    //       );
    //     }
    //   });
    // });
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
                    "You are currently hunting alone as: ${widget.teamName}",
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
                            controller: _teamNameController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit, color: Colors.white),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: _isEditing ? null : widget.teamName,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted solo team')),
                        );
                      },
                      style: AppStyles.elevatedButtonStyle,
                      child: const Text('Delete Team',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // if (_showPopup)
                  //   Container(
                  //     color: Colors.black.withOpacity(0.5),
                  //     child: Center(
                  //       child: Container(
                  //         padding: EdgeInsets.all(20),
                  //         decoration: AppStyles.infoBoxStyle,
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Text(
                  //               'You have started the hunt,',
                  //               style: AppStyles.titleStyle,
                  //               textAlign: TextAlign.center,
                  //             ),
                  //             Text(
                  //               'game will begin in',
                  //               style: AppStyles.titleStyle,
                  //               textAlign: TextAlign.center,
                  //             ),
                  //             SizedBox(height: 20),
                  //             Text(
                  //               '$_countdown',
                  //               style: AppStyles.titleStyle.copyWith(fontSize: 48),
                  //             ),
                  //             Text(
                  //               'seconds',
                  //               style: AppStyles.titleStyle,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
