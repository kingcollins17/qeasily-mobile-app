import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/util/util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'base.dart';

part 'questions_provider.g.dart';

@Riverpod(keepAlive: true)
class QuestionsByCreator extends _$QuestionsByCreator
    implements NextPageFetcher {
  @override
  Future<(List<Object> data, PageData page)> build(QuestionType type) async {
    final dio = ref.watch(generalDioProvider);
    final (:data, :detail, :page, :status) = await fetchCreatedQuestions(dio,
        page: PageData(page: 1, perPage: 3),
        type: type,
        converter: (p0) => switch (type) {
              QuestionType.mcq => p0.map((e) => MCQData.fromJson(e)).toList(),
              QuestionType.dcq => p0.map((e) => DCQData.fromJson(e)).toList()
            });
    if (!status) throw detail; //throw error if not 202
    //else
    return (data, page);
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    try {
      if (state.hasValue) {
        final (currentData, currentPage) = state.value!;
        if (currentPage.hasNextPage) {
          final dio = ref.read(generalDioProvider);
          final (:data, :detail, :page, :status) = await fetchCreatedQuestions(
            dio,
            page: currentPage..next(),
            type: type,
            converter: (p0) => switch (type) {
              QuestionType.mcq => p0.map((e) => MCQData.fromJson(e)).toList(),
              QuestionType.dcq => p0.map((e) => DCQData.fromJson(e)).toList()
            },
          );
          state = AsyncData((currentData..addAll(data), page));
          return (false, (data, page).toString());
          // return (status, detail);
        } else
          // ignore: curly_braces_in_flow_control_structures
          return (false, 'No more data');
      } else {
        return (false, 'No state value');
      }
    } catch (e) {
      return (false, e.toString());
    }
  }
}

@Riverpod(keepAlive: true)
class QuestionsByTopic extends _$QuestionsByTopic implements NextPageFetcher {
  @override
  Future<(List<Object>, PageData)> build(int topicId,
      [QuestionType type = QuestionType.mcq]) async {
    final dio = ref.watch(generalDioProvider);
    final (status, msg, data, page) = switch (type) {
      QuestionType.mcq => await fetchMCQ(dio, PageData(page: 1), topicId),
      _ => await fetchDCQ(dio, PageData(page: 1), topicId)
    };
    //throw if status is not 200
    if (!status) throw Exception(msg);
    //else return the data and page
    return (data, page);
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    if (state.hasValue) {
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final (status, msg, data, page) = switch (type) {
          QuestionType.mcq => await fetchMCQ(dio, currentPage..next(), topicId),
          QuestionType.dcq => await fetchDCQ(dio, currentPage..next(), topicId),
        };
        state = AsyncData((currentData..addAll(data), page));
        return (status, msg);
      } else {
        return (false, 'No more data');
      }
    } else {
      return (false, 'No value for state');
    }
  }
}

Future<(bool, String, List<MCQData>, PageData)> fetchMCQ(
    Dio dio, PageData page, int topicId) async {
  try {
    final res = await dio.get(APIUrl.fetchAllMcq.url,
        data: page.toJson(), queryParameters: {'topic_id': topicId});
    final {
      'detail': msg,
      'data': data,
      'page': fetchedPage,
      'has_next_page': hasNext
    } = res.data;
    return (
      res.statusCode == 200,
      msg.toString(),
      (data as List).map((e) => MCQData.fromJson(e)).toList(),
      PageData.fromJson(fetchedPage)..hasNextPage = hasNext,
      // hasNext
    );
  } catch (e) {
    return (false, e.toString(), <MCQData>[], page);
  }
}

Future<(bool, String, List<DCQData>, PageData)> fetchDCQ(
    Dio dio, PageData page, int topicId) async {
  try {
    final res = await dio.get(APIUrl.fetchAllDcq.url,
        data: page.toJson(), queryParameters: {'topic_id': topicId});
    final {
      'detail': msg,
      'data': data,
      'page': fetchedPage,
      'has_next_page': hasNext
    } = res.data;
    return (
      res.statusCode == 200,
      msg.toString(),
      (data as List).map((e) => DCQData.fromJson(e)).toList(),
      PageData.fromJson(fetchedPage)..hasNextPage = hasNext
    );
  } catch (e) {
    return (false, e.toString(), <DCQData>[], page);
  }
}

Future<({List<T> data, String detail, PageData page, bool status})>
    fetchCreatedQuestions<T>(Dio dio,
        {required PageData page,
        required QuestionType type,
        required List<T> Function(List<dynamic>) converter}) async {
  try {
    if (!page.hasNextPage) throw 'No more data';
    final res = await dio.get(
        type == QuestionType.mcq
            ? APIUrl.fetchCreatedMcq.url
            : APIUrl.fetchCreatedDcq.url,
        data: page.toJson());
    final {
      'detail': detail,
      'data': data,
      'has_next_page': hasNextPage,
      'page': fetchedPage
    } = res.data;

    return (
      status: res.statusCode == 200,
      detail: detail.toString(),
      data: converter(data),
      page: PageData.fromJson(fetchedPage)..hasNextPage = hasNextPage
    );
    // return res.data;
  } catch (e) {
    return (status: false, detail: e.toString(), data: <T>[], page: page);
    // return e;
  }
}

Future<(bool, String)> _deleteQuestions(
    Dio dio, List<int> ids, QuestionType type) async {
  try {
    final res = await dio.delete(
      switch (type) {
        QuestionType.mcq => APIUrl.deleteMcq.url,
        QuestionType.dcq => APIUrl.deleteDcq.url
      },
      data: ids,
    );
    final {'detail': detail} = res.data;
    return (res.statusCode == 200, detail.toString());
    // return res;
  } catch (e) {
    return (false, e.toString());
  }
}
