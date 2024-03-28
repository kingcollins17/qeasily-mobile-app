import 'package:json_annotation/json_annotation.dart';

part 'quiz.g.dart';

@JsonSerializable()
class QuizData {
  final int id;
  final String title, questions, description, difficulty, type, creator, topic;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'topic_id')
  final int topicId;

  final int duration;

  @JsonKey(name: 'date_added')
  final DateTime dateAdded;

  List<int> get questionsAsInt => parseQuestions(questions);

  factory QuizData.fromJson(Map<String, dynamic> json) =>
      _$QuizDataFromJson(json);

  QuizData(
      {required this.id,
      required this.title,
      required this.questions,
      required this.userId,
      required this.topicId,
      required this.duration,
      required this.dateAdded,
      required this.description,
      required this.difficulty,
    required this.type,
    required this.topic,
    required this.creator,
  });
  Map<String, dynamic> toJson() => _$QuizDataToJson(this);

  @override
  bool operator ==(covariant QuizData other) =>
      identical(this, other) ||
      (id == other.id && title == other.title && dateAdded == other.dateAdded);

  @override
  toString() =>
      'QuizData{id: $id, title: $title, type: $type, duration: $duration'
      ' seconds, description: $description, questions: $questions, difficulty: $difficulty,'
      ' topicId: $topicId, userId: $userId}';

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;
}

List<int> parseQuestions(String questions) {
  final temp = questions.replaceFirst('[', '').replaceFirst(']', '').split(',');

  return temp.map((e) => int.parse(e)).toList();
}
