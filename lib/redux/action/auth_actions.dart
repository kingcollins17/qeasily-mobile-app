import 'package:qeasily/redux/action/action.dart';

///
class AuthAction extends QeasilyAction {
  AuthActionType type;

  AuthAction({required this.type, required super.payload});
}

enum AuthActionType { login, notify }

//payloads
