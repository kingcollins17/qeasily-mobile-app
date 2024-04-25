// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qeasily/styles.dart';

class GetPremiumIcon extends StatelessWidget with Ui {
  GetPremiumIcon({super.key, this.animationDuration, this.autoPlay = true});

  final Duration? animationDuration;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.diamond, color: Colors.yellowAccent, size: 25).animate(
        autoPlay: autoPlay,
        onInit: (controller) => controller.addListener(() {}),
        effects: [
          ShimmerEffect(
              colors: [vividOrange, Colors.yellowAccent],
              duration: Duration(milliseconds: 700))
        ]);
  }
}
