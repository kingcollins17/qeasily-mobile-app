// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

import 'util/util.dart';
import 'widgets/widgets.dart';

class ChallengeDetailScreen extends ConsumerStatefulWidget {
  const ChallengeDetailScreen({super.key, required this.data});

  final ChallengeData data;
  @override
  ConsumerState<ChallengeDetailScreen> createState() =>
      _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends ConsumerState<ChallengeDetailScreen>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _scrollController = ScrollController();
  LocalNotification? notification;
  bool isLoading = false;
  List<QuizData>? data;

  var leaderboards = <LeaderboardData>[];
  PageData leaderboardsPage = PageData();

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
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

    isLoading = true;
    //fetch challenge details here
    fetchChallengeDetail(ref.read(generalDioProvider), widget.data.id)
        .then((value) {
      data = value.$2;
      _notify(value.$1);
    });

    //fetch leaderboards here
    fetchLeaderboards(
      ref.read(generalDioProvider),
      widget.data.id,
      leaderboardsPage..next(),
    ).then((value) {
      final (:status, :data, :detail, :hasNextPage, :page) = value;
      leaderboardsPage = page ?? leaderboardsPage;
      leaderboards = data;
      _notify(detail, loading: false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _notify('Fetching next page', loading: true);
        fetchLeaderboards(
          ref.read(generalDioProvider),
          widget.data.id,
          leaderboardsPage..next(),
        ).then((value) {
          final (:detail, status: _, :data, :page, hasNextPage: _) = value;
          leaderboards.addAll(data);
          leaderboardsPage = page ?? leaderboardsPage;
          _notify(detail, loading: false);
        });
      }
    });
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: highlight,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Color(0x73000000),
                        )
                      ]),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.query_builder, color: athensGray, size: 18),
                      spacer(),
                      Text('Ends in ${widget.data.endsIn.inDays} Days',
                          style: mukta),
                    ],
                  )),
              spacer(y: 10),
              Text(widget.data.name, style: medium10),
              spacer(y: 20),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Entry fee', style: mukta),
                  spacer(),
                  Text(widget.data.entryFee.toStringAsFixed(2), style: small00),
                ],
              ),
              // spacer(y: 15),
              spacer(),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reward Price', style: mukta),
                  spacer(),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      decoration: BoxDecoration(
                        color: raisingBlack,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.data.reward.toStringAsFixed(2),
                        style: small00,
                      )),
                ],
              ),
              spacer(y: 30),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      // color: raisingBlack,
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                      // borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Leaderboards', style: small10),
                  ),
                  spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      // color: raisingBlack,
                      border:
                          Border(bottom: BorderSide(color: Colors.transparent)),
                      // borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Tasks', style: small10),
                  ),
                ],
              ),
              // spacer(y: 10),
              (leaderboards.isEmpty && isLoading)
                  ? Shimmer.fromColors(
                      baseColor: Colors.transparent,
                      highlightColor: Colors.grey,
                      child: Column(
                        children: [
                          shimmer(w: maxWidth(context)),
                          spacer(),
                          shimmer(w: maxWidth(context)),
                          spacer(),
                          shimmer(h: 80, w: maxWidth(context))
                        ],
                      ))
                  : LeaderboardsTableView(leaderboards: leaderboards)
            ],
          ),
        ),
      ),
      Positioned(
          bottom: 20,
          width: maxWidth(context),
          child: Center(
            child: FilledButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {},
              child: Text('Enter Challenge', style: rubik),
            ),
          ))
    ], notification);
  }
}
