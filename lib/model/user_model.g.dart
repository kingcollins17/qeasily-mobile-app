// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as int,
      username: json['user_name'] as String?,
      email: json['email'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'user_name': instance.username,
      'email': instance.email,
      'type': instance.type,
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      department: json['department'] as String,
      level: json['level'] as String,
      regNo: json['reg_no'] as String,
      userId: json['user_id'] as int,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'reg_no': instance.regNo,
      'department': instance.department,
      'level': instance.level,
      'user_id': instance.userId,
    };
