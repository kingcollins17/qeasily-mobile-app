import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'base.dart';

part 'quiz_provider.g.dart';

@Riverpod(keepAlive: true)
class QuizByCreator extends _$QuizByCreator implements NextPageFetcher {
  @override
  Future<(List<QuizData>, PageData)> build() async {
    final dio = ref.watch(generalDioProvider);
    final response = await dio.get(
      APIUrl.fetchCreatedQuiz.url,
      data: PageData(page: 1).toJson(),
    );
    if (response.statusCode == 200) {
      final {
        // 'detail': detail,
        'data': data,
        'has_next_page': hasNextPage,
        'page': page
      } = response.data;

      return (
        (data as List).map((e) => QuizData.fromJson(e)).toList(),
        PageData.fromJson(page)..hasNextPage = hasNextPage
      );
    }
    throw response.data['detail'].toString();
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    if (state.hasValue) {
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final (:data, :detail, :page, :status) = await fetchQuizzes(dio,
            page: currentPage..next(), url: APIUrl.fetchCreatedQuiz.url);
        state = AsyncData((currentData..addAll(data), page));
        return (status, detail);
      } else {
        return (false, 'No more data');
      }
    } else {
      return (false, 'No state');
    }
  }
}

@Riverpod(keepAlive: true)
class QuizByTopic extends _$QuizByTopic implements NextPageFetcher {
  @override
  Future<(List<QuizData>, PageData)> build(int topicId) async {
    final dio = ref.watch(generalDioProvider);
    final (:status, :detail, :data, :page) = await fetchQuizzes(
      dio,
      page: PageData(page: 1),
      url: APIUrl.fetchQuiz.url,
      queryParams: {'topic': topicId},
    );
    if (!status) throw detail;
    return (data, page);
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    if (state.hasValue) {
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final (:status, :detail, :data, :page) = await fetchQuizzes(dio,
            page: currentPage..next(),
            url: APIUrl.fetchQuiz.url,
            queryParams: {'topic': topicId});
        if (status) {
          state = AsyncData((currentData..addAll(data), page));
        }
        return (status, detail);
      } else {
        return (false, 'No more data');
      }
    } else {
      return (false, 'No state');
    }
  }
}

@Riverpod(keepAlive: true)
class QuizByCategory extends _$QuizByCategory implements NextPageFetcher {
  @override
  Future<(List<QuizData>, PageData)> build(int categoryId) async {
    final dio = ref.watch(generalDioProvider);
    final (:status, :detail, :data, :page) = await fetchQuizzes(
      dio,
      page: PageData(page: 1),
      url: APIUrl.quizFromCategory.url,
      queryParams: {'cid': categoryId},
    );
    if (!status) throw detail;
    return (data, page);
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    if (state.hasValue) {
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final (:status, :data, :detail, :page) = await fetchQuizzes(dio,
            page: currentPage..next(),
            url: APIUrl.quizFromCategory.url,
            queryParams: {'cid': categoryId});
        if (status) {
          state = AsyncData((currentData..addAll(data), page));
        }
        return (status, detail);
      } else {
        return (false, 'No more data');
      }
    } else {
      return (false, 'No state');
    }
  }
}

@Riverpod(keepAlive: true)
class SuggestedQuiz extends _$SuggestedQuiz implements NextPageFetcher {
  @override
  Future<(List<QuizData>, PageData)> build() async {
    final dio = ref.watch(generalDioProvider);
    final (:status, :data, :page, :detail) = await fetchQuizzes(
      dio,
      page: PageData(page: 1),
      url: APIUrl.suggestedQuiz.url,
    );
    if (!status) throw detail;
    return (data, page);
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    if (state.hasValue) {
      final dio = ref.read(generalDioProvider);
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final (:status, :detail, :data, :page) = await fetchQuizzes(
          dio,
          page: currentPage..next(),
          url: APIUrl.suggestedQuiz.url,
        );
        state = AsyncData((currentData..addAll(data), page));
        return (status, detail);
      } else {
        return (false, 'No more data');
      }
    } else {
      return (false, 'No value');
    }
  }
}

Future<({List<QuizData> data, String detail, PageData page, bool status})>
    fetchQuizzes(Dio client,
        {required PageData page,
        required String url,
        Map<String, dynamic>? queryParams}) async {
  try {
    final res = await client.get(
      url,
      data: {'page': page.page, 'per_page': page.perPage},
      queryParameters: queryParams,
    );
    //
    if (res.statusCode == 200) {
      final {
        'detail': detail,
        'data': data,
        'has_next_page': hasNextPage,
        'page': page
      } = res.data;
      return (
        status: true,
        detail: detail.toString(),
        data: (data as List).map((e) => QuizData.fromJson(e)).toList(),
        page: PageData.fromJson(page)..hasNextPage = hasNextPage
      );
    } else {
      return (
        status: res.statusCode == 200,
        detail: res.data['detail'].toString(),
        data: <QuizData>[],
        page: page,
      );
    }
  } catch (e) {
    return (
      detail: e.toString(),
      status: false,
      data: <QuizData>[],
      page: page
    );
  }
}
