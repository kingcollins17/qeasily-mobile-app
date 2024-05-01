// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/screen/admin/questions/draft_item.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/app_constants.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/question_item.dart';

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

  void _continueEditing(List<Draft> drafts, QuestionType type) {
    context.push(
      '/admin/create-question',
      extra: (drafts, type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<List>(
      widget.type == QuestionType.mcq ? mcqDrafts : dcqDrafts,
    );
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
        ListView.builder(
            itemCount: draft.length,
            itemBuilder: (context, index) => DCQDraftItem(data: draft[index])),
        Positioned(
            bottom: 15,
            width: maxWidth(context),
            child: Center(
              child: FilledButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                          Size(maxWidth(context) * 0.9, 45)),
                      backgroundColor: MaterialStatePropertyAll(jungleGreen)),
                  onPressed: () {
                    _continueEditing(draft, QuestionType.dcq);
                  },
                  child: Text('Continue Editing',
                      style: small00.copyWith(color: Colors.white))),
            ))
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
          child: ListView.builder(
              itemCount: draft.length,
              itemBuilder: ((context, index) =>
                  MCQDraftItem(data: draft[index]))),
        ),
        Positioned(
            bottom: 15,
            width: maxWidth(context),
            child: Center(
              child: FilledButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                          Size(maxWidth(context) * 0.9, 45)),
                      backgroundColor: MaterialStatePropertyAll(jungleGreen)),
                  onPressed: () {
                    _continueEditing(draft, QuestionType.mcq);
                  },
                  child: Text('Continue Editing',
                      style: small00.copyWith(color: Colors.white))),
            ))
      ],
    );
  }
}
