/* import 'dart:convert';

import 'package:http/http.dart';
import 'package:praxis_afterhours/apis/api_client.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TeamsResponseModel {
  final String message;

  TeamsResponseModel({
    required this.message,
  });

  factory TeamsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TeamsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamsResponseModelToJson(this);
} 

Future<TeamsResponseModel> getHunts(
    String startDate, String endDate, int limit) async {
  Response response;
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");
  try {
    response = await client.get(
        Uri.parse("$apiUrl/afterhours/v1/hunts/upcoming-hunts"),
        headers: {"authorization": "Bearer $token"});
  } catch (error) {
    throw Exception("network error");
  }
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return TeamsResponseModel.fromJson(jsonResponse);
  } else {
    throw Exception("Error: Failed to load teams: $response.statusCode");
  }
} */
