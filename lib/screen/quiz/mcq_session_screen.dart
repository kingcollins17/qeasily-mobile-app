// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, non_constant_identifier_names, use_build_context_synchronously, curly_braces_in_flow_control_structures, empty_statements

import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/screen/quiz/mcq_revision.dart';
import 'package:qeasily/screen/quiz/widget/widget.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/confirm_action.dart';

import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

import 'quiz_result_screen.dart';

class MCQSessionScreen extends ConsumerStatefulWidget {
  const MCQSessionScreen({super.key, this.data, this.savedSession})
      : assert(data != null || savedSession != null);
  final QuizData? data;
  final SavedMCQSession? savedSession;
  @override
  ConsumerState<MCQSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends ConsumerState<MCQSessionScreen>
    with SingleTickerProviderStateMixin, Ui {
  late AnimationController _controller;
  //controllers
  final scrollController = ScrollController();
  final timerController = TimerController();

  bool hasInitialized = false;
  bool showHelp = false;
  var canExit = false;

  final double pointerWidth = 55;

  LocalNotification? notification;

  //
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateToQuestion(int index) {
    final screen = maxWidth(context);
    final itemPosition = pointerWidth * index;
    var offset = (itemPosition - (screen * 0.35));
    if (itemPosition > screen * 0.5) {
      scrollController.animateTo(
        offset,
        // 10,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _notify(String message, {int delay = 5, bool? loading}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller, delay);
  }

  Widget _shimmer() => Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Color(0x7FFFFFFF),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: shimmer(h: 14, w: 100)),
          spacer(y: 10),
          shimmer(w: maxWidth(context) * 0.9, h: 60, br: 2),
          spacer(y: 35),
          ...List.generate(
              4,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        shimmer(circle: true, w: 20),
                        spacer(),
                        Expanded(child: shimmer(h: 35)),
                        spacer()
                      ],
                    ),
                  )),
        ],
      ));

  Future<bool> _submit(
      List<MCQData> questions, List<MCQOption?> choices, QuizData quiz,
      {bool forceSubmit = false}) async {
    bool? action = true;
    //if user is submitting before time is up
    if (!forceSubmit) {
      action = await showModal<bool>(
          context: context,
          builder: (context) => ConfirmAction(
                action: 'Are you sure you want to submit',
                onConfirm: () => Navigator.pop(context, true),
              ));
    }
    if (action == true) {
      final (:score, :total, :attempted, :incorrect) =
          markMCQQuiz(questions, choices, quiz.questionsAsInt.length);
      push<bool>(
              ResultScreen(
                  score: score,
                  total: total,
                  attempted: attempted,
                  incorrect: incorrect),
              context)
          .then((value) => value == true
              ? context.go('/home/mcq-revise', extra: (choices, questions))
              : context.go('/home', extra: widget.data));
    }
    return action ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<QeasilyState, SessionViewModel>(
        converter: (store) =>
            SessionViewModel(store, ref.read(generalDioProvider)),
        builder: (context, vm) {
          ///if this widget has been initalized, do nothing
          if (hasInitialized)
            ;
          else if (widget.data != null) {
            vm.init(widget.data!);
          } else if (widget.savedSession != null) {
            vm.restoreSession(widget.savedSession!);
          }
          //
          hasInitialized = true;

          //check if there is no session, return an error
          if (!vm.sessionState.inSession) {
            return ErrorNotificationHint(error: 'No session availalable');
          }
          // throw Exception('No session available when there should be!');

          final MCQSessionState(
            :questions,
            :quiz,
            :current,
            :choices,
            :timeLeft
          ) = vm.sessionState.session! as MCQSessionState;
          return stackWithNotifier([
            BackButtonListener(
              onBackButtonPressed: () async {
                if (canExit) {
                  context.go('/home');
                } else {
                  vm.save(timerController.seconds ?? 1800);
                  _notify('This session will be saved', delay: 2);
                  _notify('Press back again to exit');
                  canExit = true;
                }
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: FilledButton(
                    onPressed: () =>
                        _submit(questions, choices, quiz).then((value) {
                      if (value) vm.closeSession(quiz);
                    }),
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(jungleGreen)),
                    child: Text('submit', style: rubik),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.lock_clock,
                              size: 20, color: Color(0xC8FFFFFF)),
                          spacer(x: 6),
                          TimerDisplay(
                            style: big00,
                            duration: timeLeft!,
                            // duration: Duration(seconds: 10),
                            controller: timerController,
                            onElapse: () {
                              _submit(questions, choices, quiz,
                                      forceSubmit: true)
                                  .then(
                                (value) {
                                  vm.closeSession(quiz);
                                  // vm.removeSession(quiz);
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      if (vm.sessionState.isLoading)
                        _shimmer()
                      else if (vm.sessionState.session?.availableQuestions
                              .isNotEmpty ??
                          false) ...[
                        Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Questions ${vm.sessionState.session!.current + 1} '
                                  'of ${vm.sessionState.session?.quiz.questionsAsInt.length}',
                                  style: xs00,
                                ),
                              ),
                              spacer(y: 15),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: maxWidth(context) * 0.86,
                                    constraints: BoxConstraints(minHeight: 50),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: raisingBlack,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(questions[current].query,
                                        style: small00),
                                  )),
                              spacer(y: 35),
                            ],
                          ),
                        ),
                        spacer(y: 15),
                        // Text(vm.sessionState.session.toString()),
                        () {
                          final question = questions[current];
                          final options = [
                            question.A,
                            question.B,
                            question.C,
                            question.D
                          ];
                          return OptionSelector(
                            values: MCQOption.values,
                            selected: choices[current],
                            onSelect: (value) {
                              vm.pickOption(value, current);
                            },
                            converter: (value) => options[value.index],
                            deselect: () {
                              vm.unpickOption(current);
                            },
                          );
                        }(),
                        spacer(y: 50),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: vm.previous,
                              child: direction(),
                            ),
                            GestureDetector(
                                onTap: vm.next, child: direction(dir: 'right'))
                          ],
                        ),
                        spacer(y: 100),
                      ] //wrapped by condition (if list is not empty)
                    ]),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              width: maxWidth(context),
              child: Material(
                  child: Center(
                      child: SizedBox(
                          height: 60,
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              itemExtent: pointerWidth,
                              itemCount: vm.sessionState.session?.quiz
                                      .questionsAsInt.length ??
                                  0,
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () => vm.current = index,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 450),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: choices[index] != null
                                                ? jungleGreen
                                                : Color(0xFF363636),
                                            border: Border.all(
                                              color: current == index
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: 2,
                                            )),
                                        child: Center(
                                            child: Text('${index + 1}',
                                                style: small00)),
                                      ),
                                    ),
                                  ))))),
            ),
            Positioned(
              bottom: 20,
              child: SleekNotification(
                notification: vm.sessionState.message,
                closer: () => vm.clearNotification(),
              ),
            ),
            if (showHelp)
              Center(
                  child: TutorialHint(
                      title: 'Help',
                      message: quizSessionTutorial,
                      closer: () => setState(() => showHelp = false))),
            Positioned(
                right: 20,
                bottom: 80,
                child: ShowHelpWidget(
                  onPressHelp: () => setState(() => showHelp = !showHelp),
                ))
          ], notification);
        });
  }

  Center _confirmSubmission(BuildContext context) {
    return Center(
      child: Material(
          color: Colors.transparent,
          child: Container(
            width: maxWidth(context) * 0.9,
            // height: maxHeight(context) * 0.4,
            // height: 100,
            constraints: BoxConstraints(minHeight: 80, maxHeight: 100),
            decoration: BoxDecoration(
              color: woodSmoke,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                // spacer(y: 10),
                spacer(y: 20),
                Text('Are you sure you want to submit', style: small00),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Yes', style: mukta)),
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel', style: mukta))
                    ],
                  ),
                ),
                spacer(y: 10),
              ],
            ),
          )),
    );
  }
}
