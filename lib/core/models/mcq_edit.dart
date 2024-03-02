import 'package:hive/hive.dart';

part 'mcq_edit.g.dart';

///
@HiveType(typeId: 10)
class MCQuestionEdit extends HiveObject {
  @HiveField(1)
  String query;

  @HiveField(2)
  String explanation;

  @HiveField(3)
  String correct;

  @HiveField(4)
  String difficulty;

  @HiveField(5)
  int? topicId;

  @HiveField(6)
  int? userId;

  MCQuestionEdit({
    this.query = '',
    this.explanation = '',
    this.correct = 'A',
    this.difficulty = 'Easy',
  });
}
