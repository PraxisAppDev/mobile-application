import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> leaveTeam(String huntId, String teamName) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamName/leave";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
          "playerName": "player name"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("Leave team data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to leave team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the leave team request: $e");
  }
}

void main() {
  leaveTeam("1", "Eagles");
}