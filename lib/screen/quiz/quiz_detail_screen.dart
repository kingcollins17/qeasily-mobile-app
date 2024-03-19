// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/auth_provider.dart';
// import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/styles.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'mcq_session_screen.dart';

class QuizDetailScreen extends ConsumerStatefulWidget {
  const QuizDetailScreen({super.key, required this.data});
  final QuizData data;
  @override
  ConsumerState<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends ConsumerState<QuizDetailScreen> with Ui {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userAuthProvider);
    var instructions = getInstructions(widget.data.type);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: user.when(
                data: (data) =>
                    Text('Hi, ${data.username ?? data.email}', style: xs01),
                error: (_, __) => Center(child: Text('_')),
                loading: () =>
                    SpinKitThreeInOut(size: 15, color: Colors.white)),
          ),
          spacer(x: 18),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.title, style: medium10),
              spacer(y: 20),
              Row(
                children: [
                  Icon(Icons.question_mark, size: 20),
                  spacer(),
                  Text('${widget.data.questionsAsInt.length} Questions'),
                ],
              ),
              spacer(y: 10),
              Row(
                children: [
                  Icon(Icons.query_builder, size: 20),
                  spacer(),
                  Text(
                    '${Duration(seconds: widget.data.duration).inMinutes} Minutes',
                  ),
                ],
              ),
              spacer(y: 15),
              Text('You are about to start this quiz', style: xs01),
              spacer(y: 10),
              Text(
                  'Please read the following instructions and Tips below before you start',
                  style: mukta),
              spacer(y: 50),
              Container(
                width: maxWidth(context) * 0.96,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Ui.black01,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Instructions and Tips', style: mukta)
                        .animate(
                            autoPlay: true,
                            onInit: (controller) =>
                                controller.addListener(() async {
                                  if (controller.isCompleted) {
                                    await controller.reverse();
                                    // controller.reset();
                                  } else if (controller.isDismissed) {
                                    await controller.forward();
                                  }
                                }))
                        .shimmer(
                      colors: [Colors.white, primary],
                      duration: Duration(seconds: 1),
                    ),
                    spacer(y: 15),
                    ...List.generate(
                        instructions.length,
                        (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${index + 1}.    ${instructions[index]}',
                                  textAlign: TextAlign.left,
                                  style: mukta,
                                  softWrap: true,
                                ),
                              ),
                            )),
                  ],
                ),
              ),
              spacer(y: 15),
              FilledButton.icon(
                style: ButtonStyle(
                    fixedSize:
                        MaterialStatePropertyAll(Size(maxWidth(context), 48)),
                    backgroundColor: MaterialStatePropertyAll(primary),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  push(MCQSessionScreen(data: widget.data), context);
                },
                icon: Icon(Icons.play_arrow, size: 35, color: Colors.white),
                label: Text('Start Quiz', style: small00),
              ),
              spacer(y: 20),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> getInstructions(String type) {
  const instructions = <String>[
    'All unanswered Questions will appear grey',
    'Answered Questions will appear in  Purple',
    'Double tap on option to unpick it',
    'Tap once on an option to select it',
    'If your time runs out, you will automatically submit',
  ];
  return type == 'mcq' ? instructions : [];
}
