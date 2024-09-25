import 'dart:convert';
import 'package:http/http.dart';
import 'package:praxis_afterhours/apis/api_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';

Future<Map<String, dynamic>> fetchUserInfo() async {
  final token = await getToken();
  Response response;

  try {
    response = await client.get(Uri.parse("$apiUrl/users/get_user_info"),
        headers: {
          "content-type": "application/json",
          "authorization": "Bearer $token"
        });
  } catch (error) {
    throw Exception("network error");
  }
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse;
  } else {
    // Remove this when deploying to prod
    var body = jsonDecode(response.body);
    var errorMsg = body['message'];
    Fluttertoast.showToast(
      msg: "Error ${response.statusCode}: $errorMsg",
      timeInSecForIosWeb: 5,
    );
    throw Exception("Error: Failed to load user data: ${response.statusCode}");
  }
}

Future<void> updateUserInfo(Map<dynamic, dynamic> userInfo) async {
  final token = await getToken();
  Response response;

  try {
    response = await client.put(Uri.parse("$apiUrl/users/update_user_info"),
        headers: {
          "content-type": "application/json",
          "authorization": "Bearer $token"
        },
        body: jsonEncode(userInfo));
  } catch (error) {
    throw Exception("network error");
  }
  if (response.statusCode == 200) {
    // User info updated successfully
  } else {
    // Remove this when deploying to prod
    var body = jsonDecode(response.body);
    var errorMsg = body['message'];
    Fluttertoast.showToast(
      msg: "Error ${response.statusCode}: $errorMsg",
      timeInSecForIosWeb: 5,
    );
    throw Exception(
        "Error: Failed to update user info: ${response.statusCode}");
  }
}
