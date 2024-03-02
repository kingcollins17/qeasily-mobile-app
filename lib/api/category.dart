import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import '_base.dart' as cfg;

part 'category.g.dart';

class CategoryAPI {
  static Future<({List<CategoryData>? data, bool status, String detail})>
      categories(Dio dio) async {
    try {
      final response = await dio.get(
        Uri.http(cfg.domain, '/categories').toString(),
        // options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      return (
        data: (response.data['data'] as List<dynamic>?)
            ?.map((e) => CategoryData.fromJson(e))
            .toList(),
        status: response.statusCode == 200,
        detail: response.statusCode == 200
            ? 'Categories fetched'
            : response.data['detail'].toString()
      );
    } catch (e) {
      return (data: null, status: false, detail: e.runtimeType.toString());
    }
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
