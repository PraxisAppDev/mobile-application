// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunts_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HuntsResponseModel _$HuntsResponseModelFromJson(Map<String, dynamic> json) =>
    HuntsResponseModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      venue: json['venue'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      stateAbbr: json['stateAbbr'] as String,
      zipcode: json['zipcode'] as String,
      logoURL: json['logoURL'] as String,
      startDate: _DateUtil._fromJson(json['startDate'] as String),
      endDate: _DateUtil._fromJson(json['endDate'] as String),
      teamLimit: json['teamLimit'] as String,
    );

Map<String, dynamic> _$HuntsResponseModelToJson(HuntsResponseModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'venue': instance.venue,
      'address': instance.address,
      'city': instance.city,
      'stateAbbr': instance.stateAbbr,
      'zipcode': instance.zipcode,
      'logoURL': instance.logoURL,
      'startDate': _DateUtil._toJson(instance.startDate),
      'endDate': _DateUtil._toJson(instance.endDate),
      'teamLimit': instance.teamLimit,
    };
