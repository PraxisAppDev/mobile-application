import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> solveChallenge(String huntId, String teamId, String challengeId, int attemptNumber, int timeSinceChallengeStarted, int numHintsUsed, String answerText) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/challenges/$challengeId/solve";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "attemptNumber": attemptNumber,
        "timeSinceChallengeStarted": timeSinceChallengeStarted,
        "numberOfHintsUsed": numHintsUsed,
        "answer": answerText
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Failed to solve challenge. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the solve challenge request: $e");
  }
}
