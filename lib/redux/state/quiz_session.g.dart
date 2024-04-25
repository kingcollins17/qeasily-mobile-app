// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizSession _$QuizSessionFromJson(Map<String, dynamic> json) => QuizSession(
      message: json['message'] as String?,
    )..isLoading = json['isLoading'] as bool;

Map<String, dynamic> _$QuizSessionToJson(QuizSession instance) =>
    <String, dynamic>{
      'message': instance.message,
      'isLoading': instance.isLoading,
    };

SessionHistory _$SessionHistoryFromJson(Map<String, dynamic> json) =>
    SessionHistory(
      mcqSessions: (json['mcqSessions'] as List<dynamic>?)
              ?.map((e) => SavedMCQSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SavedMCQSession>[],
      dcqSessions: (json['dcqSessions'] as List<dynamic>?)
              ?.map((e) => SavedDCQSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SavedDCQSession>[],
    );

Map<String, dynamic> _$SessionHistoryToJson(SessionHistory instance) =>
    <String, dynamic>{
      'mcqSessions': instance.mcqSessions,
      'dcqSessions': instance.dcqSessions,
    };

SavedMCQSession _$SavedMCQSessionFromJson(Map<String, dynamic> json) =>
    SavedMCQSession(
      quiz: QuizData.fromJson(json['quiz'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => MCQData.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondsLeft: json['secondsLeft'] as int,
      current: json['current'] as int,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => $enumDecodeNullable(_$MCQOptionEnumMap, e))
          .toList(),
      currentPage:
          PageData.fromJson(json['currentPage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SavedMCQSessionToJson(SavedMCQSession instance) =>
    <String, dynamic>{
      'quiz': instance.quiz,
      'questions': instance.questions,
      'secondsLeft': instance.secondsLeft,
      'current': instance.current,
      'choices': instance.choices.map((e) => _$MCQOptionEnumMap[e]).toList(),
      'currentPage': instance.currentPage,
    };

const _$MCQOptionEnumMap = {
  MCQOption.A: 'A',
  MCQOption.B: 'B',
  MCQOption.C: 'C',
  MCQOption.D: 'D',
};

SavedDCQSession _$SavedDCQSessionFromJson(Map<String, dynamic> json) =>
    SavedDCQSession(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => DCQData.fromJson(e as Map<String, dynamic>))
          .toList(),
      quiz: QuizData.fromJson(json['quiz'] as Map<String, dynamic>),
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as bool?).toList(),
      secondsLeft: json['secondsLeft'] as int,
      current: json['current'] as int,
      currentPage:
          PageData.fromJson(json['currentPage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SavedDCQSessionToJson(SavedDCQSession instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'quiz': instance.quiz,
      'choices': instance.choices,
      'secondsLeft': instance.secondsLeft,
      'current': instance.current,
      'currentPage': instance.currentPage,
    };
