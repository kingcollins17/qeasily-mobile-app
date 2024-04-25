// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'question_model.g.dart';




@JsonSerializable()
class MCQData {
  final int id;

  final String query;
  final String A, B, C, D, explanation;

  final MCQOption correct;

  @JsonKey(name: 'topic_id')
  final int topicId;

  @JsonKey(name: 'topic')
  final String? topicTitle;

  @JsonKey(name: 'user_id')
  final int userId;

  factory MCQData.fromJson(Map<String, dynamic> json) =>
      _$MCQDataFromJson(json);

  MCQData(
      {required this.id,
      required this.query,
      required this.A,
      required this.B,
      required this.C,
      required this.D,
      required this.explanation,
      required this.correct,
      required this.topicId,
      this.topicTitle,
      required this.userId});
  Map<String, dynamic> toJson() => _$MCQDataToJson(this);

  @override
  String toString() => 'MCQData{id: $id, query: $query, correct:'
      ' ${correct.name}, A: $A, B: $B, C: $C, D: $D, topicId: $topicId}';
}

enum MCQOption {
  A,
  B,
  C,
  D;

  static MCQOption? convert(int index) => optionMap[index];
}

const optionMap = {
  0: MCQOption.A,
  1: MCQOption.B,
  2: MCQOption.C,
  3: MCQOption.D
};

@JsonSerializable()
class DCQData {
  final int id;
  final String query;
  final String explanation;

  @_CorrectOptionConverter()
  final bool correct;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'topic_id')
  final int topicId;

  @JsonKey(name: 'topic')
  final String? topicTitle;

  factory DCQData.fromJson(Map<String, dynamic> json) =>
      _$DCQDataFromJson(json);

  DCQData(
      {required this.id,
      required this.query,
      required this.explanation,
      required this.correct,
      required this.userId,
      required this.topicId,
      this.topicTitle});
  Map<String, dynamic> toJson() => _$DCQDataToJson(this);

  @override
  String toString() =>
      'DCQData {id: $id, query: $query, explanation: $explanation, topic: $topicTitle'
      ' correct: $correct, userId: $userId, topicId: $topicId}';
}

class _CorrectOptionConverter extends JsonConverter<bool, int> {
  const _CorrectOptionConverter();
  @override
  fromJson(json) => switch (json) { 1 => true, _ => false };

  @override
  toJson(object) => object ? 1 : 0;
}
