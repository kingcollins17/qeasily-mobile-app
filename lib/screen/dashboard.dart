// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/dashboard_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/notification.dart';
import 'package:redux/redux.dart';
import 'package:shimmer/shimmer.dart';

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
            title: Text('Dasboard', style: small00),
          ),
          body: switch (_dashboard) {
            AsyncData(value: (String msg, DashboardData data)) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text('Hi, ${_user.asData?.value.username}', style: medium00)
                  ],
                ),
              ),
            AsyncError(:final error) => Center(),
            AsyncLoading() => Shimmer.fromColors(
                baseColor: Colors.transparent,
                highlightColor: Colors.grey,
                child: Column(),
              ),
            _ => null,
          }),
    ], notification);
  }
}
