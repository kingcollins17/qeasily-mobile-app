// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers

import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  //
  @override
  Future<UserData> build() async {
    final _dio = ref.watch(generalDioProvider);
    if (_dio.options.headers.containsKey('Authorization')) {
      final res = await _dio.get(APIUrl.user.url);
      //
      if (res.statusCode == 200) {
        return UserData.fromJson(res.data);
      } else {
        throw Exception('${res.data['detail']}');
      }
    }
    throw Exception('You are not Signed In');
  }

  Future<(String, bool)> login(String email, String password) async {
    try {
      final _dio = ref.read(generalDioProvider);
      final res = await _dio
          .post(APIUrl.login.url, data: {'email': email, 'password': password});
      if (res.statusCode == 200) {
        ref
            .read(generalDioProvider.notifier)
            .authenticate(AccessToken(res.data['token']));

        await future;
        return ('You are logged in', true);
      }
      return (res.data['detail'].toString(), false);
    } catch (e) {
      return (e.toString(), false);
    }
  }
}
