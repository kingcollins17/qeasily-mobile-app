// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      id: json['id'] as int,
      department: json['department'] as String,
      level: json['level'] as String,
      plan: json['plan'] as String,
      email: json['email'] as String,
      followers: json['followers'] as int,
      following: json['following'] as int,
      quizzesLeft: json['quizzes_left'] as int,
      topics: json['topics'] as int,
      totalQuiz: json['total_quiz'] as int,
      totalMcqs: json['total_mcqs'] as int,
      totalDcqs: json['total_dcqs'] as int,
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'department': instance.department,
      'level': instance.level,
      'plan': instance.plan,
      'email': instance.email,
      'followers': instance.followers,
      'following': instance.following,
      'topics': instance.topics,
      'quizzes_left': instance.quizzesLeft,
      'total_quiz': instance.totalQuiz,
      'total_mcqs': instance.totalMcqs,
      'total_dcqs': instance.totalDcqs,
    };
