import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_view.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_mode_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_with_team_view.dart';
import 'package:praxis_afterhours/apis/put_start_hunt.dart';
import 'package:praxis_afterhours/apis/delete_team.dart';
import 'package:praxis_afterhours/apis/patch_update_team.dart';
import 'package:praxis_afterhours/apis/post_join_team.dart';
import '../../apis/post_create_teams.dart';
import 'package:provider/provider.dart';
import '../../provider/game_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyTeamCreateView extends StatefulWidget {
  final String huntId;
  final String huntName;
  final String teamId;
  final String teamName;
  final String playerName;

  const MyTeamCreateView({
    super.key,
    required this.huntId,
    required this.huntName,
    required this.teamId,
    required this.teamName,
    required this.playerName,
  });

  @override
  _MyTeamCreateViewState createState() => _MyTeamCreateViewState();
}

class _MyTeamCreateViewState extends State<MyTeamCreateView> {
  late TextEditingController _teamNameController;
  late FocusNode _focusNode;
  bool _isEditing = false;
  bool _showPopup = false;
  int _countdown = 3;
  Timer? _timer;

  String?
      _updatedTeamId; //new variable to store team id returned from create team api call

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
    super.dispose();
  }

  void _unfocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
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

  void connectWebSocket() async {
    final wsUrl = Uri.parse(
        'ws://afterhours.praxiseng.com/ws/hunt?huntId=${widget.huntId}&teamId=${widget.teamName}&playerName=${widget.playerName}&huntAlone=false');
    try {
      print('Connecting to WebSocket at: $wsUrl');
      var channel = WebSocketChannel.connect(wsUrl);
      print('Connected to WebSocket. Awaiting messages...');
      channel.stream.listen(
        (message) {
          print('Received message: $message');
          // showSnackbarMessage("Received message: $message");
          showToast("Received message: $message");
        },
        onError: (error) {
          print('WebSocket error: $error');
          // showSnackbarMessage('WebSocket error: $error');
          showToast("WebSocket error: $error");
        },
        onDone: () {
          print('WebSocket closed');
          // showSnackbarMessage('WebSocket closed');
          showToast("Websocket closed");
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
    }
  }

  Future<void> makeTeam() async {
    String teamName = _teamNameController.text.trim();
    if (teamName.isEmpty) {
      throw Exception("Team name cannot be empty");
    }

    try {
      final postResponse = await createTeam(
          widget.huntId, widget.teamName, widget.playerName, true);
      _updatedTeamId =
          postResponse['teamId']; // new team ID returned when team was created
      await startHunt(widget.huntId, _updatedTeamId!);
    } catch (e) {
      throw e;
    }
  }

  void _startHunt() async {
    try {
      final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
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

                      huntProgressModel.totalSeconds = 0;
                      huntProgressModel.totalPoints = 0;
                      huntProgressModel.secondsSpentThisRound = 0;
                      huntProgressModel.pointsEarnedThisRound = 0;
                      huntProgressModel.currentChallenge = 0;
                      Navigator.pushReplacement(
                        context,
                        // MaterialPageRoute(builder: (context) => HuntProgressView(
                        //   huntName: widget.huntName,
                        //   huntID: widget.huntId,
                        //   teamID: _updatedTeamId ?? widget.teamId, // use updated team id from api call
                        //   totalSeconds: 0,
                        //   totalPoints: 0,
                        //   secondsSpentThisRound: 0,
                        //   pointsEarnedThisRound: 0,
                        //   currentChallenge: 0
                        // )),
                        MaterialPageRoute(builder: (context) => HuntProgressView())
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

  Future<void> _updateTeamName() async {
    String newTeamName = _teamNameController.text.trim();
    if (newTeamName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team name cannot be empty')),
      );
      return;
    }

    try {
      await updateTeam(widget.huntId, widget.teamId, newTeamName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team name updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update team: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusTextField, // Unfocus when tapping outside the TextField
      child: Scaffold(
        appBar: AppStyles.appBarStyle("My Team", context),
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cracked_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Team Name",
                  style: AppStyles.logisticsStyle,
                ),
                const SizedBox(width: 350, child: Divider(thickness: 2)),
                Container(
                  height: 75,
                  width: 325,
                  padding: const EdgeInsets.all(16),
                  decoration: AppStyles.infoBoxStyle,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _teamNameController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.check, color: Colors.white),
                              onPressed: _updateTeamName,
                            ),
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
                          onSubmitted: (value) {
                            _updateTeamName();
                          },
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 75,
                  width: 325,
                  padding: const EdgeInsets.all(16),
                  decoration: AppStyles.infoBoxStyle,
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.crown, color: Color(0xFFFFD700)),
                      const SizedBox(width: 5),
                      Icon(Icons.person, color: Colors.green),
                      const SizedBox(width: 5),
                      SizedBox(
                        child: Text(
                          widget.playerName,
                          style: AppStyles.logisticsStyle,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "(Me)",
                        style: AppStyles.logisticsStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.confirmButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      connectWebSocket();
                      _startHunt();
                      _updateTeamName();
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text(
                      'Start Hunt',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.cancelButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      ShowDeleteConfirmationDialog(
                          context, widget.huntId, widget.teamId);
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text(
                      'Delete Team',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> ShowTeamFullDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
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
                    Color(0xff281717),
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
                        'Your team has reached it\'s limit, waiting for team leader to start game',
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
              decoration: AppStyles.popupStyle(),
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
                        'You have started the game, beginning play soon',
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
  print(context.widget);
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
                      decoration: AppStyles.confirmButtonStyle,
                      child: ElevatedButton(
                        onPressed: () {
                          deleteTeam(huntId, teamId);
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context)
                              .pop(); // Navigate back to hunt mode screen
                          Navigator.of(context).pop();
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
