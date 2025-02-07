import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> endHunt(String huntId, String teamId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/end";

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Failed to end hunt. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the end hunt request: $e");
  }
}
