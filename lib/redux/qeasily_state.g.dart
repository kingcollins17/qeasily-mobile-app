// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qeasily_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QeasilyState _$QeasilyStateFromJson(Map<String, dynamic> json) => QeasilyState(
      challenges: _$JsonConverterFromJson<Map<String, dynamic>, ChallengeState>(
          json['challenges'], const _ChallengeStateConverter().fromJson),
      search: json['search'] == null
          ? null
          : SearchState.fromJson(json['search'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QeasilyStateToJson(QeasilyState instance) =>
    <String, dynamic>{
      'challenges':
          const _ChallengeStateConverter().toJson(instance.challenges),
      'search': instance.search,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
