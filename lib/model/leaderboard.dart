import 'package:json_annotation/json_annotation.dart';

part 'leaderboard.g.dart';

@JsonSerializable()
class LeaderboardData {
  @JsonKey(name: 'challenge_id')
  final int challengeId;

  @JsonKey(name: 'user_id')
  final int userId;

  final int points, progress;

  @JsonKey(name: 'user_name')
  final String? userName;

  //
  final String email;

  factory LeaderboardData.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardDataFromJson(json);

  LeaderboardData(
      {required this.challengeId,
      required this.userId,
      required this.points,
      required this.progress,
      required this.userName,
      required this.email});
  Map<String, dynamic> toJson() => _$LeaderboardDataToJson(this);

  @override
  String toString() =>
      'LeaderboardData{userid: $userId,username: $userName, points: $points, progress: $progress}';
}
