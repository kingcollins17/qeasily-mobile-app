// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with Ui {
  final searchTextController = TextEditingController();
  String? query;

  bool isFocused = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            spacer(),
            _searchBar(),
            spacer(y: 10),
            StoreConnector<QeasilyState, SearchViewModel>(
              builder: (context, vm) {
                final _filter = query == null
                    ? vm.state.queries
                    : vm.state.queries
                        .where((arg) =>
                            arg.toLowerCase().contains(query!.toLowerCase()))
                        .toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (vm.state.isLoading)
                        Shimmer.fromColors(
                            baseColor: Colors.transparent,
                            highlightColor: Colors.grey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spacer(),
                                shimmer(w: maxWidth(context) * 0.3, h: 10),
                                spacer(y: 10),
                                shimmer(w: maxWidth(context) * 0.9, h: 10),
                                spacer(y: 10),
                                shimmer(h: 70, w: maxWidth(context) * 0.9)
                              ],
                            )),
                      if (vm.state.queries.isNotEmpty && !vm.state.isLoading)
                        ...List.generate(
                            _filter.length,
                            (index) => InkWell(
                                  overlayColor: MaterialStatePropertyAll(
                                      Color(0x39818181)),
                                  onTap: () => vm.dispatch(search(
                                    dio: ref.read(generalDioProvider),
                                    query: _filter[index],
                                    page: PageData(page: 1),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 20,
                                          color: athensGray,
                                        ),
                                        spacer(x: 15),
                                        Text(_filter[index], style: mukta),
                                      ],
                                    ),
                                  ),
                                )),
                      spacer(y: 20),
                      if (vm.state.topicsResult != null &&
                          vm.state.topicsResult!.isNotEmpty &&
                          !vm.state.isLoading) ...[
                        Text('Topics search Results', style: small00),
                        spacer(y: 10),
                        ...List.generate(
                            vm.state.topicsResult?.length ?? 0,
                            (index) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  width: maxWidth(context),
                                  decoration: BoxDecoration(
                                    color: Ui.black00,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vm.state.topicsResult![index].title,
                                        style: small00,
                                      ),
                                      Text(
                                        '${vm.state.topicsResult![index].level} Level',
                                        style: xs00,
                                      )
                                    ],
                                  ),
                                )),
                      ]
                    ],
                  ),
                );
              },
              converter: (store) => SearchViewModel(store),
            ),
            spacer(y: 300),
          ],
        ),
      ),
    );
  }

  Container _searchBar() {
    return Container(
      width: maxWidth(context),
      height: 80,
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
          StoreConnector<QeasilyState, SearchViewModel>(
              converter: (store) => SearchViewModel(store),
              builder: (context, vm) {
                return GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      vm.dispatch(search(
                        dio: ref.read(generalDioProvider),
                        query: query!,
                        page: PageData(page: 1, perPage: 50),
                      ));
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white));
              }),
          spacer(x: 10),
          vDivider(),
          spacer(x: 10),
          Expanded(
            // height: 48,
            // width: maxWidth(context) * 0.8,
            child: TextField(
              controller: searchTextController,
              onTap: () => setState(() {
                isFocused = true;
              }),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
                isFocused = false;
              },
              onChanged: (value) => setState(() => query = value),
              cursorHeight: 20,
              cursorColor: Color(0xA29E9E9E),
              style: small00,
              decoration: InputDecoration(
                  hintText: 'Enter any keyword', border: InputBorder.none),
            ),
          ),
          spacer(),
          Icon(Icons.search, color: Colors.white),
          spacer(x: 15),
        ],
      ),
    );
  }
}
