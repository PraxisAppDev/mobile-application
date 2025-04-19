import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchChallengeHint(String huntId, String challengeId, String hintId) async {
  var apiUrl = "https://scavengerhunt.afterhoursdev.com/api/v1/hunts/$huntId/challenges/$challengeId/hints/$hintId";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data; 
    } else {
      throw Exception("Failed to load challenge hint. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the fetch challenge hint request: $e");
  }
}
