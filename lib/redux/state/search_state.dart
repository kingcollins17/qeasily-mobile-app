import 'package:json_annotation/json_annotation.dart';
import 'package:qeasily/model/model.dart';

part 'search_state.g.dart';

@JsonSerializable()
class SearchState {
  List<String> queries;

  String? search;

  @PageConverter()
  PageData page;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<TopicData>? topicsResult;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<ChallengeData>? challengeResult;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<QuizData>? quizResult;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoading = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? message;

  SearchState({this.queries = const [], this.search, PageData? page})
      : page = page ?? PageData(page: 1, perPage: 5);

  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  @override
  String toString() =>
      'SearchState{search: $search, page: $page, queries: $queries}';
}

class SearchAction {
  final SearchActionType type;
  final Object? payload;

  const SearchAction({required this.type, required this.payload});
}

enum SearchActionType { search, clearHistory, nextPage, notify }

class PageConverter extends JsonConverter<PageData, dynamic> {
  const PageConverter();

  @override
  PageData fromJson(json) => PageData.fromJson(json);

  @override
  toJson(PageData object) => object.toJson();
}
