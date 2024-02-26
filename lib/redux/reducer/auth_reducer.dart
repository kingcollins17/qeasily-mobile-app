import 'package:qeasily/redux/action/auth_actions.dart';
import 'package:qeasily/redux/action/base.dart';
import 'package:qeasily/redux/state/auth.dart';

AuthState authReducer(AuthState state, action) {
  if (action is AuthAction) {
    switch (action.type) {
      case AuthActionType.notify:
        if (action.payload is NotifyPayload) {
          state
            ..message = (action.payload as NotifyPayload).message
            ..isLoading = false;
        }
        break;
      case AuthActionType.login:
        state
          ..isLoading = true
          ..message = 'Trying to authenticate user';
        break;
      case AuthActionType.updateLogin:
        if (action.payload is UpdatePayload<UpdateLoginData>) {
          final pd = action.payload as UpdatePayload<UpdateLoginData>;
          state
            ..isLoading = false
            ..message = 'You are signed in'
            ..token = pd.data.token
            ..user = pd.data.user;
        }
        break;
      default:
        break;
    }
  }
  return state;
}
