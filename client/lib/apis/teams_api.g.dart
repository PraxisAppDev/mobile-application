// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamsResponseModel _$TeamsResponseModelFromJson(Map<String, dynamic> json) =>
    TeamsResponseModel(
      message: json['message'] as String,
      content: (json['content'] as List<dynamic>)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamsResponseModelToJson(TeamsResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'content': instance.content,
    };

TeamOperationSuccessMessage _$TeamOperationSuccessMessageFromJson(
        Map<String, dynamic> json) =>
    TeamOperationSuccessMessage(
      message: json['message'] as String,
    );

Map<String, dynamic> _$TeamOperationSuccessMessageToJson(
        TeamOperationSuccessMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

const _$JoinRequestStatusEnumMap = {
  JoinRequestStatus.pending: 'pending',
  JoinRequestStatus.accepted: 'accepted',
  JoinRequestStatus.rejected: 'rejected',
  JoinRequestStatus.teamDeleted: 'team_deleted',
};
