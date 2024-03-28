// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizData _$QuizDataFromJson(Map<String, dynamic> json) => QuizData(
      id: json['id'] as int,
      title: json['title'] as String,
      questions: json['questions'] as String,
      userId: json['user_id'] as int,
      topicId: json['topic_id'] as int,
      duration: json['duration'] as int,
      dateAdded: DateTime.parse(json['date_added'] as String),
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      type: json['type'] as String,
      topic: json['topic'] as String,
      creator: json['creator'] as String,
    );

Map<String, dynamic> _$QuizDataToJson(QuizData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'questions': instance.questions,
      'description': instance.description,
      'difficulty': instance.difficulty,
      'type': instance.type,
      'creator': instance.creator,
      'topic': instance.topic,
      'user_id': instance.userId,
      'topic_id': instance.topicId,
      'duration': instance.duration,
      'date_added': instance.dateAdded.toIso8601String(),
    };
