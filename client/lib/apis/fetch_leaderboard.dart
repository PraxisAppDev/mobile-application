import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchLeaderboard(String huntID) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntID/leaderboard";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
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