// ignore_for_file: prefer_const_constructors, unused_element, unused_field, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qeasily/styles.dart';

class LocalNotification extends AnimatedWidget with Ui {
  LocalNotification(
      {Key? key,
      required Animation<double> animation,
      this.message,
      this.child,
      this.borderRadius,
      this.color,
      this.backgroundColor})
      : super(key: key, listenable: animation);

  final String? message;
  final BorderRadius? borderRadius;
  final Color? backgroundColor, color;
  final Widget? child;

  @override
  build(BuildContext context) {
    Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: animation.drive(_opacity).value,
      child: Transform.translate(
        offset: animation.drive(_position).value,
        child: Transform.scale(
            scaleX: animation.drive(_scale).value,
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: message != null &&
                              child == null &&
                              backgroundColor == null
                          ? Theme.of(context).colorScheme.background
                          : backgroundColor,
                      borderRadius: borderRadius ?? BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            offset: Offset(2, 3),
                            color: Color(0x3B000000))
                      ]),
                  child: child ??
                      Text(
                        message ?? 'LocalNotification',
                        textAlign: TextAlign.center,
                        style: mukta,
                      ),
                ),
              ),
            )),
      ),
    );
  }
}

Future<void> showNotification(AnimationController controller,
    [int delay = 5]) async {
  controller.reset();
  controller.duration = const Duration(milliseconds: 300);
  controller.reverseDuration = Duration(milliseconds: 150);
  await controller.forward();

  await Future.delayed(Duration(seconds: delay));
  return controller.reverse();
}

final _scale = Tween<double>(begin: 0.9, end: 1)
    .chain(CurveTween(curve: Curves.easeInOutCubic));
final _opacity =
    Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.decelerate));
final _position = Tween<Offset>(begin: Offset(0, 20), end: Offset.zero)
    .chain(CurveTween(curve: Curves.decelerate));
