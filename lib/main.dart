// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/screen/sub/dashboard.dart';
import 'package:qeasily/screen/sub/follow_creators.dart';

import 'package:qeasily/screen/screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/test.dart';

import 'theme.dart';

void main() async {
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>('settings');

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

  // GoRoute(path: '/quiz', routes: [
  //   GoRoute(
  //     path: '',
  //     pageBuilder: (context, state) => animatePage(QuizDetailScreen(), state),
  //   ),
  //   GoRoute(
  //     path: '/session',
  //     pageBuilder: (context, state) => animatePage(QuizSessionScreen(), state),
  //   )
  // ])

  // GoRoute(path: '/home')
]);

//
CustomTransitionPage<dynamic> animatePage(Widget child, GoRouterState state,
    {Duration? duration}) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: duration ?? Duration(milliseconds: 700),
    reverseTransitionDuration: Duration(milliseconds: 500),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child),
  );
}
