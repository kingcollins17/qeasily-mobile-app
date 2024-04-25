// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_element, unused_local_variable, no_leading_underscores_for_local_identifiers, sort_child_properties_last

import 'package:animations/animations.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
// import 'package:qeasily/placeholders/placeholders.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/quiz_provider.dart';
import 'package:qeasily/provider/topics_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/view_model/quiz_vm.dart';
import 'package:qeasily/redux/view_model/topic_vm.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/screen/challenge/challenge.dart';
import 'package:qeasily/screen/quiz/quiz.dart';
import 'package:qeasily/screen/screen.dart';
import 'package:qeasily/screen/search_screen.dart';
import 'package:qeasily/styles.dart';

import 'package:qeasily/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

typedef _QuizProvider
    = AlwaysAliveProviderBase<AsyncValue<(List<QuizData>, PageData)>>;

class HomePageSubScreen extends ConsumerStatefulWidget {
  const HomePageSubScreen({super.key});
  @override
  ConsumerState<HomePageSubScreen> createState() => _IndexSubScreenState();
}

class _IndexSubScreenState extends ConsumerState<HomePageSubScreen> with Ui {
  ///When this is null, the suggestedQuizProvider is used
  CategoryData? selectedCategory;

  var previous = _Destination.quiz;
  var destination = _Destination.quiz;
  // final scrollController = ScrollController();
  String? notification;

  final pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final user = ref.watch(userAuthProvider);
    final quiz = ref.watch(selectedCategory != null
        ? quizByCategoryProvider(selectedCategory!.id)
        : suggestedQuizProvider);
    //
    if (selectedCategory != null) {
      ref.watch(topicsByCategoryProvider(selectedCategory!.id));
    }

    return Material(
      color: Theme.of(context).colorScheme.background,
      child: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(children: [
          spacer(y: 25),
          Row(
            children: [
              spacer(x: 12),
              GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Icon(Icons.menu_rounded)),
              spacer(x: 6),
              _searchBar(),
              spacer(),
              StoreConnector<QeasilyState, SessionViewModel>(
                builder: (context, vm) => Row(
                  children: [
                    circleWrap(vm.history.mcqSessions.length.toString()),
                    spacer(),
                    circleWrap(vm.history.dcqSessions.length.toString()),
                  ],
                ),
                converter: (store) =>
                    SessionViewModel(store, ref.read(generalDioProvider)),
              )
            ],
          ),
          _categories(),
          spacer(),
          _navList(),
          spacer(),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (page) => setState(() {
                destination = _Destination.values[page];
              }),
              children: [
                _quizzes(),
                _topics(),
              ],
            ),
          ),
          spacer(y: 30)
        ]),
      ),
    );
  }

  Widget _topics() {
    if (selectedCategory == null) {
      return NoDataNotification();
    } else {
      var _provider = topicsByCategoryProvider(selectedCategory!.id);
      final value = ref.read(_provider);
      return switch (value) {
        AsyncData(value: (final data, final page)) => EasyRefresh(
            onRefresh: () => ref.refresh(_provider),
            onLoad: () => ref.read(_provider.notifier).fetchNextPage(),
            child: data.isEmpty
                ? NoDataNotification()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    itemCount: data.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          context.go('/home/quiz-list',
                              extra: (id: data[index].id, isCategory: false));
                        },
                        child: TopicItemWidget(topic: data[index])),
                  ),
          ),
        AsyncLoading() => Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Shimmer.fromColors(
                child: Column(
                  children: List.generate(
                      4,
                      (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spacer(y: 15),
                              shimmer(
                                br: 4,
                              ),
                              spacer(y: 10),
                              shimmer(br: 4, h: 55, w: maxWidth(context) * 0.9)
                            ],
                          )),
                ),
                baseColor: Colors.transparent,
                highlightColor: Colors.grey),
          ),
        AsyncError(:final error) => Center(
            child:
                NetworkErrorNotification(refresh: () => ref.refresh(_provider)),
          ),
        _ => Center()
      };
    }
  }

  // Widget

  Widget _quizzes() {
    final provider = selectedCategory == null
        ? suggestedQuizProvider
        : quizByCategoryProvider(selectedCategory!.id);
    final value = ref.read(provider);
    return switch (value) {
      AsyncData(value: (final data, final page)) => EasyRefresh(
          onRefresh: () => ref.refresh(provider),
          onLoad: () =>
              ref.read((provider as dynamic).notifier).fetchNextPage(),
          child: data.isEmpty
              ? NoDataNotification()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                      onTap: () =>
                          context.go('/home/session', extra: data[index]),
                      child: QuizItemWidget(quiz: data[index])),
                ),
        ),
      AsyncLoading() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      5,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                shimmer(br: 4),
                                spacer(),
                                shimmer(
                                    h: 50, w: maxWidth(context) * 0.85, br: 4),
                                spacer()
                              ],
                            ),
                          ))
                ],
              )),
        ),
      AsyncError(:final error) => error.toString().startsWith('DioException')
          ? NetworkErrorNotification(refresh: () => ref.refresh(provider))
          : ErrorNotificationHint(error: error),
      _ => Center()
    };
  }

  Container _viewMore() => Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: primary.withOpacity(0.3)),
        child: Text('View more', style: xs00),
      );

  Widget _loadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Color(0xB8979797),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmer(h: 15),
              spacer(),
              shimmer(h: 10),
              spacer(),
              shimmer(w: maxWidth(context), h: 60),
            ],
          ),
        ));
  }

  Widget _navList() => Row(
        // scrollDirection: Axis.horizontal,
        children: [
          spacer(),
          ...List.generate(
              _Destination.values.length,
              (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          previous = destination;
                          destination = _Destination.values[index];
                        });
                        Future.delayed(Duration(milliseconds: 500), () {
                          pageController.animateToPage(index,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linearToEaseOut);
                        });
                      },
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
                                        color: index == (destination.index)
                                            ? jungleGreen
                                            : Color(0x7F5A5A5A))
                                    // width: index == (filter.index) ? 0.8 : 0.4,
                                    ),
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              () {
                                final name = _Destination.values[index].name;
                                return name[0].toUpperCase() +
                                    name.substring(1);
                              }(),
                              style: index == (destination.index)
                                  ? small00
                                  : mukta,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
          spacer(),
        ],
      );

  Widget _categories() {
    final data = ref.read(categoriesProvider);
    return switch (data) {
      AsyncData(:final value) => SizedBox(
          height: 45,
          child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              // itemCount: value.length,
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedCategory = null),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedCategory == null
                          ? tiber
                          : tiber.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6),
                    child: Text('For you', style: rubik),
                  ),
                ),
                spacer(x: 6),
                ...List.generate(
                  value.length,
                  (index) => GestureDetector(
                    onTap: () =>
                        setState(() => selectedCategory = value[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedCategory == value[index]
                            ? tiber
                            : tiber.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6),
                      child: Text(value[index].name, style: rubik),
                    ),
                  ),
                )
              ]),
        ),
      AsyncError(:final error) => Center(
          child: SleekNotification(
              optionTitle: 'Something went wrong!',
              notification: error.toString().startsWith('DioException')
                  ? 'Please check your internet connectivity'
                  : error.toString(),
              closer: () => ref.refresh(categoriesProvider)),
        ),
      AsyncLoading() => Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.grey,
          child: SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: List.generate(
                  6,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Center(child: shimmer(br: 4, h: 30, w: 80)),
                      )),
            ),
          )),
      _ => Center()
    };
  }

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

enum _Destination { quiz, topics }
