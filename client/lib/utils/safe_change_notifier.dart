import 'package:flutter/widgets.dart';

// reusable function

class SafeChangeNotifier extends ChangeNotifier {

  bool _pendingNotification = false;

  @override
  void notifyListeners() {
    if (!_pendingNotification) {
      _pendingNotification = true;
      print('Safe notifyListeners() called in $runtimeType');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pendingNotification = false;
        super.notifyListeners();
      });
    }
  }
}