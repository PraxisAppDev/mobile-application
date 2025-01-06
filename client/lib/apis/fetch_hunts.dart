import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchHunts() async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print("Hunts data: $data");
      return data;
    } else {
      // print("Failed to load hunts: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    // print("Error occurred: $e");
    return [];
  }
}

void main() {
  fetchHunts();
}