import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/fetch_challenge.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_progress_view_no_buttons.dart';
import '../../provider/game_model.dart';
import '../../provider/websocket_model.dart';

class ChallengeViewNoButtons extends StatefulWidget {
  final int currentChallenge;
  const ChallengeViewNoButtons(String challengeId, {Key? key, required this.currentChallenge}) : super(key: key);

  @override
  _ChallengeViewNoButtonsState createState() => _ChallengeViewNoButtonsState();
}

class _ChallengeViewNoButtonsState extends State<ChallengeViewNoButtons> {
  late StreamSubscription _wsSubscription;
  late HuntProgressModel _huntProgressModel;
  late WebSocketModel _webSocketModel;

  int _secondsSpent = 0;
  Timer? _timer;

  // starts timer to count seconds spent on challenge
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsSpent++;
        widget.onTimeUpdated(
            totalSeconds); // Calls the callback function with updated total seconds
      });
    });
  }

  bool _isLoading = true;
  Map<String, dynamic> _challengeData = {};
  List<dynamic> _hints = [];
  int _hintIndex = -1;
  String _clueImage = '';

  @override
  void initState() {
    super.initState();
    _huntProgressModel = Provider.of<HuntProgressModel>(context, listen: false);
    _webSocketModel = Provider.of<WebSocketModel>(context, listen: false);
    _connectWebSocket();
    _fetchChallenge();
  }

  void _connectWebSocket() {
    _wsSubscription = _webSocketModel.messages.listen((message) {
      final data = json.decode(message);
      final type = data['messageType'];

      if (type == 'CHALLENGE_RESPONSE') {
        _handleChallengeResponse(data);
      } else if (type == 'SHOW_CHALLENGE_HINT') {
        _handleHintReveal(data);
      }
    });
  }

  Future<void> _fetchChallenge() async {
    try {
      final data = await fetchChallenge(
        _huntProgressModel.huntId,
        _huntProgressModel.challengeId,
      );
      setState(() {
        _challengeData = data;
        _clueImage = data['clue'] ?? '';
        _hints = data['hints'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleHintReveal(Map<String, dynamic> data) {
    setState(() {
      _hintIndex++;
    });
    Fluttertoast.showToast(msg: "A new hint has been revealed!");
  }

  void _handleChallengeResponse(Map<String, dynamic> data) {
    final bool solved = data['challengeSolved'] == "true";

    _huntProgressModel.totalSeconds = widget.totalSeconds;
    _huntProgressModel.totalPoints = huntProgressModel.previousPoints + points;
    _huntProgressModel.secondsSpentThisRound =
        totalSec - huntProgressModel.previousSeconds;
    _huntProgressModel.pointsEarnedThisRound = points;
    _huntProgressModel.currentChallenge = huntProgressModel.challengeNum + 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HuntProgressViewNoButtons()),
          );
        });
        return AlertDialog(
          title: Text(solved ? "Correct!" : "Incorrect"),
          content: Text(solved
              ? "Your team answered correctly. Moving on."
              : "Incorrect attempt. Try again."),
        );
      },
    );
  }

  @override
  void dispose() {
    _wsSubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppStyles.noBackArrowAppBarStyle("Hunt", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Challenge ${widget.currentChallenge}",
                  style: AppStyles.logisticsStyle.copyWith(fontSize: 20)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_clueImage.isNotEmpty)
                      Center(
                        child: Image.network(
                          _clueImage,
                          height: 150,
                          errorBuilder: (_, __, ___) => const Text("Image not available", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      _challengeData['description'] ?? "No description",
                      style: AppStyles.logisticsStyle,
                    ),
                    const SizedBox(height: 20),
                    Text("Hints:", style: AppStyles.logisticsStyle.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...List.generate(
                      _hintIndex + 1,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hint ${index + 1}: ${_hints[index]['description'] ?? ''}",
                              style: AppStyles.logisticsStyle),
                          const SizedBox(height: 10),
                          if (_hints[index]['url'] != null)
                            Center(
                              child: Image.network(
                                _hints[index]['url'],
                                height: 100,
                                errorBuilder: (_, __, ___) => const Text("Image error", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
