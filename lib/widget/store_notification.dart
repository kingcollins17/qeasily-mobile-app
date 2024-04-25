// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qeasily/styles.dart';

class StoreNotification extends StatelessWidget with Ui {
  StoreNotification({super.key, this.message, required this.closer});
  final String? message;
  // final String? optionTitle;

  ///This should be a function that essentially sets the message passed to this
  ///widget to null
  final void Function() closer;

  @override
  Widget build(BuildContext context) {
    final width = maxWidth(context) * 0.92;
    return message == null
        ? SizedBox.shrink()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: maxWidth(context),
            decoration: BoxDecoration(),
            child: Column(
              children: [
                if (message != null) ...[
                  Container(
                    width: width,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: closer,
                      child: Container(
                        decoration: BoxDecoration(
                            color: raisingBlack, shape: BoxShape.circle),
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close, size: 25, color: Colors.white),
                      ),
                    ),
                  ),
                  spacer(),
                  Material(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        constraints: BoxConstraints(minHeight: 50),
                        width: width,
                        decoration: BoxDecoration(
                          color: athensGray,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(message!,
                            style: rubik.copyWith(color: Colors.black))),
                  ),
                  spacer(),
                ]
              ],
            ),
          )
            .animate(autoPlay: true)
            .fadeIn(
                duration: Duration(milliseconds: 300),
                begin: 0,
                curve: Curves.easeIn)
            .slideX(
                duration: Duration(milliseconds: 400),
                begin: -10,
                end: 0,
                curve: Curves.decelerate)
            .scaleX(
                duration: Duration(milliseconds: 300), begin: 0.8, end: 1.0);
  }
}

class SleekNotification extends StatelessWidget with Ui {
  SleekNotification(
      {super.key, this.notification, required this.closer, this.optionTitle});
  final String? notification;
  final String? optionTitle;

  ///This should be a function that essentially sets the message passed to this
  ///widget to null
  final void Function() closer;

  @override
  Widget build(BuildContext context) {
    // final width = maxWidth(context) * 0.92;
    return notification == null
        ? SizedBox.shrink()
        : SizedBox(
            width: maxWidth(context),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  width: maxWidth(context) * 0.9,
                  constraints: BoxConstraints(minHeight: 50, maxHeight: 200),
                  decoration: BoxDecoration(
                    color: athensGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(optionTitle ?? 'Note',
                                  style: small00.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              spacer(),
                              Text(notification!,
                                  style: rubik.copyWith(color: Colors.black)),
                            ],
                          ),
                        ),
                        spacer(x: 4),
                        GestureDetector(
                          onTap: closer,
                          child: Container(
                            decoration: BoxDecoration(
                                color: tiber, shape: BoxShape.circle),
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.close,
                                size: 25, color: Colors.white),
                          ),
                        ),
                        // spacer(),
                      ]),
                )
                    .animate(autoPlay: true)
                    .fadeIn(
                        duration: Duration(milliseconds: 500),
                        begin: 0,
                        curve: Curves.easeIn)
                    .slideY(
                        duration: Duration(milliseconds: 400),
                        begin: 10,
                        end: 0,
                        curve: Curves.decelerate)
                    .scaleX(
                        duration: Duration(milliseconds: 300),
                        begin: 0.6,
                        end: 1.0),
              ),
            ),
          );
  }
}
