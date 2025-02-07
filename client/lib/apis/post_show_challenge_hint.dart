import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> showChallengeHint(String huntId, String teamId, String challengeId, String hintId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/challenges/$challengeId/hints/$hintId";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Failed to show challenge hint. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the show challenge hint request: $e");
  }
}
