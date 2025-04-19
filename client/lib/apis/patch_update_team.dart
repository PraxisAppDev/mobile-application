import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> updateTeam(String huntId, String teamId, String newTeamName) async {
  var apiUrl = "https://scavengerhunt.afterhoursdev.com/api/v1/hunts/$huntId/teams/$teamId";

  try {
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "newTeamName": newTeamName, //fixed field name
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the update team request: $e");
  }
}
