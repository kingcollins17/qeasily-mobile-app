// import 'package:qeasily/redux/redux.dart';
import 'state/topic_state.dart';
import 'state/quiz_state.dart';

class QeasilyState {
  TopicState topics;
  QuizState quizzes;

  QeasilyState({TopicState? arg})
      : topics = arg ?? TopicState(),
        quizzes = QuizState();
}

QeasilyState appReducer(QeasilyState state, action) {
  state
    ..topics = topicReducer(state.topics, action)
    ..quizzes = quizReducer(state.quizzes, action);
  
  return state;
}
