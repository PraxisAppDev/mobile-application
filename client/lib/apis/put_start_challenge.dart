import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> startChallenge(String huntId, String teamId, String challengeId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/challenges/$challengeId/start";

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Failed to start challenge. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the start challenge request: $e");
  }
}
