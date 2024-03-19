// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, non_constant_identifier_names

import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';

import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

import 'result_screen.dart';

class MCQSessionScreen extends ConsumerStatefulWidget {
  const MCQSessionScreen({super.key, required this.data});
  final QuizData data;
  @override
  ConsumerState<MCQSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends ConsumerState<MCQSessionScreen>
    with SingleTickerProviderStateMixin, Ui {
  late AnimationController _controller;
  //controllers
  final scrollController = ScrollController();
  final timerController = TimerController();

  var nextPage = PageData(page: 1, perPage: 2);

  var currentQuestionIndex = 0;

  final double pointerWidth = 55;

  List<MCQData>? mcqs;
  late List<MCQOption?> options;

  LocalNotification? notification;

  //
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _notify('Please wait ...', loading: true);
    options = List.generate(widget.data.questionsAsInt.length, (index) => null);
    fetchMCQQuestions(ref.read(generalDioProvider),
            page: nextPage, quiz_id: widget.data.id)
        .then((value) {
      mcqs = value.data;
      nextPage = value.page ?? nextPage;

      //if page has next, then advance page
      if (nextPage.hasNextPage) nextPage.next();
      _notify(value.detail, loading: false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToNextQuestion() {
    if (mcqs != null && currentQuestionIndex + 1 < mcqs!.length) {
      setState(() => currentQuestionIndex += 1);
    } else if (nextPage.hasNextPage) {
      _fetchNextPage().then((fetched) =>
          fetched ? setState(() => currentQuestionIndex += 1) : null);
    }
    animateToQuestion(currentQuestionIndex);
  }

  void _goToPreviousQuest() {
    if (mcqs != null && currentQuestionIndex - 1 >= 0) {
      setState(() => currentQuestionIndex -= 1);
      animateToQuestion(currentQuestionIndex);
    }
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

  Future<bool> _fetchNextPage() async {
    if (nextPage.hasNextPage) {
      _notify('Fetching next batch of questions', loading: true);
      final temp = await fetchMCQQuestions(
        ref.read(generalDioProvider),
        page: nextPage,
        quiz_id: widget.data.id,
      );
      //add fetched mcqs if its not empty
      temp.data.isNotEmpty ? mcqs?.addAll(temp.data) : null;
      if (temp.page != null) nextPage = temp.page!..next();
      _notify(temp.detail, delay: 3, loading: false);

      //
      // _notify(temp.page.toString());
      return temp.page != null;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
              onTap: () {
                showModal(context: context, builder: _confirmSubmission)
                    .then((value) {
                  if (value == true) {
                    Navigator.pop(context);
                    push(ResultScreen(mcqs: mcqs!, options: options), context);
                  }
                });
              },
              child: Text(widget.data.title, style: mukta)),
          actions: [
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(deepSaffron)),
              child: Text('Submit', style: small00),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.lock_clock, size: 20, color: Color(0xC8FFFFFF)),
                  spacer(x: 6),
                  TimerDisplay(
                    duration: Duration(seconds: widget.data.duration),
                    controller: timerController,
                    onElapse: () => timerController.addTime(10),
                  ),
                ],
              ),

              spacer(),
              if (isLoading) _shimmer(),
              // Text(currentPage.toString()),
              if (mcqs != null && !isLoading && mcqs!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Questions ${currentQuestionIndex + 1} '
                          'of ${widget.data.questionsAsInt.length}',
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
                            child: Text(mcqs![currentQuestionIndex].query,
                                style: small00),
                          )),
                      spacer(y: 35),
                      ...List.generate(
                          4,
                          (index) => GestureDetector(
                                onTap: () => setState(() {
                                  options[currentQuestionIndex] =
                                      MCQOption.convert(index);
                                }),
                                onDoubleTap: () => setState(() {
                                  options[currentQuestionIndex] = null;
                                }),
                                child: Container(
                                  width: maxWidth(context) * 0.9,
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  constraints: BoxConstraints(minHeight: 50),
                                  decoration: BoxDecoration(
                                    // color: Colors.green,
                                    border: Border.all(
                                      color: index ==
                                              options[currentQuestionIndex]
                                                  ?.index
                                          ? Colors.greenAccent
                                          : Colors.grey,
                                    ),
                                  ),
                                  child: Text(_option(index), style: mukta),
                                ),
                              ))
                    ],
                  ),
                ),
              spacer(y: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _goToPreviousQuest,
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                      vividOrange.withOpacity(0.5),
                    )),
                    child: Text('<', style: medium10),
                  ),
                  FilledButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              jungleGreen.withOpacity(0.8)),
                          foregroundColor:
                              MaterialStatePropertyAll(Color(0xFFF0F0F0))),
                      onPressed: goToNextQuestion,
                      child: Text('>', style: mukta))
                ],
              ),
              // spacer(y: 50),

              spacer(y: 60),
              // Text(parseQuestions(widget.data.questions).toString())
            ]),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        width: maxWidth(context),
        child: Material(child: Center(child: _pointerList())),
      ),
    ], notification);
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

  String _option(int idx) {
    var opt = switch (idx) {
      0 => mcqs![currentQuestionIndex].A,
      1 => mcqs![currentQuestionIndex].B,
      2 => mcqs![currentQuestionIndex].C,
      3 => mcqs![currentQuestionIndex].D,
      _ => mcqs![currentQuestionIndex].A
    };
    return opt;
  }

  SizedBox _pointerList() {
    return SizedBox(
      height: 60,
      child: (mcqs != null)
          ? ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 6),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemExtent: pointerWidth,
              itemCount: options.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => mcqs != null && (index < mcqs!.length)
                        ? setState(() {
                            currentQuestionIndex = index;
                          })
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: AnimatedContainer(
                        // width: 50,
                        // height: 50,
                        duration: const Duration(milliseconds: 450),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index > mcqs!.length - 1
                                ? tiber.withOpacity(0.4)
                                : options[index] != null
                                    ? jungleGreen
                                    : Color(0xFF363636),
                            border: Border.all(
                              color: index == currentQuestionIndex
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            )),
                        child:
                            Center(child: Text('${index + 1}', style: small00)),
                      ),
                    ),
                  ))
          : Text('No data yet', style: mukta),
    );
  }
}


Future<MCQResp> fetchMCQQuestions(Dio dio,
    {required PageData page, required int quiz_id}) async {
  try {
    final res = await dio.get(APIUrl.fetchQuizQuestions.url,
        data: page.toJson(), queryParameters: {'quiz_id': quiz_id});

    final _fetchedPage =
        res.statusCode == 200 ? PageData.fromJson(res.data['page']) : null;

    _fetchedPage?.hasNextPage = (res.data['has_next_page'] as bool?) ?? false;

    return (
      detail: res.data['detail'].toString(),
      data: (res.data['data'] as List).map((e) => MCQData.fromJson(e)).toList(),
      page: _fetchedPage
    );
  } catch (e) {
    return (detail: e.toString(), data: const <MCQData>[], page: null);
  }
}

typedef MCQResp = ({List<MCQData> data, String detail, PageData? page});
