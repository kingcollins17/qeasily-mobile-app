// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_state.g.dart';

@JsonSerializable()
class QuizState {

  // @_PageConverter()

  @JsonKey(includeFromJson: false, includeToJson: false)
  PageData page;

  @_DataConverter()
  List<QuizData> quizzes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? message;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoading = false;
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? topic, category;

  QuizState({PageData? page, List<QuizData>? quizzes})
      : page = page ?? PageData(perPage: 5),
        quizzes = quizzes ?? const <QuizData>[];

  //
  factory QuizState.fromJson(Map<String, dynamic> json) =>
      _$QuizStateFromJson(json);

  //
  Map<String, dynamic> toJson() => _$QuizStateToJson(this);

  @override
  toString() => 'QuizState{page: $page, message: $message, quizzes:'
      ' $quizzes, isLoading:'
      ' $isLoading, topic: $topic, category: $category}';
}

class _DataConverter extends JsonConverter<List<QuizData>, List<dynamic>> {
  const _DataConverter();
  @override
  List<QuizData> fromJson(List<dynamic> data) {
    return data.map((e) => QuizData.fromJson(e)).toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<QuizData> object) {
    return object.map((e) => e.toJson()).toList();
  }
}

class _PageConverter extends JsonConverter<PageData, Map<String, dynamic>> {
  const _PageConverter();

  @override
  PageData fromJson(Map<String, dynamic> json) {
    return PageData.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(PageData object) {
    return object.toJson();
  }
}

final quizReducer = combineReducers([
  networkReducer,
  basicReducer,
]);

QuizState basicReducer(QuizState state, action) {
  if (action is QuizAction) {
    switch (action.type) {
      case QuizActionType.reset:
        state
          ..category = null
          ..topic = null
          ..isLoading = false
          ..message = null
          ..page = PageData()
          ..quizzes = <QuizData>[];
        break;
      default:
        break;
    }
  }
  return state;
}

QuizState networkReducer(QuizState state, action) {
  if (action is QuizAction) {
    switch (action.type) {
      case QuizActionType.fetch:
        state
          ..isLoading = true
          ..message = 'Fetching Quiz';
        break;
      //
      case QuizActionType.update:
        if (action.payload is QuizResp) {
          final pd = action.payload as QuizResp;
          state
            ..isLoading = false
            ..message = pd.detail
            ..page = pd.page ?? state.page
            ..quizzes = <QuizData>{...state.quizzes, ...pd.data}.toList();
        }
        break;
      case QuizActionType.notify:
        state.message = action.payload?.toString();
        break;
      default:
        break;
    }
  }
  return state;
}

class QuizAction {
  final QuizActionType type;
  final Object? payload;

  const QuizAction({required this.type, this.payload});
}

enum QuizActionType {
  fetch,
  update,
  notify,
  silence,
  reset,
  selectTopic,
  selectCategory,
  unselectTopic,
  unselectCategory
}

Future<QuizResp> fetchQuizzes(Dio client,
    {required PageData page,
    int? topicId,
    int? categoryId,
    bool suggested = false}) async {
  try {
    final _url = suggested
        ? APIUrl.suggestedQuiz.url
        : topicId != null
            ? APIUrl.fetchQuiz.url
            : categoryId != null
                ? APIUrl.quizFromCategory.url
                : APIUrl.suggestedQuiz.url;

    final res = await client.get(_url,
        data: {'page': page.page, 'per_page': page.perPage},
        queryParameters: suggested
            ? null
            : {
                if (topicId != null) 'topic': topicId,
                if (categoryId != null) 'cid': categoryId
              });
    var pageData =
        res.statusCode == 200 ? PageData.fromJson(res.data['page']) : null;
    var hasNextPage = res.data['has_next_page'] as bool?;
    pageData?.hasNextPage = hasNextPage ?? true;
    return (
      detail: res.data['detail'].toString(),
      data: res.statusCode == 200
          ? (res.data['data'] as List)
              .map<QuizData>((e) => QuizData.fromJson(e))
              .toList()
          : <QuizData>[],
      status: res.statusCode == 200,
      page: res.statusCode == 200 ? pageData : null,
      hasNextPage: hasNextPage
    );

    // return res;
  } catch (e) {
    // return e;
    return (
      detail: e.toString(),
      status: false,
      data: <QuizData>[],
      hasNextPage: false,
      page: null
    );
  }
}

class QuizVM {
  final Store _store;
  final QuizState state;
  QuizVM(Store store)
      : _store = store,
        state = store.state.quizzes;
  void dispatch(action) => _store.dispatch(action);
}

typedef QuizResp = ({
  List<QuizData> data,
  String detail,
  bool? hasNextPage,
  PageData? page,
  bool status
});
