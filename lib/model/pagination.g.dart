// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageData _$PageDataFromJson(Map<String, dynamic> json) => PageData(
      page: json['page'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 10,
    );

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
    };
