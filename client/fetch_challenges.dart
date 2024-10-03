import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchTeams() async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/1/challenges";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Teams data: $data");
    } else {
      print("Failed to load teams: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}

void main() {
  fetchTeams();
}