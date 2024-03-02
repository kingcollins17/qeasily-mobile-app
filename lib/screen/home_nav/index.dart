// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexSubScreen extends ConsumerStatefulWidget {
  const IndexSubScreen({super.key});
  @override
  ConsumerState<IndexSubScreen> createState() => _IndexSubScreenState();
}

class _IndexSubScreenState extends ConsumerState<IndexSubScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [],
          ),
        ),
      );
    });
  }
}
