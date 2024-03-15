// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/styles.dart';
import 'package:riverpod/riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with Ui {
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Ui.black00,
      child: Column(
        children: [
          spacer(y: 8),
          Container(
            width: maxWidth(context),
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            decoration: BoxDecoration(color: Colors.black, boxShadow: [
              BoxShadow(
                  color: Color(0x47272727), blurRadius: 2, offset: Offset(3, 4))
            ]),
            child: Row(
              children: [
                spacer(x: 6),
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white)),
                spacer(x: 10),
                vDivider(),
                spacer(x: 10),
                Expanded(
                  // height: 48,
                  // width: maxWidth(context) * 0.8,
                  child: TextField(
                    controller: searchTextController,
                    cursorHeight: 20,
                    cursorColor: Color(0xA29E9E9E),
                    style: small00,
                    decoration: InputDecoration(
                        hintText: 'Enter any keyword',
                        border: InputBorder.none),
                  ),
                ),
                spacer(),
                Icon(Icons.search, color: Colors.white),
                spacer(x: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
