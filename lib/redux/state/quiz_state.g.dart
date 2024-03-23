// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizState _$QuizStateFromJson(Map<String, dynamic> json) => QuizState(
      page: _$JsonConverterFromJson<Map<String, dynamic>, PageData>(
          json['page'], const _PageConverter().fromJson),
      quizzes: _$JsonConverterFromJson<List<dynamic>, List<QuizData>>(
          json['quizzes'], const _DataConverter().fromJson),
    );

Map<String, dynamic> _$QuizStateToJson(QuizState instance) => <String, dynamic>{
      'page': const _PageConverter().toJson(instance.page),
      'quizzes': const _DataConverter().toJson(instance.quizzes),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
