import 'package:json_annotation/json_annotation.dart';

part 'challenge.g.dart';

@JsonSerializable()
class ChallengeData {
  final int id;
  final String name;
  final String quizzes;

  final bool paid;
  final double reward;

  @JsonKey(name: 'entry_fee')
  final double entryFee;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'date_added')
  final DateTime dateAdded;

  final int duration;

  factory ChallengeData.fromJson(Map<String, dynamic> json) =>
      _$ChallengeDataFromJson(json);

  ChallengeData(
      {required this.id,
      required this.name,
      required this.quizzes,
      required this.paid,
      required this.reward,
      required this.userId,
      required this.dateAdded,
      required this.entryFee,
      required this.duration});
  Map<String, dynamic> toJson() => _$ChallengeDataToJson(this);

  @override
  String toString() =>
      'ChallengeData{id: $id, name: $name, duration: $duration '
      'days, paid: $paid, reward: $reward, userId: $userId}';
}
