// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicDataState _$TopicDataStateFromJson(Map<String, dynamic> json) =>
    TopicDataState(
      page: json['page'] == null
          ? null
          : PageData.fromJson(json['page'] as Map<String, dynamic>),
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => TopicData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..isLoading = json['isLoading'] as bool
      ..message = json['message'] as String?;

Map<String, dynamic> _$TopicDataStateToJson(TopicDataState instance) =>
    <String, dynamic>{
      'page': instance.page,
      'topics': instance.topics,
      'isLoading': instance.isLoading,
      'message': instance.message,
    };
