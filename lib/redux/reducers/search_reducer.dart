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

SearchHistoryState _reducer(SearchHistoryState state, action) {
  if (action is SearchAction) {
    switch (action.type) {
      case SearchActionType.saveQuery when action.payload is String:
        state.history = {...state.history, action.payload as String}.toList();
        break;
      case SearchActionType.deleteHistory when action.payload is String:
        state.history.remove(action.payload as String);
        break;
      case SearchActionType.clearHistory:
        state.history = <String>[];
        break;
      default:
        break;
    }
  }
  return state;
}
