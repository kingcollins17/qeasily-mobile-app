import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/redux/qeasily_state.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../state/quiz_session.dart';
import 'package:redux/redux.dart';
import '../state/util/util.dart';

final sessionReducer = combineReducers([_reducer, _inSessionReducer]);

QuizSession _reducer(QuizSession state, action) {
  if (action is SessionAction) {
    switch (action.type) {
      case SessionActionType.notify when action.payload is String:
        state.message = action.payload as String;
        break;

      case SessionActionType.clearNotify:
        state.message = null;
      //creates a new session
      case SessionActionType.createSession when action.payload is QuizData:
        state.session = switch ((action.payload as QuizData).type) {
          'mcq' => MCQSessionState(
              quiz: action.payload as QuizData,
              current: 0,
              currentPage: PageData(),
              choices: <MCQOption?>[
                for (int i = 0;
                    i < (action.payload as QuizData).questionsAsInt.length;
                    i++)
                  null
              ],
              timeLeft:
                  Duration(seconds: (action.payload as QuizData).duration),
            ),
          'dcq' => DCQSessionState(
              quiz: action.payload as QuizData,
              current: 0,
              currentPage: PageData(),
              choices: <bool?>[
                for (int i = 0;
                    i < (action.payload as QuizData).questionsAsInt.length;
                    i++)
                  null
              ],
              timeLeft:
                  Duration(seconds: (action.payload as QuizData).duration),
            ),
          _ => null
        };
        break;
      case SessionActionType.restore when action.payload is SavedSession:
        state
          ..session = (action.payload as SavedSession).restoreSession()
          ..message = 'session restored';

      case SessionActionType.closeSession:
        state.session = null;
        break;

      default:
        break;
    }
  }
  return state;
}

QuizSession _inSessionReducer(QuizSession state, action) {
  if (action is SessionAction) {
    switch (action.type) {
      case SessionActionType.updateQuestions:
        if (action.payload case (List data, PageData page, String detail)) {
          state.message = detail;
          state.session?.currentPage = page;
          state.session?.addQuestions(data);
          state.isLoading = false;
        }
        break;

      case SessionActionType.pickOption:
        if (action.payload case (dynamic option, int index)) {
          state.session?.pickOption(option, index);
        }
        break;

      case SessionActionType.unpickOption when action.payload is int:
        state.session?.unpickOption(action.payload as int);
        break;

      case SessionActionType.setCurrent when action.payload is int:
        state.session?.current = action.payload as int;
        break;
      case SessionActionType.next:
        //if there is a next question available
        if ((state.session?.availableQuestions.length ?? 0) >
            (state.session?.current ?? 0) + 1) {
          state.session?.current += 1;
        } else {
          state.message = 'No more questions';
        }
        break;
      case SessionActionType.previous:
        if ((state.session?.current ?? 0) > 0) {
          state.session?.current -= 1;
        } else {
          state.message = 'This is the first question';
        }
        break;

      case SessionActionType.load:
        state.isLoading = true;
        break;
      case SessionActionType.endload:
        state.isLoading = false;
        break;

      default:
        break;
    }
  }
  return state;
}

ThunkAction saveSession(int secondsLeft) {
  return (store) async {
    if (store case Store(state: QeasilyState(:final session))) {
      //save the session
      store.dispatch(SessionAction(
          type: SessionActionType.save,
          payload:
              session.session?.saveSession(Duration(seconds: secondsLeft))));
      //notify that the session has been saved
      store.dispatch(SessionAction(
          type: SessionActionType.notify, payload: 'Session saved'));
    }
  };
}

//async actions
ThunkAction fetchNextQuestions(Dio dio) {
  return (Store store) async {
    if (store
        case Store(
          state: QeasilyState(session: QuizSession(:final session!))
        )) {
      if (session.currentPage.hasNextPage) {
        //set loading to true
        store.dispatch(SessionAction(type: SessionActionType.load));
        //fetch the questions
        final response = await session.fetchNextQuestions(dio,
            converter: switch (session) {
              MCQSessionState _ => (value) => MCQData.fromJson(value),
              DCQSessionState _ => (value) => DCQData.fromJson(value),
              _ => (value) => value
            });
        //
        store.dispatch(SessionAction(
            type: SessionActionType.updateQuestions, payload: response));
      } //else if page does not have next
      else {
        store.dispatch(
          SessionAction(
            type: SessionActionType.notify,
            payload: 'No next Question',
          ),
        );
      }
    }
  };
}
