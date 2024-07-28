import 'package:dio/dio.dart';
import 'package:qeasily/model/pagination.dart';
import 'package:qeasily/provider/base.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:json_annotation/json_annotation.dart';

part 'transactions.g.dart';

@riverpod
class PendingTranx extends _$PendingTranx implements NextPageFetcher {
  @override
  Future<List<PendingTransactionData>> build() async {
    final dio = ref.watch(generalDioProvider);
    final (status, msg, data) = await fetchPendingTranxt(
      dio,
      PageData(page: 1, perPage: 100),
    );
    if (!status) throw msg;

    return (data);
  }

  @override
  Future<(bool, String)> fetchNextPage() {
    // TODO: implement fetchNextPage
    throw UnimplementedError();
  }
}

@JsonSerializable()
class PendingTransactionData {
  final int id;
  final String plan, reference, status;

  @JsonKey(name: 'access_code')
  final String accessCode;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  factory PendingTransactionData.fromJson(Map<String, dynamic> json) =>
      _$PendingTransactionDataFromJson(json);

  PendingTransactionData(
      {required this.id,
      required this.plan,
      required this.reference,
      required this.status,
      required this.accessCode,
      required this.createdAt});
  Map<String, dynamic> toJson() => _$PendingTransactionDataToJson(this);

  @override
  toString() =>
      'PendingTransactionData{plan: $plan, reference: $reference, createdAt: $createdAt}';
}

Future<(bool, String, List<PendingTransactionData>)> fetchPendingTranxt(
    Dio dio, PageData page) async {
  try {
    final response =
        await dio.get(APIUrl.pendingTransactions.url, data: page.toJson());
    if (response.statusCode == 200) {
      final {'detail': detail, 'data': data} = response.data;
      return (
        true,
        detail.toString(),
        (data as List).map((e) => PendingTransactionData.fromJson(e)).toList()
      );
    }
    return (
      false,
      response.data['detail'].toString(),
      <PendingTransactionData>[]
    );
  } catch (e) {
    return (false, e.toString(), <PendingTransactionData>[]);
  }
}
