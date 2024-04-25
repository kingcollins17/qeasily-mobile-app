import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@Riverpod(keepAlive: false)
Future<(List<QuizData>, List<TopicData>)> search(
    SearchRef ref, String query) async {
  if (query.isEmpty) throw 'Search Query is Empty'; //throw if query is empty
  final dio = ref.watch(generalDioProvider);
  final (status, msg, quizzes, topics) = await searchItem(dio, query);

  if (!status) throw msg; //throw if status is false
  return (quizzes, topics); //else return the data searched
}

Future<(bool, String, List<QuizData>, List<TopicData>)> searchItem(
    Dio dio, String query) async {
  try {
    final response = await dio.get(APIUrl.search.url,
        data: PageData(page: 1).toJson(), queryParameters: {'query': query});
    if (response.statusCode == 200) {
      final {'detail': detail, 'data': data} = response.data;
      final {'quiz': quizzes, 'topics': topics} = data;
      return (
        true,
        detail.toString(),
        // quizzes, topics,
        (quizzes as List).map((e) => QuizData.fromJson(e)).toList(),
        (topics as List).map((e) => TopicData.fromJson(e)).toList()
      );
    }
    //else return false and empty Lists
    return (
      false,
      response.data['detail'].toString(),
      <QuizData>[],
      <TopicData>[]
    );
    // return response.data;
  } catch (e) {
    return (false, e.toString(), <QuizData>[], <TopicData>[]);
  }
}
