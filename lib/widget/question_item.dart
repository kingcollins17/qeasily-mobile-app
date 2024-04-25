// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/styles.dart';

class MCQItemWidget extends StatelessWidget with Ui {
  MCQItemWidget({super.key, required this.data});
  final MCQData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration:
                BoxDecoration(color: athensGray, shape: BoxShape.circle),
            child: Text(
              data.correct.name.toUpperCase(),
              style: medium10.copyWith(color: darkerShade),
            ),
          ),
          spacer(x: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(() {
                const lim = 25;
                return data.query.length >= lim
                    ? data.query.substring(0, lim)
                    : '${data.query}...';
              }(), style: small00),
              spacer(),
              Row(
                children: [
                  Icon(Icons.tag, size: 15, color: athensGray),
                  spacer(x: 10),
                  Text(data.topicTitle ?? '', style: mukta),
                ],
              ),
              // spacer(x: 15),
              // Text(data.correct.name, style: medium10),
            ],
          ),
        ],
      ),
    );
  }
}

class DCQItemWidget extends StatelessWidget with Ui {
  DCQItemWidget({super.key, required this.data});
  final DCQData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: athensGray),
            padding: EdgeInsets.all(15),
            child: Text(
              data.correct.toString().toUpperCase()[0],
              style: medium10.copyWith(color: darkerShade),
            ),
          ),
          spacer(x: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(data.query, style: small00),
              Text(() {
                const lim = 25;
                return data.query.length >= lim
                    ? data.query.substring(0, lim)
                    : '${data.query}...';
              }(), style: small00),
              spacer(),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text('Correct', style: mukta),
                  Icon(Icons.tag, color: athensGray, size: 15), spacer(x: 10),
                  Text(data.topicTitle ?? '', style: small10)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MCQItemDetailWidget extends StatelessWidget with Ui {
  MCQItemDetailWidget({super.key, required this.data});
  final MCQData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Question details', style: small00)),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.query,
                style: small00,
              ),
              spacer(y: 25),
              _option('A', data.A),
              spacer(),
              _option('B', data.B),
              spacer(),
              _option('C', data.C),
              spacer(),
              _option('D', data.D),
              spacer(y: 25),
              Text('Correct Option', style: small00),
              spacer(),
              Text(data.correct.name, style: medium10),
              spacer(y: 25),
              Text('Explanation', style: small00),
              spacer(y: 15),
              Container(
                padding: EdgeInsets.all(15),
                width: maxWidth(context) * 0.95,
                decoration: BoxDecoration(
                    color: raisingBlack,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(data.explanation, style: small00),
              )
            ],
          ),
        ));
  }

  Row _option(String option, String value) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(option, style: medium10),
        spacer(x: 16),
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(minHeight: 50),
              child: Text(value, style: mukta)),
        ),
      ],
    );
  }
}

class DCQItemDetailWidget extends StatelessWidget with Ui {
  DCQItemDetailWidget({super.key, required this.data});
  final DCQData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question detail', style: small00),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.query, style: small00),
            spacer(y: 20),
            Divider(height: 1.2, color: Colors.grey),
            spacer(y: 20),
            Row(
              children: [
                Text('Correct Option', style: rubik),
                spacer(x: 10),
                Text(data.correct.toString().toUpperCase(), style: small10),
              ],
            ),
            spacer(y: 25),
            Text('Explanation', style: small00),
            spacer(y: 15),
            Container(
                padding: EdgeInsets.all(18),
                width: maxWidth(context) * 0.9,
                decoration: BoxDecoration(
                  color: raisingBlack,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(data.explanation, style: rubik)),
          ],
        ),
      ),
    );
  }
}
