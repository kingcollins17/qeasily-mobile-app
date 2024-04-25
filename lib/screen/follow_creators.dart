// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/follow_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class FollowCreatorScreen extends ConsumerStatefulWidget {
  const FollowCreatorScreen({super.key});
  @override
  ConsumerState<FollowCreatorScreen> createState() =>
      _FollowCreatorScreenState();
}

class _FollowCreatorScreenState extends ConsumerState<FollowCreatorScreen>
    with Ui, SingleTickerProviderStateMixin {
  final pageController = PageController();
  final scrollController = ScrollController();
  late AnimationController _controller;
  LocalNotification? notification;
  bool isLoading = false;

  var destination = _Destination.unfollowed;

  Future<void> _notify(String message, {bool? loading, int delay = 5}) async {
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        followNotifierProvider(destination == _Destination.followed);
    final followState = ref.watch(provider);
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(title: Text('Follow Creators', style: small00)),
        body: switch (followState) {
          AsyncData(value: (final data, final page)) => EasyRefresh(
              onRefresh: () => ref.refresh(provider),
              onLoad: () => ref.read(provider.notifier).fetchNextPage(),
              child: Column(
                children: [
                  spacer(y: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              destination = _Destination.unfollowed;
                            });
                          },
                          child: AnimatedScale(
                            duration: Duration(milliseconds: 200),
                            scale: destination == _Destination.unfollowed
                                ? 1.1
                                : 1,
                            child: Text('Accounts',
                                style: destination == _Destination.unfollowed
                                    ? rubik
                                    : mukta),
                          ),
                        ),
                        spacer(x: 18),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              destination = _Destination.followed;
                            });
                          },
                          child: AnimatedScale(
                            scale:
                                destination == _Destination.followed ? 1.1 : 1,
                            duration: Duration(milliseconds: 200),
                            child: Text('People you Follow',
                                style: destination == _Destination.followed
                                    ? rubik
                                    : mukta),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacer(y: 15),
                  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemCount: data.length,
                    itemBuilder: (context, index) => AccountItemTile(
                      data: data[index],
                      isFollowed: destination == _Destination.followed,
                      onPressAction: (value) async {
                        final dio = ref.read(generalDioProvider);
                        final (status, msg) =
                            destination == _Destination.followed
                                ? await unfollowCreator(dio, value.id)
                                : await followCreator(dio, value.id);
                        _notify(msg);
                      },
                    ),
                  ))
                ],
              ),
            ),
          AsyncLoading() => _shimmer(),
          AsyncError(:final error) =>
            error.toString().startsWith('DioException')
                ? NetworkErrorNotification(refresh: () => ref.refresh(provider))
                : ErrorNotificationHint(error: error),
          _ => null
        },
      ),
    ], notification);
  }

  Widget body({
    required List<ProfileData> accounts,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        Row(
          children: [
            spacer(x: 15),
          ],
        ),
        spacer(y: 20),
        Expanded(
          child: PageView(
            onPageChanged: (value) =>
                Future.delayed(Duration(milliseconds: 700), () {
              setState(() {
                destination = _Destination.values[value];
              });
            }),
            controller: pageController,
            children: [
              // unfollowedWidgetList(unfollowed),
              // followedWidgetList(followed),
            ],
          ),
        )
      ]),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Colors.grey,
      child: Column(
        children: List.generate(
            2,
            (index) => Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmer(),
                      spacer(),
                      shimmer(w: maxWidth(context) * 0.95, h: 55, br: 4)
                    ],
                  ),
                )),
      ),
    );
  }

  Widget followedWidgetList(List<ProfileData> accounts) {
    return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) => AccountItemTile(
              data: accounts[index],
              isFollowed: true,
              onPressAction: (value) {
                _notify('Please wait... ');
                unfollowCreator(ref.read(generalDioProvider), value.id)
                    .then((value) {
                  _notify(value.$2);
                  if (value.$1) ref.invalidate(followNotifierProvider);
                });
              },
            ));
  }

  Widget unfollowedWidgetList(List<ProfileData> accounts) {
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: AccountItemTile(
          data: accounts[index],
          isFollowed: false,
          onPressAction: (value) {
            _notify('Please wait ...');
            followCreator(ref.read(generalDioProvider), value.id).then((value) {
              _notify(value.$2);
              if (value.$1) {
                ref.invalidate(followNotifierProvider);
              }
            });
          },
        ),
      ),
    );
  }
}

class AccountItemTile extends StatelessWidget with Ui {
  AccountItemTile(
      {super.key,
      required this.data,
      required this.isFollowed,
      this.onPressAction});
  final ProfileData data;
  final bool isFollowed;
  final void Function(ProfileData value)? onPressAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressAction != null ? onPressAction!(data) : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(),
        child: Row(
          children: [
            circleWrap(data.userName, px: 18),
            spacer(x: 10),
            spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.userName, style: small00),
                spacer(),
                Text(data.department, style: xs01),
              ],
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: isFollowed
                        ? TextButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.redAccent)),
                            onPressed: () {
                              onPressAction != null
                                  ? onPressAction!(data)
                                  : null;
                            },
                            child: Text('unfollow', style: rubikSmall))
                        : FilledButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(athensGray)),
                            onPressed: () {
                              () => onPressAction != null
                                  ? onPressAction!(data)
                                  : null;
                            },
                            icon: Icon(Icons.add, size: 12),
                            label: Text('Follow', style: rubikSmall))))
          ],
        ),
      ),
    );
  }
}

enum _Destination { unfollowed, followed }
