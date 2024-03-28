import 'package:dio/dio.dart';
import 'package:qeasily/model/dashboard.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

@Riverpod(keepAlive: true)
Future<(String, DashboardData?)> dashboard(DashboardRef ref) async {
  final dio = ref.watch(generalDioProvider);

  final res = await dio.get(APIUrl.fetchDashboard.url);
  final {'detail': detail, 'data': data} = res.data;
  return (detail.toString(), DashboardData.fromJson(data));
}
