// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously
import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/screen/quiz/dcq_revision.dart';
import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/screen/quiz/widget/option_selector.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/confirm_action.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class DCQSessionScreen extends ConsumerStatefulWidget {
  const DCQSessionScreen({super.key, this.data, this.savedDCQSession})
      : assert(!(data == null && savedDCQSession == null));
  final QuizData? data;
  final SavedDCQSession? savedDCQSession;
  @override
  ConsumerState<DCQSessionScreen> createState() => _DCQSessionScreenState();
}

class _DCQSessionScreenState extends ConsumerState<DCQSessionScreen>
    with SingleTickerProviderStateMixin, Ui {
  //
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var canExit = false;

  bool isLoading = false, isPointerOpen = false, hasInitialized = false;
  LocalNotification? notification;
  late AnimationController _controller;

  final timerController = TimerController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // options = List.generate(widget.data.questionsAsInt.length, (index) => null);
    // _notify('Please wait', loading: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _notify(String message, {int delay = 5, bool? loading}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller, delay);
  }

  void _submit(List<DCQData> questions, List<bool?> choices, QuizData quiz) {
    showModal<bool>(
        context: context,
        builder: (context) {
          return ConfirmAction(
              action: 'Are you sure you want to submit?',
              onConfirm: () => Navigator.pop(context, true));
        }).then((value) {
      if (value == true) {
        final (int score, int total, int attempted, int incorrect) =
            markDCQQuiz(questions, choices, quiz.questionsAsInt.length);
        push(
                ResultScreen(
                    score: score,
                    total: total,
                    attempted: attempted,
                    incorrect: incorrect),
                context)
            .then((value) {
          if (value == true) {
            context.go('/home/dcq-revise',
                extra: (questions: questions, choices: choices, quiz: quiz));
          } else {
            context.go('/home');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<QeasilyState, SessionViewModel>(
        converter: (store) =>
            SessionViewModel(store, ref.read(generalDioProvider)),
        builder: (context, vm) {
          if (hasInitialized) {
          } else if (widget.data != null) {
            vm.init(widget.data!);
            hasInitialized = true;
          } else if (widget.savedDCQSession != null) {
            vm.restoreSession(widget.savedDCQSession!);
            hasInitialized = true;
          }
          if (!vm.sessionState.inSession) {
            return _loadingShimmer(context);
          } else {
            final DCQSessionState(
              :choices,
              :questions,
              :current,
              :quiz,
            ) = vm.sessionState.session as DCQSessionState;
            return stackWithNotifier([
              BackButtonListener(
                onBackButtonPressed: () async {
                  if (canExit) {
                    context.go('/home');
                  } else {
                    vm.save(timerController.seconds ?? 1800);
                    _notify(
                        'This session will be saved. You can resume it later',
                        delay: 2);
                    _notify('Press back again to exit');
                    canExit = true;
                  }
                  return true; //child handles
                },
                child: Scaffold(
                  appBar:
                      AppBar(title: Text(''), automaticallyImplyLeading: false),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        spacer(),
                        if (questions.isEmpty && vm.sessionState.isLoading)
                          _loadingShimmer(context),
                        if (questions.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.lock_clock,
                                        size: 20, color: athensGray),
                                    spacer(),
                                    TimerDisplay(
                                      duration: Duration(seconds: 100),
                                      controller: timerController,
                                      style: big00,
                                    )
                                  ],
                                ),
                                spacer(y: 20),
                                // Text(choices.toString()),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Questions ${current + 1} of ${questions.length}',
                                    style: mukta,
                                  ),
                                ),
                                spacer(y: 15),
                                Container(
                                  width: maxWidth(context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: raisingBlack,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(questions[current].query,
                                      style: small00),
                                ),
                                spacer(y: 15),
                                OptionSelector(
                                    values: [true, false],
                                    converter: (value) =>
                                        value.toString().toUpperCase(),
                                    onSelect: (value) =>
                                        vm.pickOption(value, current),
                                    selected: choices[current],
                                    deselect: () => vm.unpickOption(current)),
                                spacer(y: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: vm.previous,
                                        child: direction(dir: 'left')),
                                    GestureDetector(
                                        onTap: vm.next,
                                        child: direction(dir: 'right')),
                                  ],
                                ),
                                // Text(vm.sessionState.toString()),
                                spacer(y: 20),
                              ],
                            ),
                          ),
                        spacer(y: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 20,
                  child: Center(
                      child: Material(
                          child: InkWell(
                              onTap: () => _submit(questions, choices, quiz),
                              borderRadius: BorderRadius.circular(6),
                              overlayColor:
                                  MaterialStatePropertyAll(jungleGreen),
                              child: Ink(
                                height: 42,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: jungleGreen.withOpacity(0.5),
                                ),
                                child: Center(
                                    child: Text('Submit', style: small10)),
                              ))))),
              if (isPointerOpen)
                Positioned(
                    bottom: 1.5,
                    child: Material(
                        child: Container(
                      height: maxHeight(context) * 0.4,
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                          color: darkerShade,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(color: Color(0x97000000), blurRadius: 4)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            spacer(y: 20),
                            Text('Pointers', style: mukta),
                            spacer(y: 20),
                            Wrap(
                              runSpacing: 6,
                              spacing: 6,
                              children: [
                                ...List.generate(
                                    choices.length,
                                    (index) => GestureDetector(
                                          onTap: () => vm.current = index,
                                          child: Container(
                                              width: 50,
                                              height: 50,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: choices[index] != null
                                                    ? jungleGreen
                                                    : raisingBlack,
                                                border: Border.all(
                                                    color: index == current
                                                        ? Colors.white
                                                        : Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                  child: Text('${index + 1}'))),
                                        ))
                              ],
                            )
                          ]),
                        ),
                      ),
                    )).animate(autoPlay: true).fadeIn(
                        begin: 0.0, duration: Duration(milliseconds: 300))),
              Positioned(
                  bottom: 20,
                  right: 30,
                  child: Center(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => isPointerOpen = !isPointerOpen),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: athensGray,
                            boxShadow: [
                              BoxShadow(color: Color(0x65555555), blurRadius: 3)
                            ]),
                        child: Transform.rotate(
                          angle: isPointerOpen ? (math.pi / 2) : -(math.pi / 2),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 21,
                            color: Ui.black01,
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  bottom: 20,
                  child: SleekNotification(
                    closer: vm.clearNotification,
                    notification: vm.sessionState.message,
                  ))
            ], notification);
          }
        });
  }

  Padding _loadingShimmer(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(18),
        child: Shimmer.fromColors(
            child: Column(
              children: [
                spacer(y: 40),
                shimmer(),
                spacer(),
                shimmer(h: 60, w: maxWidth(context) * 0.9, br: 4),
                spacer(),
                SpinKitRotatingCircle(color: athensGray)
              ],
            ),
            baseColor: Colors.transparent,
            highlightColor: Colors.grey));
  }
}

///Marks a double choice quiz
(int score, int total, int attempted, int incorrect) markDCQQuiz(
    List<DCQData> dcqs, List<bool?> choices,
    [int? total]) {
  var attempted = 0, score = 0;
  final totalAvailable = choices.length;
  for (var i = 0; i < dcqs.length; i++) {
    score += dcqs[i].correct == choices[i] ? 1 : 0;
  }

  return (
    score,
    total ?? totalAvailable,
    choices.where((element) => element != null).length,
    totalAvailable - score
  );
}
