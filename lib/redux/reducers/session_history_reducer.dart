import 'package:qeasily/model/model.dart';
import 'package:redux/redux.dart';

import '../state/quiz_session.dart';

SessionHistory sessionHistoryReducer(SessionHistory state, action) {
  if (action is SessionAction) {
    switch (action.type) {
      case SessionActionType.save when action.payload is SavedMCQSession:
        state.mcqSessions =
            {...state.mcqSessions, action.payload as SavedMCQSession}.toList();

        break;
      case SessionActionType.save when action.payload is SavedDCQSession:
        state.dcqSessions =
            {...state.dcqSessions, action.payload as SavedDCQSession}.toList();
        break;
      case SessionActionType.removeHistory when action.payload is QuizData:
        state.removeSession(action.payload as QuizData);
        break;
      default:
        break;
    }
  }
  return state;
}
