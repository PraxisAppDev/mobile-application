// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_teams_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      name: json['name'] as String,
      teamLeader: json['teamLeader'] as bool,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'teamLeader': instance.teamLeader,
    };

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      name: json['name'] as String,
      logoURL: json['logoURL'] as String,
      lockStatus: json['lockStatus'] as bool,
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'name': instance.name,
      'logoURL': instance.logoURL,
      'lockStatus': instance.lockStatus,
      'players': instance.players,
    };

TeamsResponseModel _$TeamsResponseModelFromJson(Map<String, dynamic> json) =>
    TeamsResponseModel(
      huntId: json['huntId'] as String,
      teams: (json['teams'] as List<dynamic>)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamsResponseModelToJson(TeamsResponseModel instance) =>
    <String, dynamic>{
      'huntId': instance.huntId,
      'teams': instance.teams,
    };
