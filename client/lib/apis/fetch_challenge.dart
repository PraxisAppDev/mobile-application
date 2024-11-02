import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchChallenge(String huntId, String challengeId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/challenges/$challengeId";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Challenge data: $data");
      return data; // Return the data as a Map for specific challenge details
    } else {
      print("Failed to load challenge: ${response.statusCode}");
      return {}; // Return an empty map on failure
    }
  } catch (e) {
    print("Error occurred: $e");
    return {}; // Return an empty map on error
  }
}
