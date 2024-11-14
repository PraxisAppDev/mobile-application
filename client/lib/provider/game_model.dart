import 'dart:async';
import 'package:flutter/foundation.dart';

class HuntProgressModel extends ChangeNotifier {
  List<int> secondsSpentList = [];
  List<int> pointsEarnedList = [];
  int _secondsSpent = 0;
  Timer? _timer;
  bool _timerStarted = false; // Track if the timer has already started

  // Getter for accessing the timer's seconds spent
  int get secondsSpent => _secondsSpent;

  void startTimer() {
    if (_timerStarted) return; // Start the timer only once
    _timerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsSpent++;
      notifyListeners(); // Notify listeners to update only relevant widgets
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    _secondsSpent = 0;
    _timerStarted = false;
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
}


