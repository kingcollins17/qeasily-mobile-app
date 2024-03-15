import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/state/topic_state.dart';

class QeasilyState {
  TopicState topics;
  QuizState quizzes;

  QeasilyState({TopicState? arg})
      : topics = arg ?? TopicState(),
        quizzes = QuizState();
}

QeasilyState appReducer(QeasilyState state, action) {
  state.topics = topicReducer(state.topics, action);
  return state;
}
