// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/screen/challenge/util/util.dart';
import 'package:qeasily/styles.dart';

class LeaderboardsTableView extends StatelessWidget with Ui {
  LeaderboardsTableView({super.key, required this.leaderboards});
  final List<LeaderboardData> leaderboards;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spacer(y: 20),
        Table(
            columnWidths: {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(2.2),
              2: FlexColumnWidth(),
              3: FlexColumnWidth()
            },
            border: TableBorder.all(
              // color: athensGray,
              color: tiber,
              borderRadius: BorderRadius.circular(6),
            ),
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FittedBox(child: Text('Position', style: xs00)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('User', style: xs00),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Score', style: xs00),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Progress', style: xs00),
                  ),
                ],
              ),
              ...List.generate(
                leaderboards.length,
                (index) => mapBoardToRow(
                  leaderboards[index],
                  index,
                  style: mukta,
                ),
              ),
            ]),
      ],
    );
  }
}
