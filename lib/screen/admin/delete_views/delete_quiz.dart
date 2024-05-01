// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
// import 'package:qeasily/provider/created_quizzes.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/quiz_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/local_notification.dart';
import 'package:qeasily/widget/widget.dart';

class QuizManageView extends ConsumerStatefulWidget {
  const QuizManageView({super.key});
  @override
  ConsumerState<QuizManageView> createState() => _QuizManageViewState();
}

class _QuizManageViewState extends ConsumerState<QuizManageView>
    with Ui, SingleTickerProviderStateMixin {
  LocalNotification? notification;
  String? hint = 'Tap to select, double tap to unselect';
  late AnimationController _controller;
  bool isLoading = false;
  int? selected;

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
    setState(() {
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller, delay);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectItem(int id) {
    setState(() {
      selected = id;
    });
  }

  void _unselectItem(int id) {
    setState(() {
      selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = ref.watch(quizByCreatorProvider);
    return stackWithNotifier([
      Scaffold(
          appBar: AppBar(
            title: Text('Manage your Quizzes', style: small00),
          ),
          body: switch (quizzes) {
            AsyncData(value: (final data, final page)) => EasyRefresh(
                onRefresh: () => ref.refresh(quizByCreatorProvider),
                onLoad: () =>
                    ref.read(quizByCreatorProvider.notifier).fetchNextPage(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _selectItem(data[index].id),
                    onDoubleTap: () => _unselectItem(data[index].id),
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: selected == data[index].id
                                    ? jungleGreen
                                    : Colors.transparent,
                                width: 1.4)),
                        child: QuizItemWidget(quiz: data[index])),
                  ),
                ),
              ),
            AsyncError(:final error) => Center(
                child: NetworkErrorNotification(
                  refresh: () => ref.read(quizByCreatorProvider),
                ),
              ),
            _ => Center(child: SpinKitDualRing(color: Colors.white, size: 40))
          }),
      Positioned(
          top: 20,
          child: SleekNotification(
              notification: hint,
              closer: () {
                setState(() {
                  hint = null;
                });
              })),
      if (selected != null)
        Positioned(
            bottom: 20,
            width: maxWidth(context),
            child: Center(
              child: FilledButton(
                  onPressed: () {
                    if (selected != null) {
                      setState(() {
                        isLoading = true;
                      });
                      _notify('Please wait ...');
                      final notifier = ref.read(quizByCreatorProvider.notifier);
                      notifier
                          .deleteQuiz(selected!)
                          .then((value) => setState(() {
                                hint = value.toString();
                                isLoading = false;
                              }));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(jungleGreen),
                      fixedSize: MaterialStatePropertyAll(
                          Size(maxWidth(context) * 0.9, 45))),
                  child: isLoading
                      ? SpinKitDualRing(
                          color: Colors.white, size: 25, lineWidth: 1.5)
                      : Text(
                          'Delete Quiz',
                          style: small00.copyWith(color: athensGray),
                        )),
            ))
    ], notification);
  }
}
