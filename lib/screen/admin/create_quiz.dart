// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/styles.dart';

class CreateQuiz extends ConsumerStatefulWidget {
  const CreateQuiz({super.key});
  @override
  ConsumerState<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends ConsumerState<CreateQuiz> with Ui {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [],
        ));
  }
}
