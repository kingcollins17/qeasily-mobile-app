import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';

part 'search_state.g.dart';

@JsonSerializable()
class SearchHistoryState {
  List<String> history;

  SearchHistoryState({this.history = const <String>[], PageData? page});

  factory SearchHistoryState.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryStateToJson(this);

  @override
  String toString() => 'SearchHistoryState{queries: $history}';
}


//
class SearchAction {
  final SearchActionType type;
  final Object? payload;

  const SearchAction({required this.type, this.payload});
}

enum SearchActionType {
  clearHistory,
  saveQuery,
  deleteHistory,
  reset
}
