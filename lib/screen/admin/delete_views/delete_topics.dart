// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unused_element

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/topics_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class DeleteTopicScreen extends ConsumerStatefulWidget {
  const DeleteTopicScreen({super.key});
  @override
  ConsumerState<DeleteTopicScreen> createState() => _DeleteTopicScreenState();
}

class _DeleteTopicScreenState extends ConsumerState<DeleteTopicScreen>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;
  TopicData? topic;
  String? notification = 'Tap to select topic, double tap to unselect';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topics = ref.watch(createdTopicsProvider);
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(title: Text('Delete Topic', style: small00)),
            body: switch (topics) {
              AsyncData(value: (final data, final page)) => EasyRefresh(
                  onRefresh: () => ref.refresh(createdTopicsProvider),
                  onLoad: () =>
                      ref.read(createdTopicsProvider.notifier).fetchNextPage(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    itemCount: data.length,
                    itemBuilder: (context, index) => InkWell(
                        child: InkWell(
                      onTap: () => setState(() {
                        topic = data[index];
                      }),
                      onDoubleTap: () => setState(() {
                        topic = null;
                      }),
                      overlayColor: MaterialStatePropertyAll(darkShade),
                      child: Ink(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: data[index] == topic
                                      ? jungleGreen
                                      : Colors.transparent,
                                  width: 1.5)),
                          child: TopicItemWidget(topic: data[index])),
                    )),
                  )),
              AsyncError(:final error) => Center(
                    child: NetworkErrorNotification(
                  refresh: () => ref.refresh(createdTopicsProvider),
                )),
              AsyncLoading() => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: _shimmer(),
                ),
              _ => Center()
            }),
        Positioned(
            bottom: 20,
            width: maxWidth(context),
            child: Center(
              child: FilledButton(
                onPressed: () {
                  if (topic == null) {
                    setState(() {
                      notification = 'Select a Topic';
                    });
                  } else {
                    //TODO: delete topic
                    setState(() {
                      isLoading = true;
                    });
                    deleteTopic(ref.read(generalDioProvider), topic!.id)
                        .then((value) => setState(() {
                              notification = value.toString();
                              isLoading = false;
                            }));
                  }
                },
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                      Size(maxWidth(context) * 0.9, 45)),
                  backgroundColor: MaterialStatePropertyAll(jungleGreen),
                ),
                child: Text(
                  'Delete Topic',
                  style: small00.copyWith(
                    color: athensGray,
                  ),
                ),
              ),
            )),
        if (isLoading)
          Center(
            child: SpinKitDualRing(color: Colors.white, size: 40),
          ),
        Positioned(
            top: 20,
            child: SleekNotification(
                notification: notification,
                closer: () {
                  setState(() {
                    notification = null;
                  });
                }))
      ],
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(),
            shimmer(),
            spacer(),
            shimmer(w: maxWidth(context) * 0.9, h: 60)
          ],
        ),
        baseColor: Colors.transparent,
        highlightColor: Colors.grey);
  }
}
