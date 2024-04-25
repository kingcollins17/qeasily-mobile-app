// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/questions_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

//
import 'question_item.dart';

class QuestionSelectorScreen extends ConsumerStatefulWidget {
  const QuestionSelectorScreen({super.key, this.topic, this.user})
      : assert(!(topic == null && user == null));
  final (TopicData, QuestionType)? topic;
  final (UserData, QuestionType)? user;
  @override
  ConsumerState<QuestionSelectorScreen> createState() =>
      _QuestionSelectorScreenState();
}

class _QuestionSelectorScreenState extends ConsumerState<QuestionSelectorScreen>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;
  LocalNotification? notification;

  final selected = <Object>[];

  void _select(Object object) {
    if (object is DCQData || object is MCQData) {
      if (selected.contains(object)) {
        _notify('Already selected');
      } else {
        setState(() => selected.add(object));
      }
    }
  }

  void _unselect(Object object) => setState(() => selected.remove(object));

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
    dynamic _provider = widget.topic != null
        ? questionsByTopicProvider(
            widget.topic!.$1.id,
            widget.topic!.$2,
          )
        : questionsByCreatorProvider(widget.user!.$2);

    final questions = ref.watch(_provider);
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          title:
              Text('You selected ${selected.length} Questions', style: small00),
        ),
        body: switch (questions) {
          AsyncData(value: (final data, PageData page)) => EasyRefresh(
              onRefresh: () {
                selected.clear(); //clear list
                return ref.refresh(_provider);
              },
              onLoad: () => ref.read(_provider.notifier).fetchNextPage(),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (data case [MCQData _, ...]) {
                    return GestureDetector(
                        onTap: selected.contains(data[index])
                            ? () => _notify('Item is selected')
                            : () => push(
                                MCQItemDetailWidget(
                                    data: data[index] as MCQData),
                                context),
                        onLongPress: () => _select(data[index]),
                        onDoubleTap: () => _unselect(data[index]),
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: selected.contains(data[index])
                                    ? jungleGreen
                                    : Colors.transparent),
                            child: MCQItemWidget(data: data.cast()[index])));
                  } else {
                    return GestureDetector(
                      onTap: !selected.contains(data[index])
                          ? () => push(
                              DCQItemDetailWidget(data: data[index] as DCQData),
                              context)
                          : () => _notify('Item is selected'),
                      onLongPress: () => _select(data[index]),
                      onDoubleTap: () => _unselect(data[index]),
                      child: Container(
                          margin: EdgeInsets.all(4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: selected.contains(data[index])
                                  ? jungleGreen
                                  : Colors.transparent),
                          child: DCQItemWidget(data: data.cast()[index])),
                    );
                  }
                  // return Text(data[index].toString());
                },
              )),
          // AsyncData() => Column(
          //     children: [
          //       FutureBuilder(
          //         future: ref.read(_provider.notifier).fetchNextPage(),
          //         builder: (context, snapshot) =>
          //             Text(snapshot.data.toString()),
          //       )
          //     ],
          //   ),
          AsyncLoading() => _loadingShimmer(context),
          AsyncError(:final error) =>
            Center(child: Text(error.toString(), style: small00)),
          _ => null
        },
      ),
      Positioned(
          width: maxWidth(context),
          bottom: 15,
          child: Center(
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context, selected);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.black),
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: Text(
                'select',
                style: rubik,
              ),
            ),
          ))
    ], notification);
  }

  Shimmer _loadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              shimmer(),
              spacer(),
              shimmer(h: 60, w: maxWidth(context) * 0.5, br: 4)
            ],
          ),
        ));
  }
}
