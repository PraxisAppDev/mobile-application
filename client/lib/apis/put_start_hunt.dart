import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> startHunt(String huntId, String teamId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/start";

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      // print("Start hunt data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to start hunt. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the start hunt request: $e");
  }
}

void main() {
  startHunt("1", "23453");
}