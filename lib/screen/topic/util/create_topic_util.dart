import 'package:dio/dio.dart';
import 'package:qeasily/route_doc.dart';

Future<(String, bool)> createTopic(
  Dio dio, {
  required String title,
  required String description,
  required int categoryId,
  // required int userId
}) async {
  try {
    final res = await dio.post(APIUrl.createTopic.url, data: [
      {
        'title': title,
        'description': description,
        'category_id': categoryId,
        // 'user_id': userId
      }
    ]);
    final {'detail': detail} = res.data;
    return (detail.toString(), res.statusCode == 200);
  } catch (e) {
    return (e.toString(), false);
  }
}
