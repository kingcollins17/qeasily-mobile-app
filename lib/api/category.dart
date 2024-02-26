import 'package:dio/dio.dart';
import '_base.dart' as cfg;

class CategoryAPI {
  static Future<dynamic> categories(Dio dio) async {
    try {
      final response = await dio.get(
        Uri.http(cfg.domain).toString(),
        // options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      return response.data;
    } catch (e) {
      return e;
    }
  }
}
