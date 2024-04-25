// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:intl/intl.dart';
import 'package:qeasily/widget/notification_hints.dart';
import 'package:qeasily/widget/store_notification.dart';
import 'package:shimmer/shimmer.dart';
import 'package:currency_symbols/currency_symbols.dart';

class SubscriptionPlanScreen extends ConsumerStatefulWidget {
  const SubscriptionPlanScreen({super.key});
  @override
  ConsumerState<SubscriptionPlanScreen> createState() =>
      _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends ConsumerState<SubscriptionPlanScreen>
    with Ui {
  // final pageController = PageController();
  PlanData? current;
  String? hint;
  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(subPlanProvider);
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Material(
              child: Column(
            children: [
              spacer(y: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: athensGray,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 20, color: Colors.black),
                    ),
                  ),
                  TextButton(
                      style: ButtonStyle(),
                      onPressed: () => context.go('/home/transactions'),
                      child: Text(
                        'Verify Purchases',
                        style: small00.copyWith(color: deepSaffron),
                      )),
                ],
              ),
              spacer(y: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose a Package',
                  style: small00.copyWith(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              spacer(y: 15),
              switch (plans) {
                AsyncData(:final value) => Column(
                    children: List.generate(
                        value.length,
                        (index) => GestureDetector(
                              onTap: () =>
                                  setState(() => current = value[index]),
                              child: PlanItemWidget(
                                data: value[index],
                                selected: value[index] == current,
                              ),
                            ))),
                AsyncLoading() => Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.grey,
                    child: Column(
                      children: [
                        spacer(y: 20),
                        shimmer(br: 6),
                        spacer(y: 15),
                        shimmer(h: 60, w: maxWidth(context) * 0.9, br: 6),
                      ],
                    )),
                AsyncError(
                  :final error,
                ) =>
                  Center(child: Text(error.toString(), style: small00)),
                _ => Center()
              },
              spacer(),
            ],
          )),
        ),
        Positioned(
            bottom: 20,
            width: maxWidth(context),
            child: Center(
              child: FilledButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                          Size(maxWidth(context) * 0.9, 45)),
                      backgroundColor: MaterialStatePropertyAll(
                        deepSaffron,
                      )),
                  onPressed: () {},
                  child: Text('Buy Package',
                      style: small00.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white))),
            )),
        Positioned(
            top: 20,
            child: SleekNotification(
                notification: hint, closer: () => setState(() => hint = null)))
      ],
    );
  }
}

class PlanItemWidget extends StatelessWidget with Ui {
  PlanItemWidget({super.key, required this.data, this.selected = false});
  final PlanData data;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? deepSaffron : Colors.transparent, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${data.name} Package',
                  style: mukta.copyWith(color: deepSaffron)),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: selected ? deepSaffron : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      shape: BoxShape.circle,
                    )),
              )
            ],
          ),
          spacer(y: 15),
          Row(
            children: [
              Text(
                  NumberFormat.currency(
                    locale: 'en_us',
                    symbol: cSymbol('NGN'),
                  ).format(data.price),
                  style: medium00.copyWith(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              spacer(),
              // Text('/per month', style: mukta),
            ],
          ),
          spacer(),
          SizedBox(
            width: maxWidth(context) * 0.9,
            child: Wrap(
              spacing: 20,
              runSpacing: 6,
              children: [
                ...data.features.map((e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.dew_point, size: 8, color: Colors.grey),
                        spacer(),
                        Text(
                          e,
                          style: small00.copyWith(
                              fontSize: 12, color: Colors.grey),
                        )
                      ],
                    )),
              ],
            ),
          ),
          spacer(),
        ],
      ),
    );
  }
}
