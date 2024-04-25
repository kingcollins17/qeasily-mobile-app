import 'package:redux/redux.dart';

import '../state/quiz_state.dart';

class QuizVM {
  final Store _store;
  final QuizDataState state;
  QuizVM(Store store)
      : _store = store,
        state = store.state.quizzes;
  void dispatch(action) => _store.dispatch(action);
}
