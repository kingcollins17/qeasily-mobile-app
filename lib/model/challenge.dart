// ignore_for_file: unnecessary_this

import 'package:json_annotation/json_annotation.dart';

part 'challenge.g.dart';

@JsonSerializable()
class ChallengeData {
  final int id;
  final String name;
  final String quizzes;

  @CustomConverter()
  final bool paid;

  final double reward;

  @JsonKey(name: 'entry_fee')
  final double entryFee;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'date_added')
  final DateTime dateAdded;

  final int duration;

  Duration get endsIn =>
      dateAdded.add(Duration(days: duration)).difference(DateTime.now());

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

  @override
  bool operator ==(Object other) {
    return (other is ChallengeData &&
            (id == other.id) &&
            (name == other.name)) ||
        identical(this, other);
  }

  @override
  int get hashCode =>
      (this.id.hashCode ^ this.duration.hashCode ^ this.name.hashCode);
}

class CustomConverter extends JsonConverter<bool, int> {
  const CustomConverter();
  @override
  fromJson(json) {
    return json == 1;
  }

  @override
  toJson(object) {
    return object ? 1 : 0;
  }
}
