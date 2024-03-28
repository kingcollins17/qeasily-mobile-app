// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/app_constants.dart';
import 'package:qeasily/styles.dart';

class DraftListViewWidget extends StatefulWidget {
  const DraftListViewWidget(
      {super.key, required this.draftName, required this.type});

  final String draftName;
  final QuestionType type;

  @override
  State<DraftListViewWidget> createState() => _DraftListViewWidgetState();
}

class _DraftListViewWidgetState extends State<DraftListViewWidget> with Ui {
  final pageController = PageController();
  var current = 0;
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<List>(
      widget.type == QuestionType.mcq ? mcqDrafts : dcqDrafts,
    );
    // final data =
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.draftName, style: small00),
      ),
      body: switch (widget.type) {
        QuestionType.mcq =>
          mcQuestionsView(loadMCQFromStorage(box, widget.draftName) ?? []),
        QuestionType.dcq =>
          dcQuestionsView(loadDCQFromStorage(box, widget.draftName) ?? []),
      },
    );
  }

  Widget dcQuestionsView(List<DCQDraft> draft) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(),
          child: PageView.builder(
            controller: pageController,
            itemCount: draft.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer(y: 10),
                Text('Questions ${current + 1} of ${draft.length}',
                    style: mukta),
                spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  width: maxWidth(context),
                  decoration: BoxDecoration(
                    color: raisingBlack,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(draft[index].query ?? 'No query yet',
                      style: small00),
                ),
                spacer(y: 15),
                Text('Correct', style: mukta),
                spacer(y: 10),
                Text(draft[index].correct.toString().toUpperCase(),
                    style: small10),
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
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(draft[index].explanation ?? 'No explanation yet',
                      style: small00),
                ),
                spacer(y: 10),
                FilledButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(tiber)),
                    onPressed: () {
                      context.push('/admin/create-question',
                          extra: (draft, QuestionType.dcq));
                    },
                    child: Text('Continue editing', style: rubik))
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          width: maxWidth(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () => current > 0
                        ? pageController.animateToPage(--current,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut)
                        : null,
                    child: direction(dir: 'left')),
                GestureDetector(
                    onTap: () => current + 1 < draft.length
                        ? pageController.animateToPage(
                            ++current,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastEaseInToSlowEaseOut,
                          )
                        : null,
                    child: direction(dir: 'right'))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget mcQuestionsView(List<MCQDraft> draft) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
            color: darkerShade,
            borderRadius: BorderRadius.circular(6),
          ),
          child: PageView.builder(
            controller: pageController,
            itemCount: draft.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer(y: 10),
                Text('Question ${index + 1} of ${draft.length}', style: mukta),
                spacer(y: 15),
                Container(
                    width: maxWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(draft[index].query.toString(), style: small00)),
                spacer(y: 20),
                Text('Options', style: mukta),
                spacer(y: 10),
                Text('A. ${draft[index].A ?? 'No Option'}', style: small00),
                spacer(y: 10),
                Text('B. ${draft[index].B ?? 'No Option'}', style: small00),
                spacer(y: 10),
                Text('C. ${draft[index].C ?? 'No Option'}', style: small00),
                spacer(y: 10),
                Text('D. ${draft[index].D ?? 'No Option'}', style: small00),
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
                  child: Text(draft[index].correct?.name ?? 'Not Choosen yet',
                      style: small00),
                ),
                spacer(y: 10),
                Text('Explanation', style: mukta),
                spacer(y: 10),
                Text(draft[index].explanation ?? 'No explanation yet',
                    style: small00),
                spacer(y: 10),
                // Text(current.toString()),
                FilledButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(tiber)),
                    onPressed: () {
                      context.push('/admin/create-question',
                          extra: (draft, QuestionType.mcq));
                    },
                    child: Text('Continue editing', style: rubik))
              ],
            ),
          ),
        ),
        Positioned(
            width: maxWidth(context),
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => current > 0
                          ? pageController.animateToPage(--current,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastEaseInToSlowEaseOut)
                          : null,
                      child: direction(dir: 'left')),
                  GestureDetector(
                      onTap: () => current + 1 < draft.length
                          ? pageController.animateToPage(
                              ++current,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastEaseInToSlowEaseOut,
                            )
                          : null,
                      child: direction(dir: 'right')),
                ],
              ),
            ))
      ],
    );
  }
}
