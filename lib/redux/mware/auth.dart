import 'package:qeasily/api/api.dart';
import 'package:qeasily/redux/action/auth_actions.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:redux/redux.dart';

dynamic authMiddleware(Store store, action, NextDispatcher next) {
  if (action is AuthAction) {
    switch (action.type) {
      case AuthActionType.login:
        if (action.payload is LoginPayload) {
          final pd = action.payload as LoginPayload;
          AuthAPI.login(pd.client, email: pd.email, password: pd.password)
              .then((value) {
            if (value.status) {
              store.dispatch(AuthAction(
                type: AuthActionType.updateLogin,
                payload: UpdatePayload<UpdateLoginData>(
                    (token: value.token!, user: value.user!)),
              ));
              pd.onDone != null ? pd.onDone!(value) : null;
            } else {
              store.dispatch(
                AuthAction(
                    type: AuthActionType.notify,
                    payload: NotifyPayload(value.detail)),
              );
              pd.onError != null ? pd.onError!(value.detail) : null;
            }
          });
        }
        break;
      default:
        break;
    }
  }
  next(action);
}
