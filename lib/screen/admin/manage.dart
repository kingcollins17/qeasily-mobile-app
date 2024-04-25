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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, size: 18, color: athensGray),
                    spacer(),
                    Text('View ', style: small00),
                  ],
                ),
                spacer(y: 10),
                GestureDetector(
                  onTap: () => context.push('/admin/view-questions'),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 50),
                    width: maxWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('View and Manage Questions', style: rubik),
                  ),
                ),
                spacer(y: 10),
                GestureDetector(
                  onTap: () => context.push('/admin/view-topics'),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 50),
                    width: maxWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('View and Manage Topics', style: rubik),
                  ),
                ),
                spacer(y: 10),
                GestureDetector(
                  onTap: () => context.push('/admin/view-quizzes'),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 50),
                    width: maxWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('View and Manage Quizzes', style: rubik),
                  ),
                ),
                
                
                spacer(y: 50),
                Text('Create', style: small00),
                spacer(y: 10),
                Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: [
                    GestureDetector(
                        onTap: () => context.push('/admin/create-quiz'),
                        child: _createTile('Add Quiz ')),
                    GestureDetector(
                        onTap: () => context.push('/admin/create-question'),
                        child: _createTile('Add Questions ')),
                    // _createTile('Create Quiz +'),
                    GestureDetector(
                        onTap: () => context.push('/admin/create-topic'),
                        child: _createTile('Add Topic ')),
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

  Container _createTile(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      
      constraints: BoxConstraints(
        // minWidth: maxWidth(context) * 0.35,
        maxWidth: maxWidth(context) * 0.4,
        minHeight: 70,
      ),
      decoration: BoxDecoration(
        color: raisingBlack,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Text(label, style: xs01),
          ),
          spacer(),
          Center(child: Icon(Icons.add, size: 30, color: Colors.white)),
        ],
      ),
    );
  }
}
