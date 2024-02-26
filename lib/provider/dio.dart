import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

@Riverpod()
Dio dio(DioRef ref) => Dio(BaseOptions(validateStatus: (status) => true));
