import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> createTeam(String huntId, String teamName, String playerName, bool huntAlone) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "teamName": teamName,
        "playerName": playerName,
        "huntAlone": huntAlone.toString()
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("Create teams data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to create team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the create teams request: $e");
  }
}

void main() {
  createTeam("1", "Eagles", "Andy", true);
}