import 'package:dio/dio.dart';
import 'package:qeasily/model/quiz.dart';
import 'package:qeasily/redux/redux.dart';
// import 'package:qeasily/redux/state/state.dart';
import 'package:redux/redux.dart';

class SessionViewModel {
  final Store<QeasilyState> _store;
  final QuizSession sessionState;
  final SessionHistory history;
  Dio dio;

  ///
  SessionViewModel(Store<QeasilyState> store, this.dio)
      : _store = store,
        sessionState = store.state.session,
        history = store.state.sessionHistory;

  // void dispatch(action) => _store.dispatch(action);

  void pickOption(option, int index) {
    _store.dispatch(
      SessionAction(
          type: SessionActionType.pickOption, payload: (option, index)),
    );
  }

  void unpickOption(int index) {
    _store.dispatch(
      SessionAction(type: SessionActionType.unpickOption, payload: index),
    );
  }

  ///Creates the quiz session. Not be called directly
  void _createSession(QuizData quiz) {
    _store.dispatch(
      SessionAction(type: SessionActionType.createSession, payload: quiz),
    );
  }

  ///Initializes the vm and creates the session. Consider calling closeSession before
  ///calling init
  void init(QuizData quiz) {
    _createSession(quiz);
    if (sessionState.inSession) {
      _store.dispatch(fetchNextQuestions(dio));
    }
  }

  void closeSession() {
    _store.dispatch(SessionAction(type: SessionActionType.closeSession));
  }

  void notify(String message) {
    _store.dispatch(
        SessionAction(type: SessionActionType.notify, payload: message));
  }

  void clearNotification() {
    _store.dispatch(SessionAction(type: SessionActionType.clearNotify));
  }

  //
  void save(int secondsLeft) {
    _store.dispatch(saveSession(secondsLeft));
  }

  ///Restores a saved quiz sessions
  void restoreSession(SavedSession arg) {
    _store.dispatch(
      SessionAction(type: SessionActionType.restore, payload: arg),
    );
  }

  set current(int value) => _store.dispatch(
        SessionAction(type: SessionActionType.setCurrent, payload: value),
      );
  void next() {
    if (sessionState.session?.shouldLoadMore ?? false) {
      _store.dispatch(fetchNextQuestions(dio));
    }
    _store.dispatch(SessionAction(type: SessionActionType.next));
  }

  void previous() {
    _store.dispatch(SessionAction(type: SessionActionType.previous));
  }
}
