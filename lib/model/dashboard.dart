import 'package:json_annotation/json_annotation.dart';

part 'dashboard.g.dart';

@JsonSerializable()
class DashboardData {
  final int id;
  final String department, level, plan, email;

  final int followers, following, topics;

  @JsonKey(name: 'quizzes_left')
  final int quizzesLeft;

  @JsonKey(name: 'total_quiz')
  final int totalQuiz;

  @JsonKey(name: 'total_mcqs')
  final int totalMcqs;

  @JsonKey(name: 'total_dcqs')
  final int totalDcqs;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  const DashboardData(
      {required this.id,
      required this.department,
      required this.level,
      required this.plan,
      required this.email,
      required this.followers,
      required this.following,
      required this.quizzesLeft,
      required this.topics,
      required this.totalQuiz,
      required this.totalMcqs,
      required this.totalDcqs});
  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);

  @override
  toString() =>
      '{id: $id, email: $email, deparment: $department, level: $level, currentPlan: $plan'
      ' totalTopics: $topics, totalQuiz: $totalQuiz, totalMCQS: $totalMcqs,'
      'quizzesLeft: $quizzesLeft'
      ' totalDCQS: $totalDcqs, followers: $followers, following: $following}';
}
