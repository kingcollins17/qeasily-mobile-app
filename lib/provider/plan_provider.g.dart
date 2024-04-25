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

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subPlanHash() => r'bd0f7ea22fdc22b6d2e7e7410858d0c4fde1640a';

/// See also [subPlan].
@ProviderFor(subPlan)
final subPlanProvider = FutureProvider<List<PlanData>>.internal(
  subPlan,
  name: r'subPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$subPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubPlanRef = FutureProviderRef<List<PlanData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
