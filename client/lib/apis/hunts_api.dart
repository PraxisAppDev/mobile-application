import 'dart:convert';

import 'package:http/http.dart';
import 'package:praxis_afterhours/apis/api_client.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hunts_api.g.dart';

class _DateUtil {
  static DateTime _fromJson(String date) {
    return DateTime.parse(date);
  }

  static String _toJson(DateTime date) {
    return date.toIso8601String();
  }

  static DateTime? _fromJsonNullable(String? date) {
    return (date?.isEmpty ?? true) ? null : DateTime.parse(date!);
  }

  static String _toJsonNullable(DateTime? date) {
    return date?.toIso8601String() ?? "";
  }
}

@JsonSerializable()
class HuntsResponseModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String venue;
  final String address;
  final String city;
  final String stateAbbr;
  final String zipcode;
  final String logoURL;
  @JsonKey(fromJson: _DateUtil._fromJson, toJson: _DateUtil._toJson)
  final DateTime startDate;
  @JsonKey(fromJson: _DateUtil._fromJson, toJson: _DateUtil._toJson)
  final DateTime endDate;
  final String teamLimit;

  HuntsResponseModel({
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

  factory HuntsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HuntsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HuntsResponseModelToJson(this);
}

Future<HuntsResponseModel> getHunts(
    String startDate, String endDate, int limit) async {
  Response response;
  String? token = await getToken();
  //if (token == null) throw Exception("User is not logged in.");
  try {
    response = await client.get(
        Uri.parse("$apiUrl/afterhours/v1/hunts").replace(
            queryParameters: {
              'startDate': startDate,
              'endDate': endDate,
              'limit': limit
            }.map((key, value) => MapEntry(key, value.toString()))),
        headers: {"authorization": "Bearer $token"});
  } catch (error) {
    throw Exception(error);
  }
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse is Map<String, dynamic>) {
      return HuntsResponseModel.fromJson(jsonResponse);
    } else if (jsonResponse is List) {
      // Handle the case where the response is a list
      throw Exception("Expected a map but got a list");
    } else {
      throw Exception("Unexpected response format");
    }
    //var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    //return HuntsResponseModel.fromJson(jsonResponse);
  } else {
    throw Exception("Error: Failed to load hunts: ${response.statusCode}");
  }
}
