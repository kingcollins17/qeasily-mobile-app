// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardData _$LeaderboardDataFromJson(Map<String, dynamic> json) =>
    LeaderboardData(
      challengeId: json['challenge_id'] as int,
      userId: json['user_id'] as int,
      points: json['points'] as int,
      progress: json['progress'] as int,
      userName: json['user_name'] as String?,
      email: json['email'] as String,
    );

Map<String, dynamic> _$LeaderboardDataToJson(LeaderboardData instance) =>
    <String, dynamic>{
      'challenge_id': instance.challengeId,
      'user_id': instance.userId,
      'points': instance.points,
      'progress': instance.progress,
      'user_name': instance.userName,
      'email': instance.email,
    };
