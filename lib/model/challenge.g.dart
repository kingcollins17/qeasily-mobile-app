// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeData _$ChallengeDataFromJson(Map<String, dynamic> json) =>
    ChallengeData(
      id: json['id'] as int,
      name: json['name'] as String,
      quizzes: json['quizzes'] as String,
      paid: const CustomConverter().fromJson(json['paid'] as int),
      reward: (json['reward'] as num).toDouble(),
      userId: json['user_id'] as int,
      dateAdded: DateTime.parse(json['date_added'] as String),
      entryFee: (json['entry_fee'] as num).toDouble(),
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$ChallengeDataToJson(ChallengeData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quizzes': instance.quizzes,
      'paid': const CustomConverter().toJson(instance.paid),
      'reward': instance.reward,
      'entry_fee': instance.entryFee,
      'user_id': instance.userId,
      'date_added': instance.dateAdded.toIso8601String(),
      'duration': instance.duration,
    };
