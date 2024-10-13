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
  final String id;
  final String name;
  final String venue;
  final String address;
  final String city;
  final String stateAbbr;
  final String zipcode;
  final String logoURL;
  final String startDate;
  final String endDate;
  final int teamLimit;

  HuntResponseModel({
    required this.id,
    required this.name,
    required this.venue,
    required this.address,
    required this.city,
    required this.stateAbbr,
    required this.zipcode,
    required this.logoURL,
    required this.startDate,
    required this.endDate,
    required this.teamLimit,
  });

  // Correct function name for deserialization
  factory HuntResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HuntResponseModelFromJson(json);

  // Correct function name for serialization
  Map<String, dynamic> toJson() => _$HuntResponseModelToJson(this);
}
Future<List<HuntResponseModel>> getHunts({String? startdate, String? enddate, int? limit}) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts";

  print(startdate);
  print(enddate);
  print(limit);

    final queryParams = {
      if (startdate != null) 'startDate': startdate else 'startDate': "Bob",
      if (enddate != null) 'endDate': enddate else 'endDate': "Sam",
      if (limit != null) 'teamLimit': limit.toString() else 'teamLimit': "raaa",
    };

    // Build the URI with query parameters
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    print('Request URI: $uri');  // Log the final request URI


    try {
      final response = await get_http_client.getHttpClient().get(uri);
      
      // Log response details
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        // Process successful response
        List<dynamic> data = jsonDecode(response.body);
        List<HuntResponseModel> hunts = data.map((hunt) => HuntResponseModel.fromJson(hunt)).toList();
        print("Parsed hunts: $hunts");
        return hunts;
      } else {
        throw Exception("Failed to load hunts. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred during the request: $e");
      throw Exception("Error occurred during the request: $e");
    }

  }



