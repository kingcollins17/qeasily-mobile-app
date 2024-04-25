import 'package:dio/dio.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<PlanData>> subPlan(SubPlanRef ref) async {
  final dio = ref.watch(generalDioProvider);
  final (status, detail, data) = await fetchPlans(dio);
  if (!status) throw detail;
  return data;
}

@JsonSerializable()
class PlanData {
  final int id;
  final String name;
  final double price;
  final List<String> features;
  final int quizzes;

  @JsonKey(name: 'admin_access')
  final bool adminAccess;

  factory PlanData.fromJson(Map<String, dynamic> json) =>
      _$PlanDataFromJson(json);

  PlanData(
      {required this.id,
      required this.name,
      required this.price,
      required this.features,
      required this.quizzes,
      required this.adminAccess});
  Map<String, dynamic> toJson() => _$PlanDataToJson(this);

  @override
  toString() => 'PlanData{id: $id, name; $name, price: $price,'
      ' features: $features, hasAdminAccess: $adminAccess}';
}

Future<(bool, String, List<PlanData>)> fetchPlans(Dio dio) async {
  try {
    final resp = await dio.get(APIUrl.fetchPlans.url);
    if (resp.statusCode == 200) {
      final {'detail': detail, 'data': data} = resp.data;
      return (
        true,
        detail.toString(),
        (data as List).map((e) => PlanData.fromJson(e)).toList()
      );
    }
    return (false, resp.data['detail'].toString(), <PlanData>[]);
    // return;
  } catch (e) {
    return (false, e.toString(), <PlanData>[]);
  }
}
