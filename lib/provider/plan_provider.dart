import 'package:dio/dio.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'keys_provider.dart';

part 'plan_provider.g.dart';

// @Riverpod(keepAlive: true)
// Future<List<PlanData>> subPlan(SubPlanRef ref) async {
//   final dio = ref.watch(generalDioProvider);
//   final (status, detail, data) = await fetchPlans(dio);
//   if (!status) throw detail;
//   return data;
// }
@Riverpod(keepAlive: true)
class SubPlan extends _$SubPlan {
  @override
  Future<List<PlanData>> build() async {
    final dio = ref.watch(generalDioProvider);
    final (status, detail, data) = await fetchPlans(dio);
    if (!status) throw detail;
    return data;
  }

  Future<(bool, String, SubscriptionSessionData?)> buyPackage(
      PlanData plan) async {
    final dio = ref.read(generalDioProvider);
    return subscribe(dio, plan); //
  }

  Future<dynamic> verifyPurchase(String reference) async {
    final dio = ref.watch(generalDioProvider);
    final api = ref.watch(apiKeysProvider);
    final paystackResponse = switch (api) {
      APIKeyPair key => await verifyWithPaystack(key, reference),
      _ => null
    };
    if (paystackResponse == null) return; //
    if (paystackResponse case (final status, final message, final data!)) {
      return (data.status == 'success')
          ? forceVerify(dio, reference)
          : (false, 'Purchase was ${data.status}');
    }

    //else
  }
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

@JsonSerializable()
class SubscriptionSessionData {
  @JsonKey(name: 'authorization_url')
  final String authorizationUrl;

  @JsonKey(name: 'access_code')
  final String accessCode;

  final String reference;
  factory SubscriptionSessionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSessionDataFromJson(json);

  SubscriptionSessionData(
      {required this.authorizationUrl,
      required this.accessCode,
      required this.reference});
  Map<String, dynamic> toJson() => _$SubscriptionSessionDataToJson(this);

  @override
  toString() => 'SubscriptionSessionData{checkoutUrl: $authorizationUrl, '
      'reference: $reference, accessCode: $accessCode}';
}

@JsonSerializable()
class PaystackVerificationData {
  final int id;
  final String status, channel, currency;
  final String? message;
  final int amount;

  factory PaystackVerificationData.fromJson(Map<String, dynamic> json) =>
      _$PaystackVerificationDataFromJson(json);

  PaystackVerificationData(
      {required this.id,
      required this.status,
      required this.channel,
      required this.currency,
      required this.message,
      required this.amount});

  Map<String, dynamic> toJson() => _$PaystackVerificationDataToJson(this);

  @override
  toString() =>
      'PaystackVerificationData{id: $id, status: $status, amount: ${amount / 100},'
      ' currency: $currency, channel: $channel}';
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

Future<(bool, String, SubscriptionSessionData?)> subscribe(
    Dio dio, PlanData plan) async {
  try {
    final response = await dio
        .post(APIUrl.subscribe.url, queryParameters: {'plan_id': plan.id});
    if (response.statusCode == 200) {
      final {'detail': detail, 'status': status, 'data': data} = response.data;
      return (
        status as bool,
        detail.toString(),
        SubscriptionSessionData.fromJson(data)
      );
    }
    return (false, response.data['detail'].toString(), null);
  } catch (e) {
    return (false, e.toString(), null);
  }
}

Future<(bool, String, PaystackVerificationData?)> verifyWithPaystack(
    APIKeyPair keys, String reference) async {
  try {
    Dio client = Dio();
    final response = await client.get('$verifyUrl/$reference',
        options: Options(headers: {
          'Authorization': 'Bearer ${keys.secret}',
        }));

    final {'status': status, 'message': message, 'data': data} = response.data;
    return (
      status as bool,
      message.toString(),
      PaystackVerificationData.fromJson(data)
    );

    // return response.data;
  } catch (e) {
    return (false, e.toString(), null);
  }
}

Future<(bool, String)> forceVerify(Dio dio, String ref) async {
  try {
    final response = await dio
        .get(APIUrl.forceVerifyTransaction.url, queryParameters: {'ref': ref});
    return (response.statusCode == 200, response.data['detail'].toString());
  } catch (e) {
    return (false, e.toString());
  }
}
