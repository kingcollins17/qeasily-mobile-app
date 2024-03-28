// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/util/create_question_util.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/screen/admin/admin.dart';
import 'package:qeasily/screen/dashboard.dart';
import 'package:qeasily/screen/follow_creators.dart';
import 'dart:math';

import 'package:qeasily/screen/screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/test.dart';
import 'package:qeasily/redux/qeasily_state.dart';
import 'package:redux/redux.dart';
import 'app_constants.dart';
import 'redux/mware/mware.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'theme.dart';

void main() async {
  try {
   
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox<List>(mcqDrafts);
    await Hive.openBox<List>(dcqDrafts);

    final persistor = Persistor(
        storage: FlutterStorage(),
        serializer: JsonSerializer<QeasilyState>(QeasilyState.fromJson),
        throttleDuration: Duration(seconds: 5));

    final store = Store(appReducer,
        initialState:
            (await persistor.load().catchError((e) => null)) ?? QeasilyState(),
        middleware: [
          thunkMiddleware,
          persistor.createMiddleware(),
          topicMware,
          quizMware,
          chgMware,
        ]);

    runApp(ProviderScope(
      child: StoreProvider(
        store: store,
        child: MaterialApp.router(
          title: 'Qeasily ',
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          darkTheme: AppTheme.dark,
        ),
      ),
    ));
  } catch (e) {
    // final msg = StackTrace.current;
    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exception thrown before run'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                Text(e.toString()),
                Text(Random(3).nextDouble().toStringAsFixed(2))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

final router = GoRouter(routes: [
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
            path: 'follow',
            pageBuilder: (context, state) =>
                animatePage(FollowCreatorScreen(), state)),
      ]),
  GoRoute(
    path: '/admin',
    pageBuilder: (context, state) => animatePage(AdminManageScreen(), state),
      routes: [
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
              if (state.extra case (List<Draft> draft, QuestionType type)) {
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
      ]
  )
]);

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
