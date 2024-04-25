// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/dashboard_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/local_notification.dart';
import 'package:qeasily/widget/notification_hints.dart';
import 'package:redux/redux.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/get_premium_icon.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with Ui, SingleTickerProviderStateMixin {
  LocalNotification? notification;
  bool isLoading = false;
  late AnimationController _controller;

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
    return showNotification(_controller, delay);
  }

  @override
  Widget build(BuildContext context) {
    final _dashboard = ref.watch(dashboardProvider);
    final _user = ref.watch(userAuthProvider);
    return stackWithNotifier([
      Scaffold(
          appBar: AppBar(
            // title: Text('Dashboard', style: small00),
            title: Text('Hi, ${_user.asData?.value.username}', style: rubik),

            actions: [
              GetPremiumIcon(),
              spacer(x: 10),
              circleWrap(_user.asData?.value.username ?? 'U'),
              spacer(x: 15),
            ],
          ),
          body: switch (_dashboard) {
            AsyncData(value: (String msg, DashboardData data)) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    spacer(),
                    Container(
                      constraints: BoxConstraints(minHeight: 60),
                      width: maxWidth(context),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: raisingBlack,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('Following', style: mukta),
                                  spacer(),
                                  Text(data.following.toString(), style: big00)
                                ],
                              ),
                              spacer(x: 20),
                              Column(
                                children: [
                                  Text('Followers', style: rubik),
                                  spacer(),
                                  Text(data.followers.toString(), style: big00)
                                ],
                              ),
                            ],
                          ),
                          spacer(),
                          TextButton(
                              onPressed: () {}, child: Text('Verify Purchase'))
                        ],
                      ),
                    ).animate(
                        autoPlay: true,
                        onPlay: (controller) => controller.repeat(
                            period: Duration(seconds: 2), reverse: true),
                        effects: [
                          ShimmerEffect(
                              colors: [Colors.transparent, raisingBlack],
                              duration: Duration(milliseconds: 800))
                        ]),
                    spacer(y: 10),
                    Row(
                      children: [
                        _detailTile('Quizzes Left', '${data.quizzesLeft}'),
                        spacer(x: 8),
                        // _detailTile('Current Plan', data.plan)
                      ],
                    ),
                    spacer(y: 10),
                    spacer(y: 10),
                   
                    if (_user.asData?.value.type == 'Admin') ...[
                      Text('Creation Summary', style: small00),
                      Wrap(spacing: 8, runSpacing: 15, children: [
                        _detailTile('Total MCQ created', '${data.totalMcqs}'),
                        _detailTile('Total DCQ created', '${data.totalDcqs}'),
                        _detailTile('Total Quiz created', '${data.totalQuiz}'),
                        _detailTile('Total Topics', '${data.topics}')
                      ])
                    ]
                  ],
                ),
              ),
            AsyncError(:final error) => NetworkErrorNotification(
                refresh: () => ref.refresh(dashboardProvider),
              ),
            AsyncLoading() => _loadingShimmer(context),
            _ => null,
          }),
    ], notification);
  }

  Widget _detailTile(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      constraints:
          BoxConstraints(maxHeight: 150, minWidth: maxWidth(context) * 0.4),
      decoration: BoxDecoration(
        color: athensGray,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: EdgeInsets.all(15),
            decoration:
                BoxDecoration(color: raisingBlack, shape: BoxShape.circle),
            child: Icon(Icons.dashboard_rounded, size: 18, color: vividOrange)),
        // spacer(y: 30),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 38,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: small00.copyWith(color: Colors.grey, fontSize: 14))
          ],
        ))
      ]),
    );
  }

  Shimmer _loadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          shimmer(),
          spacer(),
          shimmer(h: 80, w: maxWidth(context) * 0.85),
          spacer(y: 8),
          SizedBox(
            width: maxWidth(context) * 0.85,
            child: Row(
              children: [
                Expanded(child: shimmer(h: 70, br: 3)),
                spacer(),
                Expanded(child: shimmer(h: 70, br: 3))
                // spacer(),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
