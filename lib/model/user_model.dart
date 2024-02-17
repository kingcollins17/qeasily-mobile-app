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
