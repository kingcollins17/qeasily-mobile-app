import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';

class ChallengeState {
  // PageData page;
}

Future<dynamic> fetchChallenges(Dio dio, PageData page) async {
  try {
    final res = await dio.get(APIUrl.fetchChallenges.url,
        data: page.toJson(), queryParameters: {'feed': false});

    return res;
  } catch (e) {
    return e;
  }
}
