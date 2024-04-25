// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unused_element

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/topics_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class TopicManageView extends ConsumerStatefulWidget {
  const TopicManageView({super.key});
  @override
  ConsumerState<TopicManageView> createState() => _TopicManageViewState();
}

class _TopicManageViewState extends ConsumerState<TopicManageView>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return Scaffold(
        appBar: AppBar(title: Text('Manage Topics', style: small00)),
        body: switch (topics) {
          AsyncData(value: (final data, final page)) => EasyRefresh(
              onRefresh: () => ref.refresh(createdTopicsProvider),
              onLoad: () =>
                  ref.read(createdTopicsProvider.notifier).fetchNextPage(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    TopicItemWidget(topic: data[index]),
              )),
          AsyncError(:final error) =>
            Center(child: Text(error.toString(), style: small00)),
          AsyncLoading() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: _shimmer(),
            ),
          _ => Center()
        });
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
