// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/screen/screen.dart';
// import 'package:flutter_ri'

import 'theme.dart';

void main() {
  Hive.initFlutter().then((_) {
    runApp(MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.dark,
    ));
  });
}

final router = GoRouter(routes: [
  GoRoute(
      path: '/',
      // builder: (context, state) => const TestWidget(),
      builder: (context, state) => Onboarding()),
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
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            response ?? 'No response yet',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Text(
            data.toString(),
            style: GoogleFonts.quicksand(fontSize: 16),
          ),
          FilledButton(
              onPressed: () {},
              child: Text(
                'Test',
              )),
          // switch (response) {
          //   String(final "Hello") => SizedBox(),
          //   Null() => SizedBox(),
          // }
        ],
      ),
    );
  }
}
