// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers

import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  @override
  Future<({UserData user, ProfileData? profile})> build() async {
    final _dio = ref.watch(generalDioProvider);

    if (_dio.options.headers.containsKey('Authorization')) {
      final response1 = await _dio.get(APIUrl.user.url);
      var userData = UserData.fromJson(response1.data);

      final response2 = await _dio
          .get(APIUrl.profile.url, queryParameters: {'id': userData.id});
      if (response1.statusCode == 200) {
        return (
          user: userData,
          profile: response2.statusCode == 200
              ? ProfileData.fromJson(response2.data['profile'])
              : null
          // profile: response2.data
        );
      }

      throw (response1.data['detail']).toString();
    }
    throw 'You are not authenticated!';
  }

  Future<({String message, bool status})> register(
      {required String username,
      required String email,
      required String password}) async {
    //
    state = const AsyncValue.loading();
    final _dio = ref.read(generalDioProvider);
    final response = await _dio.post(
      APIUrl.register.url,
      data: {'user_name': username, 'email': email, 'password': password},
    );

    ref.read(generalDioProvider.notifier).logout();
    return (
      status: response.statusCode == 200,
      message: response.statusCode == 400
          ? 'Email $email is already registered'
          : response.data['detail'].toString()
    );
  }

  Future<(bool, String)> login(
      {required String email, required String password}) async {
    final _dio = ref.read(generalDioProvider);

    state = const AsyncValue.loading();
    final response = await _dio
        .post(APIUrl.login.url, data: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      ref
          .read(generalDioProvider.notifier)
          .authenticate(AccessToken(response.data['token']));
      // return UserData.fromJson(response.data['user']);
    } else {
      state = AsyncValue.error(
        response.data['detail'].toString(),
        StackTrace.empty,
      );
    }
    return (
      response.statusCode == 200,
      response.statusCode == 200
          ? 'You are logged In'
          : response.data['detail'].toString()
    );
  }

  //
  Future<Resp> createProfile(
      {required String firstName,
      required String lastName,
      required String regNo,
      required String dept,
      required String level}) async {
    if (state.hasValue && state.value != null) {
      final _dio = ref.read(generalDioProvider);
      // state = const AsyncValue.loading();
      final response = await _dio.post(APIUrl.createProfile.url, data: {
        'first_name': firstName,
        'last_name': lastName,
        'reg_no': regNo,
        'department': dept,
        'level': level,
        'user_id': state.value!.user.id
      });
      return (
        status: response.statusCode == 200,
        message: response.data['detail'].toString(),
      );
    }
    return (status: false, message: 'State has no value yet');
  }

  Future<Resp> updateProfile(
      {required String firstName,
      required String lastName,
      required String regNo,
      required String dept,
      required String level}) async {
    if (state.hasValue && state.value != null) {
      final _dio = ref.read(generalDioProvider);
      // state = const AsyncValue.loading();
      final response = await _dio.put(APIUrl.updateProfile.url, data: {
        'first_name': firstName,
        'last_name': lastName,
        'reg_no': regNo,
        'department': dept,
        'level': level,
        'user_id': state.value!.user.id
      });
      return (
        status: response.statusCode == 200,
        message: response.data['detail'].toString(),
      );
    }
    return (status: false, message: 'State has no value yet');
  }
}

typedef Resp = ({String message, bool status});
