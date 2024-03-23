// import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/reducers/reducers.dart';
import 'package:qeasily/redux/state/search_state.dart';

import 'state/challenge_state.dart';
import 'package:json_annotation/json_annotation.dart';
import 'state/topic_state.dart';
import 'state/quiz_state.dart';

part 'state.g.dart';

@JsonSerializable()
class QeasilyState {
  @_TopicStateConverter()
  TopicState topics;

  @_QuizStateConverter()
  QuizState quizzes;

  @_ChallengeStateConverter()
  ChallengeState challenges;

  SearchState search;

  QeasilyState(
      {TopicState? topics,
      QuizState? quizzes,
      ChallengeState? challenges,
      SearchState? search})
      : topics = topics ?? TopicState(),
        quizzes = quizzes ?? QuizState(),
        challenges = challenges ?? ChallengeState(),
        search = search ?? SearchState();

  factory QeasilyState.fromJson(dynamic json) => _$QeasilyStateFromJson(json);

  Map<String, dynamic> toJson() => _$QeasilyStateToJson(this);
}

class _TopicStateConverter
    extends JsonConverter<TopicState, Map<String, dynamic>> {
  const _TopicStateConverter();
  @override
  TopicState fromJson(Map<String, dynamic> json) => TopicState.fromJson(json);

  @override
  Map<String, dynamic> toJson(TopicState object) => object.toJson();
}

class _QuizStateConverter
    extends JsonConverter<QuizState, Map<String, dynamic>> {
  const _QuizStateConverter();
  @override
  QuizState fromJson(Map<String, dynamic> json) => QuizState.fromJson(json);

  @override
  Map<String, dynamic> toJson(QuizState object) => object.toJson();
}

class _ChallengeStateConverter
    extends JsonConverter<ChallengeState, Map<String, dynamic>> {
  const _ChallengeStateConverter();
  @override
  ChallengeState fromJson(Map<String, dynamic> json) =>
      ChallengeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ChallengeState object) => object.toJson();
}

//
QeasilyState appReducer(QeasilyState state, action) {
  state
    ..topics = topicReducer(state.topics, action)
    ..quizzes = quizReducer(state.quizzes, action)
    ..challenges = chgReducer(state.challenges, action)
    ..search = searchReducer(state.search, action);

  return state;
}
