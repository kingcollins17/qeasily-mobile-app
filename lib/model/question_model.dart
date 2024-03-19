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
      required this.userId});
  Map<String, dynamic> toJson() => _$MCQDataToJson(this);

  @override
  String toString() => 'MCQData{id: $int, query: $query, correct:'
      ' ${correct.name}, A: $A, B: $B, C: $C, D: $D}';
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
