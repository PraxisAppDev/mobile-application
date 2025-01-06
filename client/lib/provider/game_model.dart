import 'dart:async';
import 'package:flutter/foundation.dart';

class HuntProgressModel extends ChangeNotifier {
  // Variables that were passed from screen to screen, may need to be used in
  // API calls

  late String huntName;
  late String venue;
  late String huntDate;
  late String huntId;
  late String city;
  late String stateAbbr;
  late String zipCode;
  late String teamId;
  late String teamName;
  late String playerName;
  late String playerId;

  // Hunt Progress Screen variables
  late int totalSeconds;
  late int totalPoints;
  late int secondsSpentThisRound;
  late int pointsEarnedThisRound;
  late int currentChallenge;
  late int totalChallenges;
  List<int> secondsSpentList = [];
  List<int> pointsEarnedList = [];
  int secondsSpent = 0;
  Timer? _timer;
  bool _timerStarted = false;

  // Challenge Screen variables
  late int previousSeconds;
  late int previousPoints;
  late String challengeId;
  late int challengeNum;
  late String challengeName;

  // Keep track of completed hunts
  late int currentHuntIndex;
  final Set<int> pressedHunts = {};

  void startTimer() {
    if (_timerStarted) return; // Start the timer only once
    _timerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsSpent++;
      notifyListeners(); // Notify listeners to update only relevant widgets
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    secondsSpent = 0;
    _timerStarted = false;
    notifyListeners();
  }

  void markHuntCompleted(int index) {
    pressedHunts.add(index);
    notifyListeners();
  }

  void addSecondsSpent(int seconds) {
    secondsSpentList.add(seconds);
    notifyListeners();
  }

  void addPointsEarned(int points) {
    pointsEarnedList.add(points);
    notifyListeners();
  }

  int getSecondsSpent(int index) {
    return index >= 0 && index < secondsSpentList.length ? secondsSpentList[index] : 0;
  }

  int getPointsEarned(int index) {
    return index >= 0 && index < pointsEarnedList.length ? pointsEarnedList[index] : 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void incrementCurrentChallenge() {
    currentChallenge++;
    notifyListeners(); // ensures UI or state dependent on this updates
  }
}

