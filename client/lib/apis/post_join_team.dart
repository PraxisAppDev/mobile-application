import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> joinTeam(String huntId, String teamName, String playerName) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamName/join";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
          "playerName": playerName
      }),
    );

    // print("Join Team Player Name: $playerName");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("Join team data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to join team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the join team request: $e");
  }
}

void main() {
  joinTeam("1", "Eagles", "Andy");
}