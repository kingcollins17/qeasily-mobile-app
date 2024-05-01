// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_element

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/app_constants.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/screen/admin/admin.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/widget.dart';

class QuestionDraftScreen extends ConsumerStatefulWidget {
  const QuestionDraftScreen({super.key});
  @override
  ConsumerState<QuestionDraftScreen> createState() =>
      _QuestionDraftScreenState();
}

class _QuestionDraftScreenState extends ConsumerState<QuestionDraftScreen>
    with Ui, SingleTickerProviderStateMixin {
  bool isLoading = false;
  LocalNotification? notification;

  var type = QuestionType.mcq;

  late AnimationController _controller;

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller, delay);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mcqDraftBox = Hive.box<List>(mcqDrafts);
    final dcqDraftBox = Hive.box<List>(dcqDrafts);
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          title: Text('Drafts', style: small00),
        ),
        body: ValueListenableBuilder(
          valueListenable: dcqDraftBox.listenable(),
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  spacer(y: 10),
                  _selectDraftType(),
                  spacer(y: 20),
                  ...switch (type) {
                    QuestionType.mcq => mcqDraftBox.keys.isEmpty
                        ? [NoDataNotification()]
                        : mcqDraftBox.keys
                        .map((e) => _mcqDrafts(context, e, mcqDraftBox))
                        .toList(),
                    _ => dcqDraftBox.keys.isEmpty
                        ? [NoDataNotification()]
                        : _dcqDrafts(dcqDraftBox)
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    ], notification);
  }

  Widget _mcqDrafts(
    BuildContext context,
    draftName,
    Box<List<dynamic>> mcqDraftBox,
  ) {
    return GestureDetector(
      onTap: () =>
          push(DraftListViewWidget(draftName: draftName, type: type), context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: raisingBlack,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.drafts, size: 20, color: athensGray),
            ),
            spacer(x: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(draftName.toString(),
                    style: small00.copyWith(fontWeight: FontWeight.bold)),
                spacer(),
                Row(
                  children: [
                    Icon(Icons.query_builder, size: 12, color: athensGray),
                    spacer(),
                    Text(
                      '${loadMCQFromStorage(mcqDraftBox, draftName)?.length ?? '0'} Questions',
                      style: xs00,
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_forward_ios,
                      size: 8, color: athensGray)),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _dcqDrafts(Box<List> box) => box.keys
      .map((e) => GestureDetector(
            onTap: () {
              push(
                  DraftListViewWidget(
                    draftName: e.toString(),
                    type: type,
                  ),
                  context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.drafts, size: 20, color: athensGray),
                  ),
                  spacer(x: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.toString(),
                          style: small00.copyWith(fontWeight: FontWeight.bold)),
                      spacer(),
                      Row(
                        children: [
                          Icon(Icons.query_builder,
                              size: 12, color: athensGray),
                          spacer(),
                          Text(
                              '${box.get(e)?.length.toString() ?? '0'} Questions',
                              style: xs00),
                        ],
                      ),
                      
                    ],
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios,
                            size: 8, color: athensGray)),
                  )
                ],
              ),
            ),
          ))
      .toList();

  Row _selectDraftType() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => type = QuestionType.mcq),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                  color: type == QuestionType.mcq
                      ? athensGray : raisingBlack,
                  // : Colors.transparent,
                  borderRadius: BorderRadius.circular(6)),
              child: Text('Multiple Choice',
                  style: small00.copyWith(
                      color: type == QuestionType.mcq ? Colors.black : null)),
            ),
          ),
        ),
        spacer(x: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => type = QuestionType.dcq),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                  color: type == QuestionType.dcq
                      ? athensGray : raisingBlack,
                  // : Colors.transparent,
                  borderRadius: BorderRadius.circular(6)),
              child: Text('True or False',
                  style: small00.copyWith(
                      color: type == QuestionType.dcq ? Colors.black : null)),
            ),
          ),
        )
      ],
    );
  }
}
