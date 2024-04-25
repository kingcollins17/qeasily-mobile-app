import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';

Future<MCQResp> fetchMCQQuestions(Dio dio,
    {required PageData page, required int quizId}) async {
  try {
    final res = await dio.get(APIUrl.fetchQuizQuestions.url,
        data: page.toJson(), queryParameters: {'quiz_id': quizId});

    // ignore: no_leading_underscores_for_local_identifiers
    final _fetchedPage =
        res.statusCode == 200 ? PageData.fromJson(res.data['page']) : null;

    _fetchedPage?.hasNextPage = (res.data['has_next_page'] as bool?) ?? false;

    return (
      detail: res.data['detail'].toString(),
      data: (res.data['data'] as List).map((e) => MCQData.fromJson(e)).toList(),
      page: _fetchedPage
    );
  } catch (e) {
    return (detail: e.toString(), data: const <MCQData>[], page: null);
  }
}

typedef MCQResp = ({List<MCQData> data, String detail, PageData? page});

///Fetch a page of questions over the network
Future<DCQResp> fetchDCQQuestions(Dio dio, int quizId, PageData page) async {
  try {
    final res = await dio.get(
      APIUrl.fetchQuizQuestions.url,
      queryParameters: {'quiz_id': quizId},
      data: page.toJson(),
    );
    final {
      'detail': detail,
      'data': data,
      'has_next_page': hasNext,
      'page': fetchedPage
    } = res.data;
    return (
      detail: detail,
      data: (data as List).map((e) => DCQData.fromJson(e)).toList(),
      page: (PageData.fromJson(fetchedPage)..hasNextPage = hasNext)
    );
    // return res;
  } catch (e) {
    return (detail: e.toString(), data: const <DCQData>[], page: null);
  }
}

typedef DCQResp = ({List<DCQData> data, dynamic detail, PageData? page});
