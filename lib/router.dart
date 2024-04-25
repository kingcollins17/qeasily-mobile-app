// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
// import 'package:qeasily/main.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/plan_provider.dart';
import 'package:qeasily/redux/redux.dart';
// import 'package:qeasily/screen/admin/admin.dart';
import 'package:qeasily/screen/admin/manage_views/views.dart';
import 'package:qeasily/screen/dashboard.dart';
import 'package:qeasily/screen/follow_creators.dart';
import 'package:qeasily/screen/quiz/dcq_revision.dart';
import 'package:qeasily/screen/quiz/mcq_revision.dart';
import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/screen/screen.dart';
import 'package:qeasily/test.dart';
import 'package:qeasily/util/create_question_util.dart';

GoRouter router(Box config) {
  bool hasLaunched = config.get('hasLaunched', defaultValue: false);
  String? token = config.get('accessToken');

  return GoRouter(
      initialLocation: hasLaunched && token != null
          ? '/home'
          : hasLaunched && token == null
              ? '/login'
              : null, //If the app has been launched and token is stored
      routes: [
        GoRoute(path: '/', builder: (context, state) => Onboarding()),
        GoRoute(path: '/sign-up', builder: (context, state) => SignupScreen()),
        GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
        GoRoute(path: '/test', builder: (context, state) => TestWidget()),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => animatePage(HomeScreen(), state),
          routes: [
            GoRoute(
              path: 'dashboard',
              pageBuilder: (context, state) =>
                  animatePage(DashboardScreen(), state),
            ),
            GoRoute(
              path: 'transactions',
              pageBuilder: (context, state) =>
                  animatePage(PendingTransactionView(), state),
            ),
            GoRoute(
              path: 'plans',
              pageBuilder: (context, state) =>
                  animatePage(SubscriptionPlanScreen(), state),
                routes: [
                  GoRoute(
                      path: 'buy-package',
                      builder: (context, state) => switch (state.extra) {
                            SubscriptionSessionData data =>
                              BuyPackageScreen(data: data),
                            _ => ErrorPage(
                                error:
                                    'SubscriptionSessionData was not provided')
                          })
                ]
            ),
            GoRoute(
                path: 'quiz-list',
                pageBuilder: (context, state) => animatePage(
                    switch (state.extra) {
                      (id: int a, isCategory: bool b) =>
                        QuizListScreen(filterId: a, isCategoryId: b),
                      _ => ErrorPage(
                          error: 'Invalid arguments ${state.extra}, '
                              'it should be ({id: a, isCategory: b})')
                    },
                    state)),
            GoRoute(
                path: 'follow',
                pageBuilder: (context, state) =>
                    animatePage(FollowCreatorScreen(), state)),
            GoRoute(
              path: 'history',
              pageBuilder: (context, state) =>
                  animatePage(SessionHistoryList(), state),
            ),
            GoRoute(
                path: 'session',
                pageBuilder: (context, state) => animatePage(
                    state.extra is QuizData
                        ? QuizOnboardScreen(data: state.extra as QuizData)
                        : ErrorPage(
                            error: 'extras object should be a QuizData object',
                          ),
                    state),
                //home/session/sub-routes
                routes: [
                  GoRoute(
                    path: 'start',
                    pageBuilder: (context, state) => animatePage(
                        switch (state.extra) {
                          QuizData(:final type) => type == 'mcq'
                              ? MCQSessionScreen(data: state.extra as QuizData)
                              : DCQSessionScreen(data: state.extra as QuizData),
                          //
                          SavedMCQSession session =>
                            MCQSessionScreen(savedSession: session),
                          SavedDCQSession sesh =>
                            DCQSessionScreen(savedDCQSession: sesh),
                          _ => ErrorPage(
                              error:
                                  'Extra should be a QuizData or SavedMCQSession')
                        },
                        state),
                  ),
                ]),
            GoRoute(
              path: 'mcq-revise',
              pageBuilder: (context, state) => animatePage(
                  switch (state.extra) {
                    (List<MCQOption?> options, List<MCQData> questions) =>
                      MCQRevisionScreen(options: options, questions: questions),
                    _ => ErrorPage(
                        error: 'extras should be a record of'
                            ' MCQOption? list and MCQData list',
                      )
                  },
                  state),
            ),
            GoRoute(
              path: 'dcq-revise',
              pageBuilder: (context, state) => animatePage(
                  switch (state.extra) {
                    (
                      questions: List<DCQData> questions,
                      choices: List<bool?> choices,
                      quiz: QuizData quiz
                    ) =>
                      DCQRevision(
                          choices: choices, questions: questions, quiz: quiz),
                    _ => ErrorPage(
                        error:
                            'Extras should be a record of questions, options and quiz',
                      )
                  },
                  state),
            )
          ],
        ),

        ///Admin
        GoRoute(
            path: '/admin',
            pageBuilder: (context, state) =>
                animatePage(AdminManageScreen(), state),
            routes: [
              GoRoute(
                path: 'view-questions',
                pageBuilder: (context, state) =>
                    animatePage(QuestionsManageView(), state),
              ),
              GoRoute(
                path: 'view-quizzes',
                pageBuilder: (context, state) =>
                    animatePage(QuizManageView(), state),
              ),
              GoRoute(
                path: 'view-topics',
                pageBuilder: (context, state) =>
                    animatePage(TopicManageView(), state),
              ),
              GoRoute(
                  path: 'drafts',
                  pageBuilder: (context, state) =>
                      animatePage(QuestionDraftScreen(), state)),
              GoRoute(
                  path: 'create-topic',
                  builder: (context, state) => CreateTopicScreen()),
              GoRoute(
                  path: 'create-question',
                  builder: (context, state) {
                    if (state.extra
                        case (List<Draft> draft, QuestionType type)) {
                      return CreateQuestionsScreen(
                          initialDraft: draft, initialType: type);
                    }
                    return CreateQuestionsScreen();
                  }),
              GoRoute(
                path: 'create-quiz',
                pageBuilder: (context, state) =>
                    animatePage(CreateQuizScreen(), state),
              )
            ])
      ]);
}

//
CustomTransitionPage<dynamic> animatePage(Widget child, GoRouterState state,
    {Duration? duration}) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: duration ?? Duration(milliseconds: 300),
    reverseTransitionDuration: Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child),
  );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.error});
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('An error has occurred'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          Text(error.toString()),
          SizedBox(height: 40),
          FilledButton(
              onPressed: () {
                context.go('/home');
              },
              child: Text('Go to /home'))
        ]),
      ),
    );
  }
}
