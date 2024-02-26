import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import '_base.dart' as cfg;

typedef LoginResponse = ({
  bool status,
  AccessToken? token,
  UserData? user,
  String detail
});

class AuthAPI {
  static Future<LoginResponse> login(
    Dio dio, {
    String email = 'king@gmail.com',
    String password = 'kingpass',
  }) async {
    try {
      final response = await dio.post(
        Uri.http(cfg.domain, '/auth/login').toString(),
        data: {'email': email, 'password': password},
      );
      return (
        status: response.statusCode == 200,
        token: response.statusCode == 200
            ? AccessToken(response.data['token'])
            : null,
        user: response.statusCode == 200
            ? UserData.fromJson(response.data['user'])
            : null,
        detail: response.statusCode == 200
            ? 'You are signed in'
            : response.data['detail'].toString()
      );
      // return response.data;
    } on Exception catch (e) {
      return (
        status: false,
        token: null,
        user: null,
        detail: e.toString(),
      );
    }
  }
}
