// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/screen/quiz/dcq_session_screen.dart';
import 'package:qeasily/screen/quiz/util/onboard_util.dart';
// import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/styles.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../widget/widget.dart';
import 'mcq_session_screen.dart';

class QuizOnboardScreen extends ConsumerStatefulWidget {
  const QuizOnboardScreen({super.key, required this.data});
  final QuizData data;
  @override
  ConsumerState<QuizOnboardScreen> createState() => _QuizOnboardScreenState();
}

class _QuizOnboardScreenState extends ConsumerState<QuizOnboardScreen>
    with Ui, SingleTickerProviderStateMixin {
  late QuizOnboardState onboardState;

  LocalNotification? notification;
  String? rawNotification;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    onboardState = switch (widget.data.type) {
      'mcq' => MCQOnboardState(quiz: widget.data),
      'dcq' => DCQOnboardState(quiz: widget.data),
      _ => MCQOnboardState(quiz: widget.data)
    };
  }

  Future<void> _notify(String message, {int delay = 4}) async {
    setState(() {
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller, delay);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userAuthProvider);
    // var instructions = getInstructions(widget.data.type);
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          actions: [
            spacer(x: 18),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(onboardState.title, style: medium10),
                spacer(y: 20),
                Row(
                  children: [
                    Icon(Icons.question_mark, size: 20),
                    spacer(),
                    Text(
                        '${onboardState.quiz.questionsAsInt.length} Questions'),
                  ],
                ),
                spacer(y: 10),
                Row(
                  children: [
                    Icon(Icons.query_builder, size: 20),
                    spacer(),
                    Text(
                      '${Duration(seconds: onboardState.quiz.duration).inMinutes} Minutes',
                    ),
                  ],
                ),
                spacer(y: 15),
                Text('You are about to start this quiz', style: xs01),
                spacer(y: 10),
                Text(
                    'Please read the following instructions and Tips below before you start',
                    style: mukta),
                spacer(y: 20),
                GestureDetector(
                  onTap: () {
                    rawNotification = 'Whats wrong with the quiz now!';
                    _notify('Consumed quiz');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      onboardState.label,
                      style: mukta,
                    ),
                  ),
                ),
                spacer(y: 10),
                Container(
                  width: maxWidth(context) * 0.92,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: raisingBlack,
                    borderRadius: BorderRadius.circular(6),
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
                        colors: [Colors.white, jungleGreen],
                        duration: Duration(seconds: 1),
                      ),
                      spacer(y: 15),
                      ...List.generate(
                          onboardState.instructions.length,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${index + 1}.    ${onboardState.instructions[index]}',
                                    textAlign: TextAlign.left,
                                    style: mukta,
                                    softWrap: true,
                                  ),
                                ),
                              )),
                    ],
                  ),
                ),
                spacer(),
                // FutureBuilder(
                //   future: consumeQuiz(ref.read(generalDioProvider)),
                //   builder: (context, snapshot) =>
                //       Text(snapshot.data.toString(), style: medium00),
                // ),
                spacer(y: 15),
                FilledButton.icon(
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStatePropertyAll(Size(maxWidth(context), 48)),
                      backgroundColor: MaterialStatePropertyAll(jungleGreen),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () async {
                    final (consumed, msg) = await consumeQuiz(
                      ref.read(generalDioProvider),
                    );
                    setState(() => rawNotification = msg); //notify
                    //
                    if (consumed) {
                      _notify('Preparing questions ...');
                      Future.delayed(Duration(seconds: 2), () {
                        context.go(
                          '/home/session/start',
                          extra: widget.data,
                        );
                      });
                    }
                  },
                  icon: Icon(Icons.play_arrow, size: 35, color: Colors.white),
                  label: Text('Start Quiz', style: small00),
                ),
                spacer(y: 20),
              ],
            ),
          ),
        ),
      ),
      if (rawNotification != null)
        Positioned(
            bottom: 20,
            child: StoreNotification(
              message: rawNotification,
              closer: () => setState(() => rawNotification = null),
            ))
    ], notification);
  }
}

Future<(bool, String)> consumeQuiz(Dio dio) async {
  try {
    final response = await dio.get(APIUrl.consumerQuiz.url);
    return (response.statusCode == 200, response.data['detail'].toString());
  } catch (e) {
    return (false, e.toString());
  }
}
