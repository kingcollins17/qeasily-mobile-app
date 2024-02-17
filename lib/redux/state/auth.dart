import 'package:qeasily/model/model.dart';

///
class AuthState {
  UserData? user;
  AccessToken? token;

  AuthState({this.user, this.token});

  @override
  String toString() => 'AuthState{user: $user, token: $token}';
}
