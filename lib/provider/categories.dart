// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:json_annotation/json_annotation.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories.g.dart';

@Riverpod(keepAlive: true)
Future<List<CategoryData>> categories(CategoriesRef ref) async {
  final _dio = ref.watch(generalDioProvider);
  if (_dio.options.headers.containsKey('Authorization')) {
    final res = await _dio.get(APIUrl.categories.url);
    //
    //
    if (res.statusCode == 200) {
      final temp = (res.data['data'] as List<dynamic>)
          .map((e) => CategoryData.fromJson(e))
          .toList();
      return temp;
    }
    throw Exception(res.data['detail'].toString());
  } else {
    throw Exception('You are not authenticated!');
  }
}

@JsonSerializable()
class CategoryData {
  final int id;
  final String name;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  CategoryData({required this.id, required this.name});
  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);

  @override
  String toString() => 'CategoryData{id: $id, name: $name}';
}
