// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/provider/quiz_provider.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class QuizListScreen extends ConsumerStatefulWidget {
  const QuizListScreen(
      {super.key, required this.filterId, this.isCategoryId = false});
  final int filterId;

  ///Whether the filterId is a categoryId
  final bool isCategoryId;
  @override
  ConsumerState<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends ConsumerState<QuizListScreen> with Ui {
  @override
  Widget build(BuildContext context) {
    final prov = widget.isCategoryId
        ? quizByCategoryProvider(widget.filterId)
        : quizByTopicProvider(widget.filterId);
    final value = ref.watch(prov);
    return Scaffold(
      appBar: AppBar(title: Text('Quizzes', style: small00)),
      body: switch (value) {
        AsyncData(value: (final data, final page)) => EasyRefresh(
            onRefresh: () => ref.refresh(prov),
            onLoad: () => ref.read((prov as dynamic).notifier).fetchNextPage(),
            child: data.isEmpty
                ? NoDataNotification()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    itemCount: data.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () =>
                            context.go('/home/session', extra: data[index]),
                        child: QuizItemWidget(quiz: data[index])),
                  )),
        AsyncLoading() => Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Shimmer.fromColors(
                child: Column(
                  children: List.generate(
                    4,
                    (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        spacer(y: 15),
                        shimmer(br: 4),
                        spacer(y: 10),
                        shimmer(br: 4, w: maxWidth(context) * 0.9, h: 55),
                      ],
                    ),
                  ),
                ),
                baseColor: Colors.transparent,
                highlightColor: Colors.grey),
          ),
        AsyncError(:final error) => Center(
            child: Text(error.toString(), style: medium00),
          ),
        _ => Center(),
      },
    );
  }
}
