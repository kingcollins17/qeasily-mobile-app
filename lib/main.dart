// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/api/category.dart';
import 'package:qeasily/provider/dio_provider.dart';
// import 'package:qeasily/model/access_token.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/state/auth.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:qeasily/screen/auth.dart';
import 'package:qeasily/screen/screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/test.dart';
import 'package:redux/redux.dart';
import './widget/widget.dart';
// import 'package:flutter_ri'
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'db/db.dart';
import 'theme.dart';

void main() async {
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>('settings');

  runApp(ProviderScope(
    child: StoreProvider(
      store: store,
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (BuildContext context, Box<dynamic> value, Widget? child) =>
            MaterialApp.router(
          title: 'Qeasily ',
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          themeMode:
              value.get('darkMode') == true ? ThemeMode.dark : ThemeMode.light,
          darkTheme: AppTheme.dark,
        ),
      ),
    ),
  ));
}

final router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (context, state) => Onboarding()),
  GoRoute(path: '/sign-up', builder: (context, state) => SignupScreen()),
  GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  GoRoute(path: '/test', builder: (context, state) => TestWidget()),
  GoRoute(path: '/home', builder: (context, state) => HomeScreen())
]);

