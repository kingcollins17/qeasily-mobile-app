import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';

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

  bool get hasData =>
      (topicsResult != null && topicsResult!.isNotEmpty) ||
      (challengeResult != null && challengeResult!.isNotEmpty) ||
      (quizResult != null && quizResult!.isNotEmpty);

  @override
  String toString() =>
      'SearchState{search: $search, page: $page, queries: $queries,'
      ' message: $message, isLoading: $isLoading, '
      'topics: $topicsResult, challenges: $challengeResult, quizzes:$quizResult}';
}

class SearchAction {
  final SearchActionType type;
  final Object? payload;

  const SearchAction({required this.type, required this.payload});
}

enum SearchActionType {
  search,
  clearHistory,
  saveHistory,
  deleteHistory,
  nextPage,
  notify,
  updateResult,
  reset
}

class PageConverter extends JsonConverter<PageData, dynamic> {
  const PageConverter();

  @override
  PageData fromJson(json) => PageData.fromJson(json);

  @override
  toJson(PageData object) => object.toJson();
}

///Where all the magic happens
Future<SearchResp> searchBackend(Dio dio, String term,
    {required PageData page}) async {
  try {
    final res = await dio.get(APIUrl.search.url,
        data: page.toJson(), queryParameters: {'query': term});

    final {'detail': msg, 'data': data} = res.data;
    final {'quizzes': quizzes, 'challenges': challenges, 'topics': topics} =
        data;
    bool hasNextPage = quizzes['has_next_page'] ||
        challenges['has_next_page'] ||
        topics['has_next_page'];
    //
    return (
      msg.toString(),
      (quizzes['data'] as List).map((e) => QuizData.fromJson(e)).toList(),
      (challenges['data'] as List)
          .map((e) => ChallengeData.fromJson(e))
          .toList(),
      (topics['data'] as List).map((e) => TopicData.fromJson(e)).toList(),
      hasNextPage
    );
  } catch (e) {
    return (
      e.toString(),
      <QuizData>[],
      <ChallengeData>[],
      <TopicData>[],
      false
    );
  }
}

typedef SearchResp = (
  String,
  List<QuizData>,
  List<ChallengeData>,
  List<TopicData>,
  bool
);
