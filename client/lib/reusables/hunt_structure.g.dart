// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunt_structure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HuntLocation _$HuntLocationFromJson(Map<String, dynamic> json) => HuntLocation(
      type: json['type'] as String,
      locationName: json['locationName'] as String,
      locationInstructions: json['locationInstructions'] as String,
      geofence: Geofence.fromJson(json['geofence'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HuntLocationToJson(HuntLocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'locationName': instance.locationName,
      'locationInstructions': instance.locationInstructions,
      'geofence': instance.geofence,
    };

Geofence _$GeofenceFromJson(Map<String, dynamic> json) => Geofence(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      radius: (json['radius'] as num).toDouble(),
    );

Map<String, dynamic> _$GeofenceToJson(Geofence instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'radius': instance.radius,
    };

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      questionTitle: json['questionTitle'] as String,
      description: json['description'] as String,
      imageURL: json['imageURL'] as String,
      placeholderText: json['placeholderText'] as String,
      sequence: Sequence.fromJson(json['sequence'] as Map<String, dynamic>),
      hints: (json['hints'] as List<dynamic>)
          .map((e) => Hint.fromJson(e as Map<String, dynamic>))
          .toList(),
      scoring: Scoring.fromJson(json['scoring'] as Map<String, dynamic>),
      response: Response.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'questionTitle': instance.questionTitle,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'placeholderText': instance.placeholderText,
      'sequence': instance.sequence,
      'hints': instance.hints,
      'scoring': instance.scoring,
      'response': instance.response,
    };

Sequence _$SequenceFromJson(Map<String, dynamic> json) => Sequence(
      num: (json['num'] as num).toInt(),
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$SequenceToJson(Sequence instance) => <String, dynamic>{
      'num': instance.num,
      'order': instance.order,
    };

Hint _$HintFromJson(Map<String, dynamic> json) => Hint(
      type: json['type'] as String,
      penalty: (json['penalty'] as num).toDouble(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$HintToJson(Hint instance) => <String, dynamic>{
      'type': instance.type,
      'penalty': instance.penalty,
      'text': instance.text,
    };

Scoring _$ScoringFromJson(Map<String, dynamic> json) => Scoring(
      points: (json['points'] as num).toDouble(),
      timeDecay: TimeDecay.fromJson(json['timeDecay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScoringToJson(Scoring instance) => <String, dynamic>{
      'points': instance.points,
      'timeDecay': instance.timeDecay,
    };

TimeDecay _$TimeDecayFromJson(Map<String, dynamic> json) => TimeDecay(
      type: json['type'] as String,
      timeLimit: (json['timeLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimeDecayToJson(TimeDecay instance) => <String, dynamic>{
      'type': instance.type,
      'timeLimit': instance.timeLimit,
    };

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      type: json['type'] as String,
      possibleAnswers: json['possibleAnswers'] as List<dynamic>?,
      caseSensitive: json['caseSensitive'] as bool?,
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'type': instance.type,
      'possibleAnswers': instance.possibleAnswers,
      'caseSensitive': instance.caseSensitive,
    };

Hunt _$HuntFromJson(Map<String, dynamic> json) => Hunt(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: _DateUtil._fromJson(json['startDate'] as String),
      joinableAfterDate:
          _DateUtil._fromJsonNullable(json['joinableAfterDate'] as String?),
      endDate: _DateUtil._fromJson(json['endDate'] as String),
      huntLocation:
          HuntLocation.fromJson(json['huntLocation'] as Map<String, dynamic>),
      challenges: (json['challenges'] as List<dynamic>)
          .map((e) => Challenge.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxTeamSize: (json['maxTeamSize'] as num).toInt(),
    );

Map<String, dynamic> _$HuntToJson(Hunt instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startDate': _DateUtil._toJson(instance.startDate),
      'joinableAfterDate':
          _DateUtil._toJsonNullable(instance.joinableAfterDate),
      'endDate': _DateUtil._toJson(instance.endDate),
      'huntLocation': instance.huntLocation,
      'challenges': instance.challenges,
      'maxTeamSize': instance.maxTeamSize,
    };

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      playerId: json['playerId'] as String,
      timeJoined: _DateUtil._fromJson(json['timeJoined'] as String),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'playerId': instance.playerId,
      'timeJoined': _DateUtil._toJson(instance.timeJoined),
    };

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: json['id'] as String,
      name: json['name'] as String,
      teamLeader: json['teamLead'] as String,
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      invitations: (json['invitations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isLocked: json['isLocked'] as bool,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'teamLead': instance.teamLeader,
      'players': instance.players,
      'invitations': instance.invitations,
      'isLocked': instance.isLocked,
    };
