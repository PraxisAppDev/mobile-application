import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchTeam(String huntID, String teamID) async {
  var apiUrl =
      "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntID/teams/$teamID";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      // print("fetch_team TEAM ID: $teamID");
      // print("fetch_team TEAM DATA: ${data['teams'][0]}");
      return data['teams'][0];
    } else {
      // print("Failed to load teams: ${response.statusCode}");
      throw Exception(
          "Failed to get teams. Status code: ${response.statusCode}");
    }
  } catch (e) {
    // print("Error occurred: $e");
    throw Exception("Error occurred during the update team request: $e");
  }
}
