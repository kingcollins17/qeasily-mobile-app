import 'package:qeasily/redux/reducer/auth_reducer.dart';
import 'package:qeasily/redux/state/auth.dart';
import 'package:redux/redux.dart';
import 'mware/mware.dart';
import 'action/action.dart';

final store = Store(_reducer, initialState: QeasilyState(), middleware: [
  authMiddleware,
]);

class QeasilyState {
  AuthState auth;

  QeasilyState() : auth = AuthState();
}

QeasilyState _reducer(QeasilyState state, action) {
  if (action is QeasilyAction) {
    state.auth = authReducer(state.auth, action);
  }
  return state;
}
