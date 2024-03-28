// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
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
      _FollowCreatorsScreenState();
}

class _FollowCreatorsScreenState extends ConsumerState<FollowCreatorScreen>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _scrollController = ScrollController();

  final followings = <int>[];
  int? followIsWaiting;

  LocalNotification? notification;
  var isLoading = false;
  var page = PageData();
  var accounts = <FollowAccountData>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    //attach scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchNextPage();
      }
    });

    isLoading = true;
    fetchAccountsToFollow(ref.read(generalDioProvider), page..next())
        .then((value) {
      // ignore: no_leading_underscores_for_local_identifiers
      final (status, msg, data, _page) = value;
      accounts = data;
      page = _page;
      _notify(msg, loading: false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });

    return showNotification(_controller, delay);
  }

  Future<void> fetchNextPage() async {
    if (page.hasNextPage) {
      _notify('Please wait ...', loading: true);
      final (status, msg, data, _page) = await fetchAccountsToFollow(
          ref.read(generalDioProvider), page..next());
      page = _page;
      accounts.addAll(data);
      _notify(msg, loading: false);
    } else {
      _notify('No more data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(title: Text('Creators to Follow', style: small00)),
        body: isLoading && accounts.isEmpty
            ? _shimmer()
            : ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                children: [
                  ...List.generate(
                      accounts.length, (index) => _userTile(index)),
                  spacer(),
                  if (isLoading && accounts.isNotEmpty)
                    SpinKitThreeBounce(color: Colors.white, size: 25),
                  spacer(y: 500),
                ],
              ),
        // body: SingleChildScrollView(
        //   padding: EdgeInsets.all(8),
        //   child: Column(
        //     children: [
        //       FutureBuilder(
        //           future: fetchAccountsToFollow(
        //               ref.read(generalDioProvider), PageData(page: 1)),
        //           builder: (context, snapshot) => Text(
        //               snapshot.hasData ? '${snapshot.data}' : 'Please wait ...',
        //               style: medium00))
        //     ],
        //   ),
        // ),
      ),
    ], notification);
  }

  Container _userTile(int index) {
    return Container(
      constraints: BoxConstraints(minHeight: 65),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tiber,
            ),
            child: Text(accounts[index].userName[0], style: medium00),
          ),
          spacer(x: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(accounts[index].userName, style: small00),
              spacer(),
              Text(accounts[index].department, style: mukta)
            ],
          ),
          Expanded(
              child: Align(
            alignment: Alignment.centerRight,
            child: _followButton(index),
          ))
        ],
      ),
    );
  }

  Future<void> handleFollow(int index) async {
    followIsWaiting = index;
    _notify('Following creator');
    final (status, msg) =
        await followCreator(ref.read(generalDioProvider), accounts[index].id);
    if (status) {
      followings.add(accounts[index].id);
    }
    followIsWaiting = null;
    _notify(msg, loading: false);
  }

  FilledButton _followButton(int index) {
    return FilledButton(
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
                followings.contains(accounts[index].id)
                    ? Colors.white
                    : Colors.black),
            backgroundColor: MaterialStatePropertyAll(
                followings.contains(accounts[index].id) ? tiber : Colors.white),
            fixedSize: MaterialStatePropertyAll(Size(110, 30))),
        onPressed: () => handleFollow(index),
        child: followIsWaiting == index
            ? SpinKitThreeBounce(color: Colors.black, size: 18)
            : Text(
                followings.contains(accounts[index].id) ? 'Unfollow' : 'Follow',
                style: rubikSmall));
  }

  Shimmer _shimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ...List.generate(
                4,
                (index) => Row(
                  children: [
                    shimmer(circle: true, w: 40),
                    spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // spacer(),
                        shimmer(),
                        spacer(),
                        shimmer(w: maxWidth(context) * 0.7, h: 40),
                        spacer(y: 20),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
