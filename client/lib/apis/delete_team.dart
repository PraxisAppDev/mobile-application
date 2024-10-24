import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> deleteTeam(String huntId, String teamId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId";
  print(apiUrl);
  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        //"authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      // body: jsonEncode({
      //   "teamName": newTeamName,
      // }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("Delete team data: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception("Failed to delete team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the delete team request: $e");
  }
}

void main() {
  deleteTeam("1", "23453");
}