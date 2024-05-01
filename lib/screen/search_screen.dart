// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/provider/provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with Ui {
  final textController = TextEditingController();
  String? query;
  // bool isFocused = true;

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(searchProvider(query ?? ''));
    return StoreConnector<QeasilyState, SearchViewModel>(
        converter: (store) => SearchViewModel(store),
        builder: (context, vm) {
          return SafeArea(
            child: Material(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  spacer(),
                  _searchBar(),
                  spacer(y: 10),
                  if (query == null ||
                      query!.isEmpty ||
                      (search.hasValue && search.value!.$1.isEmpty))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 6),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          ...List.generate(
                              vm.state.history.length,
                              (index) => GestureDetector(
                                    onTap: () => setState(
                                        () => query = vm.state.history[index]),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: raisingBlack,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(vm.state.history[index],
                                          style: rubik.copyWith(
                                              fontSize: 14,
                                              color: Color(0xFFC5C5C5))),
                                    ),
                                  ))
                        ],
                      ),
                    ),

                  spacer(y: 10),
                  switch (search) {
                    AsyncData(value: (final quizzes, final topics)) =>
                      quizzes.isEmpty
                          ? NoDataNotification()
                          : Expanded(
                              child: ListView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              children: [
                                Text('Found ${quizzes.length} Quizzes',
                                    style: small00),
                                spacer(),
                                ...List.generate(
                                    quizzes.length,
                                    (index) =>
                                      GestureDetector(
                                        onTap: () => context.go('/home/session',
                                            extra: quizzes[index]),
                                        child: QuizItemWidget(
                                            quiz: quizzes[index]))),
                                spacer(y: 15),
                                Text('Found ${topics.length} topics',
                                    style: small00),
                                spacer(),
                                ...List.generate(
                                    topics.length,
                                    (index) =>
                                      GestureDetector(
                                        onTap: () => context
                                                .go('/home/quiz-list', extra: (
                                              id: topics[index].id,
                                              isCategory: false
                                            )),
                                        child: TopicItemWidget(
                                            topic: topics[index])))
                              ],
                            )),
                    AsyncError(:final error) => error
                            .toString()
                            .startsWith('DioException')
                        ? NetworkErrorNotification(
                            refresh: () => ref.refresh(SearchProvider(query!)),
                          )
                        : query == null
                            ? Center()
                            : ErrorNotificationHint(error: error),
                    AsyncLoading() => Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitDualRing(color: Colors.white, size: 30),
                            spacer(x: 15),
                            Text('searching for $query', style: rubik)
                          ],
                        ),
                      ),
                    _ => Center()
                  },

                  // spacer(y: 300),
                ],
              ),
            ),
          );
        });
  }

  Container _searchBar() {
    return Container(
      width: maxWidth(context),
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
                color: Color(0x47272727), blurRadius: 2, offset: Offset(3, 4))
          ]),
      child: Row(
        children: [
          spacer(x: 6),
          InkWell(
              onTap: () => context.go('/home'),
              overlayColor: MaterialStatePropertyAll(raisingBlack),
              child: Row(
                children: [
                  Ink(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  spacer(x: 10),
                  vDivider(),
                ],
              )),
          
          spacer(x: 10),
          Expanded(
            // height: 48,
            // width: maxWidth(context) * 0.8,
            child: TextField(
              autofocus: true,
              // autofillHints: ['Test', 'Physics'],
              // controller: searchTextController,
              // onTap: () => setState(() => isFocused = true),
              // onTapOutside: (event) => Future.delayed(Duration(seconds: 2), () {
              //   setState(() => isFocused = false);
              //   FocusScope.of(context).unfocus();
              // }),
              onChanged: (value) => query = value,
              cursorHeight: 20,
              cursorColor: Color(0xA29E9E9E),
              style: small00,
              decoration: InputDecoration(
                  hintText: 'Enter any keyword', border: InputBorder.none),
            ),
          ),
          // spacer(),
          // Icon(Icons.search, color: Colors.white),
          // spacer(x: 15),
        ],
      ),
    );
  }
}
