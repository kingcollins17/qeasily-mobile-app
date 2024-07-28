// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/app_constants.dart';
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

class _DashboardScreenState extends ConsumerState<DashboardScreen> with Ui {
  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final user = ref.watch(userAuthProvider);
    final pkgs = ref.watch(subPlanProvider);
    final draftLength = Hive.box<List>(mcqDrafts).values.length +
        Hive.box<List>(dcqDrafts).values.length;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: Text('Profile', style: small00),
            ),
            body: switch (dashboard) {
              AsyncData(value: (final msg, final data)) when user.hasValue =>
                RefreshIndicator(
                  onRefresh: () => ref.refresh(dashboardProvider.future),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: deepSaffron),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'asset/undraw/male_avatar.svg',
                                width: 70,
                                height: 70,
                              ),
                            ),
                            spacer(x: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, ${user.asData?.value.username}',
                                  style: small00,
                                ),
                                spacer(),
                                Text(data?.email ?? '',
                                    // user.asData?.value.email ?? '',
                                    style: xs00),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: raisingBlack,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(data?.plan ?? 'None',
                                      style: small00),
                                ),
                              ),
                            )
                          ],
                        ),
                        spacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Overview',
                            style: small00.copyWith(fontSize: 20),
                          ),
                        ),
                        spacer(y: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Quiz credits', style: small00),
                        ),
                        spacer(y: 10),
                        progressBar(data!.quizzesLeft, 100,
                            '${data.quizzesLeft} Quiz credits',
                            action: TextButton(
                                onPressed: () => context.push('/home/plans'),
                                child: Text(
                                  'Buy more',
                                  style: small00.copyWith(color: deepSaffron),
                                ))),
                        spacer(y: 20),
                        Row(
                          children: [
                            Expanded(
                                child: statBox(
                                    formatNum(data!.followers), 'Followers')),
                            spacer(),
                            Expanded(
                                child: statBox(
                                    formatNum(data.following), 'Following')),
                          ],
                        ),
                        spacer(y: 25),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Admin Overview',
                        //     style: small00,
                        //   ),
                        // ),
                        spacer(),
                        // Divider(color: Colors.grey),
                        // spacer(y: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Admin credits',
                            style: small00,
                          ),
                        ),
                        spacer(y: 20),
                        progressBar(data.adminPoints, 100,
                            '${data.adminPoints} Admin credits left',
                            action: TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStatePropertyAll(deepSaffron)),
                                onPressed: () => context.go('/home/plans'),
                                icon: Icon(Icons.credit_score, size: 15),
                                label:
                                    Text('Buy more ', style: small00))),
                        spacer(y: 20),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            wrappedBox(
                              label: 'Questions',
                              value:
                                  (data.totalDcqs + data.totalMcqs).toString(),
                              subscript: 'Mcq & Dcq',
                              icon: Icons.query_builder_rounded,
                            ),
                            wrappedBox(
                              label: 'Created Topics',
                              value: formatNum(data.topics),
                              subscript: ' topics',
                              icon: Icons.folder,
                            ),
                            wrappedBox(
                                label: 'Created Quizzes',
                                value: formatNum(data.totalQuiz),
                                subscript: ' quizzes',
                                icon: Icons.quiz),
                            
                            wrappedBox(
                                label: 'Total Drafts',
                                value: draftLength.toString(),
                                subscript: ' drafts',
                                icon: Icons.folder_copy_rounded)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              AsyncLoading() => Center(
                  child: SpinKitDualRing(
                      color: athensGray, size: 40, lineWidth: 5),
                ),
              AsyncError(:final error) => Center(
                  child: NetworkErrorNotification(
                      refresh: () => ref.refresh(dashboardProvider)),
                ),
              _ => Center()
            }),
      ],
    );
  }

  Widget wrappedBox(
      {required String label,
      required String value,
      required String subscript,
      required IconData icon}) {
    const height = 65.0;
    final width = maxWidth(context) * 0.42;
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: raisingBlack, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: xs01),
                spacer(y: 10),
                Row(
                  children: [
                    Text(
                      value,
                      style: small00.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    spacer(),
                    Text(subscript, style: xs01),
                  ],
                )
              ]),
          Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: athensGray),
            child: Icon(icon, size: 12, color: jungleGreen),
          )
        ],
      ),
    );
  }

  Widget progressBar(num value, num total, String footer, {Widget? action}) {
    if (value > total) value = total;
    num totalWidth = maxWidth(context) * 0.9;
    const height = 8.0;
    const radius = 20.0;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: totalWidth.toDouble(),
          height: height,
          decoration: BoxDecoration(
              color: raisingBlack, borderRadius: BorderRadius.circular(radius)),
          child: Container(
            height: height,
            width: (value / total) * totalWidth,
            decoration: BoxDecoration(
                color: deepSaffron,
                borderRadius: BorderRadius.circular(radius)),
          ),
        ),
        spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            action ?? spacer(),
            Text(footer, style: xs01),
          ],
        )
      ],
    );
  }

  Widget statBox(String value, String label) => Container(
        width: maxWidth(context) * 0.4,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: raisingBlack,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.stacked_bar_chart, color: Colors.grey, size: 15),
                spacer(x: 10),
                Text('Stat',
                    style: small00.copyWith(fontSize: 12, color: athensGray)),
              ],
            ),
            spacer(),
            Row(
              children: [
                Text(value,
                    style: rubik.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                spacer(),
                Text(label, style: xs00),
              ],
            ),
          ],
        ),
      );
}

String formatNum(int number) {
  return switch (number) {
    < 1000 => number.toString(),
    > 1000 && < 1000000 => '${(number / 1000).toStringAsFixed(1)}K',
    _ => '${(number / 1000000).toStringAsFixed(1)}M'
  };
}
