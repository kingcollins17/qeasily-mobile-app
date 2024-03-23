// ignore_for_file: unused_element

import 'package:qeasily/redux/state/search_state.dart';
import 'package:redux/redux.dart';

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
      default:
        break;
    }
  }
  return state;
}
