import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchTeam(String huntID, String teamID) async {
  var apiUrl =
      "https://scavengerhunt.afterhoursdev.com/api/v1/hunts/$huntID/teams/$teamID";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      return data; //don't need indexing
    } else {
      // print("Failed to load teams: ${response.statusCode}");
      throw Exception(
        "Failed to get team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    // print("Error occurred: $e");
    throw Exception("Error occurred during the fetch team request: $e");
  }
}
