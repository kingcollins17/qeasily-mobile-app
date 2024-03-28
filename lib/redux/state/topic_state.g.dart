// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicState _$TopicStateFromJson(Map<String, dynamic> json) => TopicState(
      topics: json['topics'] == null
          ? const []
          : const _DataConverter().fromJson(json['topics'] as List),
    );

Map<String, dynamic> _$TopicStateToJson(TopicState instance) =>
    <String, dynamic>{
      'topics': const _DataConverter().toJson(instance.topics),
    };
