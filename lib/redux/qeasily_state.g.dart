// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qeasily_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QeasilyState _$QeasilyStateFromJson(Map<String, dynamic> json) => QeasilyState(
      search: json['search'] == null
          ? null
          : SearchHistoryState.fromJson(json['search'] as Map<String, dynamic>),
    )..sessionHistory =
        SessionHistory.fromJson(json['sessionHistory'] as Map<String, dynamic>);

Map<String, dynamic> _$QeasilyStateToJson(QeasilyState instance) =>
    <String, dynamic>{
      'search': instance.search,
      'sessionHistory': instance.sessionHistory,
    };
