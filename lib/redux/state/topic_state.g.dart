// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicState _$TopicStateFromJson(Map<String, dynamic> json) => TopicState(
      page: _$JsonConverterFromJson<Map<String, dynamic>, PageData>(
          json['page'], const _PageConverter().fromJson),
      topics: json['topics'] == null
          ? const []
          : const _DataConverter().fromJson(json['topics'] as List),
    );

Map<String, dynamic> _$TopicStateToJson(TopicState instance) =>
    <String, dynamic>{
      'page': const _PageConverter().toJson(instance.page),
      'topics': const _DataConverter().toJson(instance.topics),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
