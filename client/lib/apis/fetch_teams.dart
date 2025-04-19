import 'package:http/http.dart' as http;
import 'dart:convert';

/* unncessary
Future<List<dynamic>> fetchTeamsFromHunt(String huntID) async {
  var apiUrl =
      "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntID/teams";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data; //removed icorrect casting
    } else {
      throw Exception(
        "Failed to get teams. Status code: ${response.statusCode}");
    }
  } catch (e) {
    // print("Error occurred: $e");
    throw Exception("Error occurred during the fetch teams request: $e");
  }
}
*/

Future<List<dynamic>> fetchTeamsFromHunt(String huntID) async {
  var apiUrl = "https://scavengerhunt.afterhoursdev.com/api/v1/hunts/$huntID/teams";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return data; //need to make sure it's a list
      } else {
        throw Exception("Unexpected response format: Expected List, got ${data.runtimeType}");
      }
    } else {
      throw Exception("Failed to get teams. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the fetch teams request: $e");
  }
}
