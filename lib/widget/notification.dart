// ignore_for_file: prefer_const_constructors, unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalNotification extends AnimatedWidget {
  const LocalNotification(
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: message != null &&
                            child == null &&
                            backgroundColor == null
                        ? Color(0xFF111111)
                        : backgroundColor,
                    borderRadius: borderRadius ?? BorderRadius.circular(30),
                  ),
                  child: child ??
                      Text(
                        message ?? 'LocalNotification',
                        style: GoogleFonts.poppins(
                            color: message != null &&
                                    child == null &&
                                    color == null
                                ? Colors.white
                                : color),
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
  controller.duration = const Duration(milliseconds: 150);
  controller.reverseDuration = Duration(milliseconds: 100);
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
