import 'package:json_annotation/json_annotation.dart';

part 'hunt_structure.g.dart';

@JsonSerializable()
class HuntLocation {
  final String type;
  final String locationName;
  final String locationInstructions;
  final Geofence geofence;

  HuntLocation({
    required this.type,
    required this.locationName,
    required this.locationInstructions,
    required this.geofence,
  });

  factory HuntLocation.fromJson(Map<String, dynamic> json) =>
      _$HuntLocationFromJson(json);

  Map<String, dynamic> toJson() => _$HuntLocationToJson(this);
}

@JsonSerializable()
class Geofence {
  final String type;
  final List<double> coordinates;
  final double radius;

  Geofence({
    required this.type,
    required this.coordinates,
    required this.radius,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) =>
      _$GeofenceFromJson(json);

  Map<String, dynamic> toJson() => _$GeofenceToJson(this);
}

@JsonSerializable()
class Challenge {
  final String questionTitle;
  final String description;
  final String imageURL;
  final String placeholderText;
  final Sequence sequence;
  final List<Hint> hints;
  final Scoring scoring;
  final Response response;

  Challenge({
    required this.questionTitle,
    required this.description,
    required this.imageURL,
    required this.placeholderText,
    required this.sequence,
    required this.hints,
    required this.scoring,
    required this.response,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}

@JsonSerializable()
class Sequence {
  final int num;
  final int order;

  Sequence({
    required this.num,
    required this.order,
  });

  factory Sequence.fromJson(Map<String, dynamic> json) =>
      _$SequenceFromJson(json);

  Map<String, dynamic> toJson() => _$SequenceToJson(this);
}

@JsonSerializable()
class Hint {
  final String type;
  final double penalty;
  final String text;

  Hint({
    required this.type,
    required this.penalty,
    required this.text,
  });

  factory Hint.fromJson(Map<String, dynamic> json) => _$HintFromJson(json);

  Map<String, dynamic> toJson() => _$HintToJson(this);
}

@JsonSerializable()
class Scoring {
  final double points;
  final TimeDecay timeDecay;

  Scoring({
    required this.points,
    required this.timeDecay,
  });

  factory Scoring.fromJson(Map<String, dynamic> json) =>
      _$ScoringFromJson(json);

  Map<String, dynamic> toJson() => _$ScoringToJson(this);
}

@JsonSerializable()
class TimeDecay {
  final String type;
  final int? timeLimit;

  TimeDecay({
    required this.type,
    this.timeLimit,
  });

  factory TimeDecay.fromJson(Map<String, dynamic> json) =>
      _$TimeDecayFromJson(json);

  Map<String, dynamic> toJson() => _$TimeDecayToJson(this);
}

@JsonSerializable()
class Response {
  final String type;
  final List<dynamic>? possibleAnswers;
  final bool? caseSensitive;

  Response({
    required this.type,
    required this.possibleAnswers,
    required this.caseSensitive,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}

@JsonSerializable()
class Hunt {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  @JsonKey(fromJson: _DateUtil._fromJson, toJson: _DateUtil._toJson)
  final DateTime startDate;
  @JsonKey(
      fromJson: _DateUtil._fromJsonNullable, toJson: _DateUtil._toJsonNullable)
  final DateTime? joinableAfterDate;
  @JsonKey(fromJson: _DateUtil._fromJson, toJson: _DateUtil._toJson)
  final DateTime endDate;
  final HuntLocation huntLocation;
  final List<Challenge> challenges;
  final int maxTeamSize;

  Hunt({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.joinableAfterDate,
    required this.endDate,
    required this.huntLocation,
    required this.challenges,
    required this.maxTeamSize,
  });

  factory Hunt.fromJson(Map<String, dynamic> json) => _$HuntFromJson(json);

  Map<String, dynamic> toJson() => _$HuntToJson(this);
}

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
class Player {
  final String playerId;
  @JsonKey(fromJson: _DateUtil._fromJson, toJson: _DateUtil._toJson)
  final DateTime timeJoined;

  Player({
    required this.playerId,
    required this.timeJoined,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

@JsonSerializable()
class Team {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "teamLead")
  String teamLeader;
  @JsonKey(name: "players")
  List<Player> players;
  @JsonKey(name: "invitations")
  List<String> invitations;
  bool isLocked;

  Team({
    required this.id,
    required this.name,
    required this.teamLeader,
    required this.players,
    required this.invitations,
    required this.isLocked,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
