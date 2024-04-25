// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:qeasily/redux/redux.dart';
import 'dart:math';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/redux/qeasily_state.dart';
import 'package:redux/redux.dart';
import 'app_constants.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'router.dart';
import 'theme.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox<List>(mcqDrafts);
    await Hive.openBox<List>(dcqDrafts);
    final config =
        await Hive.openBox('config'); //opens the configuration storage
    //always set has Launched to true


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
        ]);

    final appRoutes = router(config); //create the routes first
    config.put('hasLaunched', true); //now set [hasLaunched]
    runApp(ProviderScope(
      child: StoreProvider(
        store: store,
        child: MaterialApp.router(
          title: 'Qeasily ',
          routerConfig: appRoutes,
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
