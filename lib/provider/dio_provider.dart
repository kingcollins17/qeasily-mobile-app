// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
class GeneralDio extends _$GeneralDio {
  @override
  Dio build() => Dio(BaseOptions(
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        validateStatus: (status) => true,
        baseUrl: baseUrl,
      ));

  void authenticate(AccessToken token) {
    state.close(force: true);
    state = Dio(
      state.options.copyWith(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  void logout() {
    state.close(force: true);
    state = Dio(state.options..headers.remove('Authorization'));
  }
}
