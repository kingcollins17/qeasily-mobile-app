// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/styles.dart';

class DCQRevision extends ConsumerStatefulWidget {
  const DCQRevision(
      {super.key,
      required this.choices,
      required this.questions,
      required this.quiz});
  final List<DCQData> questions;
  final List<bool?> choices;
  final QuizData quiz;
  @override
  ConsumerState<DCQRevision> createState() => _DCQRevisionState();
}

class _DCQRevisionState extends ConsumerState<DCQRevision> with Ui {
  int currentQuestionIndex = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.quiz.title} Revision', style: medium00),
      ),
      body: stackWithNotifier(
        // crossAxisAlignment: CrossAxisAlignment.start,
        [
          SizedBox(
            // decoration: BoxDecoration(color: woodSmoke, borderRadius: BordeR),
            height: maxHeight(context) * 0.7,
            child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) =>
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {
                        currentQuestionIndex = value;
                      });
                    }),
                itemCount: widget.questions.length,
                itemBuilder: (context, index) => _revision(index)),
          ),
          Positioned(
              // bottom: 0,
              child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => currentQuestionIndex > 0
                          ? pageController.animateToPage(
                              currentQuestionIndex - 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            )
                          : null,
                      child: direction(dir: 'left')),
                  GestureDetector(
                      onTap: () =>
                          currentQuestionIndex < widget.questions.length - 1
                              ? pageController.animateToPage(
                                  currentQuestionIndex + 1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut)
                              : null,
                      child: direction(dir: 'right'))
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _revision(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
            color: woodSmoke, borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(y: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions ${index + 1} of ${widget.choices.length}',
                  style: xs00,
                ),
               
                () {
                  final crt =
                      widget.questions[index].correct == widget.choices[index];
                  return Icon(crt ? Icons.check : Icons.clear,
                      size: 22, color: crt ? jungleGreen : vividOrange);
                }()
              ],
            ),
            spacer(y: 20),
            Text(widget.questions[index].query, style: small00),
            spacer(y: 15),
            spacer(y: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Option', style: small00),
                Text(
                    widget.choices[index]?.toString().toUpperCase() ??
                        'Unanswered',
                    style: medium10),
              ],
            ),
            spacer(y: 22),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  color: raisingBlack,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        color: Color(0x52000000),
                        offset: Offset(2, 4))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Correct Option', style: small00),
                  Text(widget.questions[index].correct.toString().toUpperCase(),
                      style: medium10),
                ],
              ),
            ),
            spacer(y: 20),
            Text('Explanation', style: mukta),
            spacer(y: 12),
            Container(
              width: maxWidth(context),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.questions[index].explanation,
                style: small00,
              ),
            ),
            spacer(y: 10),
          ],
        ),
      ),
    );
  }
}
