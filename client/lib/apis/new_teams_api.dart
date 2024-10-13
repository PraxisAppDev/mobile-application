import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';

// Import the correct HTTP client based on the platform
import 'package:praxis_afterhours/apis/api_utils/get_http_client/get_http_client_default.dart'
    if (dart.library.io) './api_utils/get_http_client/get_http_client_io.dart'
    if (dart.library.html) './api_utils/get_http_client/get_http_client_web.dart'
    as get_http_client;

part 'new_teams_api.g.dart';

@JsonSerializable()
class Player {
  final String name;
  final bool teamLeader;

  Player({required this.name, required this.teamLeader});
  // Correct function name for deserialization
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  // Correct function name for serialization
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

@JsonSerializable()
class Team {
  final String name;
  final String logoURL;
  final bool lockStatus;
  final List<Player> players;

  Team({
    required this.name,
    required this.logoURL,
    required this.lockStatus,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  // Correct function name for serialization
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

@JsonSerializable()
class TeamsResponseModel {
  final String huntId;
  final List<Team> teams;

  TeamsResponseModel({
    required this.huntId,
    required this.teams,
  });

  // Correct function name for deserialization
  factory TeamsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TeamsResponseModelFromJson(json);

  // Correct function name for serialization
  Map<String, dynamic> toJson() => _$TeamsResponseModelToJson(this);
}

Future<List<Team>> getTeams(int huntID) async {
  var apiUrl =
      "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntID/teams";

  final uri = Uri.parse(apiUrl);

  print('Request URI: $uri'); // Log the final request URI

  try {
    final response = await get_http_client.getHttpClient().get(uri);

    // Log response details
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Process successful response

      var data = jsonDecode(response.body);
      List<Team> teams =
          data["teams"].map((team) => Team.fromJson(team)).toList();

      print("Parsed hunts: $teams");
      return teams;
    } else {
      throw Exception(
          "Failed to load hunts. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred during the request: $e");
    throw Exception("Error occurred during the request: $e");
  }
}
