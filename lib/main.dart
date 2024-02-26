// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/api/category.dart';
// import 'package:qeasily/model/access_token.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/state/auth.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/screen/auth.dart';
import 'package:qeasily/screen/screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import './widget/widget.dart';
// import 'package:flutter_ri'
// import 'db/db.dart';
import 'theme.dart';

void main() {
  Hive.initFlutter();
  runApp(ProviderScope(
    child: StoreProvider(
      store: store,
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        darkTheme: AppTheme.dark,
      ),
    ),
  ));
}

final router = GoRouter(routes: [
  GoRoute(
      path: '/',
      // builder: (context, state) => const TestWidget(),
      builder: (context, state) => Onboarding()),
  GoRoute(path: '/auth', builder: (context, state) => Authentication()),
  GoRoute(path: '/test', builder: (context, state) => TestWidget())
]);

class TestWidget extends ConsumerStatefulWidget {
  const TestWidget({super.key});

  @override
  ConsumerState<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends ConsumerState<TestWidget>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  dynamic data;
  String? response;
  late AnimationController _controller;
  LocalNotification? notification;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _notify(String message, {bool? loading}) {
    setState(() {
      notification =
          LocalNotification(animation: _controller, message: message);
    });

    return showNotification(_controller)
        .then((value) => setState(() => notification = null));
  }

  @override
  Widget build(BuildContext context) {
    // final dio = ref.watch(provider)
    return Material(
      child: StoreConnector<QeasilyState, _ViewModel>(
          converter: (store) => _ViewModel(store),
          builder: (context, vm) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          '${vm.auth}',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        Text(
                          // AccessToken(data['token']).toString(),
                          '$data',
                          style: GoogleFonts.quicksand(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          // AccessToken(data['token']).toString(),
                          vm.auth.message ?? 'No notification yet',
                          style: GoogleFonts.quicksand(fontSize: 16),
                        ),
                        FilledButton(
                          onPressed: () {
                            _notify('Hello sir');
                          },
                          child: isLoading || vm.auth.isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 1.2, color: Colors.white)
                              : Text('Test'),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (notification != null)
                //   Positioned(child: Center(child: notification!))
                if (notification != null)
                  Positioned(
                      top: 25,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: notification!))
              ],
            );
          }),
    );
  }
}

class _ViewModel {
  final Store<QeasilyState> _store;

  final AuthState auth;
  _ViewModel(Store<QeasilyState> store)
      : _store = store,
        auth = store.state.auth;

  void dispatch(QeasilyAction action) => _store.dispatch(action);
}
