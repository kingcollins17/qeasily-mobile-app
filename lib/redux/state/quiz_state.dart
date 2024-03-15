// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';

class QuizState {
  PageData page = PageData();
  List<QuizData> quizzes = [];
  String? message;
  bool isLoading = false;
  int? topic, category;
  QuizState();

  @override
  toString() =>
      'QuizState{page: $page, message: $message, quizzes: $quizzes, isLoading:'
      ' $isLoading, topic: $topic, category: $category}';
}

QuizState quizReducer(QuizState state, action) {
  if (action is QuizAction) {
    switch (action.type) {
      case QuizActionType.fetch:
        state
          ..isLoading = true
          ..message = 'Fetching Quiz';
        break;
      case QuizActionType.notify:
        state.message = action.payload?.toString();
        break;
      case QuizActionType.selectTopic:
        if (action.payload is int) {
          state
            ..topic = (action.payload as int)
            ..category = null;
        }
        break;
      case QuizActionType.unselectTopic:
        state.topic = null;
        break;
      case QuizActionType.unselectCategory:
        state.category = null;
        break;
      case QuizActionType.selectCategory:
        if (action.payload is int) {
          state
            ..category = (action.payload as int)
            ..topic = null;
        }
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

  const QuizAction({required this.type, required this.payload});
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

Future<QResp> fetchQuizzes(Dio client,
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
    return (
      detail: res.data['detail'].toString(),
      data: res.statusCode == 200
          ? (res.data['data'] as List)
              .map<QuizData>((e) => QuizData.fromJson(e))
              .toList()
          : <QuizData>[],
      status: res.statusCode == 200,
      page: res.statusCode == 200 ? PageData.fromJson(res.data['page']) : null,
      hasNextPage:
          res.statusCode == 200 ? res.data['has_next_page'] as bool : null
    );
    // return res;
  } catch (e) {
    // return e;
    return (
      detail: e.toString(),
      status: false,
      data: <QuizData>[],
      hasNextPage: null,
      page: null
    );
  }
}

class QuizVM {
  final Store _store;
  final QuizAction state;
  QuizVM(Store store)
      : _store = store,
        state = store.state.quizzes;
  void dispatch(action) => _store.dispatch(action);
}

typedef QResp = ({
  List<QuizData> data,
  String detail,
  bool? hasNextPage,
  PageData? page,
  bool status
});
