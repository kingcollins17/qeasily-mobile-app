import 'package:redux/redux.dart';

import '../state/topic_state.dart';

class TopicVM {
  final Store _store;
  final TopicDataState state;
  TopicVM(store)
      : _store = store,
        state = store.state.topics;

  void dispatch(action) => _store.dispatch(action);
}
