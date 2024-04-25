import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/redux/qeasily_state.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
// import 'package:json_annotation/json_annotation.dart';

import '../state/quiz_state.dart';

final quizReducer = combineReducers([
  networkReducer,
  basicReducer,
]);

QuizDataState basicReducer(QuizDataState state, action) {
  if (action is QuizAction) {
    switch (action.type) {
      case QuizActionType.load:
        state.isLoading = true;
        break;
      case QuizActionType.endload:
        state.isLoading = false;
        break;
      case QuizActionType.resetPage:
        state.page = PageData();
        break;
      case QuizActionType.notify when action.payload is String:
        state.message = action.payload.toString();
        break;
      case QuizActionType.clearNotify:
        state.message = null;
        break;
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

QuizDataState networkReducer(QuizDataState state, action) {
  if (action is QuizAction) {
    switch (action.type) {
      case QuizActionType.update:
        if (action.payload
            case (
              :bool status,
              :List<QuizData> data,
              :String detail,
              :PageData page,
            )) {
          state
            ..isLoading = false
            ..message = detail
            ..quizzes = {...state.quizzes, ...data}.toList()
            ..page = page;
        }
        break;
      default:
        break;
    }
  }
  return state;
}

ThunkAction fetchQuizByTopic(Dio dio, int topicId, {bool resetPage = false}) {
  return (store) async {
    if (store case Store(state: QeasilyState(:final quizzes))) {
      //If there is a next page
      if (resetPage) {
        //reset page to PageData(page: 0)
        store.dispatch(const QuizAction(type: QuizActionType.resetPage));
      }
      if (quizzes.page.hasNextPage) {
        store.dispatch(const QuizAction(type: QuizActionType.load));

        //
        final data = await fetchQuizzes(dio,
            page: quizzes.page..next(),
            url: APIUrl.fetchQuiz.url,
            queryParams: {'topic': topicId});
        store.dispatch(QuizAction(type: QuizActionType.update, payload: data));
      } else {
        //else when there is no next page
        store.dispatch(
          const QuizAction(
              type: QuizActionType.notify, payload: 'No more data'),
        );
      }
    }
  };
}

///Fetches all quiz
ThunkAction fetchAllQuiz(Dio dio, {bool resetPage = false}) {
  return (store) async {
    if (store case Store(state: QeasilyState(:final quizzes))) {
      if (resetPage) {
        store.dispatch(const QuizAction(type: QuizActionType.resetPage));
      }

      if (quizzes.page.hasNextPage) {
        store.dispatch(const QuizAction(type: QuizActionType.load));
        final data = await fetchQuizzes(dio,
            page: quizzes.page..next(), url: APIUrl.fetchAllQuiz.url);

        store.dispatch(QuizAction(type: QuizActionType.update, payload: data));
      } else {
        //no more data
        store.dispatch(const QuizAction(
            type: QuizActionType.notify, payload: 'No more data'));
      }
    }
  };
}

///An action to fetch quizzes by their category
ThunkAction fetchQuizByCategory(Dio dio, int categoryId,
    {bool resetPage = false}) {
  return (store) async {
    if (store case (Store(state: QeasilyState(:final quizzes)))) {
      //
      if (resetPage) {
        store.dispatch(const QuizAction(type: QuizActionType.resetPage));
      }
      if (quizzes.page.hasNextPage) {
        store.dispatch(const QuizAction(type: QuizActionType.load));
        final response = await fetchQuizzes(dio,
            page: quizzes.page..next(),
            url: APIUrl.quizFromCategory.url,
            queryParams: {'cid': categoryId});
        store.dispatch(
            QuizAction(type: QuizActionType.update, payload: response));
      } else {
        store.dispatch(const QuizAction(
            type: QuizActionType.notify, payload: 'No more data'));
      }
    } else {}
  };
}

ThunkAction fetchSuggestedQuiz(Dio dio, {bool resetPage = false}) {
  return (store) async {
    if (store case Store(state: QeasilyState(:final quizzes))) {
      if (resetPage) {
        store.dispatch(const QuizAction(type: QuizActionType.resetPage));
      }
      if (quizzes.page.hasNextPage) {
        final res = await fetchQuizzes(dio,
            page: quizzes.page..next(), url: APIUrl.suggestedQuiz.url);
        store.dispatch(QuizAction(type: QuizActionType.update, payload: res));
      } else {
        store.dispatch(const QuizAction(
            type: QuizActionType.notify, payload: 'No more data'));
      }
    } else {}
  };
}

Future<({List<QuizData> data, String detail, PageData page, bool status})>
    fetchQuizzes(Dio client,
        {required PageData page,
        required String url,
        Map<String, dynamic>? queryParams}) async {
  try {
    final res = await client.get(
      url,
      data: {'page': page.page, 'per_page': page.perPage},
      queryParameters: queryParams,
    );
    //
    if (res.statusCode == 200) {
      final {
        'detail': detail,
        'data': data,
        'has_next_page': hasNextPage,
        'page': page
      } = res.data;
      return (
        status: true,
        detail: detail.toString(),
        data: (data as List).map((e) => QuizData.fromJson(e)).toList(),
        page: PageData.fromJson(page)..hasNextPage = hasNextPage
      );
    } else {
      return (
        status: res.statusCode == 200,
        detail: res.data['detail'].toString(),
        data: <QuizData>[],
        page: page,
      );
    }
  } catch (e) {
    return (
      detail: e.toString(),
      status: false,
      data: <QuizData>[],
      page: page
    );
  }
}
