// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_element

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/placeholders/placeholders.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/screen/sub/search_screen.dart';
import 'package:qeasily/styles.dart';
import 'package:shimmer/shimmer.dart';

class IndexSubScreen extends ConsumerStatefulWidget {
  const IndexSubScreen({super.key});
  @override
  ConsumerState<IndexSubScreen> createState() => _IndexSubScreenState();
}

class _IndexSubScreenState extends ConsumerState<IndexSubScreen> with Ui {
  int currentCategoryIndex = 0;

  var previous = _Filter.quiz;
  var filter = _Filter.quiz;
  final scrollCtrl = ScrollController();

  //Whether this widget was just mounted
  bool justMountedQuiz = true, justMountedTopics = true, justMountedChg = true;

  bool atBottom(ScrollController controller) =>
      controller.position.pixels == controller.position.maxScrollExtent;

  _quizScrollListener(ScrollController ctrl, QuizVM vm) {
    if (atBottom(ctrl) && filter == _Filter.quiz) {
      vm.dispatch(QuizAction(
        type: QuizActionType.fetch,
        payload: ref.read(generalDioProvider),
      ));
    }
  }

  _topicScrollListener(ScrollController controller, TopicVM vm) {
    if (filter == _Filter.topics && atBottom(controller)) {
      vm.dispatch(TopicAction(
          type: TopicActionType.fetch, payload: ref.read(generalDioProvider)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final user = ref.watch(userAuthProvider);

    return Material(
      color: Theme.of(context).colorScheme.background,
      child: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          child: Column(children: [
            spacer(y: 25),
            Row(
              children: [
                spacer(x: 15),
                GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Icon(Icons.menu_rounded)),
                spacer(x: 10),
                _searchBar(),
                spacer(),
                Icon(Icons.filter_alt),
                spacer(),
                user.when(
                    data: (data) => Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tiber,
                          ),
                          child: Text(
                            data.email[0],
                            style: small00,
                          ),
                        ),
                    error: (_, __) => Center(child: Text('_')),
                    loading: () => Text('')),
              ],
            ),
            _filterList(),
            spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 600),
                reverse: previous.index > filter.index,
                transitionBuilder:
                    (child, primaryAnimation, secondaryAnimation) =>
                        SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: Container(color: Colors.transparent, child: child),
                ),
                child: _filterContent(filter),
              ),
            ),
            spacer(y: 30)
          ]),
        ),
      ),
    );
  }

  Widget _topicContent() => StoreConnector<QeasilyState, TopicVM>(
        key: ValueKey(filter),
        builder: (context, vm) {
          if (justMountedTopics) {
            vm.dispatch(
              TopicAction(
                  type: TopicActionType.fetch,
                  payload: ref.read(generalDioProvider)),
            );
            //add scroll listener
            scrollCtrl.addListener(() {
              _topicScrollListener(scrollCtrl, vm);
            });
          }
          justMountedTopics = false;
          return vm.state.topics.isEmpty && vm.state.isLoading
              ? _defaultShimmer(context)
              : Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...vm.state.topics.map(
                      (topic) => Padding(
                        key: ValueKey(topic.id),
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          constraints: BoxConstraints(minHeight: 70),
                          width: maxWidth(context) * 0.92,
                          decoration: BoxDecoration(
                              // color: Ui.black01
                              color: Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x73000000),
                                    offset: Offset(2, 4),
                                    blurRadius: 3)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(topic.title, style: small00),
                              spacer(y: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Level', style: xs01),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                          children: List.generate(
                                              (int.parse(topic.level) / 100)
                                                  .ceil(),
                                              (index) =>
                                                  Icon(Icons.star, size: 10))),
                                      Text('${topic.level} level', style: xs01)
                                    ],
                                  ),
                                ],
                              ),
                              Text(() {
                                final temp = topic.description;
                                return temp.length > 20
                                    ? '${temp.substring(0, 20)}...'
                                    : temp;
                              }(), style: xs01)
                            ],
                          ),
                        ),
                      ),
                    ),
                    spacer(y: 10),
                    if (vm.state.topics.isNotEmpty && vm.state.isLoading)
                      SpinKitThreeBounce(size: 35, color: Colors.white),
                    spacer(y: 100),
                    if (vm.state.page.hasNextPage)
                      GestureDetector(
                          onTap: () => vm.dispatch(TopicAction(
                                type: TopicActionType.fetch,
                                payload: ref.read(generalDioProvider),
                              )),
                          child: _viewMore()),
                  ],
                );
        },
        converter: (store) => TopicVM(store),
      );

  // Widget

  Widget _quizContent() => StoreConnector<QeasilyState, QuizVM>(
      key: ValueKey(filter),
      converter: (store) => QuizVM(store),
      builder: (context, vm) {
        if (justMountedQuiz) {
          vm.dispatch(
            QuizAction(
                type: QuizActionType.fetch,
                payload: ref.read(generalDioProvider)),
          );
          scrollCtrl.addListener(() => _quizScrollListener(scrollCtrl, vm));
        }
        justMountedQuiz = false;

        return vm.state.quizzes.isEmpty && vm.state.isLoading
            ? _defaultShimmer(context)
            : Column(
                children: [
                  ...vm.state.quizzes.map((e) => GestureDetector(
                      onTap: () => push(QuizDetailScreen(data: e), context),
                      child: _quizItem(e))),
                  spacer(y: 10),
                  if (vm.state.quizzes.isNotEmpty && vm.state.isLoading)
                    SpinKitThreeBounce(color: Colors.white, size: 35),
                  if (vm.state.page.hasNextPage)
                    GestureDetector(
                      onTap: () => vm.dispatch(QuizAction(
                          type: QuizActionType.fetch,
                          payload: ref.read(generalDioProvider))),
                      child: _viewMore(),
                    )
                ],
              );
      });

  Container _viewMore() => Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: primary.withOpacity(0.3)),
        child: Text('View more', style: xs00),
      );

  Widget _defaultShimmer(BuildContext context) {
    return Container(
      color: Ui.black00,
      child: Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Color(0xB8979797),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmer(h: 15),
                spacer(y: 10),
                shimmer(w: 40, h: 10),
                spacer(y: 8),
                shimmer(w: maxWidth(context), h: 100),
              ],
            ),
          )),
    );
  }

  Padding _quizItem(QuizData quiz) => Padding(
        key: ValueKey(quiz.id),
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          // height: 100,
          constraints: BoxConstraints(minHeight: 110),
          decoration: BoxDecoration(
              color: darkShade,
              borderRadius: BorderRadius.circular(8),
              // color: Ui.black01,
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    color: Color(0xCE000000),
                    offset: Offset(2, 4))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 50),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: raisingBlack,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ...List.generate(
                          switch (quiz.difficulty) {
                            'Hard' => 3,
                            'Medium' => 2,
                            'Easy' => 1,
                            _ => 0,
                          },
                          (index) =>
                              Icon(Icons.star, color: jungleGreen, size: 12),
                        ),
                        spacer(),
                        Text(quiz.difficulty, style: xs01),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.query_builder_outlined,
                          size: 10,
                          color: Colors.grey,
                        ),
                        spacer(x: 6),
                        Text(
                          '${Duration(seconds: quiz.duration).inMinutes} Minutes',
                          style: xs01,
                        )
                      ],
                    ),
                  ],
                ),
              ),
             
              spacer(y: 10),
              Row(
                children: [
                  Text(quiz.title, style: small00),
                ],
              ),
              spacer(y: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Questions: ', style: xs01),
                  Text('${quiz.questionsAsInt.length} Questions', style: xs00),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Type: ', style: xs01),
                  Text(
                    () {
                      final temp = quiz.type;
                      return temp == 'mcq'
                          ? 'Multiple Choice'
                          : 'True or False';
                    }(),
                    style: xs00,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _filterContent(_Filter filter) {
    Widget widget = SizedBox();
    switch (filter) {
      case _Filter.quiz:
        widget = _quizContent();
        break;
      case _Filter.topics:
        widget = _topicContent();
      case _Filter.categories:
        widget = _categoriesList();
        break;
      case _Filter.challenges:
        widget = _challengeContent();
        break;
      default:
        break;
    }
    return widget;
  }

  SizedBox _filterList() {
    return SizedBox(
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...List.generate(
                _Filter.values.length,
                (index) => GestureDetector(
                      onTap: () => setState(() {
                        previous = filter;
                        filter = _Filter.values[index];
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            height: 40,
                            constraints: BoxConstraints(minWidth: 100),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: index == (filter.index)
                                            ? jungleGreen
                                            : Color(0x7F5A5A5A))
                                    // width: index == (filter.index) ? 0.8 : 0.4,
                                    ),
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              () {
                                final name = _Filter.values[index].name;
                                return name[0].toUpperCase() +
                                    name.substring(1);
                              }(),
                              style: index == (filter.index) ? small00 : mukta,
                            ),
                          ),
                        ),
                      ),
                    ))
          ],
        ));
  }

  Widget _categoriesList() {
    // return c-wh
    final temp = ref.read(categoriesProvider);
    return temp.when(
        data: (data) => SizedBox(
              key: ValueKey(filter),
              width: maxWidth(context),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...data.map((e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  // color: Color(0xFF111111),
                                  ),
                              child: Text(e.name, style: small00)),
                        ))
                  ]),
            ),
        error: (_, __) => Center(
                child: Text(
              'Please check your internet connection and try again!',
              style: small10,
            )),
        loading: () => _defaultShimmer(context));
  }

  Widget _challengeContent() => StoreConnector<QeasilyState, ChallengeVM>(
      key: ValueKey(filter),
      builder: (context, vm) {
        if (justMountedChg) {
          vm.dispatch(
            ChallengeAction(
              type: ChgActionType.fetch,
              payload: ref.read(generalDioProvider),
            ),
          );
        }
        justMountedChg = false;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (vm.state.challenges.isEmpty && vm.state.isLoading)
              _defaultShimmer(context),
            if (vm.state.challenges.isNotEmpty)
              ...vm.state.challenges.map((e) => Padding(
                    key: ValueKey(e.id),
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                      width: maxWidth(context) * 0.9,
                      constraints: BoxConstraints(minHeight: 80),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                          color: darkShade,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              offset: Offset(2, 4),
                              color: Color(0x47000000),
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(children: [],),
                          spacer(y: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.name, style: small00),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFA13131),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.query_builder,
                                        size: 10, color: athensGray),
                                    spacer(),
                                    Text(() {
                                      final temp = e.dateAdded
                                          .difference(DateTime.now())
                                          .inDays;
                                      return temp > 1
                                          ? 'Ended'
                                          : 'Ends in $temp Days';
                                      // return e.duration.toString();
                                    }(), style: mukta),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          spacer(y: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Icon(Icons.monetization_on, size: 10),
                              Text('Entry Fee: ', style: xs01),
                              Text('${e.paid ? e.entryFee : "Free"}',
                                  style: xs00),
                            ],
                          ),
                          spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text('Type', style: xs01),
                              // spacer(),
                              // Divider(color: Colors.grey, height: 10),
                              Icon(Icons.subscriptions_rounded,
                                  size: 20, color: athensGray),
                              spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
                                decoration: BoxDecoration(
                                    color: raisingBlack,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                    e.paid
                                        ? 'Paid Challenge'
                                        : 'Free Challenge',
                                    style: xs01),
                              ),
                            ],
                          ),
                          
                          
                        ],
                      ),
                    ),
                  )),
          ],
        );
      },
      converter: (store) => ChallengeVM(store));

  Widget _searchBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => push(SearchScreen(), context),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0x366D6D6D)),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 16, color: Colors.white),
              spacer(x: 6),
              Text('Search any keyword', style: mukta)
            ],
          ),
        ),
      ),
    );
  }
}

enum _Filter { quiz, challenges, topics, categories }
