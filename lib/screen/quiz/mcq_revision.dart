// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/styles.dart';
import 'package:redux/redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MCQRevisionScreen extends ConsumerStatefulWidget {
  const MCQRevisionScreen(
      {super.key, required this.options, required this.questions});
  final List<MCQData> questions;
  final List<MCQOption?> options;
  @override
  ConsumerState<MCQRevisionScreen> createState() => _MCQRevisionState();
}

class _MCQRevisionState extends ConsumerState<MCQRevisionScreen> with Ui {
  int currentQuestionIndex = 0;

  void goToNextQuestion() => currentQuestionIndex < widget.questions.length - 1
      ? setState(() => currentQuestionIndex += 1)
      : null;

  void goToPrevious() => currentQuestionIndex > 0
      ? setState(() => currentQuestionIndex -= 1)
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revision', style: small00),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            spacer(y: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1} of ${widget.questions.length}',
                  style: mukta,
                ),
                () {
                  final correct =
                      widget.questions[currentQuestionIndex].correct ==
                          widget.options[currentQuestionIndex];
                  return Icon(correct ? Icons.check : Icons.clear,
                      size: 20, color: correct ? jungleGreen : vividOrange);
                }()
              ],
            ),
            spacer(y: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.questions[currentQuestionIndex].query,
                style: small00,
                textAlign: TextAlign.left,
              ),
            ),
            spacer(y: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Choice', style: mukta),
                  Text(
                    widget.options[currentQuestionIndex]?.name.toString() ??
                        'None',
                    style: medium10,
                  )
                ],
              ),
            ),
            spacer(y: 10),
            Container(
              constraints: BoxConstraints(minHeight: 50),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: maxWidth(context) * 0.9,
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      switch (widget.options[currentQuestionIndex]) {
                        MCQOption.A => widget.questions[currentQuestionIndex].A,
                        MCQOption.B => widget.questions[currentQuestionIndex].B,
                        MCQOption.C => widget.questions[currentQuestionIndex].C,
                        MCQOption.D => widget.questions[currentQuestionIndex].D,
                        _ => 'Not answered'
                      },
                      style: mukta)),
            ),
            spacer(y: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Correct Option', style: mukta),
                  Text(
                    widget.questions[currentQuestionIndex].correct.name
                        .toString(),
                    style: medium10,
                  )
                ],
              ),
            ),
            spacer(y: 10),
            Container(
              constraints: BoxConstraints(minHeight: 50),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: maxWidth(context) * 0.9,
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      switch (widget.questions[currentQuestionIndex].correct) {
                        MCQOption.A => widget.questions[currentQuestionIndex].A,
                        MCQOption.B => widget.questions[currentQuestionIndex].B,
                        MCQOption.C => widget.questions[currentQuestionIndex].C,
                        MCQOption.D => widget.questions[currentQuestionIndex].D,
                        // _ => 'None correct'
                      },
                      style: mukta)),
            ),
            spacer(y: 20),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Explanation', style: mukta)),
            spacer(y: 10),
            Container(
              constraints: BoxConstraints(minHeight: 50),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: maxWidth(context) * 0.9,
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.questions[currentQuestionIndex].explanation,
                    style: mukta,
                  )),
            ),
            Expanded(
              child: Material(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: goToPrevious,
                    child: direction(dir: 'left'),
                  ),
                  GestureDetector(
                    onTap: goToNextQuestion,
                    child: direction(dir: 'right'),
                  ),
                ],
              )),
            ),
            spacer(y: 20),
          ],
        ),
      ),
    );
  }
}
