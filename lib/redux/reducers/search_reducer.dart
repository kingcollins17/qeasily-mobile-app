// ignore_for_file: unused_element

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/state/search_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final searchReducer = combineReducers([
  _reducer,
]);

SearchState _reducer(SearchState state, action) {
  if (action is SearchAction) {
    switch (action.type) {
      case SearchActionType.search when action.payload is String:
        state
          ..isLoading = true
          ..search = action.payload.toString();
        break;
      case SearchActionType.notify when action.payload is String:
        state.message = action.payload.toString();
        break;
      case SearchActionType.saveHistory when action.payload is String:
        state.queries = {action.payload.toString(), ...state.queries}.toList();
        break;
      case SearchActionType.clearHistory:
        state.queries = const <String>[];
        break;
      case SearchActionType.deleteHistory when action.payload is String:
        state.queries
            .removeWhere((element) => element == action.payload as String);
        break;
      case SearchActionType.updateResult when action.payload is SearchResp:
        final (msg, quizzes, challenges, topics, hasNextPage) =
            (action.payload as SearchResp);
        state
          ..isLoading = false
          ..message = msg
          ..topicsResult = topics
          ..challengeResult = challenges
          ..quizResult = quizzes;

        state.page.hasNextPage = hasNextPage;
        break;

      default:
        break;
    }
  }
  return state;
}

ThunkAction search(
    {required Dio dio, required String query, required PageData page}) {
  //
  return (Store store) async {
    store.dispatch(SearchAction(type: SearchActionType.search, payload: query));
    final res = await searchBackend(dio, query, page: page);
    store.dispatch(
        SearchAction(type: SearchActionType.updateResult, payload: res));
    if (res.$1 == 'Searched $query') {
      await Future.delayed(const Duration(seconds: 1));
      store.dispatch(
          SearchAction(type: SearchActionType.saveHistory, payload: query));
    }
  };
}
