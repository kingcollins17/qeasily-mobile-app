// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/screen/quiz/mcq_revision.dart';
// import 'package:qeasily/screen/quiz/mcq_session_screen.dart';
import 'package:qeasily/styles.dart';

class ResultScreen extends StatelessWidget with Ui {
  ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.attempted,
    required this.incorrect,
  });
  final int score, total, attempted, incorrect;

  @override
  Widget build(BuildContext context) {
    // var (score, total, attempted, incorrect) = markMCQQuiz(mcqs, options);

    final halfW = maxWidth(context) * 0.45;
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: maxWidth(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              spacer(y: 15),
              Container(
                width: halfW,
                height: halfW,
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: jungleGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 100),
              ),
              spacer(y: 15),
              Text(
                'Congratulations',
                style: medium00,
              ),
              Text(
                'You have completed the quiz',
                style: rubik,
              ),
              spacer(y: 20),
              // spacer(y: 10),
              SizedBox(
                width: maxWidth(context) * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Results', style: xs01),
                    Container(
                      decoration: BoxDecoration(),
                    ),
                    spacer(y: 15),
                    Wrap(
                      runSpacing: 6,
                      spacing: 4,
                      children: [
                        _board(
                          context,
                          label: 'score',
                          value:
                              '${((score / total) * 100).toStringAsFixed(2)} %',
                        ),
                        _board(context,
                            label: 'Attempted ', value: '$attempted'),
                        _board(context,
                            label: 'Total Questions', value: '$total'),
                        _board(context, label: 'Incorrect', value: '$incorrect')
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Ink(
                        height: 48,
                        width: maxWidth(context) * 0.9,
                        decoration: BoxDecoration(
                          color: jungleGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child:
                            Center(child: Text('See revision', style: small00)),
                      ),
                    )),
              ),
              spacer(y: 15),
            ],
          ),
        ),
      ),
    );
  }

  Container _board(BuildContext context,
      {required String label, required String value}) {
    return Container(
      width: maxWidth(context) * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      // height: 80,
      decoration: BoxDecoration(
        color: raisingBlack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: mukta),
          Text(value, style: medium10),
          // spacer(y: 10),
        ],
      ),
    );
  }
}

({int score, int total, int attempted, int incorrect}) markMCQQuiz(
    List<MCQData> questions, List<MCQOption?> choices) {
  var score = 0;
  // var correct = 0;
  var attempted = 0;
  for (var i = 0; i < questions.length; i++) {
    if (questions[i].correct == choices[i]) {
      score += 1;
    }
    attempted += choices[i] != null ? 1 : 0;
  }
  return (
    score: score,
    total: questions.length,
    attempted: attempted,
    incorrect: questions.length - score
  );
}
