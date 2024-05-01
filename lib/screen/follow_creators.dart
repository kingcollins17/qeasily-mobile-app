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
                      // isLoading: isLoading,
                      isFollowed: destination == _Destination.followed,
                      onPressAction: (value) async {
                        _notify('Please wait ...', loading: true);
                        final dio = ref.read(generalDioProvider);
                        final (status, msg) =
                            destination == _Destination.followed
                                ? await unfollowCreator(dio, value.id)
                                : await followCreator(dio, value.id);
                        _notify(msg, loading: false);
                        ref.invalidate(provider);
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
}

class AccountItemTile extends StatefulWidget {
  const AccountItemTile(
      {super.key,
      required this.data,
      required this.isFollowed,
      // this.isLoading = false,
      required this.onPressAction});
  final ProfileData data;
  final bool isFollowed;
  // final bool isLoading;
  final Future Function(ProfileData value) onPressAction;

  @override
  State<AccountItemTile> createState() => _AccountItemTileState();
}

class _AccountItemTileState extends State<AccountItemTile> with Ui {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          circleWrap(widget.data.userName, px: 18),
          spacer(x: 10),
          spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.userName, style: small00),
              spacer(),
              Text(widget.data.department, style: xs01),
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.isFollowed
                      ? TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.redAccent)),
                          onPressed: () {
                            setState(() => isLoading = true);
                            widget.onPressAction(widget.data).then(
                                (value) => setState(() => isLoading = false));
                          },
                          child: isLoading
                              ? SizedBox(
                                  width: 15,
                                  child: SpinKitDualRing(
                                      color: Colors.white,
                                      size: 12,
                                      lineWidth: 1.2),
                                )
                              : Text('unfollow', style: rubikSmall))
                      : FilledButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(athensGray)),
                          onPressed: () {
                            setState(() => isLoading = true);
                            widget.onPressAction(widget.data).then(
                                (value) => setState(() => isLoading = false));
                          },
                          icon: isLoading
                              ? SizedBox(
                                  width: 15,
                                  child: SpinKitDualRing(
                                      color: Colors.black,
                                      size: 12,
                                      lineWidth: 1.2),
                                )
                              : Icon(Icons.add, size: 12),
                          label: Text('Follow', style: rubikSmall))))
        ],
      ),
    );
  }
}

enum _Destination { unfollowed, followed }
