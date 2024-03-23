// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeState _$ChallengeStateFromJson(Map<String, dynamic> json) =>
    ChallengeState(
      challenges: json['challenges'] == null
          ? const <ChallengeData>[]
          : const _DataConverter().fromJson(json['challenges'] as List),
      page: _$JsonConverterFromJson<Map<String, dynamic>, PageData>(
          json['page'], const _PageConverter().fromJson),
    );

Map<String, dynamic> _$ChallengeStateToJson(ChallengeState instance) =>
    <String, dynamic>{
      'page': const _PageConverter().toJson(instance.page),
      'challenges': const _DataConverter().toJson(instance.challenges),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
