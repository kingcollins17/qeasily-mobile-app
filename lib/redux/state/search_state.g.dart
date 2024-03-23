// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchState _$SearchStateFromJson(Map<String, dynamic> json) => SearchState(
      queries: (json['queries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      search: json['search'] as String?,
      page: const PageConverter().fromJson(json['page']),
    );

Map<String, dynamic> _$SearchStateToJson(SearchState instance) =>
    <String, dynamic>{
      'queries': instance.queries,
      'search': instance.search,
      'page': const PageConverter().toJson(instance.page),
    };
