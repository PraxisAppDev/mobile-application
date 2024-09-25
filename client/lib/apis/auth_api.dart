import 'dart:convert';
import 'package:http/http.dart';
import 'package:praxis_afterhours/apis/api_client.dart';
import 'package:praxis_afterhours/storage/secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<(String, String, String)> logIn(String username, String password) async {
  Response response;
  try {
    response = await client.post(Uri.parse("$apiUrl/users/auth/login"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"username": username, "password": password}));
  } catch (error) {
    throw Exception("network error");
  }
  if (response.statusCode == 201) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return (
      jsonResponse["token"]["access_token"].toString(),
      jsonResponse["token"]["exp"].toString(),
      jsonResponse["user_id"].toString()
    );
  } else {
    // Remove this when deploying to prod
    var body = jsonDecode(response.body);
    var errorMsg = body['message'];
    Fluttertoast.showToast(
      msg: "Error ${response.statusCode}: $errorMsg",
      timeInSecForIosWeb: 5,
    );
    throw const FormatException("invalid credentials");
  }
}

Future<(String, String, String)> signUp(
    String username, String email, String fullname, String password) async {
  Response response;
  try {
    response = await client.post(Uri.parse("$apiUrl/users/auth/signup"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "fullname": fullname,
          "password": password
        }));
  } catch (error) {
    throw Exception("network error");
  }
  if (response.statusCode == 201) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return (
      jsonResponse["token"]["access_token"].toString(),
      jsonResponse["token"]["exp"].toString(),
      jsonResponse["user_id"].toString()
    );
  } else {
    // Remove this when deploying to prod
    var body = jsonDecode(response.body);
    var errorMsg = body['message'];
    Fluttertoast.showToast(
      msg: "Error ${response.statusCode}: $errorMsg",
      timeInSecForIosWeb: 5,
    );
    throw const FormatException("invalid credentials");
  }
}

Future<void> logoutUser() async {
  // Remove auth token from storage to logout of user session
  await storage.delete(key: "token");
}
