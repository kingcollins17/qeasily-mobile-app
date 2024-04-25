// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/qeasily_state.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/styles.dart';

class SessionHistoryList extends ConsumerStatefulWidget {
  const SessionHistoryList({super.key});
  @override
  ConsumerState<SessionHistoryList> createState() => _SessionHistoryListState();
}

class _SessionHistoryListState extends ConsumerState<SessionHistoryList>
    with Ui {
  var destination = _Destination.mcq;
  final pageCX = PageController();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<QeasilyState, SessionViewModel>(
        converter: (store) =>
            SessionViewModel(store, ref.read(generalDioProvider)),
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved sessions', style: small00),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      spacer(),
                      ...List.generate(
                          _Destination.values.length,
                          (index) => Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    destination = _Destination.values[index];
                                    pageCX.animateToPage(index,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn);
                                  }),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(20),
                                        border: Border(
                                            bottom: BorderSide(
                                                color: destination ==
                                                        _Destination
                                                            .values[index]
                                                    ? jungleGreen
                                                    : Colors.transparent,
                                                width: 1.8)
                                            // : BorderSide.none,
                                            )),
                                    child: Text(
                                      _Destination.values[index].alias,
                                      style: small00,
                                    ),
                                  ),
                                ),
                              )),
                      spacer(),
                    ],
                  ),
                  spacer(y: 15),
                  Expanded(
                    child: PageView(
                      controller: pageCX,
                      onPageChanged: (value) {
                        setState(() {
                          destination = _Destination.values[value];
                        });
                      },
                      children: [mcqs(vm), dcqs(vm)],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget mcqs(SessionViewModel vm) {
    return ListView.builder(
      itemCount: vm.history.mcqSessions.length,
      itemBuilder: (context, index) =>
          SavedMCQItem(data: vm.history.mcqSessions[index]),
    );
  }

  Widget dcqs(SessionViewModel vm) {
    return ListView.builder(
        itemCount: vm.history.dcqSessions.length,
        itemBuilder: (context, index) => SavedDQCItem(
              data: vm.history.dcqSessions[index],
            ));
  }
}

enum _Destination {
  mcq('Multiple Choice'),
  dcq('True or False');

  final String alias;

  const _Destination(this.alias);
}

class SavedMCQItem extends StatelessWidget with Ui {
  SavedMCQItem({super.key, required this.data});
  final SavedMCQSession data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home/session/start', extra: data),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: tiber, shape: BoxShape.circle),
                child: Icon(
                  Icons.save_rounded,
                  size: 22,
                )),
            spacer(x: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.quiz.title,
                  style: small00.copyWith(fontWeight: FontWeight.bold),
                ),
                spacer(),
                Row(
                  children: [
                    Icon(Icons.timer, size: 12, color: jungleGreen),
                    spacer(),
                    Text(
                      '${Duration(seconds: data.secondsLeft).inMinutes} Minutes left',
                      style:
                          rubikSmall.copyWith(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios,
                        size: 8, color: athensGray)))
          ],
        ),
      ),
    );
  }
}

class SavedDQCItem extends StatelessWidget with Ui {
  SavedDQCItem({super.key, required this.data});
  final SavedDCQSession data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home/session/start', extra: data),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tiber,
              ),
              child: Icon(Icons.save, size: 20),
              // child: Column(),
            ),
            spacer(x: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.quiz.title,
                  style: small00.copyWith(fontWeight: FontWeight.bold),
                ),
                spacer(),
                Row(
                  children: [
                    Icon(Icons.timer, size: 12, color: jungleGreen),
                    spacer(),
                    Text(
                      '${Duration(seconds: data.secondsLeft).inMinutes} Minutes Left',
                      style:
                          rubikSmall.copyWith(fontSize: 12, color: Colors.grey),
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
}
