// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:qeasily/styles.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay(
      {super.key, required this.duration, this.onElapse, this.controller});

  final Duration duration;
  final VoidCallback? onElapse;
  final TimerController? controller;

  @override
  State<TimerDisplay> createState() => TimerDisplayState();
}

class TimerDisplayState extends State<TimerDisplay> with Ui {
  // late AnimationController _controller;

  late int seconds;

  bool hasRunOnElapse = false;

  // late Stream<int> eventStream;

  late TimerController timerController;
  void addTime(int time) => setState(() {
        seconds += time;
      });

  void subtractTime(int time) => seconds > time
      ? setState(() {
          seconds -= time;
        })
      : null;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
    seconds = widget.duration.inSeconds;
    //start the timer

    timerController = widget.controller ?? TimerController();
    timerController.init(this);

    // eventStream = Stream.periodic(Duration(seconds: 1));
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      setState(() {
        seconds = widget.duration.inSeconds;
      });
    }
  }

  // Stream<void> startTimer() async* {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: Stream.periodic(Duration(seconds: 1), (event) => event),
        builder: (context, snapshot) {
          if (seconds >= 1) {
            seconds -= (snapshot.hasData ? 1 : 0);
          } else if (widget.onElapse != null && !hasRunOnElapse) {
            hasRunOnElapse = true;
            Future.delayed(
              Duration(milliseconds: 1400),
              () => widget.onElapse!(),
            );
          }

          return Container(
            // width: maxWidth(context) * 0.9,
            decoration: BoxDecoration(),
            child: Text(_parse(seconds).toString(), style: rubik),
          );
        });
  }
}

class TimerController {
  TimerDisplayState? state;
  TimerController();

  void init(TimerDisplayState widgetState) => state = widgetState;
  void addTime(int seconds) => state?.addTime(seconds);
  void subtractTime(int seconds) => state?.subtractTime(seconds);
}

String _parse(int seconds) {
  const secPerHour = 3600;
  const secPerMin = 60;
  var secondsLeft = seconds;
  //calculate
  final hours = (seconds / secPerHour).floor();
  secondsLeft = (seconds - (hours * secPerHour));
  final mins = (secondsLeft / secPerMin).floor();
  secondsLeft = (secondsLeft - (mins * secPerMin));
  //Parse into string
  final h = hours < 10 ? '0$hours' : '$hours';
  final m = mins < 10 ? '0$mins' : '$mins';
  final s = secondsLeft < 10 ? '0$secondsLeft' : '$secondsLeft';

  return '$h:$m:$s';
  // return (hours.toString(), mins.toString(), secondsLeft.toString());
}
