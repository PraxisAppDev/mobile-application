import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchTeams() async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/1/teams";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      print("Teams data: $data");
      return data;
    } else {
      print("Failed to load teams: ${response.statusCode}");
      throw Exception(
          "Failed to get teams. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred: $e");
    throw Exception("Error occurred during the update team request: $e");
  }
}

Future<Map<String, dynamic>> fetchTeamsFromHunt(String huntID) async {
  var apiUrl =
      "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntID/teams";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      print("Teams data: $data");
      return data;
    } else {
      print("Failed to load teams: ${response.statusCode}");
      throw Exception(
          "Failed to get teams. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred: $e");
    throw Exception("Error occurred during the update team request: $e");
  }
}

void main() {
  fetchTeams();
}
