// import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/reducers/reducers.dart';
import 'package:qeasily/redux/state/quiz_session.dart';
import 'package:qeasily/redux/state/search_state.dart';

import 'package:json_annotation/json_annotation.dart';

import 'state/topic_state.dart';
import 'state/quiz_state.dart';

part 'qeasily_state.g.dart';

@JsonSerializable()
class QeasilyState {
  @JsonKey(includeFromJson: false, includeToJson: false)
  TopicDataState topics;

  @JsonKey(includeFromJson: false, includeToJson: false)
  QuizDataState quizzes;

  ///search history
  SearchHistoryState search;

  @JsonKey(includeFromJson: false, includeToJson: false)
  QuizSession session;

  SessionHistory sessionHistory;

  QeasilyState(
      {TopicDataState? topics,
      QuizDataState? quizzes,
      SearchHistoryState? search,
      SessionHistory? history})
      : topics = topics ?? TopicDataState(),
        quizzes = quizzes ?? QuizDataState(),
        search = search ?? SearchHistoryState(),
        sessionHistory = history ?? SessionHistory(),
        session = QuizSession();

  factory QeasilyState.fromJson(dynamic json) => _$QeasilyStateFromJson(json);

  Map<String, dynamic> toJson() => _$QeasilyStateToJson(this);
}

//
QeasilyState appReducer(QeasilyState state, action) {
  state
    ..topics = topicReducer(state.topics, action)
    ..quizzes = quizReducer(state.quizzes, action)
    ..search = searchReducer(state.search, action)
    ..session = sessionReducer(state.session, action)
    ..sessionHistory = sessionHistoryReducer(state.sessionHistory, action);

  return state;
}
