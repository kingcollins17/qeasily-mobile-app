// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';

Future<(String, List<QuizData>, bool)> fetchChallengeDetail(
    Dio dio, int id) async {
  try {
    final res = await dio.get(
      APIUrl.fetchChallengeDetails.url,
      queryParameters: {'cid': id},
    );
    if (res.statusCode == 200) {
      final {'detail': msg, 'quiz_data': data} = res.data;
      return (
        msg.toString(),
        (data as List).map((e) => QuizData.fromJson(e)).toList(),
        true
      );
    } else {
      return (res.data['detail'].toString(), <QuizData>[], false);
    }
    // return res;
  } catch (e) {
    return (e.toString(), <QuizData>[], false);
  }
}

Future<
    ({
      List<LeaderboardData> data,
      String detail,
      PageData? page,
      bool? hasNextPage,
      bool status
    })> fetchLeaderboards(Dio dio, int challengeId, PageData page) async {
  try {
    final res = await dio.get(APIUrl.fetchLeaderboards.url,
        queryParameters: {'cid': challengeId}, data: page.toJson());

    if (res.statusCode == 200) {
      final {
        'detail': msg,
        'data': data,
        'has_next_page': hasNextPage,
        'page': fetchedPage
      } = res.data;
      return (
        status: true,
        detail: msg.toString(),
        data: (data as List).map((e) => LeaderboardData.fromJson(e)).toList(),
        hasNextPage: hasNextPage as bool,
        page: PageData.fromJson(fetchedPage)..hasNextPage = hasNextPage
      );
    }
    return (
      status: false,
      detail: res.data['detail'].toString(),
      data: <LeaderboardData>[],
      hasNextPage: null,
      page: null
    );
  } catch (e) {
    return (
      status: false,
      detail: e.toString(),
      data: <LeaderboardData>[],
      hasNextPage: null,
      page: null
    );
  }
}

TableRow mapBoardToRow(LeaderboardData data, int position,
        {TextStyle? style, Decoration? decoration}) =>
    TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text('${position + 1}', style: style),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
        child: Text(data.userName ?? data.email, style: style),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
        child: Text(data.points.toString(), style: style),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(data.progress.toString(), style: style),
      )
    ], decoration: decoration
        // decoration:,
        );
