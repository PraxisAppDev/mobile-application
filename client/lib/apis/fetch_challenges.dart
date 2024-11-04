import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchChallenges(String huntID) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntID/challenges";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Challenges data: $data");
      return data;  // Return the data instead of printing it
    } else {
      print("Failed to load challenges: ${response.statusCode}");
      return []; // Return an empty list on failure
    }
  } catch (e) {
    print("Error occurred: $e");
    return []; // Return an empty list on error
  }
}