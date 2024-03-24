// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qeasily_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QeasilyState _$QeasilyStateFromJson(Map<String, dynamic> json) => QeasilyState(
      topics: _$JsonConverterFromJson<Map<String, dynamic>, TopicState>(
          json['topics'], const _TopicStateConverter().fromJson),
      quizzes: _$JsonConverterFromJson<Map<String, dynamic>, QuizState>(
          json['quizzes'], const _QuizStateConverter().fromJson),
      challenges: _$JsonConverterFromJson<Map<String, dynamic>, ChallengeState>(
          json['challenges'], const _ChallengeStateConverter().fromJson),
      search: json['search'] == null
          ? null
          : SearchState.fromJson(json['search'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QeasilyStateToJson(QeasilyState instance) =>
    <String, dynamic>{
      'topics': const _TopicStateConverter().toJson(instance.topics),
      'quizzes': const _QuizStateConverter().toJson(instance.quizzes),
      'challenges':
          const _ChallengeStateConverter().toJson(instance.challenges),
      'search': instance.search,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
