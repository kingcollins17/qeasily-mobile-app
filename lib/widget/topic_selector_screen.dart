// ignore_for_file: prefer_const_constructors, unused_element, no_leading_underscores_for_local_identifiers, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/topics_provider.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/local_notification.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class TopicSelectorScreen extends ConsumerStatefulWidget {
  const TopicSelectorScreen(
      {super.key, required this.category, this.multiple = true});
  final CategoryData category;
  final bool multiple;
  @override
  ConsumerState<TopicSelectorScreen> createState() =>
      _TopicSelectorScreenState();
}

class _TopicSelectorScreenState extends ConsumerState<TopicSelectorScreen>
    with Ui, SingleTickerProviderStateMixin {
  LocalNotification? notification;
  bool isLoading = false;
  final selected = <TopicData>[];
  late AnimationController _controller;

  void _unselect(TopicData value) {
    // if (index < selected.length) {
    setState(() => selected.remove(value));
    // }
  }

  void _select(TopicData topic) {
    if (widget.multiple) {
      if (!selected.contains(topic)) {
        setState(() {
          selected.add(topic);
        });
      } else {
        _notify('Topic is already selected');
      }
    } else {
      setState(() {
        if (selected.isEmpty) {
          selected.add(topic);
        } else {
          selected[0] = topic;
        }
      });
    }
  }

  Future<void> _notify(String message, {bool? loading, int delay = 5}) {
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
    final _provider = topicsByCategoryProvider(widget.category.id);
    final topics = ref.watch(_provider);

    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          title: Text('Select Topics', style: small00),
        ),
        body: switch (topics) {
          AsyncData(value: (List<TopicData> data, PageData page)) =>
            EasyRefresh(
                onRefresh: () => ref.refresh(_provider),
                onLoad: () => ref.read(_provider.notifier).fetchNextPage(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _select(data[index]),
                    onLongPress: () => _unselect(data[index]),
                    onDoubleTap: () => _unselect(data[index]),
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: selected.contains(data[index])
                                ? jungleGreen
                                : Colors.transparent),
                        child: TopicItemWidget(topic: data[index])),
                  ),
                )),
          AsyncLoading() => Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    shimmer(),
                    spacer(),
                    shimmer(h: 60, w: maxWidth(context) * 0.9),
                    spacer()
                  ],
                ),
              ),
            ),
          AsyncError(:final error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(error.toString()),
              ),
            ),
          _ => SizedBox()
        },
      ),
      Positioned(
          bottom: 15,
          width: maxWidth(context),
          child: Center(
            child: FilledButton(
              style: btn,
              onPressed: () {
                Navigator.pop(context, selected);
              },
              child: Text('Select', style: rubik),
            ),
          ))
    ], notification);
  }
}
