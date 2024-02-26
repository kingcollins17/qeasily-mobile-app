import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/redux/action/action.dart';

///
class AuthAction extends QeasilyAction {
  AuthActionType type;

  AuthAction({required this.type, super.payload});
}

enum AuthActionType {
  login,

  updateLogin,

  ///Requires the NotifyPayload
  notify,
}

//payloads
class LoginPayload extends Payload {
  final Dio client;
  final String email, password;

  LoginPayload({
    required this.client,
    required this.email,
    required this.password,
    super.onDone,
    super.onError,
  });
}

typedef UpdateLoginData = ({AccessToken token, UserData user});
