// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/create_question_util.dart';

import 'questions/questions.dart';

class AdminManageScreen extends ConsumerStatefulWidget {
  const AdminManageScreen({super.key});
  @override
  ConsumerState<AdminManageScreen> createState() => _AdminManageScreenState();
}

class _AdminManageScreenState extends ConsumerState<AdminManageScreen> with Ui {
  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
          appBar: AppBar(
            title: Text('Create and Manage', style: small00),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, size: 18, color: athensGray),
                    spacer(),
                    Text('View ', style: mukta),
                  ],
                ),
                spacer(y: 10),
                Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: [
                    _createTile('Questions'),
                    _createTile('Quizzes'),
                    // _createTile('Challenges'),
                  ],
                ),
                spacer(y: 130),
                Text('Create', style: mukta),
                spacer(y: 10),
                Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: [
                    GestureDetector(
                        onTap: () => context.push('/admin/create-quiz'),
                        child: _createTile('Add Quiz +')),
                    GestureDetector(
                        onTap: () => context.push('/admin/create-question'),
                        child: _createTile('Add Questions +')),
                    // _createTile('Create Quiz +'),
                    GestureDetector(
                        onTap: () => context.push('/admin/create-topic'),
                        child: _createTile('Add Topic +')),
                  ],
                ),
                spacer(y: 30),
                // Text('Delete', style: mukta),
                spacer(y: 10),
                // Wrap(
                //   runSpacing: 4,
                //   spacing: 4,
                //   children: [
                //     _createTile('Delete Question'),
                //     _createTile('Delete Quiz'),
                //   ],
                // ),
              ],
            ),
          )),
    ]);
  }

  Container _createTile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      constraints: BoxConstraints(
        // minWidth: maxWidth(context) * 0.35,
        maxWidth: maxWidth(context) * 0.4,
        minHeight: 40,
      ),
      decoration: BoxDecoration(
        color: raisingBlack,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: Text(title, style: small00)),
    );
  }
}
