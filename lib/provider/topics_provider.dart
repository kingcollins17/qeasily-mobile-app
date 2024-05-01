import 'package:dio/dio.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/model.dart';

part 'topics_provider.g.dart';

@Riverpod(keepAlive: false)
class TopicsByCategory extends _$TopicsByCategory {
  @override
  Future<(List<TopicData>, PageData)> build(int categoryId,
      [String? level]) async {
    final dio = ref.watch(generalDioProvider);
    final resp = await dio.get(
      APIUrl.fetchTopics.url,
      data: PageData(page: 1, perPage: 5).toJson(),
      queryParameters: {
        'category_id': categoryId,
        if (level != null) 'level': level
      },
    );
    if (resp.statusCode == 200) {
      final {
        'detail': detail,
        'data': data,
        'has_next_page': hasNextPage,
        'page': page
      } = resp.data;
      return (
        (data as List).map((e) => TopicData.fromJson(e)).toList(),
        PageData.fromJson(page)..hasNextPage = hasNextPage
      );
    } else {
      throw Exception(resp.data['detail'].toString());
    }
  }

  Future<dynamic> fetchNextPage() async {
    if (state.hasValue) {
      final (data, currentPage) = state.asData!.value;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final response = await dio.get(APIUrl.fetchTopics.url,
            data: (currentPage..next()).toJson(),
            queryParameters: {
              'category_id': categoryId,
              if (level != null) 'level': level
            });
        if (response.statusCode == 200) {
          final {
            'detail': detail,
            'data': newData,
            'has_next_page': hasNexPage,
            'page': page
          } = response.data;
          state = AsyncData((
            data
              ..addAll(
                  (newData as List).map((e) => TopicData.fromJson(e)).toList()),
            PageData.fromJson(page)..hasNextPage = hasNexPage
          ));
        } else {
          throw Exception(response.data['detail'].toString());
        }
      } else {
        return 'No more data';
      }
    } else {
      return 'State has no value!';
    }
  }
}

@Riverpod(keepAlive: true)
class CreatedTopics extends _$CreatedTopics {
  @override
  Future<(List<TopicData>, PageData)> build() async {
    final dio = ref.watch(generalDioProvider);
    final (status, msg, data, page) =
        await fetchCreatedTopics(dio, PageData(page: 1));
    if (!status) {
      throw Exception(msg);
    }
    return (data, page);
  }

  Future<(bool, dynamic)> fetchNextPage() async {
    if (state.hasValue) {
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final (status, msg, data, page) =
            await fetchCreatedTopics(dio, currentPage..next());

        state = AsyncData((currentData..addAll(data), page));
        return (status, msg);
      } else
        // ignore: curly_braces_in_flow_control_structures
        return (false, 'No more data');
    } else
      // ignore: curly_braces_in_flow_control_structures
      return (false, 'No value for state');
  }
}

///Fetch user created topics from backend
Future<(bool, String, List<TopicData>, PageData)> fetchCreatedTopics(
    Dio dio, PageData requestedPage) async {
  final res = await dio.get(APIUrl.fetchCreatedTopics.url,
      data: requestedPage.toJson());

  if (res.statusCode == 200) {
    final {
      'detail': msg,
      'data': data,
      'has_next_page': hasNextPage,
      'page': page
    } = res.data;

    return (
      true,
      msg.toString(),
      (data as List).map((e) => TopicData.fromJson(e)).toList(),
      PageData.fromJson(page)..hasNextPage = hasNextPage
    );
  }
  return (false, res.data['detail'].toString(), <TopicData>[], requestedPage);
}

Future<dynamic> deleteTopic(Dio dio, int id) async {
  try {
    final response = await dio.delete(
      APIUrl.deleteTopic.url,
      queryParameters: {'topic': id},
    );
    return response.data;
  } catch (e) {
    return e;
  }
}
