// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesHash() => r'405aabd942492b0b76c541ff3ea38448bfe92d97';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider = FutureProvider<List<CategoryData>>.internal(
  categories,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CategoriesRef = FutureProviderRef<List<CategoryData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
