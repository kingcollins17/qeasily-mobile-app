// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/provider/provider.dart';
import 'package:qeasily/provider/transactions.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/notification_hints.dart';
import 'package:qeasily/widget/store_notification.dart';

class PendingTransactionView extends ConsumerStatefulWidget {
  const PendingTransactionView({super.key});

  @override
  ConsumerState<PendingTransactionView> createState() =>
      _PendingTransactionViewState();
}

class _PendingTransactionViewState extends ConsumerState<PendingTransactionView>
    with Ui {
  String? notification;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(pendingTranxProvider);
    final keys = ref.watch(apiKeysProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Pending Transactions', style: small00)),
          body: switch (transactions) {
            AsyncData(value: final values) => values.isEmpty
                ? NoDataNotification()
                : ListView(
                    children: List.generate(
                        values.length,
                        (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                                notification =
                                    'Please wait while we verify your purchase ...';
                              });
                              verifyWithPaystack(keys.asData!.value,
                                      values[index].reference)
                                  .then((value) => setState(() {
                                        notification = value.toString();
                                        isLoading = false;
                                      }));
                            },
                            child: TransactionItem(data: values[index]))),
                  ),
            AsyncLoading() => Center(
                child: SpinKitDualRing(color: Colors.white, size: 40),
              ),
            AsyncError(:final error) => NetworkErrorNotification(
                message: error.toString(),
                refresh: () => ref.refresh(pendingTranxProvider)),
            _ => Center()
          },
        ),
        if (notification != null)
          Positioned(
              top: 20,
              child: SleekNotification(
                  optionTitle: 'Purchase verification',
                  notification: notification,
                  closer: () => setState(() {
                        notification = null;
                      }))),
        if (isLoading)
          Positioned(
              child: Center(
            child: SpinKitDualRing(
              color: Colors.white,
              size: 40,
            ),
          ))
      ],
    );
  }
}

class TransactionItem extends StatelessWidget with Ui {
  TransactionItem({super.key, required this.data});
  final PendingTransactionData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration:
                BoxDecoration(color: raisingBlack, shape: BoxShape.circle),
            child: Icon(Icons.data_saver_off_outlined, color: jungleGreen),
          ),
          spacer(x: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.plan} Package',
                style: small00.copyWith(fontWeight: FontWeight.bold),
              ),
              spacer(),
              Text(
                () {
                  final date = data.createdAt;
                  final months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'April',
                    'May',
                    'June',
                    'July',
                    'Aug',
                    'Sept',
                    'Oct',
                    'Nov',
                    'Dec'
                  ];
                  return '${date.day} ${months[date.month - 1]}, ${date.year}';
                }(),
                style: small00.copyWith(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(athensGray)),
                  onPressed: () {},
                  child: Text('verify', style: small00.copyWith(color: tiber))),
            ),
          )
        ],
      ),
    );
  }
}
