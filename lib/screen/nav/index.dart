// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/placeholders/placeholders.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/styles.dart';
import 'package:shimmer/shimmer.dart';

class IndexSubScreen extends ConsumerStatefulWidget {
  const IndexSubScreen({super.key});
  @override
  ConsumerState<IndexSubScreen> createState() => _IndexSubScreenState();
}

class _IndexSubScreenState extends ConsumerState<IndexSubScreen> with Ui {
  int currentCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        color: Ui.black00,
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: categories.when(
              data: (data) => SingleChildScrollView(
                    child: Column(
                      children: [
                        _catList(data),
                        // FutureBuilder(
                        //   future: fetchTopics(
                        //       ref.read(generalDioProvider), PageData(page: 1),
                        //       useFollowing: false,
                        //       categoryId: data[currentCategoryIndex].id),
                        //   builder: (context, snapshot) => snapshot.hasData
                        //       ? Padding(
                        //           padding: const EdgeInsets.all(20.0),
                        //           // child: Text('${snapshot.data}'),
                        //           child: Column(
                        //             children: [
                        //               Text('${snapshot.data}'),
                        //             ],
                        //           ),
                        //         )
                        //       : Text('Loading ...'),
                        // ),
                        StoreConnector<QeasilyState, TopicVM>(
                            builder: (context, vm) => _topicList(vm, data),
                            converter: (store) => TopicVM(store))
                      ],
                    ),
                  ),
              error: (_, __) => Center(
                    child: Text('$_'),
                  ),
              loading: () => Center()),
          // child: _IndexShimmer(),
        ),
      );
    });
  }

  Padding _topicList(TopicVM vm, List<CategoryData> data) {
    const count = 3;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          spacer(y: 10),
          ...List.generate(
              vm.state.topics.length > count ? count : vm.state.topics.length,
              (index) => _topicItem(
                    vm.state.topics[index],
                    data,
                  )),
          spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              spacer(),
              Text('View all >', style: small01),
            ],
          ),
          spacer(y: 100)
        ],
      ),
    );
  }

  Container _topicItem(TopicData topic, List<CategoryData> categories) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(
        minHeight: 60,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: Color(0xFF131313),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(3, 4),
              color: Color(0x2C222222),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.title,
            style: medium00,
          ),
          spacer(y: 10),
          Text('${topic.level} Level', style: small01),
          Text(
              categories
                  .firstWhere((element) => element.id == topic.categoryId)
                  .name,
              style: small01)
        ],
      ),
    );
  }

  Widget _catList(List<CategoryData> data) {
    return StoreConnector<QeasilyState, TopicVM>(
        converter: (store) => TopicVM(store),
        builder: (context, vm) {
          return SizedBox(
            height: 50,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                data.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() => currentCategoryIndex = index);
                    vm.dispatch(
                      TopicAction(
                          type: TopicActionType.selectCategory,
                          payload: data[currentCategoryIndex].id),
                    );
                    vm.dispatch(TopicAction(
                      type: TopicActionType.fetch,
                      // payload: ref.read(generalDioProvider),
                    ));
                  },
                  child: _catBoxItem(data[index],
                      selected: index == currentCategoryIndex),
                ),
              ),
            ),
          );
        });
  }

  Padding _catBoxItem(CategoryData data, {bool selected = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
              color: Ui.black00,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(blurRadius: 3, color: Color(0x4EDF40FB))],
              gradient:
                  selected ? LinearGradient(colors: [blue10, purple1]) : null),
          child: Text(data.name, style: small01)),
    );
  }
}

class _IndexShimmer extends StatelessWidget with Ui {
  _IndexShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFF313131),
      highlightColor: Color(0xFF4D4D4D),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              // spacer(),
              spacer(),
              CategoriesPlaceholder(),
              spacer(),
              ContentPlaceholder(),
              spacer(y: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(color: Colors.white, height: 20, width: 60)),
              spacer(),
              ContentPlaceholder(),
              spacer(),
              ContentPlaceholder()
            ],
          ),
        ),
      ),
    );
  }
}
