// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/placeholders/placeholders.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
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

  var filter = _Filter.quiz;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return SafeArea(
      child: SizedBox(
        width: maxWidth(context),
        child: Material(
          color: Ui.black00,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(children: [
              spacer(y: 10),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(Icons.menu_rounded)),
                  spacer(x: 10),
                  _searchBar(),
                ],
              ),
              SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...List.generate(
                          _Filter.values.length,
                          (index) => GestureDetector(
                                onTap: () => setState(() {
                                  filter = _Filter.values[index];
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 350),
                                      height: 40,
                                      constraints:
                                          BoxConstraints(minWidth: 100),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: index == (filter.index)
                                                ? purple1
                                                : Colors.grey,
                                            width: index == (filter.index)
                                                ? 0.8
                                                : 0.4,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Text(
                                        () {
                                          final name =
                                              _Filter.values[index].name;
                                          return name[0].toUpperCase() +
                                              name.substring(1);
                                        }(),
                                        style: index == (filter.index)
                                            ? small00
                                            : small01,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  Align _searchBar() {
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
              Text('Search any keyword', style: small01)
            ],
          ),
        ),
      ),
    );
  }
}

enum _Filter { quiz, challenges, topics, categories }
