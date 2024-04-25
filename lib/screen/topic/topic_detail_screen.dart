// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/styles.dart';

import 'package:qeasily/widget/widget.dart';

class TopicItemDetailScreen extends StatelessWidget with Ui {
  TopicItemDetailScreen({super.key, required this.data});
  final TopicData data;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(data.title, style: small00)),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data.title, style: medium10),
              spacer(),
              Text('created by ${data.creator}', style: xs01),
              spacer(),
              Text(() {
                final date = data.dateAdded;
                final days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
                final months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'July',
                  'Aug',
                  'Sept',
                  'Oct',
                  'Nov',
                  'Dec'
                ];
                final day = days[date.weekday];
                final mon = months[date.month - 1];
                return '$day, ${date.day} $mon, ${date.year}';
              }(), style: xs01),
              spacer(y: 20),
              Text('About', style: mukta),
              spacer(y: 10),
              Text(data.description, style: small00),
              spacer(),
              InfoHint(info: 'Hi, there!')
            ]),
          ),
        ),
        Positioned(
            bottom: 20,
            width: maxWidth(context),
            child: Center(
              child: FilledButton(
                  style: btn,
                  onPressed: () {
                    context.go('/home/quiz-list',
                        extra: (id: data.id, isCategory: false));
                  },
                  child: Text('See all Quizzes', style: rubik)),
            ))
      ],
    );
  }
}
