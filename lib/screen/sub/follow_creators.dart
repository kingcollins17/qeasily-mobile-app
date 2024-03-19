// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/styles.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FollowCreatorScreen extends ConsumerStatefulWidget {
  const FollowCreatorScreen({super.key});
  @override
  ConsumerState<FollowCreatorScreen> createState() =>
      _FollowCreatorsScreenState();
}

class _FollowCreatorsScreenState extends ConsumerState<FollowCreatorScreen>
    with Ui {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: stackWithNotifier([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Text('Creators to Follow', style: mukta),
            ],
          ),
        )
      ]),
    );
  }
}
