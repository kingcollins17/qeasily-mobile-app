// import 'package:qeasily/redux/redux.dart';
import 'state/challenge_state.dart';

import 'state/topic_state.dart';
import 'state/quiz_state.dart';

class QeasilyState {
  TopicState topics;
  QuizState quizzes;
  ChallengeState challenges;

  QeasilyState({TopicState? arg})
      : topics = arg ?? TopicState(),
        quizzes = QuizState(),
        challenges = ChallengeState();
}

QeasilyState appReducer(QeasilyState state, action) {
  state
    ..topics = topicReducer(state.topics, action)
    ..quizzes = quizReducer(state.quizzes, action)
    ..challenges = chgReducer(state.challenges, action);

  return state;
}
