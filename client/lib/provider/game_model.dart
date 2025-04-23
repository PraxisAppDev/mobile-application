import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/safe_change_notifier.dart';

class HuntProgressModel extends SafeChangeNotifier {
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
  final Set<String> completedChallenges = {}; //track completed challenges

  void startTimer() {
    if (_timerStarted) return; // Start the timer only once
    _timerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsSpent++;
      print("notifyListeners() called from startTimer at :${DateTime.now()}");
      notifyListeners(); // Notify listeners to update only relevant widgets
    });
  }

  
  void stopTimer() {
    _timer?.cancel();
    _timerStarted = false;
  }

 
  void resetTimer() {
    stopTimer();
    secondsSpent = 0;
    print("notifyListeners() called from resetTimer at :${DateTime.now()}");
    notifyListeners();
  }

  void markHuntCompleted(int index) {
    pressedHunts.add(index);
    print("notifyListeners() called from markHuntCompleted at :${DateTime.now()}");
    notifyListeners();
  }

  void addSecondsSpent(int seconds) {
    secondsSpentList.add(seconds);
    print("notifyListeners() called from addSecondsSpent at :${DateTime.now()}");
    notifyListeners();
  }

  void addPointsEarned(int points) {
    pointsEarnedList.add(points);
    print("notifyListeners() called from addPointsEarned at :${DateTime.now()}");
    notifyListeners();
  }

  int getSecondsSpent(int index) {
    return index >= 0 && index < secondsSpentList.length ? secondsSpentList[index] : 0;
  }


  int getPointsEarned(int index) {
    return index >= 0 && index < pointsEarnedList.length ? pointsEarnedList[index] : 0;
  }

  void incrementCurrentChallenge() {
    if (!completedChallenges.contains(challengeId)) {
      completedChallenges.add(challengeId);
      currentChallenge++;
      print("notifyListeners() called from incrementCurrentChallenge at :${DateTime.now()}");
      notifyListeners();
    }
  }

  
  void updateChallengeState(String newChallengeId, int newChallengeNum) {
    if (newChallengeId != challengeId) {
      challengeId = newChallengeId;
      challengeNum = newChallengeNum;
      print("notifyListeners() called from updateChallengeState at :${DateTime.now()}");
      incrementCurrentChallenge();
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
