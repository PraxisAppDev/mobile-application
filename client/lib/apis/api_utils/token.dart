import 'package:praxis_afterhours/storage/secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<String?> getToken() async {
  try {
    final token = await storage.read(key: "token");
    return token;
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: Failed to read token: $e");
    throw Exception("Error: Failed to read token: $e");
  }
}

Future<String?> getUserId() {
  return storage.read(key: "user_id");
}