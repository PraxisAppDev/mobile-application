import 'package:flutter/foundation.dart';

class HuntProgressModel extends ChangeNotifier {
  List<int> secondsSpentList = [];
  List<int> pointsEarnedList = [];

  void addSecondsSpent(int seconds) {
    secondsSpentList.add(seconds);
    print("SecondsSpentList: $secondsSpentList");
    notifyListeners();  // Notify listeners to rebuild
  }

  void addPointsEarned(int points) {
    pointsEarnedList.add(points);
    print("pointsEarnedList: $pointsEarnedList");
    notifyListeners();  // Notify listeners to rebuild
  }

  // returns a specific challenges seconds spent
  int getSecondsSpent(int index) {
    if(index >= 0 && index < secondsSpentList.length) {
      return secondsSpentList[index];
    } else {
      return 0;
    }
  }

  // returns a specific challenge's points earned
  int getPointsEarned(int index) {
    if(index >= 0 && index < pointsEarnedList.length) {
      return pointsEarnedList[index];
    } else{
      return 0;
    }
  }
}
