import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> solveChallenge(String huntId, String teamId, String challengeId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/challenges/$challengeId/solve";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "attemptNumber": 3,
        "timeSinceChallengeStarted": 10000,
        "numberOfHintsUsed": 0,
        "answer": "answer text"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("Solve challenge data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to solve challenge. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the solve challenge request: $e");
  }
}

void main() {
  solveChallenge("1", "23453", "123");
}