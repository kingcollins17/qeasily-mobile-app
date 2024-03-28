// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
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
    return stackWithNotifier(
      [
        Scaffold(
          appBar: AppBar(title: Text('Creators to Follow', style: small00)),
          // body: ListView(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                FutureBuilder(
                    future: fetchAccountsToFollow(
                        ref.read(generalDioProvider), PageData(page: 1)),
                    builder: (context, snapshot) => Text(
                        snapshot.hasData
                            ? '${snapshot.data}'
                            : 'Please wait ...',
                        style: medium00))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
