import 'package:qeasily/redux/action/auth_actions.dart';
import 'package:qeasily/redux/state/auth.dart';

AuthState authReducer(AuthState state, action) {
  if (action is AuthAction) {
    switch (action.type) {
      default:
        break;
    }
  }
  return state;
}
