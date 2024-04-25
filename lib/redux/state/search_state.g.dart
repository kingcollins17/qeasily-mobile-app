// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistoryState _$SearchHistoryStateFromJson(Map<String, dynamic> json) =>
    SearchHistoryState(
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$SearchHistoryStateToJson(SearchHistoryState instance) =>
    <String, dynamic>{
      'history': instance.history,
    };
