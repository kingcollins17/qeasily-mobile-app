import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserData {
  final int id;

  @JsonKey(name: 'user_name')
  final String? username;
  final String email, type;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  UserData(
      {required this.id,
      required this.username,
      required this.email,
      required this.type});
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() {
    return 'UserData{id: $id, name: $username, email: $email, type: $type}';
  }
}

// @JsonSerializable()
// class ProfileData {
//   final int id;

//   @JsonKey(name: 'first_name')
//   final String firstName;

//   @JsonKey(name: 'last_name')
//   final String lastName;

//   @JsonKey(name: 'reg_no')
//   final String regNo;

//   final String department, level;

//   @JsonKey(name: 'user_id')
//   final int userId;

//   factory ProfileData.fromJson(Map<String, dynamic> json) =>
//       _$ProfileDataFromJson(json);

//   ProfileData(
//       {required this.id,
//       required this.firstName,
//       required this.lastName,
//       required this.department,
//       required this.level,
//       required this.regNo,
//       required this.userId});
//   Map<String, dynamic> toJson() => _$ProfileDataToJson(this);

//   @override
//   toString() =>
//       'ProfileData{id: $id, firstName: $firstName, lastName: $lastName, regNo: $regNo'
//       ' dept: $department, level: $level, userId: $userId}';
// }
