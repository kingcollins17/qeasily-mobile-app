// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      id: json['id'] as int,
      userName: json['user_name'] as String,
      department: json['department'] as String,
      level: json['level'] as String,
      followers: json['followers'] as int,
      topics: json['topics'] as int,
      totalQuiz: json['total_quiz'] as int,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'department': instance.department,
      'level': instance.level,
      'followers': instance.followers,
      'topics': instance.topics,
      'total_quiz': instance.totalQuiz,
    };
