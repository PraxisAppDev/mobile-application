import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> updateTeam(String huntId, String teamId, String newTeamName) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/update";

  try {
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "teamName": newTeamName,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("Update team data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to update team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the update team request: $e");
  }
}

void main() {
  updateTeam("1", "23453", "Birds");
}