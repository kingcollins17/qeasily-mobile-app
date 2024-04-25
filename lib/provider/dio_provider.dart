// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
class GeneralDio extends _$GeneralDio {
  @override
  Dio build() {
    final config = Hive.box('config');
    final token = config.get('accessToken'); //check if accessToken is stored
    //
    return Dio(BaseOptions(
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
        validateStatus: (status) => true,
        baseUrl: baseUrl,
        headers: token != null
            ? {'Authorization': 'Bearer $token'}
            : null //check if token is not null
        ));
  }

  void authenticate(AccessToken token) {
    state.close(force: true);
    state = Dio(
      state.options.copyWith(headers: {'Authorization': 'Bearer $token'}),
    );
    final config = Hive.box('config');
    config.put(
        'accessToken', token.toString()); //save the token to local storage
  }

  void logout() {
    state.close(force: true);
    state = Dio(state.options..headers.remove('Authorization'));
    final config = Hive.box('config');
    config.delete('accessToken');
  }
}
