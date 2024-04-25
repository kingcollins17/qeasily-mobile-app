import 'package:qeasily/redux/state/search_state.dart';
import 'package:redux/redux.dart';

import '../qeasily_state.dart';

class SearchViewModel {
  final Store<QeasilyState> _store;
  final SearchHistoryState state;
  SearchViewModel(Store<QeasilyState> store)
      : _store = store,
        state = store.state.search;
  void dispatch(action) => _store.dispatch(action);

  void deleteQuery(String query) => _store.dispatch(
      SearchAction(type: SearchActionType.deleteHistory, payload: query));

  void saveQuery(String query) => _store
      .dispatch(SearchAction(type: SearchActionType.saveQuery, payload: query));

  void clearHistory() {
    _store.dispatch(SearchAction(type: SearchActionType.clearHistory));
  }
}
