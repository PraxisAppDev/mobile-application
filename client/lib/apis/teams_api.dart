import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart' hide Response;

import 'api_client.dart';
import 'api_utils/token.dart';
import 'api_utils/stream_request.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:praxis_afterhours/apis/api_utils/token.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart';

// Import the correct HTTP client based on the platform
import 'package:praxis_afterhours/apis/api_utils/get_http_client/get_http_client_default.dart'
if (dart.library.io) './api_utils/get_http_client/get_http_client_io.dart'
if (dart.library.html) './api_utils/get_http_client/get_http_client_web.dart'
as get_http_client;

part 'teams_api.g.dart';

@JsonSerializable()
class TeamOperationSuccessMessage {
  final String message;

  TeamOperationSuccessMessage({
    required this.message,
  });

  factory TeamOperationSuccessMessage.fromJson(Map<String, dynamic> json) =>
      _$TeamOperationSuccessMessageFromJson(json);

  Map<String, dynamic> toJson() => _$TeamOperationSuccessMessageToJson(this);
}

@JsonEnum(alwaysCreate: true)
enum JoinRequestStatus {
  @JsonValue("pending")
  pending,
  @JsonValue("accepted")
  accepted,
  @JsonValue("rejected")
  rejected,
  @JsonValue("team_deleted")
  teamDeleted;

  static JoinRequestStatus fromJson(String json) {
    if(!_$JoinRequestStatusEnumMap.values.contains(json)){
      throw Exception("Invalid JoinRequestStatus: $json");
    }
    return JoinRequestStatus.values.firstWhere(
        (element) => _$JoinRequestStatusEnumMap[element] == json);
  }

  String toJson() {
    return _$JoinRequestStatusEnumMap[this]!;
  }
}

Future<List<Team>> listTeams(String huntId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams";
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");

  try {
    final response = await get_http_client.getHttpClient().get(
      Uri.parse(apiUrl),
      headers: {"authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((teamJson) => Team.fromJson(teamJson as Map<String, dynamic>)).toList();
    } else {
      throw Exception("Failed to load teams. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the request: $e");
  }
}

Future<Team> getHuntTeam(String huntId, String teamId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId";
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");

  try {
    final response = await get_http_client.getHttpClient().get(
      Uri.parse(apiUrl),
      headers: {"authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Team.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to get team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the request: $e");
  }
}

Future<Team> createTeam(String huntId, String teamName, String playerName, bool huntAlone) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams";
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");

  try {
    final response = await get_http_client.getHttpClient().post(
      Uri.parse(apiUrl),
      headers: {
        "authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "teamName": teamName,
        "playerName": playerName,
        "huntAlone": huntAlone.toString()
      }),
    );

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Team.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to create team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the request: $e");
  }
}

Future<TeamOperationSuccessMessage> removePlayerFromTeam(String huntId, String teamId, String memberId) async {
  var apiUrl = "http://afterhours.praxiseng.com/afterhours/v1/hunts/$huntId/teams/$teamId/members/$memberId";
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");

  try {
    final response = await get_http_client.getHttpClient().delete(
      Uri.parse(apiUrl),
      headers: {"authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return TeamOperationSuccessMessage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to remove member from team. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error occurred during the request: $e");
  }
}
class TeamsResponseModel {
  final String message;
  final List<Team> content;

  TeamsResponseModel({
    required this.message,
    required this.content,
  });

  factory TeamsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TeamsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamsResponseModelToJson(this);
}


Stream<List<Team>> watchListTeams(String huntId) async* {
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");
  yield* StreamRequest.get(
    Uri.parse("$apiUrl/game/$huntId/teams/listen_list_teams"),
    headers: {"authorization": "Bearer $token"},
    converter: (json) => (json as List<Object?>)
        .map((e) => Team.fromJson(e as Map<String, dynamic>))
        .toList(),
  ).send(client);
}


Stream<List<Player>> watchListPlayersForTeam(
    String huntId, String teamId) async* {
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");
  yield* StreamRequest.get(
    Uri.parse("$apiUrl/game/$huntId/teams/$teamId/listen_members"),
    headers: {"authorization": "Bearer $token"},
    converter: (json) => (json as List<Object?>)
        .map((e) => Player.fromJson(e as Map<String, dynamic>))
        .toList(),
  ).send(client);
}


Stream<List<String>> watchListJoinRequestsForTeam(
    String huntId, String teamId) async* {
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");
  yield* RetryStreamRequest(
      () => StreamRequest.get(
        Uri.parse("$apiUrl/game/$huntId/teams/$teamId/listen_join_requests"),
        headers: {"authorization": "Bearer $token"},
        converter: (json) => (json as List<Object?>).cast<String>().toList(),
      ),
      maxRetries: 5,
      retryDelay: const Duration(seconds: 5),
  ).send(client);
}



Stream<JoinRequestStatus> requestJoinTeam(
    String huntId, String teamId) async* {
  String? token = await getToken();
  if (token == null) throw Exception("User is not logged in.");
  try {
    yield* StreamRequest.post(
        Uri.parse("$apiUrl/game/$huntId/teams/$teamId/request_join"),
        headers: {
          "authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: null,
        converter: (json) => JoinRequestStatus.fromJson(json as String)
    ).send(client);
  } catch (e1) {
    if (kDebugMode) {
      print("join request stream disconnected with error: $e1");
    }
    try {
      newRequestBuilder() => StreamRequest.post(
        Uri.parse("$apiUrl/game/$huntId/teams/$teamId/join_requests/currentUser/listenStatus"),
        headers: {
          "authorization": "Bearer $token"
        },
        body: null,
        converter: (json) => JoinRequestStatus.fromJson(json as String)
      );
      yield* RetryStreamRequest<JoinRequestStatus>(
        newRequestBuilder,
        maxRetries: 5,
        retryDelay: const Duration(seconds: 5),
      ).send(client);
    } catch (e2) {
      if (kDebugMode) {
        print("join request stream disconnected with error: $e2");
      }
      throw Exception("network error: $e1, $e2");
    }
  }
}


