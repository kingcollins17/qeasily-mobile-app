// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qeasily/styles.dart';

class ConfirmAction extends StatelessWidget with Ui {
  ConfirmAction(
      {super.key,
      required this.action,
      required this.onConfirm,
      this.positiveLabel,
      this.negativeLabel});
  final String action;
  final void Function() onConfirm;
  final String? positiveLabel, negativeLabel;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          child: Container(
            width: maxWidth(context) * 0.9,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: raisingBlack),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    action,
                    style: small00,
                    textAlign: TextAlign.center,
                  ),
                ),
                spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: onConfirm,
                        style: ButtonStyle(),
                        child: Text(positiveLabel ?? 'Yes', style: small00)),
                    spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(),
                        child: Text(negativeLabel ?? 'Cancel', style: mukta))
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
