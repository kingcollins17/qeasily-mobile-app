// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/api/auth.dart';
// import 'package:qeasily/model/access_token.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/redux/redux.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/screen/auth.dart';
import 'package:qeasily/screen/screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  bool isLoading = false;
  dynamic data;
  String? response;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                response ?? 'No response yet',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              Text(
                // AccessToken(data['token']).toString(),
                '$data',
                style: GoogleFonts.quicksand(fontSize: 16),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });

                  AuthAPI.login(
                          Dio(BaseOptions(validateStatus: (status) => true)))
                      .then((value) => setState(() {
                            isLoading = false;
                            data = value;
                            response = value.toString();
                          }));
                },
                child: isLoading
                    ? CircularProgressIndicator(
                        strokeWidth: 1.2, color: Colors.white)
                    : Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
