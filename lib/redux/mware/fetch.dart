// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:redux/redux.dart';

dynamic topicMware(Store<QeasilyState> store, action, NextDispatcher next) {
  bool shouldCallNext = true;
  if (action is TopicAction) {
    switch (action.type) {
      case TopicActionType.fetch:
        shouldCallNext = store.state.topics.page.hasNextPage;
        if (action.payload is Dio && store.state.topics.page.hasNextPage) {
          fetchTopics(
            action.payload as Dio,
            store.state.topics.page..next(),
            categoryId: store.state.topics.categoryId,
          ).then((value) => store.dispatch(
                TopicAction(type: TopicActionType.update, payload: value),
              ));
        }
        break;

      default:
        break;
    }
  }
  if (shouldCallNext) next(action);
}

dynamic quizMware(Store<QeasilyState> store, action, NextDispatcher next) {
  bool shouldCallNext = true;
  if (action is QuizAction) {
    switch (action.type) {
      case QuizActionType.fetch:
        shouldCallNext = store.state.quizzes.page.hasNextPage;
        //
        if (action.payload is Dio && store.state.quizzes.page.hasNextPage) {
          fetchQuizzes(action.payload as Dio,
                  page: store.state.quizzes.page..next())
              .then((response) => store.dispatch(
                    QuizAction(type: QuizActionType.update, payload: response),
                  ));
        }
        break;
      default:
        break;
    }
  }
  if (shouldCallNext) next(action);
}

dynamic chgMware(Store<QeasilyState> store, action, NextDispatcher next) {
  bool shouldCallNext = true;
  if (action is ChallengeAction) {
    switch (action.type) {
      case ChgActionType.fetch:
        shouldCallNext = store.state.challenges.page.hasNextPage;
        if (action.payload is Dio && store.state.challenges.page.hasNextPage) {
          fetchChallenges(
                  action.payload as Dio, store.state.challenges.page..next())
              .then(
            (value) => store.dispatch(
                ChallengeAction(type: ChgActionType.update, payload: value)),
          );
        }
        break;
      default:
        break;
    }
  }
  if (shouldCallNext) next(action);
}
