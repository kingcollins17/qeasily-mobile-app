// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizDataState _$QuizDataStateFromJson(Map<String, dynamic> json) =>
    QuizDataState(
      page: json['page'] == null
          ? null
          : PageData.fromJson(json['page'] as Map<String, dynamic>),
      quizzes: (json['quizzes'] as List<dynamic>?)
          ?.map((e) => QuizData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..isLoading = json['isLoading'] as bool
      ..topic = json['topic'] as int?
      ..category = json['category'] as int?;

Map<String, dynamic> _$QuizDataStateToJson(QuizDataState instance) =>
    <String, dynamic>{
      'page': instance.page,
      'quizzes': instance.quizzes,
      'message': instance.message,
      'isLoading': instance.isLoading,
      'topic': instance.topic,
      'category': instance.category,
    };
