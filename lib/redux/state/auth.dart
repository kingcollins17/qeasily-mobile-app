import 'package:qeasily/model/model.dart';

///
class AuthState {
  UserData? user;
  AccessToken? token;

  String? message;
  bool isLoading;

  AuthState({this.user, this.token, this.message, this.isLoading = false});

  @override
  String toString() =>
      'AuthState{user: $user, token: $token, isLoading: $isLoading, message: $message}';
}
