// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunts_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HuntResponseModel _$HuntResponseModelFromJson(Map<String, dynamic> json) =>
    HuntResponseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      venue: json['venue'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      stateAbbr: json['stateAbbr'] as String,
      zipcode: json['zipcode'] as String,
      logoURL: json['logoURL'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      teamLimit: (json['teamLimit'] as num).toInt(),
    );

Map<String, dynamic> _$HuntResponseModelToJson(HuntResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'venue': instance.venue,
      'address': instance.address,
      'city': instance.city,
      'stateAbbr': instance.stateAbbr,
      'zipcode': instance.zipcode,
      'logoURL': instance.logoURL,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'teamLimit': instance.teamLimit,
    };
