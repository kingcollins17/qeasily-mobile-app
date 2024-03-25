// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_question_util.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MCQDraft _$MCQDraftFromJson(Map<String, dynamic> json) => MCQDraft(
      query: json['query'] as String?,
      A: json['A'] as String?,
      B: json['B'] as String?,
      C: json['C'] as String?,
      D: json['D'] as String?,
      correct: $enumDecodeNullable(_$MCQOptionEnumMap, json['correct']),
      explanation: json['explanation'] as String?,
      topicId: json['topicId'] as int?,
      difficulty:
          $enumDecodeNullable(_$MCQDifficultyEnumMap, json['difficulty']) ??
              MCQDifficulty.easy,
    );

Map<String, dynamic> _$MCQDraftToJson(MCQDraft instance) => <String, dynamic>{
      'query': instance.query,
      'A': instance.A,
      'B': instance.B,
      'C': instance.C,
      'D': instance.D,
      'explanation': instance.explanation,
      'correct': _$MCQOptionEnumMap[instance.correct],
      'difficulty': _$MCQDifficultyEnumMap[instance.difficulty]!,
      'topicId': instance.topicId,
    };

const _$MCQOptionEnumMap = {
  MCQOption.A: 'A',
  MCQOption.B: 'B',
  MCQOption.C: 'C',
  MCQOption.D: 'D',
};

const _$MCQDifficultyEnumMap = {
  MCQDifficulty.easy: 'easy',
  MCQDifficulty.medium: 'medium',
  MCQDifficulty.hard: 'hard',
};

DCQDraft _$DCQDraftFromJson(Map json) => DCQDraft(
      query: json['query'] as String?,
      explanation: json['explanation'] as String?,
      correct: json['correct'] as bool? ?? true,
      topicId: json['topicId'] as int?,
    );

Map<String, dynamic> _$DCQDraftToJson(DCQDraft instance) => <String, dynamic>{
      'query': instance.query,
      'explanation': instance.explanation,
      'correct': instance.correct,
      'topicId': instance.topicId,
    };
