import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchHunts() async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Hunts data: $data");
    } else {
      print("Failed to load hunts: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}

void main() {
  fetchHunts();
}