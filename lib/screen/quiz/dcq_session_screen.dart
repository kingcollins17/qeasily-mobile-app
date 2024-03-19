// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class DCQSessionScreen extends ConsumerStatefulWidget {
  const DCQSessionScreen({super.key, required this.data});
  final QuizData data;
  @override
  ConsumerState<DCQSessionScreen> createState() => _DCQSessionScreenState();
}

class _DCQSessionScreenState extends ConsumerState<DCQSessionScreen>
    with SingleTickerProviderStateMixin, Ui {
  //
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false, isPointerOpen = false;
  LocalNotification? notification;
  late AnimationController _controller;

  final timerController = TimerController();

  List<DCQData>? dcqs;
  late List<bool?> options;

  PageData currentPage = PageData(page: 1, perPage: 3);
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    options = List.generate(widget.data.questionsAsInt.length, (index) => null);
    _notify('Please wait', loading: true);

    fetchDCQQuestions(
      ref.read(generalDioProvider),
      widget.data.id,
      PageData(page: 1, perPage: 3),
    ).then((value) {
      dcqs = value.data;
      currentPage = value.page ?? currentPage;
      _notify(value.detail, loading: false);
    });
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

  void goToNext() async {
    if (dcqs != null &&
        currentQuestionIndex + 1 >= dcqs!.length - 1 &&
        currentPage.hasNextPage) {
      _notify('Please wait', loading: true);
      final (:data, :detail, :page) = await fetchDCQQuestions(
          ref.read(generalDioProvider), widget.data.id, currentPage..next());
      dcqs?.addAll(data);
      //if page has next, advance page pointer
      page != null && page.hasNextPage ? currentPage.next() : null;
      await _notify(detail, loading: false);
    }

    if (dcqs != null && currentQuestionIndex < dcqs!.length - 1) {
      setState(() {
        currentQuestionIndex += 1;
      });
    }
  }

  void goToPrevious() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        _notify('You cannot go back at this time!');
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(automaticallyImplyLeading: false),
        body: stackWithNotifier([
          Column(
            children: [
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Shimmer.fromColors(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        spacer(y: 15),
                        shimmer(),
                        spacer(y: 6),
                        shimmer(w: maxWidth(context), h: 40),
                        spacer(y: 10),
                        shimmer(w: maxWidth(context) * 0.8, h: 48),
                      ],
                    ),
                    baseColor: Colors.transparent,
                    highlightColor: Color(0xFF858585),
                  ),
                ),
              spacer(),
              if (!isLoading && dcqs != null && dcqs!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.lock_clock, size: 20, color: athensGray),
                          spacer(),
                          TimerDisplay(
                            duration: Duration(seconds: widget.data.duration),
                            controller: timerController,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Questions ${currentQuestionIndex + 1} of ${widget.data.questionsAsInt.length}',
                          style: mukta,
                        ),
                      ),
                      spacer(y: 15),
                      Container(
                        width: maxWidth(context),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        decoration: BoxDecoration(
                            color: raisingBlack,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(dcqs![currentQuestionIndex].query,
                            style: small00),
                      ),
                      spacer(y: 15),
                      ...List.generate(
                        2,
                        (index) => GestureDetector(
                          onTap: () => setState(() {
                            options[currentQuestionIndex] =
                                switch (index) { 0 => true, _ => false };
                          }),
                          onDoubleTap: () => setState(() {
                            options[currentQuestionIndex] = null;
                          }),
                          child: Container(
                            width: maxWidth(context),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            constraints: BoxConstraints(minHeight: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: switch (
                                        options[currentQuestionIndex]) {
                                      true when index == 0 => jungleGreen,
                                      false when index == 1 => jungleGreen,
                                      _ => Colors.grey
                                    },
                                    width: 2)),
                            child: Text(index == 0 ? 'True' : 'False',
                                style: mukta),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                              onPressed: goToPrevious,
                              icon: Icon(Icons.arrow_back_ios_new,
                                  size: 15, color: athensGray),
                              label: Text('Previous', style: mukta)),
                          ElevatedButton(
                              onPressed: () => goToNext(),
                              // icon: Icon(Icons.arrow_back_ios_new, size: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Next', style: mukta),
                                  spacer(),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 15, color: athensGray),
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
          if (isPointerOpen)
            Positioned(
                bottom: 1.5,
                child: _pointerList()
                    .animate(autoPlay: true)
                    .fadeIn(begin: 0.0, duration: Duration(milliseconds: 300))),
          Positioned(
              bottom: 20,
              right: 30,
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => isPointerOpen = !isPointerOpen),
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
              ))
        ], notification),
      ),
    );
  }

  Material _pointerList() {
    return Material(
        child: Container(
      height: maxHeight(context) * 0.5,
      width: maxWidth(context),
      decoration: BoxDecoration(
          color: Ui.black00,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [BoxShadow(color: Color(0x97000000), blurRadius: 4)]),
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
                    widget.data.questionsAsInt.length,
                    (index) => GestureDetector(
                          onTap: () => index < dcqs!.length
                              ? setState(() => currentQuestionIndex = index)
                              : null,
                          child: Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: index >= dcqs!.length
                                    ? tiber
                                    : options[index] != null
                                        ? blue10
                                        : raisingBlack,
                                border: Border.all(
                                    color: index == currentQuestionIndex
                                        ? athensGray
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Text('${index + 1}'))),
                        ))
              ],
            )
          ]),
        ),
      ),
    ));
  }
}

Future<DCQResp> fetchDCQQuestions(Dio dio, int quizId, PageData page) async {
  try {
    final res = await dio.get(
      APIUrl.fetchQuizQuestions.url,
      queryParameters: {'quiz_id': quizId},
      data: page.toJson(),
    );
    final {
      'detail': detail,
      'data': data,
      'has_next_page': hasNext,
      'page': fetchedPage
    } = res.data;
    return (
      detail: detail,
      data: (data as List).map((e) => DCQData.fromJson(e)).toList(),
      page: (PageData.fromJson(fetchedPage)..hasNextPage = hasNext)
    );
    // return res;
  } catch (e) {
    return (detail: e.toString(), data: const <DCQData>[], page: null);
  }
}

typedef DCQResp = ({List<DCQData> data, dynamic detail, PageData? page});
