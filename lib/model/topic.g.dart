// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicData _$TopicDataFromJson(Map<String, dynamic> json) => TopicData(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      dateAdded: DateTime.parse(json['date_added'] as String),
      categoryId: json['category_id'] as int,
      userId: json['user_id'] as int,
      level: json['level'] as String,
    );

Map<String, dynamic> _$TopicDataToJson(TopicData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date_added': instance.dateAdded.toIso8601String(),
      'category_id': instance.categoryId,
      'user_id': instance.userId,
      'level': instance.level,
    };
