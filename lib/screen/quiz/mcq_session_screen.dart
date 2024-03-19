// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

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

    _notify('Fetching Questions ...', loading: true);
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
  }

  void _goToPreviousQuest() {
    if (mcqs != null && currentQuestionIndex - 1 >= 0) {
      setState(() => currentQuestionIndex -= 1);
    }
  }

  dynamic animateToQuestion(double itemExtent, int index) {
    //total item count
    final itemCount = options.length;
    final totalWidth = itemCount * itemExtent;
    final screen = maxWidth(context);
    final position = itemExtent * index;
    var scrollExtent = 0.0;

    if ((totalWidth - position) > screen) {
      scrollExtent = position - (screen / 2);
    } else if (position < screen) {}

    // scrollController.offset = 0;
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
        appBar: AppBar(automaticallyImplyLeading: false),
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
              if (mcqs != null && !isLoading)
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
                          child: Text(mcqs![currentQuestionIndex].query,
                              style: small00)),
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
              spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _goToPreviousQuest,
                    child: Text('Previous'),
                  ),
                  FilledButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              primary.withOpacity(0.3)),
                          foregroundColor:
                              MaterialStatePropertyAll(Color(0xFFF0F0F0))),
                      onPressed: goToNextQuestion,
                      child: Text('Next Question', style: mukta))
                ],
              ),
              spacer(y: 20),
              _pointerList(),
              spacer(y: 60),
              // Text(parseQuestions(widget.data.questions).toString())
            ]),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        width: maxWidth(context),
        child: Center(
          child: OutlinedButton(
              style: ButtonStyle(
                // backgroundColor: MaterialStatePropertyAll(Color(0xFF00AA58)),
                foregroundColor: MaterialStatePropertyAll(primary),
              ),
              // onPressed: _fetchNextPage,
              onPressed: () {
                animateToQuestion(pointerWidth, currentQuestionIndex);
              },
              child: Text('Submit', style: medium00)),
        ),
      )
    ], notification);
  }

  String _option(int idx) {
    var opt = '';
    switch (idx) {
      case 0:
        opt = mcqs![currentQuestionIndex].A;
        break;
      case 1:
        opt = mcqs![currentQuestionIndex].B;
        break;
      case 2:
        opt = mcqs![currentQuestionIndex].C;
        break;
      case 3:
        opt = mcqs![currentQuestionIndex].D;
        break;
      default:
        break;
    }
    return opt;
  }

  SizedBox _pointerList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
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
                        color: options[index] != null
                            ? primary
                            : Color(0xFF363636),
                        border: Border.all(
                          color: index == currentQuestionIndex
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        )),
                    child: Center(child: Text('${index + 1}', style: small00)),
                  ),
                ),
              )),
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
