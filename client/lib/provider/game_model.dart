import 'package:flutter/foundation.dart';

class HuntProgressModel extends ChangeNotifier {
  List<int> secondsSpentList = [];
  List<int> pointsEarnedList = [];

  void addSecondsSpent(int seconds) {
    secondsSpentList.add(seconds);
    print(secondsSpentList);
    notifyListeners();  // Notify listeners to rebuild
  }

  void addPointsEarned(int points) {
    pointsEarnedList.add(points);
    print(pointsEarnedList);
    notifyListeners();  // Notify listeners to rebuild
  }
}
