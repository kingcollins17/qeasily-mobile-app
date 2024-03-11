import 'package:qeasily/redux/state/topic_state.dart';

class QeasilyState {
  TopicState topics;

  QeasilyState({TopicState? arg}) : topics = arg ?? TopicState();
}

QeasilyState appReducer(QeasilyState state, action) {
  state.topics = topicReducer(state.topics, action);
  return state;
}
