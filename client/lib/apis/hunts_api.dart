import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';

// Import the correct HTTP client based on the platform
import 'package:praxis_afterhours/apis/api_utils/get_http_client/get_http_client_default.dart'
    if (dart.library.io) './api_utils/get_http_client/get_http_client_io.dart'
    if (dart.library.html) './api_utils/get_http_client/get_http_client_web.dart'
    as get_http_client;

part 'hunts_api.g.dart'; // Ensure the file name matches


@JsonSerializable()
class HuntResponseModel {
  final String message;

  HuntResponseModel({
    required this.message,
  });

 // Correct function name for deserialization
  factory HuntResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HuntResponseModelFromJson(json);

  // Correct function name for serialization
  Map<String, dynamic> toJson() => _$HuntResponseModelToJson(this);
}
Future<HuntResponseModel> getHunts() async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts";

  try {
    final response = await get_http_client.getHttpClient().get(Uri.parse(apiUrl));
    print(response);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Raw data: $data");  // Log raw data for debugging

      // Ensure that the JSON structure matches your model
      return HuntResponseModel.fromJson(data);
    } else {
      throw Exception("Failed to load hunts. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred during the request: $e");
    throw Exception("Error occurred during the request: $e");
  }
}


