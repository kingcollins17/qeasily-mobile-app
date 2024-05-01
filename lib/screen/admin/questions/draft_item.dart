// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';

class MCQDraftItem extends StatelessWidget with Ui {
  MCQDraftItem({super.key, required this.data});
  final MCQDraft data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll(raisingBlack),
      onTap: () => push(MCQDraftItemDetail(data: data), context),
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration:
                  BoxDecoration(color: raisingBlack, shape: BoxShape.circle),
              child: Icon(Icons.question_mark, size: 20, color: athensGray),
            ),
            spacer(x: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.query ?? 'No query yet', style: small00),
                spacer(),
                Text(
                  'Correct Option: ${data.correct?.name}',
                  style: small00.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MCQDraftItemDetail extends StatelessWidget with Ui {
  MCQDraftItemDetail({super.key, required this.data});
  final MCQDraft data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(y: 15),
            Text('Question', style: small00),
            spacer(y: 10),
            Container(
                width: maxWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: raisingBlack,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(data.query.toString(), style: small00)),
            spacer(y: 20),
            Text('Options', style: mukta),
            spacer(y: 10),
            Text('A. ${data.A ?? 'No Option'}', style: small00),
            spacer(y: 10),
            Text('B. ${data.B ?? 'No Option'}', style: small00),
            spacer(y: 10),
            Text('C. ${data.C ?? 'No Option'}', style: small00),
            spacer(y: 10),
            Text('D. ${data.D ?? 'No Option'}', style: small00),
            spacer(y: 25),
            Text('Correct Option', style: mukta),
            spacer(y: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              width: maxWidth(context),
              child:
                  Text(data.correct?.name ?? 'Not Choosen yet', style: small00),
            ),
            spacer(y: 10),
            Text('Explanation', style: mukta),
            spacer(y: 10),
            Text(data.explanation ?? 'No explanation yet', style: small00),
            spacer(y: 10),
            // Text(current.toString()),
            // FilledButton(
            //     style: ButtonStyle(
            //         foregroundColor: MaterialStatePropertyAll(Colors.white),
            //         backgroundColor: MaterialStatePropertyAll(tiber)),
            //     onPressed: () {
            //       _continueEditing(draft, QuestionType.mcq);
            //     },
            //     child: Text('Continue editing', style: rubik))
          ],
        ),
      ),
    );
  }
}

class DCQDraftItem extends StatelessWidget with Ui {
  DCQDraftItem({super.key, required this.data});
  final DCQDraft data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll(raisingBlack),
      onTap: () {
        push(DCQDraftItemDetail(data: data), context);
      },
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: raisingBlack,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.question_mark, size: 20, color: athensGray),
            ),
            spacer(x: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.query ?? 'No Query yet',
                  style: small00,
                ),
                Text('Correct: ${data.correct.toString().toUpperCase()}',
                    style: xs00),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DCQDraftItemDetail extends StatelessWidget with Ui {
  DCQDraftItemDetail({super.key, required this.data});
  final DCQDraft data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(y: 10),
            spacer(),
            Text(
              'Question',
              style: small00,
            ),
            spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              width: maxWidth(context),
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(data.query ?? 'No query yet', style: small00),
            ),
            spacer(y: 15),
            Text('Correct', style: mukta),
            spacer(y: 10),
            Text(data.correct.toString().toUpperCase(), style: small10),
            spacer(y: 20),
            Text('Explanation', style: mukta),
            spacer(y: 10),
            Container(
              width: maxWidth(context),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                  color: raisingBlack, borderRadius: BorderRadius.circular(6)),
              child: Text(data.explanation ?? 'No explanation yet',
                  style: small00),
            ),
          ],
        ),
      ),
    );
  }
}
