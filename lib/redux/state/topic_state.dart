// ignore_for_file: unnecessary_this

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_state.g.dart';

@JsonSerializable()
class TopicDataState {

  PageData page;
  List<TopicData> topics;

  bool isLoading = false;

  String? message;

  ///Holds the current selected categoryId
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? categoryId;

  //
  TopicDataState({PageData? page, this.topics = const []})
      : this.page = page ?? PageData(perPage: 6);

  factory TopicDataState.fromJson(Map<String, dynamic> json) =>
      _$TopicDataStateFromJson(json);

  Map<String, dynamic> toJson() => _$TopicDataStateToJson(this);

  @override
  toString() => 'TopicState{isLoading: $isLoading, page: $page, '
      'topics: $topics, message: $message, categorId: $categoryId}';
}



class TopicAction {
  final TopicActionType type;
  final Object? payload;

  TopicAction({required this.type, this.payload});
}

enum TopicActionType {
  fetch,
  nextPage,
  selectCategory,
  unselectCategory,
  notify,
  silence,
  search,
  update,
  reset,
  resetPage
}

