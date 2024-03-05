// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/placeholders/placeholders.dart';
import 'package:qeasily/styles.dart';
import 'package:shimmer/shimmer.dart';

class IndexSubScreen extends ConsumerStatefulWidget {
  const IndexSubScreen({super.key});
  @override
  ConsumerState<IndexSubScreen> createState() => _IndexSubScreenState();
}

class _IndexSubScreenState extends ConsumerState<IndexSubScreen> with UIStyles {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        color: Colors.transparent,
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: _IndexShimmer(),
          // child: CustomScrollView(
          //   slivers: [],
          // )
        ),
      );
    });
  }
}


class _IndexShimmer extends StatelessWidget with UIStyles {
  _IndexShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFFD6D6D6),
      highlightColor: Colors.white,
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
