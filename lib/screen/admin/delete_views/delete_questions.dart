// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/questions_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/local_notification.dart';
import 'package:qeasily/widget/question_selector_screen.dart';

class QuestionsManageView extends ConsumerStatefulWidget {
  const QuestionsManageView({super.key});
  @override
  ConsumerState<QuestionsManageView> createState() => _QuestionsListViewState();
}

class _QuestionsListViewState extends ConsumerState<QuestionsManageView>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final scrollController = ScrollController();

  bool isLoading = false;
  LocalNotification? notification;

  QuestionType questionType = QuestionType.mcq;
  var mcqs = <MCQData>[];
  var dcqs = <DCQData>[];
  PageData mcqsPage = PageData(), dcqsPage = PageData();

  List<int> selectedMultipleCQIds = [], selectedDualCQIds = [];

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

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
          appBar: AppBar(
            title: Text('Delete Questions', style: small00),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('What type of questions do you want to delete?',
                    textAlign: TextAlign.center, style: small00),
                spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        push<List>(
                                QuestionSelectorScreen(
                                  user: (
                                    ref.read(userAuthProvider).value!,
                                    QuestionType.mcq
                                  ),
                                ),
                                context)
                            .then((value) async {
                          if (value case [MCQData _, ...]) {
                            _notify(
                                'Removing multiple choice questions ${value.map((e) => e.id)} ...',
                                loading: true);
                            final notifier = ref.read(
                              questionsByCreatorProvider(QuestionType.mcq)
                                  .notifier,
                            );
                            final response = await notifier.deleteQuestions(
                              value.map((e) => e.id as int).toList(),
                              QuestionType.mcq,
                            );
                            _notify(response.$2, loading: false);
                          }
                        });
                      },
                      child: Text('Multiple Choice',
                          style: rubik.copyWith(color: jungleGreen)),
                    ),
                    TextButton(
                        onPressed: () {
                          push<List>(
                                  QuestionSelectorScreen(user: (
                                    ref.read(userAuthProvider).value!,
                                    QuestionType.dcq
                                  )),
                                  context)
                              .then((value) {
                            if (value case [DCQData _, ...]) {
                              _notify(
                                'Removing ${value.length} Questions',
                                loading: true,
                              );
                              final notifier = ref.read(
                                  questionsByCreatorProvider(QuestionType.dcq)
                                      .notifier);
                              notifier
                                  .deleteQuestions(
                                    value.map((e) => e.id as int).toList(),
                                    QuestionType.dcq,
                                  )
                                  .then((value) => _notify(value.$2));
                            }
                          });
                        },
                        child: Text('True or False',
                            style: rubik.copyWith(color: deepSaffron)))
                  ],
                )
              ],
            ),
          )),
    ], notification);
  }

  List<Widget> get _dcqItems => [
        ...List.generate(
            dcqs.length,
            (index) => GestureDetector(
                  onLongPress: () => setState(() {
                    if (selectedDualCQIds.contains(dcqs[index].id)) {
                      //if its already picked, unpick it
                      selectedDualCQIds.remove(dcqs[index].id);
                    } else {
                      //else pick it
                      selectedDualCQIds.add(dcqs[index].id);
                    }
                  }),
                  child: Row(
                    children: [
                      _numberingWidget(index + 1),
                      spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        width: maxWidth(context) * 0.8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        constraints: BoxConstraints(minHeight: 60),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: selectedDualCQIds.contains(dcqs[index].id)
                              ? jungleGreen
                              : Colors.transparent,
                          width: 1.5,
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(() {
                              final q = dcqs[index].query;
                              return q.length > 35
                                  ? '${q.substring(0, 35)}...'
                                  : q;
                            }(), style: small00),
                            spacer(),
                            Text(dcqs[index].topicTitle ?? '', style: xs01),
                            spacer(),
                            Row(
                              children: [
                                Text('Correct Option', style: mukta),
                                spacer(),
                                Text(
                                    dcqs[index]
                                        .correct
                                        .toString()
                                        .toUpperCase(),
                                    style: small10)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        spacer(y: 10),
        if (isLoading) ...[
          SpinKitThreeBounce(size: 25, color: Colors.white),
          spacer(y: 50)
        ]
      ];

  List<Widget> get _mcqItems => [
        ...List.generate(
            mcqs.length,
            (index) => GestureDetector(
                  onLongPress: () => setState(() {
                    if (selectedMultipleCQIds.contains(mcqs[index].id)) {
                      selectedMultipleCQIds.remove(mcqs[index].id);
                    } else {
                      selectedMultipleCQIds.add(mcqs[index].id);
                    }
                  }),
                  child: Row(
                    children: [
                      _numberingWidget(index + 1),
                      spacer(x: 6),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        width: maxWidth(context) * 0.8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        constraints: BoxConstraints(minHeight: 60),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedMultipleCQIds
                                        .contains(mcqs[index].id)
                                    ? jungleGreen
                                    : Colors.transparent,
                                width: 1.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(() {
                              final query = mcqs[index].query;
                              return query.length > 30
                                  ? '${query.substring(0, 30)}...'
                                  : query;
                            }(), style: rubik),
                            spacer(),
                            Text(mcqs[index].topicTitle ?? '', style: xs01),
                            spacer(),
                            Row(
                              children: [
                                Text('Correct', style: mukta),
                                spacer(),
                                Text(mcqs[index].correct.name, style: small10),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        if (isLoading) ...[
          spacer(y: 20),
          SpinKitThreeBounce(size: 25, color: Colors.white),
          spacer(y: 50)
        ]
      ];

  Container _numberingWidget(int number) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      child: Text(number.toString(), style: medium00),
    );
  }

  Widget _destination(QuestionType type) {
    return GestureDetector(
      onTap: () => setState(() {
        questionType = type;
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: type == questionType
                        ? Colors.white
                        : Colors.transparent,
                    width: 1.5))),
        child: Text(
            type == QuestionType.mcq ? 'Multiple Choice' : 'True or False',
            style: type == questionType ? rubik : mukta),
      ),
    );
  }
}
