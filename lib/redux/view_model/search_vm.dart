import 'package:qeasily/redux/state/search_state.dart';
import 'package:redux/redux.dart';

import '../qeasily_state.dart';

class SearchViewModel {
  final Store<QeasilyState> _store;
  final SearchState state;
  SearchViewModel(Store<QeasilyState> store)
      : _store = store,
        state = store.state.search;
  void dispatch(action) => _store.dispatch(action);
}
