// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MCQData _$MCQDataFromJson(Map<String, dynamic> json) => MCQData(
      id: json['id'] as int,
      query: json['query'] as String,
      A: json['A'] as String,
      B: json['B'] as String,
      C: json['C'] as String,
      D: json['D'] as String,
      explanation: json['explanation'] as String,
      correct: $enumDecode(_$MCQOptionEnumMap, json['correct']),
      topicId: json['topic_id'] as int,
      userId: json['user_id'] as int,
    );

Map<String, dynamic> _$MCQDataToJson(MCQData instance) => <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'A': instance.A,
      'B': instance.B,
      'C': instance.C,
      'D': instance.D,
      'explanation': instance.explanation,
      'correct': _$MCQOptionEnumMap[instance.correct]!,
      'topic_id': instance.topicId,
      'user_id': instance.userId,
    };

const _$MCQOptionEnumMap = {
  MCQOption.A: 'A',
  MCQOption.B: 'B',
  MCQOption.C: 'C',
  MCQOption.D: 'D',
};
