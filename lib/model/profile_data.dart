import 'package:json_annotation/json_annotation.dart';

part 'profile_data.g.dart';

@JsonSerializable()
class ProfileData {
  final int id;

  @JsonKey(name: 'user_name')
  final String userName;

  final String department, level;
  final int followers, topics;

  @JsonKey(name: 'total_quiz')
  final int totalQuiz;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  ProfileData(
      {required this.id,
      required this.userName,
      required this.department,
      required this.level,
      required this.followers,
      required this.topics,
      required this.totalQuiz});
  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);

  @override
  toString() =>
      'FollowAccountData{id: $id, username: $userName, followers: $followers,'
      ' topics: $topics, totalQuiz: $totalQuiz, department: $department}';
}
