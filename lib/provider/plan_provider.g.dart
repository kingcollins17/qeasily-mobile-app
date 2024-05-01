// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanData _$PlanDataFromJson(Map<String, dynamic> json) => PlanData(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      quizzes: json['quizzes'] as int,
      adminAccess: json['admin_access'] as bool,
    );

Map<String, dynamic> _$PlanDataToJson(PlanData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'features': instance.features,
      'quizzes': instance.quizzes,
      'admin_access': instance.adminAccess,
    };

SubscriptionSessionData _$SubscriptionSessionDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionSessionData(
      authorizationUrl: json['authorization_url'] as String,
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$SubscriptionSessionDataToJson(
        SubscriptionSessionData instance) =>
    <String, dynamic>{
      'authorization_url': instance.authorizationUrl,
      'access_code': instance.accessCode,
      'reference': instance.reference,
    };

PaystackVerificationData _$PaystackVerificationDataFromJson(
        Map<String, dynamic> json) =>
    PaystackVerificationData(
      id: json['id'] as int,
      status: json['status'] as String,
      channel: json['channel'] as String,
      currency: json['currency'] as String,
      message: json['message'] as String?,
      amount: json['amount'] as int,
    );

Map<String, dynamic> _$PaystackVerificationDataToJson(
        PaystackVerificationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'channel': instance.channel,
      'currency': instance.currency,
      'message': instance.message,
      'amount': instance.amount,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subPlanHash() => r'2153a1d5437f896259950379d0cfa2cae9ae1f9f';

/// See also [SubPlan].
@ProviderFor(SubPlan)
final subPlanProvider = AsyncNotifierProvider<SubPlan, List<PlanData>>.internal(
  SubPlan.new,
  name: r'subPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$subPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubPlan = AsyncNotifier<List<PlanData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
