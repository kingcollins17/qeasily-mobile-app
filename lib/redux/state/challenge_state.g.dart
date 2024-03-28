// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeState _$ChallengeStateFromJson(Map<String, dynamic> json) =>
    ChallengeState(
      challenges: json['challenges'] == null
          ? const <ChallengeData>[]
          : const _DataConverter().fromJson(json['challenges'] as List),
    );

Map<String, dynamic> _$ChallengeStateToJson(ChallengeState instance) =>
    <String, dynamic>{
      'challenges': const _DataConverter().toJson(instance.challenges),
    };
