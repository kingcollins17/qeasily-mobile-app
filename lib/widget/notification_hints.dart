// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qeasily/styles.dart';
import 'package:go_router/go_router.dart';

class TutorialHint extends StatelessWidget with Ui {
  TutorialHint({super.key, this.message, this.title, required this.closer});
  final String? message, title;
  final void Function() closer;
  // final
  @override
  Widget build(BuildContext context) {
    final width = maxWidth(context) * 0.85;
    return message != null
        ? SizedBox(
            width: maxWidth(context),
            child: Material(
              color: Color(0x7D000000),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  header(
                    width: width,
                    color: jungleGreen,
                    label: title ?? 'Hint',
                    style: rubik,
                    icon: Icons.help,
                    closer: closer,
                  ),
                  _body(
                      width: width,
                      child: Text(
                        message!,
                        style: small00,
                      ),
                      color: raisingBlack)
                ],
              ),
            ),
          ).animate()
        : SizedBox.shrink();
  }
}

class ShowHelpWidget extends StatelessWidget with Ui {
  ShowHelpWidget({super.key, this.onPressHelp});
  final void Function()? onPressHelp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressHelp,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(shape: BoxShape.circle, color: athensGray),
        child:
            Center(child: Icon(Icons.help_sharp, color: deepSaffron, size: 30)),
      ),
    );
  }
}

class NetworkErrorNotification extends StatelessWidget with Ui {
  NetworkErrorNotification({super.key, this.message, required this.refresh});
  final String? message;
  final void Function() refresh;

  @override
  Widget build(BuildContext context) {
    final width = maxWidth(context) * 0.4;
    const msg = 'Oops!, something went wrong. Please check '
        'your internet connection and try again';
    return SizedBox(
      width: maxWidth(context),
      child: Column(
        children: [
          spacer(y: 30),
          SvgPicture.asset(
            'asset/undraw/no_internet.svg',
            width: width,
            height: width,
          ),
          spacer(y: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(message ?? msg,
                textAlign: TextAlign.center,
                style: small00.copyWith(fontSize: 14, color: Colors.grey)),
          ),
          spacer(),
          TextButton(
              onPressed: refresh,
              // onPressed: () => context.go('/'),
              child: Text('Try again', style: rubik))
        ],
      ),
    );
  }
}

class NoDataNotification extends StatelessWidget with Ui {
  NoDataNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final width = maxWidth(context) * 0.43;
    return SizedBox(
      width: maxWidth(context),
      child: Column(
        children: [
          spacer(y: 25),
          SvgPicture.asset(
            'asset/undraw/no_data.svg',
            width: width,
            height: width,
          ),
          spacer(),
          Text('Nothing to show!', style: small00.copyWith(fontSize: 18))
        ],
      ),
    );
  }
}

class ErrorNotificationHint extends StatelessWidget with Ui {
  ErrorNotificationHint({super.key, this.error, this.closer});
  final dynamic error;
  final void Function()? closer;
  @override
  Widget build(BuildContext context) {
    final width = maxWidth(context) * 0.85;
    // const errorMsg = 'Please check your internet connection and retry again';
    return SizedBox(
      width: maxWidth(context),
      child: Material(
        color: Color(0x8B000000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            header(
                width: width,
                style: rubik.copyWith(fontWeight: FontWeight.w600),
                label: 'Error',
                closer: closer),
            _body(
                width: width,
                child: Text(error.toString(), style: small00),
                color: raisingBlack)
          ],
        ),
      ),
    );
  }
}

class InfoHint extends StatelessWidget with Ui {
  InfoHint({super.key, required this.info});
  final String info;

  @override
  Widget build(BuildContext context) {
    final width = maxWidth(context) * 0.8;
    return SizedBox(
      width: maxWidth(context),
      child: Column(
        children: [
          header(
            width: width,
            icon: Icons.info_outline_rounded,
            style: rubik,
            color: jungleGreen,
            label: 'Note',
          ),
          _body(
              width: width,
              child: Text(info, style: small00),
              color: raisingBlack)
        ],
      ),
    ).animate();
  }
}

Widget _body({
  required double width,
  required Widget child,
  required Color color,
}) {
  return Container(
    width: width,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(color: color),
    child: child,
  );
}

Container header(
    {required double width,
    IconData icon = Icons.dangerous_outlined,
    Color color = Colors.redAccent,
    String label = 'Error',
    required TextStyle style,
    void Function()? closer}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    width: width,
    height: 35,
    decoration: BoxDecoration(color: color),
    child: Row(children: [
      Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      // spacer(),
      // Spacer(),
      SizedBox(width: 6),
      Text(
        label,
        style: style,
      ),
      Expanded(
        child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: closer,
              child: Icon(
                Icons.close,
                size: 20,
              ),
            )),
      )
    ]),
  );
}
